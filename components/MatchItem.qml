import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

ListItem.Empty {
    id: matchItem
    property string team1Name
    property string team2Name
    property string team1Logo
    property string team2Logo
    property string startTime
    property string timeDiff

    width: parent.width
    height: Math.max(team1Info.height, team2Info.height)

    Item {
        id: team1Info
        width: parent.width*0.35
        height: team1ItemLoader.item.height

        anchors {
            left: parent.left
        }

        Loader {
            id: team1ItemLoader
            property string name: matchItem.team1Name
            property string logo: matchItem.team1Logo

            width: parent.width

            source: (logo) ? "MatchListTeamLogoItem.qml" : "MatchListTeamItem.qml"
        }
    }

    Item {
        id: versusInfo

        anchors {
            left: team1Info.right
            right: team2Info.left
            top: parent.top
            bottom: parent.bottom
        }

        Item {
            anchors.fill: parent
            anchors.margins: {
                left: units.gu(1)
                right: units.gu(1)
            }

            Label {
                id: versusText
                text: i18n.tr("vs")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -((versusText.height/2+matchTimeDiff.height)/2)
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                lineHeight: 1.3
                fontSize: "small"
            }

            Label {
                id: matchTimeDiff
                width: parent.width
                text: (matchItem.timeDiff < 0) ? i18n.tr("LIVE") : matchItem.startTime
                anchors.top: versusText.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: Text.AlignHCenter
                opacity: 0.5
                fontSize: "small"
            }
        }
    }

    Item {
        id: team2Info
        width: parent.width*0.35
        height: team2ItemLoader.item.height

        anchors {
            right: parent.right
        }

        Loader {
            id: team2ItemLoader
            property string name: matchItem.team2Name
            property string logo: matchItem.team2Logo

            width: parent.width

            source: (logo) ? "MatchListTeamLogoItem.qml" : "MatchListTeamItem.qml"
        }
    }
}
