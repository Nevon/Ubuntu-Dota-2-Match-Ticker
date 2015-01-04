import QtQuick 2.2
import QtQuick.Window 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import QtSystemInfo 5.0
import U1db 1.0 as U1db
import "ui"
import "config.js" as Config
import "constants.js" as Constants
import "components/Mixpanel"

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    id: dota2MatchTicker

    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.gmail.developer.tommy.dota-2-match-ticker"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(50)
    height: units.gu(75)

    headerColor: "#333333"
    backgroundColor: "#444444"
    footerColor: "#555555"

    PageStack {
        id: mainStack
        anchors.fill: parent
    }

    U1db.Database {
        id: settingsDatabase
        path: "settings"
    }

    U1db.Document {
        id: trackingDocument
        database: settingsDatabase
        docId: "tracking"
        create: true
        defaults: {
            "enabled": false
        }
    }

    U1db.Document {
        id: flagsDocument
        database: settingsDatabase
        docId: "flags"
        create: true
        defaults: {
            "firstrun": true
        }
    }

    DeviceInfo {
        id: device
    }

    function getScreenOrientation() {
        switch (Screen.orientation) {
            case Qt.PrimaryOrientation : return "Primary";
            case Qt.LandscapeOrientation : return "Landscape";
            case Qt.PortraitOrientation : return "Portrait";
            case Qt.InvertedLandscapeOrientation : return "Inverted Landscape";
            case Qt.InvertedPortraitOrientation : return "Inverted portrait";
            default : return "Unknown";
        }
    }

    Mixpanel {
        id: mx
        enabled: trackingDocument.contents["enabled"]
        userId: (device.imei(0)) ? device.imei(0) : "testuser"
        mixpanelToken: Config.MIXPANEL_TOKEN
        commonProperties: {
            "Version": Config.VERSION,
            "Product Name": device.productName(),
            "Model": device.model(),
            "Device ID": device.uniqueDeviceID(),
            "OS Version": device.version(DeviceInfo.Os),
            "Firmware Version": device.version(DeviceInfo.Firmware),
            "IMEI": device.imei(0),
            "Orientation": getScreenOrientation(),
            "Resolution": Screen.width + "x" + Screen.height,
        }
    }

    Component {
        id: trackingAcceptanceDialog

        Dialog {
            id: trackingDialog
            title: i18n.tr("Help improve Dota 2 Match Ticker?")
            text: i18n.tr("With your permission, usage information will be collected to improve this application (you can change this setting at any time from the settings page).")

            Button {
                text: i18n.tr("Allow")
                color: UbuntuColors.orange
                onClicked: {
                    var trackingData = trackingDocument.contents
                    trackingData.enabled = true
                    trackingDocument.contents = trackingData
                    PopupUtils.close(trackingDialog)
                }
            }

            Button {
                text: i18n.tr("Do not allow")
                onClicked: {
                    var trackingData = trackingDocument.contents
                    trackingData.enabled = false
                    trackingDocument.contents = trackingData
                    PopupUtils.close(trackingDialog)
                }
            }
        }
    }

    Component.onCompleted: {
        mainStack.push(Qt.resolvedUrl("./ui/TickerPage.qml"));

        if (flagsDocument.contents["firstrun"] === true) {
            // Ask for permission to track usage metrics
            PopupUtils.open(trackingAcceptanceDialog)

            // Ideally I'd want to run this after quitting, in case
            // I'd want to show some tutorial stuff elsewhere in the app
            var flags = flagsDocument.contents
            flags.firstrun = false
            flagsDocument.contents = flags
        }

        mx.track("Load");
    }
}

