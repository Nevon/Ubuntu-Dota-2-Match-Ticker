import QtQuick 2.0
import Ubuntu.Components 1.1
import QtGraphicalEffects 1.0

Page {
    id: matchPage
    anchors.fill: parent
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
}
