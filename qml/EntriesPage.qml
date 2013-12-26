import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1

Page {
    id: page

    property string corpusId
    property alias corpusName: header.text
    property variant modelData

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
                leftMargin: -UiConstants.ButtonSpacing
                rightMargin: -UiConstants.ButtonSpacing
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
                        text: model.id
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

            cacheBuffer: page.height
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
                            listView.model.append({
                                id: isNaN(id) ? id : "§"+id,
                                text: obj[id]
                            })
                        }
                        modelData = obj
                    }
                }

        xhr.open("GET", "qrc:/codes/" + corpusId + ".json")
        xhr.send()
    }
}
