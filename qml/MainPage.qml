import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import "LawSuggestion.js" as Suggestions

ListViewPage {
    id: page

    function navigate(model) {
        pageStack.push("qrc:/qml/EntriesPage.qml", {
                           corpus: model.name
                       })
    }

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

                onTextChanged: {
                    if (text.length) Suggestions.show(text)
                }

                Keys.onReturnPressed: Suggestions.show(text)
            }
        }
    }

    listView {
        section.property: "title"
        model: ListModel { id: listModel }

        delegate: Component {
            ListDelegate {
                onClicked: navigate(model)
                MoreIndicator {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
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
        item.section = item.category === "remote" ? "在網路上" :
                                                    item.starred ? "我的最愛" : "在手機上"
        item.title = !query ? item.name :
                              item.name.replace(text, "<u style='color: #4187C5;'>$&</u>")

        listModel.append(item)
    }

    Component.onCompleted: {
        Suggestions.show()
    }

    Connections {
        target: settings
        onFirstRun: {
            db.batch(function(db) {
                db.collection("indices")
                db.insert({name: "中華民國憲法", lyId: "04101", starred: 0})
                db.insert({name: "中華民國刑法", lyId: "04536", starred: 0})
                db.insert({name: "民法第一編總則", lyId: "04507", starred: 0})
                db.insert({name: "民法第二編債", lyId: "04509", starred: 0})
                db.insert({name: "民法第三編物權", lyId: "04511", starred: 0})
                db.insert({name: "民法第四編親屬", lyId: "04513", starred: 0})
                db.insert({name: "民法第五編繼承", lyId: "04515", starred: 0})
            })
        }
    }
}
