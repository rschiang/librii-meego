import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1

Page {
    property string corpusId
    property alias corpusName: header.text

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: pageStack.pop()
        }

        ToolIcon {
            platformIconId: "toolbar-search"
            onClicked: searchField.visible = !searchField.visible
        }

        ToolIcon {
            platformIconId: "toolbar-view-menu"
        }
    }

    PageHeader {
        id: header

        SearchField {
            id: searchField
            visible: false
            anchors {
                left: parent.paddingItem.left
                right: parent.paddingItem.right
                verticalCenter: parent.paddingItem.verticalCenter
            }
        }
    }

    Item {
        clip: true
        anchors {
            top: header.bottom
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

            delegate: Component {
                Item {
                    width: parent.width
                    height: entryText.implicitHeight + UiConstants.DefaultMargin

                    Label {
                        id: entryId
                        anchors {
                            top: parent.top
                            left: parent.left
                            topMargin: UiConstants.DefaultMargin / 2
                        }

                        font: UiConstants.SmallTitleFont
                        text: "§" + model.id
                    }

                    Label {
                        id: entryText
                        anchors {
                            top: parent.top
                            left: entryId.right
                            right: parent.right
                            topMargin: UiConstants.DefaultMargin / 2
                            leftMargin: UiConstants.DefaultMargin
                        }

                        font: UiConstants.BodyTextFont
                        text: model.text
                    }

                }
            }

            section.property: "id"
            model: ListModel {}
        }

        FastScroll {
            listView: listView
        }
    }

    Component.onCompleted: {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
                    if (xhr.readyState == xhr.DONE) {
                        var obj = JSON.parse(xhr.responseText)
                        for (var id in obj) {
                            listView.model.append({id: id, text: obj[id]})
                        }
                    }
                }

        xhr.open("GET", "qrc:/codes/" + corpusId + ".json")
        xhr.send()
    }
}
