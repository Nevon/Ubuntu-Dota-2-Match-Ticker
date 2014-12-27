import QtQuick 2.0
import Ubuntu.Components 1.1

Item {
    id: teamItemRoot
    property string name: parent.name

    height:teamItemName.height + units.gu(10)

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
            text: teamItemRoot.name
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: units.gu(1)
            anchors.rightMargin: units.gu(1)
            fontSize: "medium"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
