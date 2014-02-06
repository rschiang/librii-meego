import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: root
    width: parent.width
    height: entryContent.height + UiConstants.DefaultMargin

    Column {
        id: entryContent
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter

        Row {
            spacing: UiConstants.DefaultMargin

            Label {
                id: entryId
                font: UiConstants.SmallTitleFont
                text: model.article
            }

            Label {
                id: entryTitle
                text: model.title
            }
        }

        Label {
            id: entryText
            anchors {
                left: parent.left
                right: parent.right
            }

            font: UiConstants.BodyTextFont
            text: model.text
        }
    }
}
