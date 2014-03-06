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
            LawArticleDelegate {
            }
        }
        section.property: "article"
        model: ListModel { id: listModel }
        cacheBuffer: page.height * 7
    }

    LoadIndicator {
        id: indicator
        anchors.centerIn: parent
        size: "large"
    }

    NotificationBanner {
        id: toast
    }

    function clearItems() {
        listModel.clear()
    }

    function pushItem(item) {
        item.article = isNaN(item.article) ?
                             item.article :
                            (item.article > 0) ? ("§" + item.article) : "前言"
        item.title = item.title ? "("+ item.title + ")" : ""
        item.text = item.text.trim().replace(/\n/g, "<br />")
        listModel.append(item)
    }

    function showError(context) {
        if (context === "info")
            toast.showMessage("無法載入法條資訊")
        else if (context === "statute")
            toast.showMessage("無法載入法條內容")
        indicator.stop()
    }

    Component.onCompleted: Entries.show(modelData)
}
