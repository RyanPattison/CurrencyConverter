// DB
function _getDB() {
    return LocalStorage.openDatabaseSync("currency", "1.0", "Currency app", 2048)
}

function initializeUser() {
    var user = _getDB();
    user.transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS user(key TEXT UNIQUE, value TEXT)');
            var table  = tx.executeSql("SELECT * FROM user");
            // Seed the table with default values
            if (table.rows.length == 0) {
                tx.executeSql('INSERT INTO user VALUES(?, ?)', ["from", "0"]);
                tx.executeSql('INSERT INTO user VALUES(?, ?)', ["to", "1"]);
            };
        });
}
// This function is used to write a key into the database
function setKey(key, value) {
    var db = _getDB();
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO user VALUES (?,?);', [key,""+value]);
        if (rs.rowsAffected == 0) {
            throw "Error updating key";
        } else {

        }
    });
}
// This function is used to retrieve a key from the database
function getKey(key) {
    var db = _getDB();
    var returnValue = undefined;

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT value FROM user WHERE key=?;', [key]);
        if (rs.rows.length > 0)
          returnValue = rs.rows.item(0).value;
    })

    return returnValue;
}
// This function is used to delete a key from the database
function deleteKey(key) {
    var db = _getDB();

    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM user WHERE key=?;', [key]);
    })
}

function convert(from, to, amount) {
    setKey("from", from);
    setKey("to", to);

    var url = "http://www.freecurrencyconverterapi.com/api/v3/convert?q="+currencies[from]+"_"+currencies[to]+"&compact=ultra";
    if (!amount) {
        amount = 1;
    }

    var xhr = new XMLHttpRequest;
    xhr.open("GET", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            console.log(xhr.responseText)

            var results = JSON.parse(xhr.responseText);
            var i = 0;
            for (i in results) {
                var c = results[i];
            }

            camount.text = c*amount;
            console.log(c);
        }
    }
    xhr.send();
}

function allcurrencies() {
    var url = "http://www.freecurrencyconverterapi.com/api/v3/currencies";

    var xhr = new XMLHttpRequest;
    xhr.open("GET", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            var results = JSON.parse(xhr.responseText);
            var i = 0;
            var j = 0;
            var keysSorted;
            for (j in results) {
                keysSorted = Object.keys(results[j]).sort()
                for (i = 0; i < keysSorted.length; i++) {
                    currencies.push(keysSorted[i]);
                    currenciesModel.append({"name":results[j][keysSorted[i]]["currencyName"], "symbol":results[j][keysSorted[i]]["id"]})
                }
            }
        }
    }
    xhr.send();
}
