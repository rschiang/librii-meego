function load(statute) {
    // Track unique entries
    var articles = []

    clearItems()
    for (var i = 0; i < statute.length; i++) {
        var entry = statute[i]

        // Skip duplicate article entries
        if (articles.indexOf(entry.article) >= 0)
            continue
        articles.push(entry.article)

        pushItem({
            article: entry.article,
            title: entry.title,
            text: entry.content.trim(),
            date: entry.passed_date
        })
    }
}

function fetchInfo(name, callback) {
    var xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function() {
        if (xhr.readyState == xhr.DONE) {
            var response = JSON.parse(xhr.responseText)
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
            var response = JSON.parse(xhr.responseText)
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

function show(params) {
    var lyID = params.lyID
    if (lyID) {
        var statutes = db.collection("statute").find({ lyID: lyID })
        if (statutes.length) {
            var statute = JSON.parse(statutes[0].json)
            load(statute)
            return
        }
    }

    // No cache available, fetch all
    indicator.start()
    fetchInfo(params.name,
              function(info) {
                  fetchStatute(info.lyID,
                               function(statute) {
                                   load(statute)
                                   indicator.stop()
                               })
              })
}
