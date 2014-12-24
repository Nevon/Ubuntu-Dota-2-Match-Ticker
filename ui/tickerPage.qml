import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Connectivity 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../components/JSONListModel"

Page {
    id: tickerPage
    anchors.fill: parent
    title: i18n.tr("Dota 2 Match Ticker")
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
                iconName: "help"
                onTriggered: mainStack.push(Qt.resolvedUrl("./aboutPage.qml"))
            }
        }

        ToolbarButton {
            action: Action {
                text: i18n.tr("Reload")
                iconName: "reload"
                onTriggered: tickerFeed.reload()
            }
        }
    }

    UbuntuListView {
        id: matchList
        anchors.fill: parent
        model: tickerFeed.model
        visible: model.count > 0
        delegate: ListItem.Subtitled {
            id: matchItemDelegate
            text: model.team1.team_name + " " + i18n.tr("vs") + " " + model.team2.team_name
            subText: (model.status === 1 || model.timediff < 0) ? i18n.tr("LIVE") : model.starttime
            opacity: 0
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
            source: "http://dailydota2.com/match-api"
            query: "$.matches[*]"
        }

        PullToRefresh {
            enabled: true
            refreshing: tickerFeed.status == tickerFeed.loadingStatus
            onRefresh: tickerFeed.reload()
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
