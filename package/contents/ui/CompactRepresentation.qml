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

    Layout.preferredWidth: ssidLabel.width >= bandwidthLabel.width ? ssidLabel.width : bandwidthLabel.width
    Layout.preferredHeight: parent.height

    property string commandResultStdout: ''
    property string currentSSID: 'None'
    property string currentUsage: '0B'

    Plasmoid.toolTipTextFormat: Text.RichText

    function updateTooltip(parsedSSIDStat) {
        var toolTipSubText = Utils.tabularSSIDStat(parsedSSIDStat)

        Plasmoid.toolTipSubText = toolTipSubText
    }

    function updateStats() {
        commandResultsDS.exec("ssidstat --active --json")
    }

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

            updateTooltip(parsedSSIDStat)
        }
    }

    GridLayout {
        id: gridLayout
        anchors.fill: parent

        property int spacing: 4 * units.devicePixelRatio
        columnSpacing: spacing
        rowSpacing: -spacing

        columns: 1
        
        PlasmaComponents.Label {
            id: ssidLabel
            anchors.horizontalCenter: parent.horizontalCenter
            visible: plasmoid.configuration.useDefaultIcons
            font.pointSize: -1

            text: currentSSID + " (" + selectedAdapter + ")"
        }

        PlasmaComponents.Label {
            id: bandwidthLabel
            anchors.horizontalCenter: parent.horizontalCenter
            visible: plasmoid.configuration.useDefaultIcons
            font.pointSize: -1

            text: currentUsage
        }
    }

    Timer {
        id: ssidstat_query
        interval: 10000
        repeat: true
        running: true

        onTriggered: {
            updateStats()
        }
    }

    onSelectedAdapterChanged: {
        updateStats()
    }

    Component.onCompleted: {
        updateStats()
    }
}
