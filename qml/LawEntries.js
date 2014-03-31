function load(statute) {
    // Track unique entries
    var articles = []
    var items = {}

    clearItems()
    for (var i = 0; i < statute.length; i++) {
        var entry = statute[i]

        // Skip duplicate article entries
        if (articles.indexOf(entry.article) >= 0)
            continue
        articles.push(entry.article)

        items[entry.article] = {
            article: entry.article,
            title: entry.title,
            text: entry.content.trim(),
            date: entry.passed_date
        }
    }

    articles.sort(function (x, y) {
                      var ax = x.split('-'), ay = y.split('-')
                      var len = Math.min(ax.length, ay.length)
                      for (var i = 0; i < len; i++) {
                          var ix = ax[i], iy = ay[i]
                          if (ix !== iy)
                              return (parseInt(ix) < parseInt(iy)) ? -1 : 1
                      }
                      return 0
                  })

    for (var j = 0; j < articles.length; j++)
        pushItem(items[articles[j]])
}

function parseJSON(str) {
    try {
        return JSON.parse(str)
    }
    catch (e) {
        console.log("JSONParseError: " + e)
        return {}
    }
}

function fetchInfo(name, callback) {
    var xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function() {
        if (xhr.readyState == xhr.DONE) {
            var response = parseJSON(xhr.responseText)
            if (response.isSuccess) {
                var info = response.law
                var options = { replace: true }

                db.collection("indices").insert({ name: name, lyID: info.lyID, starred: 0 }, options)
                db.collection("article").insert({ lyID: info.lyID, json: JSON.stringify(info) }, options)

                if (callback) callback(info)
            }
            else showError("info")
        }
    }
    xhr.open("GET", "http://g0v-laweasyread.herokuapp.com/api/law/" + name)
    xhr.send()
}

function fetchStatute(lyID, callback) {
    var xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function() {
        if (xhr.readyState == xhr.DONE) {
            var response = parseJSON(xhr.responseText)
            if (response.length) {
                var options = { replace: true }

                db.collection("statute").insert({ lyID: lyID, json: xhr.responseText }, options)

                if (callback) callback(response)
            }
            else showError("statute")
        }
    }
    xhr.open("GET", "https://raw.github.com/g0v/laweasyread-data/master/data/law/" + lyID + "/article.json")
    xhr.send()
}

function fetch(params, callback) {
    var lyID = params.lyID
    if (lyID) {
        var statutes = db.collection("statute").find({ lyID: lyID })
        if (statutes.length) {
            var statute = JSON.parse(statutes[0].json)
            callback(lyID, statute)
            return
        }
    }

    // No cache available, fetch all
    indicator.start()
    fetchInfo(params.name,
              function(info) {
                  fetchStatute(info.lyID,
                               function(statute) {
                                   callback(info.lyID, statute)
                                   indicator.stop()
                               })
              })
}

function show(params) {
    fetch(params, function(lyID, statute) { load(statute) })
}
