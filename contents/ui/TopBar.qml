import QtQuick 1.0
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1 as QtExtras

Item {
    id: topBar
    height: 20
    property string icon

    QtExtras.QIconItem {
        id: topBarIcon
        width: 26
        height: 26
        icon: new QIcon(topBar.icon)
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
            left: topBarIcon.right
        }
        verticalAlignment: Text.AlignVCenter
    }


    Row {
        id: playingToolBar
        visible: tomatoid.inPomodoro && !tomatoid.inBreak
        anchors {
            top: parent.top
            topMargin: -4
            leftMargin: 15
            right: parent.right
        }

        PlasmaComponents.ToolButton {
            id: pauseButton
            iconSource: "media-playback-pause"
            width: 22
            height: 22
        }

        PlasmaComponents.ToolButton {
            id: stopButton
            iconSource: "media-playback-stop"
            width: 22
            height: 22
        }
    }


    Row {
        id: notPlayingToolBar
        visible: !tomatoid.inPomodoro && !tomatoid.inBreak
        anchors {
            top: parent.top
            topMargin: -4
            leftMargin: 15
            right: parent.right
        }

        PlasmaComponents.ToolButton {
            id: addTaskButton
            iconSource: "list-add"
            width: 22
            height: 22
        }
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
