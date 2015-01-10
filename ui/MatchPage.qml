import QtQuick 2.0
import Ubuntu.Components 1.1
import QtGraphicalEffects 1.0
import "../components"

Page {
    property string link
    property string team1Name
    property string team2Name
    property string team1Tag
    property string team2Tag
    property string team1Logo
    property string team2Logo
    property string leagueName
    property string leagueImage
    property int seriesType
    property date startTime
    property int timeDiff
    property int streamViewers
    property int status

    id: matchPage
    title: qsTr(i18n.tr("%1 vs %2")).arg(matchPage.team1Tag).arg(matchPage.team2Tag)

    head.actions: [
        Action {
            text: i18n.tr("Watch")
            iconName: "external-link"
            onTriggered: {
                mx.track("Match: Open Stream", {
                    "Method": "toolbar",
                    "Match Link": matchPage.link,
                    "Team 1 Name": matchPage.team1Name,
                    "Team 2 Name": matchPage.team2Name,
                    "Live": (matchPage.timeDiff < 0),
                    "League Name": matchPage.leagueName,
                    "Image Background": matchPage.leagueImage,
                    "Series Type": matchPage.seriesType,
                });
                Qt.openUrlExternally(matchPage.link)
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
            source: matchPage.leagueImage
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
            team1Name: matchPage.team1Name
            team2Name: matchPage.team2Name
            team1Logo: matchPage.team1Logo
            team2Logo: matchPage.team2Logo
            startTime: matchPage.startTime
            timeDiff: matchPage.timeDiff

            anchors {
                top: parent.top
            }
        }

        Item {
            id: leagueInfo
            visible: (matchPage.leagueName || matchPage.seriesType)
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
                text: matchPage.leagueName
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                anchors {
                    left: parent.left
                    right: parent.right
                }

            }

            Label {
                id: gameMode
                text: qsTr(i18n.tr("Best of %1")).arg(matchPage.seriesType)
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
                    "Match Link": matchPage.link,
                    "Team 1 Name": matchPage.team1Name,
                    "Team 2 Name": matchPage.team2Name,
                    "Live": (matchPage.timeDiff < 0),
                    "League Name": matchPage.leagueName,
                    "Image Background": matchPage.leagueImage,
                    "Series Type": matchPage.seriesType,
                });
                Qt.openUrlExternally(matchPage.link)
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
            visible: (matchPage.status === 1)
            text: i18n.tr("%1 viewer", "%1 viewers", matchPage.streamViewers).arg(matchPage.streamViewers)
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
