import QtQuick 1.1

Item {

    function generate(list) {
        var result = ""
        for (var i = 0; i < list.length; i++)
            result += ("<p>" + list[i] + "</p>")
        return result
    }

    function get() {
        return [
            {
                image: "qrc:/assets/app-icon.png",
                text: generate([
                    "<b>Librii</b> (libriimeego 1.14.3)",
                    "© Poren Chiang 2013, released under MIT License.",
                    "收錄立法院法律系統等資料來源之法條、修正時間與紀錄，並可快取離線瀏覽。" +
                    "在法典名稱上長按，可以將其加入我的最愛、或清除快取；" +
                    "長按法條內容可以選取文字、全文檢索、或以 Google 搜尋。",
                    "原始碼可在 " +
                    "<a href='https://github.com/rschiang/librii-meego'>GitHub</a> "+
                    "上取得，以 MIT 授權釋出；關於法規易讀資料來源與相關計劃，請參見 " +
                    "<a href='http://g0v.github.io/laweasyread-front/'>laweasyread</a> " +
                    "專案頁面。"
                ])
            },
            {
                image: "qrc:/assets/g0v-icon.png",
                text: generate([
                    "感謝 #g0v.tw 頻道內所有協助開發的朋友們。"
                ])
            }
        ]
    }
}
