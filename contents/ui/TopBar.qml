import QtQuick 1.0
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1 as QtExtras

PlasmaComponents.ToolBarLayout {
    id: topBar
    spacing: 5
    
    property string icon
    
    PlasmaComponents.Button {
        id: addTaskButton
        iconSource: "list-add"
        text: "Add Task"
        width: 75
    }
    
    
    QtExtras.QIconItem {
        id: topBarIcon
        width: 26
        height: 26
        icon: new QIcon(topBar.icon)
        //anchors.right: parent.right
    }
}
