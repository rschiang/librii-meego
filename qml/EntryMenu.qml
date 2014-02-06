import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.feedback 1.1

ContextMenu {
    id: root
    property QtObject effect: ThemeEffect {
            id: menuEffect
            effect: ThemeEffect.PopupOpen
        }

    onStatusChanged: {
        if (status === DialogStatus.Opening)
            effect.play()
    }
}
