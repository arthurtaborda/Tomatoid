import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents

Item {
    id: taskContainer
    
    property alias completeTasks: completeTaskList.model
    property alias incompleteTasks: incompleteTaskList.model
    
    Component.onCompleted: {
        console.log("container: " + completeTasks)
        console.log("container: " + incompleteTasks)
    }
    
    PlasmaComponents.TabBar {
        id: tabBar
        height: 30
        
        PlasmaComponents.TabButton { tab: incompleteTaskList; text: "Incomplete Tasks" }
        PlasmaComponents.TabButton { tab: completeTaskList; text: "Complete Tasks" }
        
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            leftMargin: 10; rightMargin: 10;
        }
    }
    
    PlasmaComponents.TabGroup {
        id: toolBarLayout
        anchors {
            top: tabBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: 10
        }
        
        ListView {
            id: incompleteTaskList
            anchors.fill: parent
            clip: true
            
            delegate: TaskItem {
                taskName: name
                completeTask: false
                height: 25
                anchors.margins: 10
                anchors.left: parent.left
                anchors.right: parent.right
                
                Component.onCompleted: {                    
                    console.log("container: " + name)
                    console.log("container: " + incompleteTasks)
                }
            }
        }
        
        
        ListView {
            id: completeTaskList
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            
            TaskItem {
                id: doneItem
                height: 25
                taskName: "Done Task"
                completeTask: true
                anchors.margins: 10
                
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
            }
        }        
    }
}