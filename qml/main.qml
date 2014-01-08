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
        property bool firstRun
    }

    Component.onCompleted: {
        theme.colorScheme = "darkBlue"

        db.batch(function(db) {
            var r = db.collection("sqlite_master").find({type: "table", name: "indices"})
            settings.firstRun = (!r.length)

            if (settings.firstRun) {
                db.collection("indices").create(
                    {name: 'text unique', lyId: 'text', starred: 'integer'})
                db.collection("article").create({lyId: 'text unique', json: 'text'})
                db.collection("statute").create({lyId: 'text unique', json: 'text'})
            }
        })
    }
}
