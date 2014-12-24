import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

Page {
    id: aboutPage
    title: i18n.tr("About")

    Column {
        spacing: units.gu(1)

        anchors {
            left: parent.left
            right: parent.right
        }

        Label {
            anchors {
                left: parent.left
                right: parent.right
                margins: units.gu(2)
            }

            width: parent.width - units.gu(4)

            wrapMode: Text.WrapAtWordBoundaryOrAnywhere

            onLinkActivated: {
                Qt.openUrlExternally(link)
            }

            text: i18n.tr("Dota 2 Match Ticker displays live and upcoming professional Dota 2 matches. All the information is sourced from <a href='http://dailydota2.com'>DailyDota2.com</a>.")
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
    }
}
