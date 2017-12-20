import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: main

    Layout.minimumWidth: units.gridUnit * 1
    Layout.minimumHeight: units.gridUnit * 1
    Layout.preferredWidth: units.gridUnit * 10
    Layout.preferredHeight: units.gridUnit * 10
    Layout.maximumWidth: plasmoid.screenGeometry.width
    Layout.maximumHeight: plasmoid.screenGeometry.height

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.compactRepresentation: CompactRepresentation { }
}
