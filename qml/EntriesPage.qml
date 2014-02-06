import QtQuick 1.1
import com.nokia.meego 1.0
import "LawEntries.js" as Entries

ListViewPage {
    id: page

    property variant modelData
    property bool showSearchField: false

    header: Component {
        PageHeader {
            text: modelData ? modelData.name : ""
        }
    }

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: pageStack.pop()
        }

        ToolIcon {
            platformIconId: "toolbar-search"
            onClicked: page.showSearchField = !page.showSearchField
        }

        ToolIcon {
            platformIconId: "toolbar-view-menu"
        }
    }

    listHeader: Component {
        Item {
            width: parent.width
            height: page.showSearchField ? UiConstants.ListItemHeightDefault : 0
            y: page.showSearchField ? 0 : UiConstants.ListItemHeightDefault
            opacity: page.showSearchField ? 1.0 : 0.0

            SearchField {
                id: searchField
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
            }

            Behavior on y { SmoothedAnimation { duration: 150; easing.type: Easing.OutBack }}
            Behavior on height { SmoothedAnimation { duration: 200; easing.type: Easing.OutBack }}
            Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.Linear }}
        }
    }

    listView {
        delegate: Component {
            Item {
                width: parent.width
                height: entryTitle.height + entryText.implicitHeight + UiConstants.DefaultMargin

                Label {
                    id: entryId
                    anchors {
                        top: parent.top
                        left: parent.left
                        topMargin: UiConstants.DefaultMargin / 2
                    }

                    font: UiConstants.SmallTitleFont
                    text: model.article
                }

                Label {
                    id: entryTitle
                    anchors {
                        top: entryId.top
                        left: entryId.right
                        right: parent.right
                        leftMargin: UiConstants.DefaultMargin
                    }
                    height: model.title.length > 0 ? implicitHeight : 0
                    text: model.title
                }

                Label {
                    id: entryText
                    anchors {
                        top: entryTitle.bottom
                        left: entryTitle.left
                        right: parent.right
                    }

                    font: UiConstants.BodyTextFont
                    text: model.text
                }

            }
        }

        section.property: "article"
        model: ListModel { id: listModel }
    }

    BusyIndicator {
        id: indicator
        anchors.centerIn: parent
        running: false
        visible: running
        style: BusyIndicatorStyle { size: "large" }

        function start() {
            indicator.running = true
        }

        function stop() {
            indicator.running = false
        }
    }

    function clearItems() {
        listModel.clear()
    }

    function pushItem(item) {
        item.article = isNaN(item.article) ?
                             item.article :
                            (item.article > 0) ? ("§" + item.article) : "前言"
        item.title = item.title ? "("+ item.title + ")" : ""
        listModel.append(item)
    }

    function showError(context) {
        // TODO
        indicator.stop()
    }

    Component.onCompleted: Entries.show(modelData)
}
