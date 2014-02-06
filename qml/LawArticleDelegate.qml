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

        Text {
            id: entryTitle
            width: parent.width
            text: "<b>" + model.article + "</b> " + model.title
        }

        Text {
            id: entryText
            width: parent.width
            text: model.text
        }
    }
}
