import QtQuick 2.0
import Ubuntu.Components 1.1

Page {
    id: matchPage
    property var matchObj

    title: matchObj.team1.team_tag + " " + i18n.tr("vs") + " " + matchObj.team2.team_tag
}
