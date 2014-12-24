import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../components/JSONListModel"

Page {
    id: tickerPage
    anchors.fill: parent
    title: i18n.tr("Dota 2 Match Ticker")

    UbuntuListView {
        id: matchList

        anchors.fill: parent

        model: tickerFeed.model

        visible: model.count > 0

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

        delegate: ListItem.Subtitled {
            id: matchItemDelegate
            text: model.team1.team_name + " " + i18n.tr("vs") + " " + model.team2.team_name
            subText: (model.status === 1 || model.timediff < 0) ? i18n.tr("LIVE") : model.starttime
        }
    }

    Label {
        visible: matchList.model.count === 0 && tickerFeed.status === tickerFeed.readyStatus
        anchors.centerIn: parent
        text: i18n.tr("No upcoming matches")
        fontSize: "medium"
    }

    Label {
        visible: tickerFeed.status === tickerFeed.errorStatus
        anchors.centerIn: parent
        text: i18n.tr("Something went wrong")
    }

    tools: ToolbarItems {
        ToolbarButton {
            action: Action {
                text: i18n.tr("Reload")
                iconName: "reload"
                onTriggered: tickerFeed.reload()
            }
        }
    }
}
