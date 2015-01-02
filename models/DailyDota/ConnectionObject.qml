import QtQuick 2.0

QtObject {
    id: connectionObject
    property string errorMessage: ""
    property var response

    signal connection(var response)
    signal success()
    signal raiseRetry()
    signal error(string error)
    signal abort()

    onSuccess: connectionObject.destroy()
    onError: {
        abort()
        if (error) {
            errorMessage = error
        }
        console.error("Error: " + errorMessage)
        connectionObject.destroy()
    }
}
