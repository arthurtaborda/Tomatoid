import QtQuick 1.0
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

Item {
    id: topbar
    height: 20
    property string icon

    QIconItem {
        id: headerIcon
        width: 26
        height: 26
        icon: new QIcon(topbar.icon)
        anchors {
            top: parent.top
            topMargin: -4
            leftMargin: 15
            left: parent.left
        }
    }


    PlasmaComponents.Label {
        id: header
        text: "Tomatoid"
        anchors {
            top: parent.top
            leftMargin: 3
            left: headerIcon.right
        }
        verticalAlignment: Text.AlignVCenter
    }


    PlasmaCore.Svg {
        id: lineSvg
        imagePath: "widgets/line"
    }

    PlasmaCore.SvgItem {
        id: headerSeparator
        svg: lineSvg
        elementId: "horizontal-line"
        anchors {
            top: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: 1
        }
        height: lineSvg.elementSize("horizontal-line").height
    }
}
