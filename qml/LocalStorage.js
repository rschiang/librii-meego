.pragma library

var Db = function() {
    var db = openDatabaseSync("org.librii", "1", "Librii", 4 * 1024 * 1024)
    this.db = db
}

Db.prototype.exec = function(it, params, tx) {
            if (tx)
                return tx.executeSql(it, val)
            var result
            this.db.transaction(function(tx) { result = exec(it, val, tx) })
            return result
        }

Db.prototype.query = function(it, val, tx) {
            if (tx)
                return tx.executeSql(it, val)
            var result
            this.db.readTransaction(function(tx) { result = query(it, val, tx) })
            return result
        }

var Collection = function(db, name) {
    this.db = db
    this.name = name
}

Db.prototype.collection = function(name) {
            return new Collection(this.db, name)
        }

Collection.prototype.find = function(selector, options, tx) {
            var statement, values
            statement = "SELECT "
            statement += (options.fields) ? options.fields.join() : "*"
            statement += "FROM " + this.name
            if (selector) {
                statement += " WHERE "
                values = []
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

            var q = this.db.query(statement, values, tx)
            var result = []
            for (var i = 0; i < q.rows.length; i++)
                result.push(q.rows.item(i))
            return result
        }

Collection.prototype.update = function(selector, doc, tx) {
            var values = []
            var statement = "UPDATE" + this.name
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

            var q = this.db.exec(statement, values, tx)
            return q.rowsAffected
        }

Collection.prototype.insert = function(doc, tx) {
            var fields = [], values = []
            for (var k in doc) {
                fields.push(k)
                values.push(doc[k])
            }

            var statement = "INSERT INTO " + this.name
            statement += " (" + fields.join() + ") "
            statement += " VALUES ("
            for (var i = 0; i < values.length; i++)
                statement += (i ? ",?": "?")
            statement += ")"

            var q = this.db.exec(statement, values, tx)
            return q.insertId
        }

Collection.prototype.drop = function(selector, options, tx) {
            var statement, values
            statement = "DELETE "
            statement += (options.fields) ? options.fields.join() : "*"
            statement += "FROM " + this.name
            if (selector) {
                statement += " WHERE "
                values = []
                for (var k in selector) {
                    statement += (values.length ? ", " : "") + k + " = ?"
                    values.push(selector[k])
                }
            }

            var q = this.db.exec(statement, values, tx)
            return q.rowsAffected
        }
