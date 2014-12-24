/* JSONListModel - a QML ListModel with JSON and JSONPath support
 *
 * Copyright (c) 2012 Romain Pokrzywka (KDAB) (romain@kdab.com)
 * Licensed under the MIT licence (http://opensource.org/licenses/mit-license.php)
 */

import QtQuick 2.0
import "jsonpath.js" as JSONPath

Item {
    property int nullStatus: 0
    property int readyStatus: 1
    property int loadingStatus: 2
    property int errorStatus: 3

    property string source: ""
    property string json: ""
    property string query: ""
    property int status: nullStatus

    property ListModel model : ListModel { id: jsonModel }
    property alias count: jsonModel.count
    property string lastError: ""

    onSourceChanged: {
        request();
    }

    onJsonChanged: updateJSONModel()
    onQueryChanged: updateJSONModel()

    function errorString() {
        if (status == errorStatus) {
            return lastError;
        }
    }

    function reload() {
        status = nullStatus;

        request();
    }

    function request() {
        status = loadingStatus;
        json = "";

        var xhr = new XMLHttpRequest;
        xhr.open("GET", source);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    status = readyStatus;
                    json = xhr.responseText;
                    lastError = "";
                } else {
                    status = errorStatus;
                    lastError = xhr.statusText;
                }
            }
        }
        xhr.send();
    }

    function updateJSONModel() {
        jsonModel.clear();

        if ( json === "" )
            return;

        var objectArray = parseJSONString(json, query);
        for ( var key in objectArray ) {
            var jo = objectArray[key];
            jsonModel.append( jo );
        }
    }

    function parseJSONString(jsonString, jsonPathQuery) {
        var objectArray = JSON.parse(jsonString);
        if ( jsonPathQuery !== "" )
            objectArray = JSONPath.jsonPath(objectArray, jsonPathQuery);

        return objectArray;
    }

    Component.onCompleted: updateJSONModel();
}
