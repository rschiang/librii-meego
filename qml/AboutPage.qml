import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: page
    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: pageStack.pop()
        }

        ToolIcon {
            platformIconId: "toolbar-view-menu"
            onClicked: menu.open()
        }
    }

    PageHeader {
        id: header
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        text: "關於 Librii"
        z: 1
    }

    Flickable {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: UiConstants.DefaultMargin
        }
        contentWidth: width
        contentHeight: boundItem.height

        Column {
            id: boundItem
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: UiConstants.DefaultMargin

            Repeater {
                id: repeater

                Item {
                    width: parent.width
                    height: aboutLabel.height

                    Image {
                        id: aboutImage
                        anchors.left: parent.left
                        width: 80; height: 80; smooth: true
                        source: modelData.image
                    }

                    Label {
                        id: aboutLabel
                        anchors {
                            left: aboutImage.right
                            right: parent.right
                            margins: UiConstants.DefaultMargin
                        }
                        text: modelData.text
                        wrapMode: Text.Wrap

                        onLinkActivated: Qt.openUrlExternally(link)
                    }
                }
            }
        }
    }

    Menu {
        id: menu
        MenuLayout {
            MenuItem { text: "清除所有資料"
                       onClicked: wipeDialogLoader.load() }
        }
    }

    DelayedLoader {
        id: wipeDialogLoader
        url: "qrc:/qml/WipeDialog.qml"
        onCall: item.open()
    }

    Loader {
        source: "qrc:/assets/about.qml"
        onLoaded: repeater.model = item.get()
    }
}
