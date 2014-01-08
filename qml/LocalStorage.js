var db
var tx
var colName

db = openDatabaseSync("org.librii", "1", "Librii", 4 * 1024 * 1024)
