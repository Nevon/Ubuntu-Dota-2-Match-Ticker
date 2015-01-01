import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Connectivity 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../components"
import "../models/JSONListModel"
import "../config.js" as Config

Page {
    id: tickerPage
    anchors.fill: parent
    title: i18n.tr("Matches")

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

    tools: ToolbarItems {
        ToolbarButton {
            id: aboutButton
            action: Action {
                text: i18n.tr("About")
                iconName: "info"
                onTriggered: mainStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        ToolbarButton {
            action: Action {
                text: i18n.tr("Reload")
                iconName: "reload"
                onTriggered: {
                    mx.track("MatchList: Reload", {
                        "Method": "toolbar"
                    });
                    tickerFeed.reload();
                }
            }
        }
    }

    UbuntuListView {
        id: matchList
        anchors.fill: parent
        model: tickerFeed.model
        visible: model.count > 0

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

        JSONListModel {
            id: tickerFeed
            source: Config.API_URL
            query: "$.matches[*]"
        }

        PullToRefresh {
            enabled: true
            refreshing: tickerFeed.status == tickerFeed.loadingStatus
            onRefresh: {
                mx.track("MatchList: Reload", {
                    "Method": "pull to refresh"
                });
                tickerFeed.reload();
            }
        }
    }

    Label {
        visible: matchList.model.count === 0 && tickerFeed.status === tickerFeed.readyStatus
        anchors.centerIn: parent
        text: i18n.tr("No upcoming matches")
        fontSize: "large"
        opacity: 0.5
    }

    Label {
        visible: tickerFeed.status === tickerFeed.errorStatus
        anchors.centerIn: parent
        text: i18n.tr("Something went wrong")
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
