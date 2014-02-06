import QtQuick 1.1
import com.nokia.meego 1.0
import "LawSuggestion.js" as Suggestions
import "LawEntries.js" as Entries

ListViewPage {
    id: page

    header: Component {
        PageHeader {
            text: "Librii"
            interactive: true
            onClicked: pageStack.push("qrc:/qml/AboutPage.qml")
        }
    }

    listHeader: Component {
        Item {
            width: parent.width
            height: UiConstants.ListItemHeightDefault

            SearchField {
                id: searchField
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                onTextChanged: Suggestions.show(text)
                Keys.onReturnPressed: Suggestions.show(text)
            }
        }
    }

    listView {
        section.property: "section"
        model: ListModel { id: listModel }

        section.delegate: Component {
            GroupHeader { text: section }
        }

        delegate: Component {
            LawEntryDelegate {
                onClicked: navigate(model)
                onPressAndHold: {
                    contextMenu.context = model
                    contextMenu.open()
                }
            }
        }
    }

    EntryMenu {
        id: contextMenu
        property variant context: ({})

        MenuLayout {
            MenuItem { text: "在新視窗中開啟" }
            MenuItem { text: contextMenu.context.starred ? "從我的最愛移除" : "加入至我的最愛"
                       onClicked: Suggestions.toggleStar(contextMenu.context) }
            MenuItem { text: "詳細資訊" }
            MenuItem { text: (contextMenu.context.category === "local") ? "刪除" : "儲存"
                       onClicked: Suggestions.toggleSave(contextMenu.context) }
        }
    }

    LoadIndicator {
        id: indicator
        anchors { // Indicator can't be accessed if placed in header component
            top: parent.top
            right: parent.right
            margins: UiConstants.DefaultMargin
        }
        inverted: true
    }

    NotificationBanner {
        id: toast
    }

    function findItem(name) {
        for (var i = 0; i < listModel.count; i++) {
            if (listModel.get(i).name === name)
                return i
        }
        return -1
    }

    function updateItem(name, props) {
        var i = findItem(name)
        if (i >= 0)
            listModel.set(i, props)
    }

    function removeItem(name) {
        listModel.remove(findItem(name))
    }

    function clearItems(category) {
        for (var i = 0; i < listModel.count; i++) {
            if (listModel.get(i).category !== category)
                continue
            listModel.remove(i--)
        }
    }

    function pushItem(item, query) {
        item.iconSource = "image://theme/icon-m-content-document"
        item.starred = (item.starred && item.starred != 0)
        item.section = item.category === "remote" ? "在網路上" :
                                                    item.starred ? "我的最愛" : "在手機上"
        item.title = !query ? item.name :
                              item.name.replace(query, "<u style='color: #4187C5;'>$&</u>")

        listModel.append(item)
    }

    function showError(context) {
        toast.showMessage("法條資訊無效，無法將其加至我的最愛")
        indicator.stop()
    }

    function navigate(model) {
        pageStack.push("qrc:/qml/EntriesPage.qml", { modelData: model })
    }

    Component.onCompleted: Suggestions.show()

    Connections {
        target: settings
        onFirstRun: {
            db.batch(function(db) {
                db.collection("indices")
                db.insert({name: "中華民國憲法", lyID: "04101", starred: 1})
                db.insert({name: "中華民國刑法", lyID: "04536", starred: 1})
                db.insert({name: "民法第一編總則", lyID: "04507", starred: 1})
                db.insert({name: "民法第二編債", lyID: "04509", starred: 1})
                db.insert({name: "民法第三編物權", lyID: "04511", starred: 1})
                db.insert({name: "民法第四編親屬", lyID: "04513", starred: 1})
                db.insert({name: "民法第五編繼承", lyID: "04515", starred: 1})
            })
            Suggestions.show()
        }
    }
}
