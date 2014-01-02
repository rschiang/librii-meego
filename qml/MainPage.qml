import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1

ListViewPage {
    id: page

    function navigate(model) {
        pageStack.push("qrc:/qml/EntriesPage.qml", {
                           corpus: model.name
                       })
    }

    function showSuggestions(text) {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState == xhr.DONE) {
                var response = JSON.parse(xhr.responseText)
                if (response.isSuccess) {
                    listModel.clear()
                    for (var i in response.suggestion) {
                        var entry = response.suggestion[i]
                        var ht = entry.law.replace(text, "<u style='color: #4187C5;'>$&</u>")
                        listModel.append({ name: entry.law, title: ht,
                                           iconSource: "image://theme/icon-m-content-document"
                                         })
                    }
                }
            }
        }
        xhr.open("GET", "http://g0v-laweasyread.herokuapp.com/api/suggestion/" + text)
        xhr.send()
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
                    if (text.length) showSuggestions(text)
                }

                Keys.onReturnPressed: showSuggestions(text)
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

    Component.onCompleted: {
        var bookmarks = ["中華民國憲法", "中華民國刑法", "民法第一編總則", "民法第二編債", "民法第三編物權", "民法第四編親屬", "民法第五編繼承"]
        for (var i = 0; i < bookmarks.length; i++)
            listModel.append({ name: bookmarks[i], title: bookmarks[i],
                               iconSource: "image://theme/icon-m-content-favourites"
                             })
    }
}
