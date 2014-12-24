import QtQuick 2.0
import Ubuntu.Components 1.1
import "ui"

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
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

    Component.onCompleted: mainStack.push(Qt.resolvedUrl("./ui/tickerPage.qml"))
}

