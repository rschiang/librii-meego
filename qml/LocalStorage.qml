import QtQuick 1.1
import "LocalStorage.js" as This

QtObject {
    id: root

    function exec(it, val, tx) {
        console.log(it)
        if ((tx = tx || This.tx))
            return tx.executeSql(it, val)
        var result
        This.db.transaction(function(tx) { result = exec(it, val, tx) })
        return result
    }

    function query(it, val, tx) {
        console.log(it)
        if ((tx = tx || This.tx))
            return tx.executeSql(it, val)
        var result
        This.db.readTransaction(function(tx) { result = query(it, val, tx) })
        return result
    }

    function batch(callback) {
        var result
        This.db.transaction(function(tx) {
                                This.tx = tx
                                result = callback(root)
                                This.tx = undefined
                            })
        return result
    }

    function collection(name) {
        This.colName = name
        return root
    }

    // Collection functions

    function create(fields) {
        var count = 0
        var statement = "CREATE TABLE IF NOT EXISTS " + This.colName
        statement += "("
        for (var f in fields) {
            statement += (count++ ? ", ": "")
            statement += f
            statement += " "
            statement += fields[f].toUpperCase()
        }
        statement += ")"
        return root.exec(statement, [])
    }

    function find(selector, options) {
        var values = []
        var statement = "SELECT "
        statement += (options && options.fields) ? options.fields.join() : "*"
        statement += " FROM " + This.colName
        if (selector) {
            statement += " WHERE "
            for (var k in selector) {
                statement += (values.length ? " AND " : "")
                if (k[0] === "~")
                    statement += k.substring(1) + " LIKE ?"
                else
                    statement += k + " = ?"
                values.push(selector[k])
            }
        }
        if (options && options.limit) statement += " LIMIT " + options.limit
        if (options && options.sort) {
            statement += " ORDER BY "
            var count = 0
            for (var f in options.sort) {
                statement += (count ? ", " : "") + f
                statement += (options.sort[f] > 0 ? " ASC" : " DESC")
                count++
            }
        }

        var q = root.query(statement, values)
        var result = []
        for (var i = 0; i < q.rows.length; i++)
            result.push(q.rows.item(i))
        return result
    }

    function update(selector, doc) {
        var values = []
        var statement = "UPDATE" + This.colName
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

        var q = root.exec(statement, values)
        return q.rowsAffected
    }

    function insert(doc) {
        var fields = [], values = []
        for (var k in doc) {
            fields.push(k)
            values.push(doc[k])
        }

        var statement = "INSERT INTO " + This.colName
        statement += " (" + fields.join() + ") "
        statement += " VALUES ("
        for (var i = 0; i < values.length; i++)
            statement += (i ? ",?": "?")
        statement += ")"

        var q = root.exec(statement, values)
        return q.insertId
    }

    function remove(selector, options) {
        var values = []
        var statement = "DELETE "
        statement += (options && options.fields) ? options.fields.join() : "*"
        statement += "FROM " + This.colName
        if (selector) {
            statement += " WHERE "
            for (var k in selector) {
                statement += (values.length ? ", " : "") + k + " = ?"
                values.push(selector[k])
            }
        }

        var q = root.exec(statement, values)
        return q.rowsAffected
    }

    function drop() {
        var statement = "DROP TABLE " + This.colName
        return root.exec(statement, [])
    }

    function createIndex(name, fields, options) {
        var statement = "CREATE "
        if (options && options.unique) statement += "UNIQUE "
        statement += "INDEX IF NOT EXISTS " + name
        statement += " ON " + This.colName
        statement += " ("
        statement += fields.join()
        statement += ")"
        return root.exec(statement, [])
    }
}
