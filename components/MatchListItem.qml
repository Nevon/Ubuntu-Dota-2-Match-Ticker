import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../utils/moment.js" as M

ListItem.Empty {
    id: matchItem
    property string team1Name
    property string team2Name
    property string team1Logo
    property string team2Logo
    property string startTime
    property string timeDiff

    width: parent.width
    height: Math.max(team1Info.height, team2Info.height)

    Item {
        id: team1Info
        width: parent.width*0.35
        height: team1ItemLoader.item.height

        anchors {
            left: parent.left
        }

        Loader {
            id: team1ItemLoader
            property string name: matchItem.team1Name
            property string logo: matchItem.team1Logo

            width: parent.width

            source: (logo) ? "MatchListTeamLogoItem.qml" : "MatchListTeamItem.qml"
        }
    }

    Item {
        id: versusInfo

        anchors {
            left: team1Info.right
            right: team2Info.left
            top: parent.top
            bottom: parent.bottom
        }

        Item {
            anchors.fill: parent
            anchors.margins: {
                left: units.gu(1)
                right: units.gu(1)
            }

            Label {
                id: versusText
                text: i18n.tr("vs")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -((versusText.height/2+matchTimeDiff.height)/2)
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                lineHeight: 1.3
                fontSize: "small"
            }

            Label {
                id: matchTimeDiff
                width: parent.width
                text: getTimeString()
                anchors.top: versusText.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: Text.AlignHCenter
                opacity: 0.5
                fontSize: "small"
                property var absoluteStartDateString: M.moment(matchItem.startTime, "YYYY-MM-DD HH:mm:ss")
                property var startDate: new Date(matchItem.startTime)

                function getTimeString() {
                    if (matchItem.timeDiff < 0) {
                        return i18n.tr("LIVE");
                    } else if (matchItem.timeDiff < 36000) {
                        // Relative time if less than 10 hours away
                        var now = M.moment(new Date());
                        var then = M.moment(matchTimeDiff.startDate)

                        if (now.isSame(then)) {
                            return "";
                        }

                        if (now.isAfter(then)) {
                            var tmp = now;
                            now = then;
                            then = tmp;
                        }

                        var yDiff = then.year() - now.year();
                        var mDiff = then.month() - now.month();
                        var dDiff = then.date() - now.date();
                        var hourDiff = then.hour() - now.hour();
                        var minDiff = then.minute() - now.minute();
                        var sDiff = then.second() - now.second();

                        if (sDiff < 0) {
                            sDiff += 60;
                            minDiff--;
                        }

                        if (minDiff < 0) {
                            minDiff += 60;
                            hourDiff--;
                        }

                        if (hourDiff < 0) {
                            hourDiff += 24;
                            dDiff--;
                        }

                        if (dDiff < 0) {
                            var daysInLastFullMonth = M.moment(then.year() + "-" + (then.month() + 1), "YYYY-MM").subtract("months", 1).daysInMonth();
                            if (daysInLastFullMonth < now.date()) {
                                dDiff = daysInLastFullMonth + dDiff + (now.date() - daysInLastFullMonth);
                            } else {
                                dDiff = daysInLastFullMonth + dDiff;
                            }
                            mDiff--;
                        }

                        if (mDiff < 0) {
                            mDiff += 12;
                            yDiff--;
                        }

                        var result = [];

                        if (yDiff) {
                            result.push(i18n.tr("%1 year", "%1 years", yDiff).arg(yDiff));
                        }

                        if (mDiff) {
                            result.push(i18n.tr("%1 month", "%1 months", mDiff).arg(mDiff));
                        }

                        if (dDiff) {
                            result.push(i18n.tr("%1 day", "%1 days", dDiff).arg(dDiff));
                        }

                        if (hourDiff) {
                            result.push(i18n.tr("%1 hour", "%1 hours", hourDiff).arg(hourDiff));
                        }

                        if (minDiff) {
                            result.push(i18n.tr("%1 minute", "%1 minutes", minDiff).arg(minDiff));
                        }

                        return result.join(", ")

                    } else {
                        // Absolute time if more than 10 hours away
                        return matchTimeDiff.startDate.toLocaleString(Qt.locale(), i18n.tr("d MMM, hh:mm"))
                    }
                }
            }
        }
    }

    Item {
        id: team2Info
        width: parent.width*0.35
        height: team2ItemLoader.item.height

        anchors {
            right: parent.right
        }

        Loader {
            id: team2ItemLoader
            property string name: matchItem.team2Name
            property string logo: matchItem.team2Logo

            width: parent.width

            source: (logo) ? "MatchListTeamLogoItem.qml" : "MatchListTeamItem.qml"
        }
    }
}
