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

    QtObject {
        id: settings
        signal firstRun
    }

    Component.onCompleted: {
        theme.colorScheme = "darkBlue"

        var r = db.collection("sqlite_master").find({type: "table", name: "indices"})
        if (!r.length)
            settings.firstRun()
    }

    Connections {
        target: settings
        onFirstRun: {
            db.batch(function(db) {
                db.collection("indices").create(
                    {name: 'text unique', lyId: 'text', starred: 'integer'})
                db.collection("article").create({lyId: 'text unique', json: 'text'})
                db.collection("statute").create({lyId: 'text unique', json: 'text'})
            })
        }
    }
}
