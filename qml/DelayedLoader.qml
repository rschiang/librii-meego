import QtQuick 1.1

Loader {
    id: loader

    property url url
    property Component component

    signal call

    onLoaded: call()

    function load() {
        if (!item) {
            if (url)
                source = url
            else
                sourceComponent = component
        }
        else call()
    }
}
