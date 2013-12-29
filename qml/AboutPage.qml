import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: page
    tools: naviTools

    PageHeader {
        id: header
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        text: "關於 Librii"
    }

    Item {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: UiConstants.DefaultMargin
        }

        Column {
            id: boundItem
            width: parent.width
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

    Loader {
        source: "qrc:/assets/about.qml"
        onLoaded: repeater.model = item.get()
    }
}
