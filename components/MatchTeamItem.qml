import QtQuick 2.0
import Ubuntu.Components 1.1

Item {
    id: teamItemRoot
    property string name: parent.name

    height:teamItemName.height + units.gu(14.5)

    Item {
        anchors.fill: parent
        anchors.margins: {
            left: units.gu(1)
            right: units.gu(1)
            top: units.gu(2)
            bottom: units.gu(2)
        }

        Label {
            id: teamItemName
            text: (teamItemRoot.name !== "To be determined") ? teamItemRoot.name : i18n.tr("To be determined")
            fontSize: "medium"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.AlignHCenter

            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter

                margins: {
                    left: units.gu(1)
                    right: units.gu(1)
                }
            }
        }
    }
}
