function show(text) {
    // Find for indices
    var locals = db.collection("indices").find(text ? {"~name": "%"+text+"%"} : undefined)
    clearItems("local")
    for (var i = 0; i < locals.length; i++) {
        var entry = locals[i]
        entry.category = "local"
        pushItem(entry, text)
    }

    // Call XHR for online suggestion
    if (!text) return;
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
                    pushItem(entry, text)
                }
            }
        }
    }
    xhr.open("GET", "http://g0v-laweasyread.herokuapp.com/api/suggestion/" + text)
    xhr.send()
}
