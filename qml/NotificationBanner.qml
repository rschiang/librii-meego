import QtQuick 1.1
import com.nokia.extras 1.1

InfoBanner {
    id: banner

    function showMessage(text) {
        banner.text = text
        banner.show()
    }
}
