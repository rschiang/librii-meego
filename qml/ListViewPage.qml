import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1

Page {
    id: page

    property alias header: headerLoader.sourceComponent
    property alias listHeader: listHeaderLoader.sourceComponent
    property alias listView: listView

    Loader {
        id: headerLoader
        anchors {
            left: parent.left
            right: parent.right
        }
    }

    Loader {
        id: listHeaderLoader
        anchors {
            top: headerLoader.bottom
            left: parent.left
            right: parent.right
            leftMargin: UiConstants.DefaultMargin
            rightMargin: UiConstants.DefaultMargin
        }

        Behavior on height {
            SmoothedAnimation {
                duration: 200
                easing.type: Easing.InOutElastic
            }
        }
    }

    Item {
        clip: true
        anchors {
            top: listHeaderLoader.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        ListView {
            id: listView
            anchors {
                fill: parent
                leftMargin: UiConstants.DefaultMargin
                rightMargin: UiConstants.DefaultMargin
            }

            cacheBuffer: page.height
        }

        FastScroll {
            listView: listView
        }
    }
}
