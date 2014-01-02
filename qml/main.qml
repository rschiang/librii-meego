import QtQuick 1.1
import com.nokia.meego 1.0
import "LocalStorage.js" as LocalStorage

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

    Component.onCompleted: {
        theme.colorScheme = "darkBlue"

        var db = new LocalStorage.Db()
        db.batch(function(db) {
            db.collection("index").create(
                {name: 'text unique', lyId: 'integer', starred: 'integer'});
            db.collection("article").create({lyId: 'integer', json: 'text'});
            db.collection("statute").create({lyId: 'integer', json: 'text'});
        })
    }
}
