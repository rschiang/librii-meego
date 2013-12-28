import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1

ListViewPage {
    id: page

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
                    page.pinListHeader = (text.length > 0)
                }
            }
        }
    }

    listView {
        delegate: Component {
            ListDelegate {
                MoreIndicator {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }

                onClicked: {
                    pageStack.push("qrc:/qml/EntriesPage.qml", {
                                       corpusId: model.corpusId, corpusName: model.title
                                   })
                }
            }
        }

        section.property: "title"
        model: ListModel {
            ListElement { iconSource: "image://theme/icon-m-content-document"; title: "憲法"; corpusId: "constitution" }
            ListElement { iconSource: "image://theme/icon-m-content-document"; title: "民法"; corpusId: "civil" }
            ListElement { iconSource: "image://theme/icon-m-content-document"; title: "刑法"; corpusId: "criminal" }
            ListElement { iconSource: "image://theme/icon-m-content-document"; title: "民事訴訟法" }
            ListElement { iconSource: "image://theme/icon-m-content-document"; title: "刑事訴訟法" }
            ListElement { iconSource: "image://theme/icon-m-content-document"; title: "社會秩序維護法" }
            ListElement { iconSource: "image://theme/icon-m-content-document"; title: "法院組織法" }
            ListElement { iconSource: "image://theme/icon-m-content-document"; title: "中央法規標準法" }
            ListElement { iconSource: "image://theme/icon-m-content-document"; title: "非訟事件法" }
        }
    }
}
