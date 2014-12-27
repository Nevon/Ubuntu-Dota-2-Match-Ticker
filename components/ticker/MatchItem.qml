import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

ListItem.Empty {
    id: matchItem
    property var match: model

    width: parent.width
    height: team1Logo.height + team2Logo.height + matchStart.height + units.gu(2)
    anchors.topMargin: units.gu(1)
    anchors.bottomMargin: units.gu(1)

    onClicked: mainStack.push(Qt.resolvedUrl("../../ui/matchPage.qml"))

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
                    id: team1Logo
                    source: "http://dailydota2.com" + match.team1.logo_url
                    width: Math.round(parent.width * 0.15 * 100) / 100
                    height: team1Logo.width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                }

                Label {
                    id: team1Name
                    text: match.team1.team_name
                    fontSize: "medium"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: team1Logo.right
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
                    id: team2Name
                    text: match.team2.team_name
                    fontSize: "medium"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: team2Logo.left
                    anchors.rightMargin: units.gu(1)
                }

                Image {
                    id: team2Logo
                    source: "http://dailydota2.com" + match.team2.logo_url
                    width: Math.round(parent.width * 0.15 * 100) / 100
                    height: team2Logo.width
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
                text: match.starttime
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
