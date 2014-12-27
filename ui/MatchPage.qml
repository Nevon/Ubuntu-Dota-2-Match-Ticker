import QtQuick 2.0
import Ubuntu.Components 1.1
import QtGraphicalEffects 1.0
import "../components"

Page {
    id: matchPage
    property var matchObj

    title: matchObj.team1.team_tag + " " + i18n.tr("vs") + " " + matchObj.team2.team_tag

    tools: ToolbarItems {
        ToolbarButton {
            id: openStreamButton
            action: Action {
                text: i18n.tr("Watch")
                iconName: "external-link"
                onTriggered: {
                    Qt.openUrlExternally(matchObj.link)
                }
            }
        }
    }

    Item {
        anchors.fill: parent

        Image {
            id: background
            visible: false
            source: "http://dailydota2.com" + matchObj.league.image_url
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectCrop
            smooth: true
        }

        FastBlur {
            anchors.fill: background
            source: background
            radius: 64
        }
    }

    Item {
        anchors.fill: parent

        MatchTeams {
            id: teams
            team1Name: matchObj.team1.team_name
            team2Name: matchObj.team2.team_name
            team1Logo: (matchObj.team1.logo_url) ? "http://dailydota2.com" + matchObj.team1.logo_url : ""
            team2Logo: (matchObj.team2.logo_url) ? "http://dailydota2.com" + matchObj.team2.logo_url : ""
            startTime: matchObj.starttime
            timeDiff: matchObj.timediff

            anchors.top: parent.top
        }

        Item {
            id: leagueInfo
            visible: (matchObj.league.name || matchObj.series_type)
            anchors.top: teams.bottom
            anchors.topMargin: units.gu(2)
            anchors.left: parent.left
            anchors.right: parent.right
            height: leagueName.height + gameMode.height + units.gu(1)

            Label {
                id: leagueName
                text: matchObj.league.name
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                id: gameMode
                text: qsTr(i18n.tr("Best of %1")).arg(matchObj.series_type)
                anchors.top: leagueName.bottom
                anchors.topMargin: units.gu(1)
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: 0.5
            }
        }

        Button {
            height: units.gu(6)
            width: units.gu(20)
            color: UbuntuColors.blue

            anchors.top: leagueInfo.bottom
            anchors.topMargin: units.gu(4)
            anchors.horizontalCenter: parent.horizontalCenter

            onClicked: {
                Qt.openUrlExternally(matchObj.link)
            }

            Label {
                anchors {
                    centerIn: parent
                }
                color: "white"
                text: i18n.tr("Watch now")
            }
        }
    }
}
