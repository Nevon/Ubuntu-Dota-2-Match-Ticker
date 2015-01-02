import QtQuick 2.0
import "../config.js" as Config
import "DailyDota/DailyDota.js" as DailyDota

ListModel {
    id: matchListModel

    property string filter

    property bool loaded
    signal loadFinished

    property var dotaObj: new DailyDota.DailyDota(Config.API_URL);

    onFilterChanged: {
        console.log("Changed filter to " + filter);
        reload();
    }

    Component.onCompleted: reload()


    function reload() {
        clear();
        load();
    }

    function load() {
        loaded = false

        var connection = dotaObj.getMatches()
        connection.onSuccess.connect(function(response) {
            response = filterMatches(connection.response);

            for (var i = 0; i < response.length; i++) {
                var matchObj = response[i];
                matchListModel.append(matchObj);
            }

            loadFinished();
            loaded = true;
        });
    }

    function filterMatches(matches) {
        switch(filter) {
            case "live":
                return matches.filter(function(match) { return (match.timediff < 0 || match.status === "1") });
                break;
            case "upcoming":
                return matches.filter(function(match) { return (match.timediff > 0 && match.status === "0") });
                break;
            default:
                return matches;
        }
    }
}
