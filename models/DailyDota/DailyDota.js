function createObject(ObjectStr) {
    var component = Qt.createComponent(ObjectStr);
    return component.createObject(Qt.application);
}

function createTimer(timeout) {
    return Qt.createQmlObject('import QtQuick 2.0; Timer { interval: ' + timeout + '; running: true; repeat: false}', Qt.application);
}

var DailyDota = function(url) {

    this.url = url

    this.toString = function() {
        return "[object DailyDotaObject]";
    };

    this.getConnection = function(url) {
        var request = new XMLHttpRequest();
        var connection = createObject("ConnectionObject.qml");
        var timeout = 30000;

        var timer = createTimer(timeout);
        timer.onTriggered.connect(function() {
            if (request.readyState !== request.DONE) {
                connection.raiseRetry();
                timer.destroy();
            }
        });

        connection.onAbort.connect(function() {
            request.abort();
        });

        request.open("GET", url, true);
        request.setRequestHeader("User-Agent", "DailyDotaQML");
        request.setRequestHeader("Connection", "close");

        request.onreadystatechange = function() {
            if (request.readyState == request.DONE) {
                if (timer.stop) {
                    timer.stop();
                    timer.destroy();
                }

                if (request.status == 200) {
                    var response = JSON.parse(request.responseText);
                    connection.connection(response);
                } else {
                    connection.error("Could not connect to DailyDota2");
                }
            }
        };

        request.send();

        return connection;
    }

    this.getMatches = function() {
        var connectionObj = this.getConnection(this.url)
        var self = this;

        connectionObj.onConnection.connect(function(response) {
            connectionObj.response = response.matches;
            connectionObj.success();
        });

        return connectionObj;
    }
};
