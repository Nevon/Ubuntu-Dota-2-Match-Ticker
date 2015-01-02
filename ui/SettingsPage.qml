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

    Column {
        spacing: units.gu(3)
        anchors {
            left: parent.left
            right: parent.right
        }

        ListItem.ItemSelector {
            id: favoriteFilterSelector
            text: i18n.tr("Default filter")
            model: Object.keys(Constants.MatchFilters)
            selectedIndex: settingFavoriteFilter.contents.value

            onSelectedIndexChanged: {
                var newFilterLabel = favoriteFilterSelector.model[selectedIndex];
                var newFilterValue = Constants.MatchFilters[favoriteFilterSelector.model[selectedIndex]]
                mx.track("Settings: Change: Filter", {
                    "Filter": newFilterLabel
                })

                console.log("Index changed to" + newFilterLabel)
                settingFavoriteFilter.contents.value = newFilterValue
                console.log(settingsDatabase.putDoc("favoriteFilter"))
            }
        }
    }

}
