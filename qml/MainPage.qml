import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.feedback 1.1
import "LawSuggestion.js" as Suggestions

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
                onPressAndHold: contextMenu.open()
            }
        }
    }

    ContextMenu {
        id: contextMenu
        MenuLayout {
            MenuItem { text: "在新視窗中開啟" }
            MenuItem { text: "加入至我的最愛" }
            MenuItem { text: "詳細資訊" }
            MenuItem { text: "刪除" }
        }

        onStatusChanged: if (status === DialogStatus.Opening) menuEffect.play()
    }

    ThemeEffect {
        id: menuEffect
        effect: ThemeEffect.PopupOpen
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

    function navigate(model) {
        pageStack.push("qrc:/qml/EntriesPage.qml", { modelData: model })
    }

    Component.onCompleted: Suggestions.show()

    Connections {
        target: settings
        onFirstRun: {
            db.batch(function(db) {
                db.collection("indices")
                db.insert({name: "中華民國憲法", lyID: "04101", starred: 0})
                db.insert({name: "中華民國刑法", lyID: "04536", starred: 0})
                db.insert({name: "民法第一編總則", lyID: "04507", starred: 0})
                db.insert({name: "民法第二編債", lyID: "04509", starred: 0})
                db.insert({name: "民法第三編物權", lyID: "04511", starred: 0})
                db.insert({name: "民法第四編親屬", lyID: "04513", starred: 0})
                db.insert({name: "民法第五編繼承", lyID: "04515", starred: 0})
            })
            Suggestions.show()
        }
    }
}
