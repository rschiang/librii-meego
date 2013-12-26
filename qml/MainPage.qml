import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1

Page {
    tools: commonTools

    PageHeader {
        id: header
        text: "Librii"
        z: 100
    }

    ListView {
        id: listView
        anchors {
            fill: parent
            topMargin: header.height
            leftMargin: UiConstants.DefaultMargin
            rightMargin: UiConstants.DefaultMargin
        }

        header: Component {
            Item {
                anchors {
                    left: parent.left
                    right: parent.right
                }
                height: searchField.height + UiConstants.DefaultMargin * 2

                SearchField {
                    id: searchField
                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    placeholderText: "搜尋"
                }
            }
        }

        delegate: ListDelegate {
            MoreIndicator {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        model: ListModel {
            ListElement { iconSource: "image://theme/icon-m-content-document"; title: "憲法" }
            ListElement { iconSource: "image://theme/icon-m-content-document"; title: "民法" }
            ListElement { iconSource: "image://theme/icon-m-content-document"; title: "刑法" }
            ListElement { iconSource: "image://theme/icon-m-content-document"; title: "民事訴訟法" }
            ListElement { iconSource: "image://theme/icon-m-content-document"; title: "刑事訴訟法" }
            ListElement { iconSource: "image://theme/icon-m-content-document"; title: "社會秩序維護法" }
            ListElement { iconSource: "image://theme/icon-m-content-document"; title: "法院組織法" }
            ListElement { iconSource: "image://theme/icon-m-content-document"; title: "中央法規標準法" }
            ListElement { iconSource: "image://theme/icon-m-content-document"; title: "非訟事件法" }
        }
    }
}
