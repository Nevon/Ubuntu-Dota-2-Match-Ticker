import QtQuick 2.0

/**
 * Inspired by https://github.com/campfirelabs/node-mixpanel-api
 * @TODO: Implement buffering so that event sending was possible even before token or userid is specified
 * @TODO: Implement queueing at some point
 */

QtObject {
    // nothing works without it
    property string mixpanelToken: undefined

    // A hashed version of it is is passed to mixpanel for identifying the userId
    // You'd want something like IMEI here probably. Or actual user name if you use accounts
    // For now let's make it mandatory
    property string userId: ""

    // You can put here a list of properties to be added to every request. E.g. {version: "1.0", build: "126"}
    // Note that modifying individual subproperties might not be possible, it is to be verified
    property variant commonProperties: null

    // if true, mixpanel will process request with higher priority - useful for debugging
    property bool test: false

    // adds ip=1 if specified. That can replace userId and hopefully adds geolocation
    property bool sendIp: false

    /**
     * No queueing. Will not send event if token or user id isn't specified yet
     * @param properties Optional dictionary to pass to mixpanel token and userid are added on top of it
     */
    function track(eventName, properties) {
        if(!mixpanelToken || (!userId && !sendIp)) {
            console.error("ERROR: Mixpanel token or user id is missing")
            return
        }

        var objToSend = _objForTrack(eventName, properties)

        var strData = Qt.btoa(JSON.stringify(objToSend))
        var fullUrl = _apiEndpoint + "/track?data=" + strData

        var doc = new XMLHttpRequest()
        doc.onreadystatechange = function() {
            if(doc.readyState === XMLHttpRequest.DONE) {
                var responseCode = parseInt(doc.responseText.substr(0,1))
                if(responseCode !== 1) {
                    console.error("ERROR: Failed to send to mixpanel object " + JSON.stringify(objToSend))
                }
            }
        }
        doc.open("GET", fullUrl)
        doc.send()

    }

    /////// Internals /////////

    property string _apiEndpoint: "http://api.mixpanel.com"

    /**
     * Does not check whole Mixpanel object validity, does not generate string, just returns an object
     *
     * @return object to be sent for the track call.
     */
    function _objForTrack(eventName, properties) {
        if(!properties) {
            properties = {}
        }
        var localCommonProperties = commonProperties
        if(!localCommonProperties) {
            localCommonProperties = {}
        }

        var fullProperties = _extend(properties,
            {
                token: mixpanelToken,
                distinct_id: Qt.md5(userId)
            }
        )

        fullProperties = _extend(fullProperties, localCommonProperties)

        if(test) { fullProperties = _extend(fullProperties, {test: "1"}) }
        if(sendIp) { fullProperties = _extend(fullProperties, {ip: "1"}) }

        var objToSend = {
            event: eventName,
            properties: fullProperties
        }

        return objToSend
    }

    /**
     *  Adds properties of b to the object a. Modifies a in the process
     *
     *  @return a
     */
    function _extend(a, b) {
        var i;
        for( i in b) {
            if(b.hasOwnProperty(i)) {
                a[i] = b[i];
            }
        }
        return a;
    }

}
