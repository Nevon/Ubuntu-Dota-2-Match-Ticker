import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

Page {
    id: aboutPage
    title: i18n.tr("About")

    Component.onCompleted: {
        mx.track("About: Open");
    }

    Column {
        spacing: units.gu(2)

        anchors.fill: parent
        anchors.topMargin: units.gu(4)

        Label {
            id: aboutText
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: i18n.tr("Dota 2 Match Ticker displays live and upcoming professional Dota 2 matches. All the information is sourced from <a href='http://dailydota2.com'>DailyDota2.com</a>.")
            textFormat: Text.StyledText
            linkColor: UbuntuColors.orange
            lineHeight: 1.3

            onLinkActivated: {
                Qt.openUrlExternally(link)
            }

            anchors {
                left: parent.left
                right: parent.right

                margins: {
                    left: units.gu(2)
                    right: units.gu(2)
                }
            }
        }

        ListItem.Subtitled {
            text: i18n.tr("Author")
            subText: "Tommy Brunn"
            onClicked: {
                Qt.openUrlExternally("http://tommybrunn.com")
            }
        }

        ListItem.Subtitled {
            text: i18n.tr("Website")
            subText: i18n.tr("https://github.com/Nevon/Ubuntu-Dota-2-Match-Ticker")
            onClicked: {
                Qt.openUrlExternally("https://github.com/Nevon/Ubuntu-Dota-2-Match-Ticker")
            }
        }

        ListItem.Subtitled {
            text: i18n.tr("License")
            subText: "MIT"
            onClicked: {
                Qt.openUrlExternally("http://opensource.org/licenses/MIT")
            }
        }

        Label {
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: i18n.tr("Dota, the Dota 2 logo and Defense of the Ancients are trademarks and/or registered trademarks of Valve Corporation. All other trademarks are property of their respective owners.")
            fontSize: "x-small"
            lineHeight: 1.3
            opacity: 0.5

            anchors {
                left: parent.left
                right: parent.right

                margins: {
                    left: units.gu(2)
                    right: units.gu(2)
                }
            }
        }
    }
}
