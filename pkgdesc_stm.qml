import QtQuick 2.15

Item {
    property string pkgName: "VESC NIU N1S Control STM"
    property string pkgDescriptionMd: "README_stm.md"
    property string pkgLisp: "code_stm.lbm"
    property string pkgQml: "ui_stm.qml"
    property bool pkgQmlIsFullscreen: false
    property string pkgOutput: "vesc_niu_n1s_control_stm.vescpkg"

    function isCompatible (fwRxParams) {
        var hwType = fwRxParams.hwTypeStr().toLowerCase();
        return hwType == "vesc"
    }
}