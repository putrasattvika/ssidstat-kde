import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import "../code/utils.js" as Utils

Item {
    id: compactRepresentation

    readonly property string selectedAdapter: plasmoid.configuration.adapter

    property double itemWidth:  parent === null ? 0 : vertical ? parent.width : parent.height
    property double itemHeight: itemWidth

    Layout.preferredWidth: bandwidthStatusLabel.width
    Layout.preferredHeight: itemHeight

    property string commandResultStdout: ''
    property string currentSSID: 'None'
    property string currentUsage: '0B'

    PlasmaCore.DataSource {
        id: commandResultsDS
        engine: "executable"
        connectedSources: []
        onNewData: {
            var stdout = data["stdout"]
            commandResultStdout = stdout

            exited(sourceName, stdout)
            disconnectSource(sourceName)
        }
        
        function exec(cmd) {
            connectSource(cmd)
        }

        signal exited(string sourceName, string stdout)
    }


    Connections {
        target: commandResultsDS
        onExited: {
            var parsedSSIDStat = Utils.parseSSIDStat(commandResultStdout)

            currentUsage = parsedSSIDStat["data"][selectedAdapter]["Total"]
            currentSSID = parsedSSIDStat["data"][selectedAdapter]["SSID"]
        }
    }

    PlasmaComponents.Label {
        id: bandwidthStatusLabel
        anchors.centerIn: parent
        visible: plasmoid.configuration.useDefaultIcons
        font.pointSize: -1

        text: currentSSID + ': ' + currentUsage
    }

    Timer {
        id: ssidstat_query
        interval: 10000
        repeat: true
        running: true

        onTriggered: {
            commandResultsDS.exec("ssidstat --active --json")
        }
    }

    onSelectedAdapterChanged: {
        commandResultsDS.exec("ssidstat --active --json")
    }
}
