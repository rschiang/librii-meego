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

        db.collection("sqlite_master")
        var r = db.find({type: "table", name: "indices"}, {fields: ["1"]})
        if (!r.length)
            settings.firstRun()
    }

    Connections {
        target: settings
        onFirstRun: {
            db.batch(function(db) {
                db.collection("indices").create(
                    {name: 'text unique', lyID: 'text', starred: 'integer'})
                db.collection("article").create({lyID: 'text unique', json: 'text'})
                db.collection("statute").create({lyID: 'text unique', json: 'text'})

                db.collection("article").createIndex("article_lyID", ["lyID"])
                db.collection("article").createIndex("statute_lyID", ["lyID"])
            })
        }
    }
}
