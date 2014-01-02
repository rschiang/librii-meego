import QtQuick 1.1
import com.nokia.meego 1.0

ListViewPage {
    id: page

    property string corpus
    property variant infoData
    property bool showSearchField: false

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

                                    var articles = []
                                    for (var i = 0; i < response.length; i++) {
                                        var entry = response[i]
                                        if (articles.indexOf(entry.article) >= 0)
                                            continue

                                        articles.push(entry.article)
                                        listModel.append({
                                            id: entry.article,
                                            article: isNaN(entry.article) ? entry.article : "§"+entry.article,
                                            title: entry.title ? "("+ entry.title + ")" : "",
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

        xhr.open("GET", "http://g0v-laweasyread.herokuapp.com/api/law/" + corpus)
        xhr.send()
    }
}
