import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: root
    width: parent.width
    height: entryText.height + 10

    Label {
        id: entryText
        y: 5
        width: root.width
        text: "<b>" + model.article + "</b> " + model.title + "<br>" + model.text
    }
}
