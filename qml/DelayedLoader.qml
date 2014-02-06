import QtQuick 1.1

Loader {
    id: loader

    property Component component

    signal call

    onLoaded: call()

    function load() {
        if (!sourceComponent)
            sourceComponent = component
        else
            call()
    }
}
