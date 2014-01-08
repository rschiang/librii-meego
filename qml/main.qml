import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow

    initialPage: "qrc:/qml/MainPage.qml"

    ToolBarLayout {
        id: naviTools
        visible: false
        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: pageStack.pop()
        }
    }

    LocalStorage {
        id: db
    }

    Component.onCompleted: {
        theme.colorScheme = "darkBlue"

        db.batch(function(db) {
            db.collection("indices").create(
                {name: 'text unique', lyId: 'integer', starred: 'integer'});
            db.collection("article").create({lyId: 'integer', json: 'text'});
            db.collection("statute").create({lyId: 'integer', json: 'text'});
        })
    }
}
