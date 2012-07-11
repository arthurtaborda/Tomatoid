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

        PlasmaComponents.TabButton { tab: incompleteTaskPage; text: "Incomplete Tasks" }
        PlasmaComponents.TabButton { tab: completeTaskPage; text: "Complete Tasks" }

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 10
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

        PlasmaComponents.Page {
            id: incompleteTaskPage
            ListView {
                id: incompleteTaskList
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                delegate: TaskItem {
                    id: incompleteTask
                    height: 25
                    taskName: modelData[1]
                    completeTask: false
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }
                }
                
                
            }
        }

        PlasmaComponents.Page {
            id: completeTaskPage
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
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }
                }
            }
        }
    }
}