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
    height: team1Logo.height + team2Logo.height + matchStart.height + units.gu(2)

    Item {
        id: matchInfo
        anchors.left: parent.left
        anchors.leftMargin: units.gu(2)
        anchors.right: parent.right
        anchors.rightMargin: units.gu(2)
        anchors.verticalCenter: parent.verticalCenter

        Item {
            id: teamInfo
            anchors.fill: parent

            Item {
                id: team1Info
                width: matchItem.width / 2 - versusLabel.width / 2 - units.gu(2)
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: units.gu(1)
                anchors.bottomMargin: units.gu(1)
                anchors.left: parent.left

                Image {
                    id: team1LogoImage
                    source: matchItem.team1Logo
                    width: Math.round(parent.width * 0.15 * 100) / 100
                    height: team1LogoImage.width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                }

                Label {
                    id: team1NameLabel
                    text: matchItem.team1Name
                    fontSize: "medium"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: team1LogoImage.right
                    anchors.leftMargin: units.gu(1)
                }
            }

            Item {
                anchors.left: team1Info.right
                anchors.right: team2Info.left

                Label {
                    id: versusLabel
                    text: i18n.tr("vs")
                    fontSize: "small"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item {
                id: team2Info
                width: matchItem.width / 2 - versusLabel.width / 2 - units.gu(2)
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: units.gu(1)
                anchors.bottomMargin: units.gu(1)
                anchors.right: parent.right

                Label {
                    id: team2NameLabel
                    text: matchItem.team2Name
                    fontSize: "medium"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: team2LogoImage.left
                    anchors.rightMargin: units.gu(1)
                }

                Image {
                    id: team2LogoImage
                    source: matchItem.team2Logo
                    width: Math.round(parent.width * 0.15 * 100) / 100
                    height: team2LogoImage.width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                }
            }
        }

        Item {
            id: matchStart
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: units.gu(2)
            anchors.rightMargin: units.gu(2)
            anchors.top: matchInfo.bottom

            Label {
                text: matchItem.startTime
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
