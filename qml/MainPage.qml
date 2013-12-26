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

    SearchField {
        id: searchField
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            margins: UiConstants.DefaultMargin
        }
        placeholderText: "搜尋"
    }

    Item {
        clip: true
        anchors {
            top: searchField.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: UiConstants.DefaultMargin
        }

        ListView {
            id: listView
            anchors {
                fill: parent
                leftMargin: UiConstants.DefaultMargin
                rightMargin: UiConstants.DefaultMargin
            }

            delegate: ListDelegate {
                MoreIndicator {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            section.property: "title"
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

        FastScroll {
            listView: listView
        }
    }
}
