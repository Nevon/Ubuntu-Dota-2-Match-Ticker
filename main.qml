import QtQuick 2.2
import QtQuick.Window 2.2
import Ubuntu.Components 1.1
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
    applicationName: "com.tommybrunn.developer.tommy.dota-2-match-ticker"

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

    U1db.Database {
        id: teamDatabase
        path: "teams"
    }

    U1db.Database {
        id: favoritesDatabase
        path: "favorites"
    }

    U1db.Database {
        id: settingsDatabase
        path: "settings"
    }

    U1db.Document {
        id: settingFavoriteFilter
        database: settingsDatabase
        docId: "favoriteFilter"
        create: true
        defaults: {
            "value": Constants.MatchFilters.All
        }
    }

    Component.onCompleted: {
        mx.track("Load");
        mainStack.push(Qt.resolvedUrl("./ui/TickerPage.qml"));
    }
}

