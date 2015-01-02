import QtQuick 2.0
import "../config.js" as Config
import "DailyDota/DailyDota.js" as DailyDota
import "../constants.js" as Constants

ListModel {
    id: matchListModel

    property int filter

    property bool loaded
    signal loadFinished(var response)

    property var dotaObj: new DailyDota.DailyDota(Config.API_URL);

    onFilterChanged: {
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

            matchListModel.loadFinished(connection.response);
            loaded = true;
        });
    }

    function filterMatches(matches) {
        switch(filter) {
            case Constants.MatchFilters.Live:
                return matches.filter(function(match) { return (match.timediff < 0 || match.status === "1") });
                break;
            default:
                return matches;
        }
    }
}
