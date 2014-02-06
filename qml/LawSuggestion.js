function show(text) {
    // Record what we've already pushed to UI
    var found = []

    // Find for indices
    var locals = db.collection("indices").find(text ? {"~name": "%"+text+"%"} : undefined,
                                               { sort: { lyID: 1 } })
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
        }
    }
    xhr.open("GET", "http://g0v-laweasyread.herokuapp.com/api/suggestion/" + text)
    xhr.send()
}

function remove(model) {
    var selector = { lyID: model.lyID }
    db.collection("indices").remove(selector)
    db.collection("article").remove(selector)
    db.collection("statute").remove(selector)
    removeItem(model.name)
}
