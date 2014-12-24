import QtQuick 2.0
import Ubuntu.Components 1.1

Page {
    id: aboutPage
    anchors.fill: parent
    title: i18n.tr("About")

    Item {
        anchors {
            fill: parent
        }

        Label {
            text: i18n.tr("Gets data from DailyDota.com")
        }
    }
}
