import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: listItem

    signal clicked
    signal pressAndHold
    property alias pressed: mouseArea.pressed

    property color titleColor: theme.inverted ? "#fff" : "#282828"
    property color titleColorPressed: "#797979"
    property color subtitleColor: theme.inverted ? "#c8c8c8" : "#505050"
    property color subtitleColorPressed: "#797979"

    height: UiConstants.ListItemHeightDefault
    width: parent.width

    BorderImage {
        id: background
        anchors.fill: parent
        // Fill page porders
        anchors.leftMargin: -UiConstants.DefaultMargin
        anchors.rightMargin: -UiConstants.DefaultMargin
        visible: mouseArea.pressed
        source: theme.inverted ? "image://theme/meegotouch-panel-inverted-background-pressed" : "image://theme/meegotouch-panel-background-pressed"
    }

    Row {
        anchors.fill: parent
        spacing: 16

        Image {
            anchors.verticalCenter: parent.verticalCenter
            visible: model.iconSource ? true : false
            width: 64
            height: 64
            source: model.iconSource ? model.iconSource : ""
        }

        Column {
            width: listItem.width - 80
            anchors.verticalCenter: parent.verticalCenter

            Label {
                id: mainText
                width: parent.width
                text: model.title
                font: UiConstants.TitleFont
                color: mouseArea.pressed ? listItem.titleColorPressed : listItem.titleColor
            }

            Label {
                id: subText
                width: parent.width
                text: model.subtitle ? model.subtitle : ""
                font: UiConstants.SubtitleFont
                color: mouseArea.pressed ? listItem.subtitleColorPressed : listItem.subtitleColor
                visible: text != ""
            }
        }
    }

    Image {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        source: model.starred ?
                    listItem.pressed ? "image://theme/icon-s-common-favorite-mark-selected" :
                        theme.inverted ? "image://theme/icon-s-common-favorite-mark-inverted" :
                                         "image://theme/icon-s-common-favorite-mark"
                : ""
        visible: source != ""
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: listItem.clicked()
        onPressAndHold: listItem.pressAndHold()
    }
}
