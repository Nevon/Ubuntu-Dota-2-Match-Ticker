import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Connectivity 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../components"
import "../models"
import "../config.js" as Config
import "../constants.js" as Constants

Page {
    id: tickerPage
    anchors.fill: parent
    title: i18n.tr("Matches")

    property string matchFilter: Constants.MatchFilters.All
    StateSaver.properties: "matchFilter"
    StateSaver.enabled: true

    states: State {
        name: "OFFLINE"
        when: (NetworkingStatus.online === false)
        PropertyChanges {
            target: matchList
            visible: false
        }
        PropertyChanges {
            target: offlineMessage
            visible: true
        }
    }

    head {
        sections {
            model: [i18n.tr("All"), i18n.tr("Live"), i18n.tr("Favorites")]
            onSelectedIndexChanged: {
                mx.track("MatchList: Filter", {
                    "Filter": Object.keys(Constants.MatchFilters)[head.sections.selectedIndex],
                    "Previous Filter": Object.keys(Constants.MatchFilters)[matchFilter]
                });
                matchFilter = head.sections.selectedIndex
            }
        }

        actions: [
            Action {
                text: i18n.tr("About")
                iconName: "info"
                onTriggered: mainStack.push(Qt.resolvedUrl("AboutPage.qml"))
            },
            Action {
                text: i18n.tr("Settings")
                iconName: "settings"
                onTriggered: mainStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
        ]
    }

    UbuntuListView {
        id: matchList
        anchors.fill: parent
        model: tickerFeed
        visible: model.count > 0 && model.loaded === true

        delegate: MatchListItem {
            id: matchItemDelegate
            team1Name: model.team1.team_name
            team2Name: model.team2.team_name
            team1Logo: (model.team1.logo_url) ? "http://dailydota2.com" + model.team1.logo_url : ""
            team2Logo: (model.team2.logo_url) ? "http://dailydota2.com" + model.team2.logo_url : ""
            startTime: model.starttime
            timeDiff: model.timediff
            property int listIndex: index

            onClicked: {
                mx.track("MatchList: Open", {
                    "Team 1 Name": matchItemDelegate.team1Name,
                    "Team 2 Name": matchItemDelegate.team2Name,
                    "Live": (matchItemDelegate.timediff < 0),
                    "League Name": model.league.name,
                    "List Index": matchItemDelegate.listIndex
                });
                mainStack.push(Qt.resolvedUrl("MatchPage.qml"), {'matchObj': model});
            }
        }

        add: Transition {
            id: addMatchAnimation

            property bool forward: false

            ParallelAnimation {
                UbuntuNumberAnimation {
                    properties: "opacity"
                    to: 100
                }

                UbuntuNumberAnimation {
                    properties: "x"
                    from: addMatchAnimation.forward ? matchList.width : -matchList.width
                    to: 0
                }
            }
        }

        remove: Transition {
            id: removeMatchAnimation

            property bool forward: true

            ParallelAnimation {
                UbuntuNumberAnimation {
                    properties: "opacity"
                    to: 0
                }

                UbuntuNumberAnimation {
                    properties: "x"
                    from: 0
                    to: removeMatchAnimation.forward ? -matchList.width : matchList.width
                }
            }
        }

        MatchListModel {
            id: tickerFeed
            filter: matchFilter

            onLoadFinished: {
                // Save each team in the DB so that we can use that when listing
                // available teams to mark as favorites
                var teams = {};

                function createTeamObject(team) {
                    return {
                        "id": team.team_id,
                        "name": team.team_name,
                        "tag": team.team_tag,
                        "logo": team.logo_url,
                    }
                }

                function createTeamDocument(team) {
                    var documentString = "import QtQuick 2.0; import U1db 1.0 as U1db; U1db.Document {database: teamDatabase; docId: '" + team.id + "'; create: true; defaults: " + JSON.stringify(team) +  "}"
                    Qt.createQmlObject(documentString, teamDatabase)
                }

                for (var i = 0; i < response.length; i++) {
                    teams[response[i].team1.team_id] = createTeamObject(response[i].team1)
                    teams[response[i].team2.team_id] = createTeamObject(response[i].team2)
                }

                for (var team in teams) {
                    if (teams.hasOwnProperty(team)) {
                        createTeamDocument(teams[team])
                    }
                }
            }
        }

        PullToRefresh {
            enabled: true
            refreshing: tickerFeed.loaded == false
            onRefresh: {
                mx.track("MatchList: Reload", {
                    "Method": "pull to refresh"
                });
                tickerFeed.reload();
            }
        }
    }

    Label {
        visible: matchList.model.count === 0
        anchors.centerIn: parent
        text: i18n.tr("No upcoming matches")
        fontSize: "large"
        opacity: 0.5
    }

    Label {
        id: offlineMessage
        visible: false
        anchors.centerIn: parent
        text: i18n.tr("Go online to see upcoming matches")
        fontSize: "large"
        opacity: 0.5
    }
}
