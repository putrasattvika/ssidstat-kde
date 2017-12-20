import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore

import ".."
import "../../code/utils.js" as Utils

ConfigPage {
    id: page

    property alias cfg_adapter: adapterComboBox.value
    property string commandResultStdout: ''

    PlasmaCore.DataSource {
        id: adapterComboBoxDS
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
        target: adapterComboBoxDS
        onExited: {
            var parsedSSIDStat = Utils.parseSSIDStat(commandResultStdout)

            var arr = []
            for (var i = 0; i < parsedSSIDStat["adapters"].length; i++) {
                var adapter = parsedSSIDStat["adapters"][i]
                arr.push({text: adapter, value: adapter})
            }

            adapterComboBox.model = arr.slice()
        }
    }

    GroupBox {
        Layout.fillWidth: true

        ColumnLayout {
            Layout.fillWidth: true

            Text {
                text: i18n("Adapter Selection")
                font.bold: true
            }

            RowLayout {
                Label {
                    text: i18n("Adapter:")
                }
                ComboBoxProperty {
                    id: adapterComboBox
                    textRole: "text"

                    Component.onCompleted: {
                        adapterComboBoxDS.exec("ssidstat --active --json")
                    }

                    onCurrentIndexChanged: {}
                }
            }
        }
    }
}
