import QtQuick 1.1
import com.nokia.meego 1.0

QueryDialog {
    visualParent: appWindow

    titleText: "清除所有資料？"
    message: "儲存的法條、我的最愛以及所有設定都將被清除。"
    acceptButtonText: "繼續"
    rejectButtonText: "取消"

    onAccepted: {
        settings.reset()
        pageStack.pop()
    }
}
