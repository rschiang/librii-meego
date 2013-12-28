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
        xhr.open("GET", "http://laweasyread.herokuapp.com/api/suggestion/" + text)
        xhr.send()
    }

    header: Component {
        PageHeader {
            text: "Librii"
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
                    if (!text.length) focus = false
                    page.pinListHeader = (text.length > 0)
                }

                Keys.onReturnPressed: showSuggestions(text)
            }

            Connections {
                target: page
                onListHeaderVisibleChanged: {
                    if (!page.listHeaderVisible)
                        searchField.focus = false
                }
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
}
