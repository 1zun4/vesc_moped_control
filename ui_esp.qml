import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import Vedder.vesc.commands 1.0
import Vedder.vesc.utility 1.0

Item {
    id: root
    anchors.fill: parent

    property Commands mCommands: VescIf.commands()

    Component.onCompleted: {
        sendCode("(send-settings)")
    }

    function sendCode(str) {
        mCommands.sendCustomAppData(str + "\0")
    }

    ScrollView {
        anchors.fill: parent
        anchors.margins: 10
        contentWidth: availableWidth

        ColumnLayout {
            width: parent.width
            spacing: 14

            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: "Configure which TCA9535 IO-expander pins are used for each input. " +
                      "Pin numbers follow the TCA9535 scheme (P0x = 0–7, P1x = 10–17)."
            }

            GroupBox {
                Layout.fillWidth: true
                title: "Pin Configuration"

                GridLayout {
                    anchors.fill: parent
                    columns: 2
                    rowSpacing: 6
                    columnSpacing: 12

                    // Header row
                    Label { text: "Signal";        font.bold: true }
                    Label { text: "Pin #";         font.bold: true }

                    // Mode Left
                    Label { text: "Mode Button Left" }
                    SpinBox { id: pinModeLeft;  Layout.fillWidth: true; from: 0; to: 17; value: 2 }

                    // Mode Right
                    Label { text: "Mode Button Right" }
                    SpinBox { id: pinModeRight; Layout.fillWidth: true; from: 0; to: 17; value: 3 }

                    // Brake
                    Label { text: "Brake Switch" }
                    SpinBox { id: pinBrake;     Layout.fillWidth: true; from: 0; to: 17; value: 6 }

                    // Sidestand
                    Label { text: "Sidestand" }
                    SpinBox { id: pinSidestand; Layout.fillWidth: true; from: 0; to: 17; value: 7 }

                    // Cruise
                    Label { text: "Cruise Button" }
                    SpinBox { id: pinCruise;    Layout.fillWidth: true; from: 0; to: 17; value: 12 }

                    // Start (active-low)
                    Label { text: "Start Button (active-low)" }
                    SpinBox { id: pinStart;     Layout.fillWidth: true; from: 0; to: 17; value: 10 }

                    // Ignition (active-high 12 V)
                    Label { text: "Ignition Input (active-high)" }
                    SpinBox { id: pinIgnition;  Layout.fillWidth: true; from: 0; to: 17; value: 13 }

                    Button {
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        text: "Save Settings"
                        onClicked: {
                            var cmd = "(save-settings " +
                                pinModeLeft.value  + " " +
                                pinModeRight.value + " " +
                                pinBrake.value     + " " +
                                pinSidestand.value + " " +
                                pinCruise.value    + " " +
                                pinStart.value     + " " +
                                pinIgnition.value  + ")"
                            sendCode(cmd)
                        }
                    }

                    Button {
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        text: "Restore Defaults"
                        onClicked: {
                            sendCode("(restore-defaults)")
                            sendCode("(send-settings)")
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: mCommands

        function onCustomAppDataReceived(data) {
            var str = data.toString().trim()

            if (str.startsWith("settings ")) {
                var t = str.split(" ")
                pinModeLeft.value   = parseInt(t[1])
                pinModeRight.value  = parseInt(t[2])
                pinBrake.value      = parseInt(t[3])
                pinSidestand.value  = parseInt(t[4])
                pinCruise.value     = parseInt(t[5])
                pinStart.value      = parseInt(t[6])
                pinIgnition.value   = parseInt(t[7])
            } else if (str === "ok") {
                VescIf.emitStatusMessage("Settings saved.", true)
            }
        }
    }
}
