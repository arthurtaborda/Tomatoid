import QtQuick 1.0
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1 as QtExtras

PlasmaComponents.ToolBarLayout {
    id: topBar
    
    property string icon
    
    PlasmaComponents.TextField {
        placeholderText: "Task Name"
        anchors.left: parent.left
        anchors.right: addTaskButton.right
        anchors.rightMargin: 3 + addTaskButton.width
    }
    
    PlasmaComponents.Button {
        id: addTaskButton
        iconSource: "list-add"
        text: "Add Task"
        width: 75
        anchors.right: parent.right
    }
}
