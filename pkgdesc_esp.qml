import QtQuick 2.15

Item {
    property string pkgName: "VESC NIU N1S Control ESP"
    property string pkgDescriptionMd: "README_esp.md"
    property string pkgLisp: "code_esp.lbm"
    property string pkgQml: "ui_esp.qml"
    property bool pkgQmlIsFullscreen: false
    property string pkgOutput: "vesc_niu_n1s_control_esp.vescpkg"

    function isCompatible (fwRxParams) {
        var hwName = fwRxParams.hw.toLowerCase();
        var hwType = fwRxParams.hwTypeStr().toLowerCase();

        if (hwType == "vesc bms") {
            return false
        }

        if (hwType != "custom module") {
            return false
        }

        return hwName == "str365 io"
    }
}