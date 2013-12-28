import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1

Page {
    id: page

    property alias header: headerLoader.sourceComponent
    property alias listView: listView
    property Component listHeader
    property bool pinListHeader: false

    QtObject {
        id: internal
        property alias listYPosition: listView.contentY
        property bool showListHeader: false
        property bool listHeaderVisible: pinListHeader | showListHeader
    }

    Loader {
        id: headerLoader
        anchors {
            left: parent.left
            right: parent.right
        }
    }

    Item {
        clip: true
        anchors {
            top: headerLoader.bottom
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

            header: Item {
                id: listHeaderWrapper

                width: parent.width
                height: internal.listHeaderVisible ? listHeaderLoader.height : 0
                opacity: internal.listHeaderVisible ? 1 : 0
                y: internal.listYPosition < 0 ? -height : -height - internal.listYPosition

                Behavior on height {
                    SpringAnimation {
                        spring: 2; damping: 0.2; epsilon: 0.25
                    }
                }

                Behavior on opacity {
                    SmoothedAnimation {
                        velocity: 2
                    }
                }

                Loader {
                    id: listHeaderLoader
                    sourceComponent: page.listHeader
                }
            }

            Connections {
                target: listView.visibleArea
                onYPositionChanged: {
                    if ((!listView.flicking && listView.moving) &&
                            internal.listYPosition < 0 &&
                            !internal.listHeaderVisible) {
                        internal.showListHeader = true
                        listHeaderTimer.start()
                    }
                }
            }

            Timer {
                id: listHeaderTimer
                interval: 5000
                onTriggered: internal.showListHeader = false
            }
        }

        FastScroll {
            listView: listView
        }
    }
}
