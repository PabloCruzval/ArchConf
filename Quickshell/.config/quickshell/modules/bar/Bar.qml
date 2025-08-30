import QtQuick
import Quickshell
import Quickshell.Hyprland

PanelWindow {
    id: panel

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 40

    margins {
        top: 8
        left: 8
        right: 8
    }

    Rectangle {
        id: bar
        anchors.fill: parent
        color: "#1a1a1a"
        radius: 0
        border.color: "#333333"
        border.width: 3

        Row {
            id: workspaceRow

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }

            spacing: 8
            leftPadding: 20
            rightPadding: 20

            Repeater {
                model: Hyprland.workspaces

                Rectangle {
                    width: 14
                    height: 14
                    radius: 15
                    color: modelData.active ? "#4a9eff" : "#333333"
                    // border.color: "#555555"
                    // border.width: 2

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspaces " + modelData.id)
                    }
                }
            }

            Text {
                visible: Hyprland.workspaces.length === 0
                text: "No workspaces"
                color: "#ff0000"
                font.pixelSize: 12
            }
        }

        Row {
            id: workspaceName

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
        }
    }
}
