import QtQuick 1.1
import com.nokia.meego 1.0

Image {
    id: viewHeader
    source: internal.imageSource
    anchors.left: parent.left
    anchors.right: parent.right
    height: internal.headerHeight

    // Properties
    property alias paddingItem: __paddingItem
    property alias text: __headerText.text
    property alias interactive: mouseArea.enabled

    signal clicked()

    QtObject {
        id: internal
        property int headerHeight: appWindow.inPortrait ? UiConstants.HeaderDefaultHeightPortrait : UiConstants.HeaderDefaultHeightLandscape
        property string imageSource: (interactive && mouseArea.pressed) ?
                                         "image://theme/" + theme.colorString + "meegotouch-view-header-fixed-pressed" :
                                         "image://theme/" + theme.colorString + "meegotouch-view-header-fixed"
    }

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
            color: "white"
        }
    }
}
