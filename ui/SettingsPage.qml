import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../constants.js" as Constants

Page {
    id: settingsPage
    title: i18n.tr("Settings")

    Component.onCompleted: {
        mx.track("Settings: Open");
    }

    function changedSetting(properties) {
        mx.track("Settings: Change", properties)
    }

    Column {
        anchors {
            left: parent.left
            right: parent.right
        }

        ListItem.Standard {
            text: i18n.tr("Send anonymous usage metrics")
            progression: false
            control: Switch {
                id: trackingSwitch
                checked: trackingDocument.contents.enabled

                onTriggered: {
                    var tracking = trackingDocument.contents
                    tracking.enabled = trackingSwitch.checked
                    trackingDocument.contents = tracking

                    // Won't be sent if tracking is disabled
                    settingsPage.changedSetting({
                        "Setting": "Enable tracking",
                        "Value": tracking.enabled
                    })
                }
            }
        }

        ListItem.Standard {
            text: i18n.tr("About")
            progression: true
            onTriggered: mainStack.push(Qt.resolvedUrl("AboutPage.qml"))
        }
    }

}
