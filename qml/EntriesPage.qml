import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1

ListViewPage {
    id: page

    property string corpus
    property variant infoData

    header: Component {
        PageHeader {
            text: corpus
        }
    }

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

    listView {
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
                    text: model.article
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

        section.property: "article"
        model: ListModel { id: listModel }
    }

    BusyIndicator {
        id: indicator
        anchors.centerIn: parent
        running: true
        visible: running
        style: BusyIndicatorStyle { size: "large" }
    }

    Component.onCompleted: {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
                    if (xhr.readyState == xhr.DONE) {
                        var response = JSON.parse(xhr.responseText)
                        if (response.isSuccess) {
                            infoData = response.law

                            var xxhr = new XMLHttpRequest()
                            xxhr.onreadystatechange = function() {
                                if (xxhr.readyState == xxhr.DONE) {
                                    var response = JSON.parse(xxhr.responseText)
                                    if (!response.length) return

                                    for (var i = 0; i < response.length; i++) {
                                        var entry = response[i]
                                        listModel.append({
                                            id: entry.article,
                                            article: isNaN(entry.article) ? entry.article : "§"+entry.article,
                                            text: entry.content.trim(),
                                            date: entry.passed_date
                                        })
                                    }
                                    indicator.running = false
                                }
                            }
                            xxhr.open("GET", "https://raw.github.com/g0v/laweasyread-data/master/data/law/"+response.law.lyID+"/article.json")
                            xxhr.send()
                        }
                        else
                            indicator.running = false
                    }
                }

        xhr.open("GET", "http://laweasyread.herokuapp.com/api/law/" + corpus)
        xhr.send()
    }
}
