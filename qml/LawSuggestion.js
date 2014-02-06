function show(text) {
    // Record what we've already pushed to UI
    var found = []

    // Find for indices
    var locals = db.collection("indices").find(text ? {"~name": "%"+text+"%"} : undefined,
                                               { sort: { starred: -1, lyID: 1 } })
    clearItems("local")
    for (var i = 0; i < locals.length; i++) {
        var entry = locals[i]
        entry.category = "local"

        found.push(entry.name)
        pushItem(entry, text)
    }

    if (!text) {
        clearItems("remote")
        return
    }

    // Call XHR for online suggestion
    var xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function() {
        if (xhr.readyState == xhr.DONE) {
            var response = JSON.parse(xhr.responseText)
            if (response.isSuccess) {
                clearItems("remote")
                for (var i in response.suggestion) {
                    var entry = {
                        name: response.suggestion[i].law,
                        category: "remote"
                    }
                    if (found.indexOf(entry.name) >= 0)
                        continue
                    found.push(entry.name)
                    pushItem(entry, text)
                }
            }
            indicator.stop()
        }
    }
    xhr.open("GET", "http://g0v-laweasyread.herokuapp.com/api/suggestion/" + text)
    xhr.send()
    indicator.start()
}

function remove(model) {
    var selector = { lyID: model.lyID }
    db.collection("indices").remove(selector)
    db.collection("article").remove(selector)
    db.collection("statute").remove(selector)
    removeItem(model.name)
}

function toggleStar(model) {
    if (model.category === "remote") {
        Entries.fetch(model,
                      function(lyID, statute) {
                          db.collection("indices")
                          db.update({ lyID: lyID }, { starred: 1 })
                          updateItem(model.name, {
                                        lyID: lyID,
                                        starred: 1,
                                        category: "local",
                                        section: "我的最愛"
                                     })
                      })
    } else {
        var starred = (1 - model.starred)
        db.collection("indices")
        db.update({ lyID: model.lyID }, { starred: starred })
        updateItem(model.name,
                   { starred: starred,
                     section: starred == 1 ? "我的最愛" : "在手機上" })
    }
}
