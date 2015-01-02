import QtQuick 2.0
import Ubuntu.Components 1.1
import QtGraphicalEffects 1.0
import "../components"

Page {
    id: matchPage
    property var matchObj

    title: matchObj.team1.team_tag + " " + i18n.tr("vs") + " " + matchObj.team2.team_tag

    head.actions: [
        Action {
            text: i18n.tr("Watch")
            iconName: "external-link"
            onTriggered: {
                mx.track("Match: Open Stream", {
                    "Method": "toolbar",
                    "Match Link": matchObj.link,
                    "Team 1 Name": matchObj.team1.team_name,
                    "Team 2 Name": matchObj.team2.team_name,
                    "Live": (matchObj.timediff < 0),
                    "League Name": matchObj.league.name,
                    "Image Background": matchObj.league.image_url,
                    "Series Type": matchObj.series_type,
                });
                Qt.openUrlExternally(matchObj.link)
            }
        },
        Action {
            text: i18n.tr("Settings")
            iconName: "settings"
            onTriggered: mainStack.push(Qt.resolvedUrl("SettingsPage.qml"))
        }
    ]

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
            onStatusChanged: if (background.status === Image.Ready) blurredBackground.opacity = 1
        }

        FastBlur {
            id: blurredBackground
            anchors.fill: background
            source: background
            radius: 64
            opacity: 0

            Behavior on opacity {
                UbuntuNumberAnimation {
                    properties: "opacity"
                    duration: UbuntuAnimation.BriskDuration
                }
            }
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

            anchors {
                top: parent.top
            }
        }

        Item {
            id: leagueInfo
            visible: (matchObj.league.name || matchObj.series_type)
            height: leagueName.height + gameMode.height + units.gu(1)

            anchors {
                top: teams.bottom
                left: parent.left
                right: parent.right

                margins: {
                    top: units.gu(2)
                    left: units.gu(2)
                    right: units.gu(2)
                }
            }

            Label {
                id: leagueName
                text: matchObj.league.name
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                anchors {
                    left: parent.left
                    right: parent.right
                }

            }

            Label {
                id: gameMode
                text: qsTr(i18n.tr("Best of %1")).arg(matchObj.series_type)
                opacity: 0.5
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                anchors {
                    top: leagueName.bottom
                    left: parent.left
                    right: parent.right

                    margins: {
                        top: units.gu(1)
                    }
                }
            }
        }

        Button {
            id: watchButton
            height: units.gu(6)
            width: units.gu(20)
            color: UbuntuColors.blue

            anchors {
                top: leagueInfo.bottom
                horizontalCenter: parent.horizontalCenter

                margins: {
                    top: units.gu(4)
                }
            }

            onClicked: {
                mx.track("Match: Open Stream", {
                    "Method": "WatchButton",
                    "Match Link": matchObj.link,
                    "Team 1 Name": matchObj.team1.team_name,
                    "Team 2 Name": matchObj.team2.team_name,
                    "Live": (matchObj.timediff < 0),
                    "League Name": matchObj.league.name,
                    "Image Background": matchObj.league.image_url,
                    "Series Type": matchObj.series_type,
                });
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

        Label {
            visible: (parseInt(matchObj.status, 10) === 1)
            text: i18n.tr("%1 viewer", "%1 viewers", matchObj.viewers.stream).arg(matchObj.viewers.stream)
            horizontalAlignment: Text.AlignHCenter
            fontSize: "small"
            opacity: 0.5
            width: units.gu(20)
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere

            anchors {
                top: watchButton.bottom
                horizontalCenter: parent.horizontalCenter

                margins: {
                    top: units.gu(1)
                }
            }
        }
    }
}
