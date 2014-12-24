import QtQuick 2.0
import Ubuntu.Components 1.1

Page {
    id: aboutPage
    title: i18n.tr("About")

    Column {
        spacing: units.gu(2)

        anchors {
            left: parent.left
            right: parent.right
        }

        Label {
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: units.gu(1)
                rightMargin: units.gu(1)
            }

            text: i18n.tr("Gets data from DailyDota.com")
        }
    }
}
