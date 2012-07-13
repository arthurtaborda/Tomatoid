import QtQuick 1.0
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1 as QtExtras

import "plasmapackage:/code/logic.js" as Logic

PlasmaComponents.ToolBarLayout {
    id: topBar
    
    property string icon
    
    PlasmaComponents.Label {
        text: {
            if(tomatoid.inPomodoro)
                return "Running pomodoro #" + (tomatoid.completedPomodoros + 1)
            else if(tomatoid.inBreak)
                return "Take a break dude."
        }
        visible: tomatoid.inPomodoro || tomatoid.inBreak
    }
    
    Row {
        spacing: 2
        visible: !tomatoid.inPomodoro && !tomatoid.inBreak
        PlasmaComponents.TextField {
            id: taskField        
            placeholderText: "Task Name"
        }
        
        
        PlasmaComponents.Button {
            id: addTaskButton
            iconSource: "list-add"
            text: "Add"
            width: 55
            
            onClicked: {
                if(taskField.text != "") {
                    Logic.newTask(taskField.text)
                    taskField.text = ""
                }                
            }
        }
    }
        
}
