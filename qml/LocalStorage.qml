import QtQuick 1.1

QtObject {
    id: local
    property variant db
    property variant tx
    property variant colName

    function open() {
        local.db = openDatabaseSync("org.librii", "1", "Librii", 4 * 1024 * 1024)
        return local
    }

    function close() {
        local.db = undefined
        return local
    }

    function exec(it, params) {
        if (local.tx)
            return local.tx.executeSql(it, val)
        var result
        local.db.transaction(function(tx) { result = exec(it, val, tx) })
        return result
    }

    function query(it, val) {
        if (local.tx)
            return local.tx.executeSql(it, val)
        var result
        local.db.readTransaction(function(tx) { result = query(it, val, tx) })
        return result
    }

    function batch(callback) {
        var result
        local.db.transaction(function(tx) {
                                local.tx = tx
                                result = callback(local)
                                local.tx = undefined
                            })
        return result
    }

    function collection(name) {
        local.colName = name
        return local
    }

    // Collection functions

    function create(fields) {
        var statement = "CREATE TABLE IF NOT EXISTS " + local.colName
        statement += "("
        for (var f in fields) {
            statement += (values.length ? ", ": "")
            statement += f
            statement += fields[f].toUpperCase()
        }
        statement += ")"
        return local.db.exec(statement, [])
    }

    function find(selector, options) {
        var values = []
        var statement = "SELECT "
        statement += (options.fields) ? options.fields.join() : "*"
        statement += "FROM " + local.colName
        if (selector) {
            statement += " WHERE "
            for (var k in selector) {
                statement += (values.length ? ", " : "") + k + " = ?"
                values.push(selector[k])
            }
        }
        if (options.limit) statement += " LIMIT " + options.limit
        if (options.sort) {
            statement += " ORDER BY "
            var count = 0
            for (var f in options.sort) {
                statement += (count ? ", " : "") + f
                statement += (options.sort[f] > 0 ? " ASC" : " DESC")
                count++
            }
        }

        var q = local.db.query(statement, values)
        var result = []
        for (var i = 0; i < q.rows.length; i++)
            result.push(q.rows.item(i))
        return result
    }

    function update(selector, doc) {
        var values = []
        var statement = "UPDATE" + local.colName
        for (var f in doc) {
            statement += (values.length ? ", ": " SET ") + f + " = ?"
            values.push(doc[f])
        }

        if (selector) {
            statement += " WHERE "
            for (var k in selector) {
                statement += (values.length ? ", " : "") + k + " = ?"
                values.push(selector[k])
            }
        }

        var q = local.db.exec(statement, values)
        return q.rowsAffected
    }

    function insert(doc) {
        var fields = [], values = []
        for (var k in doc) {
            fields.push(k)
            values.push(doc[k])
        }

        var statement = "INSERT INTO " + local.colName
        statement += " (" + fields.join() + ") "
        statement += " VALUES ("
        for (var i = 0; i < values.length; i++)
            statement += (i ? ",?": "?")
        statement += ")"

        var q = local.db.exec(statement, values)
        return q.insertId
    }

    function remove(selector, options) {
        var values = []
        var statement = "DELETE "
        statement += (options.fields) ? options.fields.join() : "*"
        statement += "FROM " + local.colName
        if (selector) {
            statement += " WHERE "
            for (var k in selector) {
                statement += (values.length ? ", " : "") + k + " = ?"
                values.push(selector[k])
            }
        }

        var q = local.db.exec(statement, values)
        return q.rowsAffected
    }

    function drop() {
        var statement = "DROP TABLE " + local.colName
        return local.db.exec(statement, [])
    }
}
