import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: root
    width: parent.width
    height: entryContent.height + 10

    Column {
        id: entryContent
        y: 5

        Text {
            id: entryTitle
            width: root.width
            text: "<b>" + model.article + "</b> " + model.title
        }

        Text {
            id: entryText
            width: root.width
            text: model.text
        }
    }
}
