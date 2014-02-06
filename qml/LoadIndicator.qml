import QtQuick 1.1
import com.nokia.meego 1.0

BusyIndicator {
    id: indicator
    running: false
    visible: running

    platformStyle: BusyIndicatorStyle { id: style }
    property alias size: style.size

    function start() {
        indicator.running = true
    }

    function stop() {
        indicator.running = false
    }
}
