import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents

import "plasmapackage:/code/logic.js" as Logic

ListView {
    property bool done
    
    id: taskList
    anchors.fill: parent
    clip: true
    highlightFollowsCurrentItem: !tomatoid.inPomodoro && !tomatoid.inBreak
    
    highlight: PlasmaComponents.Highlight {
        width: parent.width
    }
    
    delegate: TaskItem {
        id: item
        identity: taskId
        taskName: name
        done: taskList.done
        pomos: pomodoros
        anchors.left: parent.left
        anchors.right: parent.right
        
        onEntered: taskList.currentIndex = index;
        
        onTaskDone: {
            if (!item.done) {
                Logic.doTask(identity, taskName, pomos)
            } else {
                Logic.undoTask(identity, taskName, pomos)
            }
        }
        
        onRemoved: {
            if(item.done) {
                Logic.removeCompleteTask(identity)
            } else {
                Logic.removeIncompleteTask(identity)
            }
        }
        
        onStarted: {
            Logic.startTask(identity)
        }
    }
}