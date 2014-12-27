import QtQuick 2.0
import Ubuntu.Components 1.1

Item {
    id: teamItemRoot
    property string name: parent.name
    property string logo: parent.logo

    height: teamItemLogo.height + teamItemName.height + units.gu(5)

    Item {
        anchors.fill: parent
        anchors.margins: {
            left: units.gu(1)
            right: units.gu(1)
            top: units.gu(2)
            bottom: units.gu(2)
        }

        Image {
            id: teamItemLogo
            source: teamItemRoot.logo
            width: parent.width
            height: units.gu(12)
            fillMode: Image.PreserveAspectFit
        }

        Label {
            id: teamItemName
            text: teamItemRoot.name
            fontSize: "medium"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.AlignHCenter

            anchors {
                top: teamItemLogo.bottom
                left: parent.left
                right: parent.right

                margins: {
                    top: units.gu(1)
                    left: units.gu(1)
                    right: units.gu(1)
                }
            }
        }
    }
}
