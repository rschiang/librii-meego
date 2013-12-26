import QtQuick 1.1
import com.nokia.meego 1.0

Image {
    id: viewHeader
    source: (interactive && mouseArea.pressed) ?
              "image://theme/meegotouch-view-header-fixed-pressed" :
              "image://theme/meegotouch-view-header-fixed"
    anchors.left: parent.left
    anchors.right: parent.right
    height: appWindow.inPortrait ? UiConstants.HeaderDefaultHeightPortrait : UiConstants.HeaderDefaultHeightLandcape

    // Properties
    property alias paddingItem: __paddingItem
    property alias text: __headerText.text
    property alias interactive: mouseArea.enabled

    signal clicked()

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: false
        onClicked: viewHeader.clicked()
    }

    Item {
        id: __paddingItem
        anchors.leftMargin: UiConstants.DefaultMargin
        anchors.rightMargin: UiConstants.DefaultMargin
        anchors.fill: parent

        Text {
            id: __headerText
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            font: UiConstants.HeaderFont
        }
    }
}
