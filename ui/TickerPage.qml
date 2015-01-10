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

    states: [
        State {
            name: "OFFLINE"
            when: (NetworkingStatus.online === false)
            PropertyChanges {
                target: matchList
                visible: false
            }
            PropertyChanges {
                target: tickerMessage
                text: i18n.tr("Go online to see %1 matches")
                visible: true
            }
        },
        State {
            name: "EMPTY"
            when: (matchList.model.count === 0)
            PropertyChanges {
                target: matchList
                visible: false
            }
            PropertyChanges {
                target: tickerMessage
                text: tickerMessage.emptyMessages[head.sections.selectedIndex]
                visible: true
            }
        }
    ]

    head {
        sections {
            model: [i18n.tr("All"), i18n.tr("Live")]
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
        id: tickerMessage
        visible: false
        anchors.centerIn: parent
        text: ""
        fontSize: "large"
        opacity: 0.5

        property var emptyMessages: [
            i18n.tr("No matches"),
            i18n.tr("No live matches")
        ]
    }
}
