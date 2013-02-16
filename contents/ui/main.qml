/*
 *   Copyright 2013 Arthur Taborda <arthur.hvt@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

 import QtQuick 1.1
 import org.kde.plasma.core 0.1 as PlasmaCore
 import org.kde.plasma.components 0.1 as PlasmaComponents

 import "plasmapackage:/code/logic.js" as Logic

 Item {
    id: tomatoid

    property string appName: "Tomatoid"
    property int minimumWidth: 240
    property int minimumHeight: 280
    property bool inPomodoro: false
    property bool inBreak: false
    property bool timerRunning: inPomodoro || inBreak

    property int pomodoroLenght
    property int shortBreakLenght
    property int longBreakLenght
    property int pomodorosPerLongBreak



    property int completedPomodoros: 0

    ListModel { id: completeTasks }
    ListModel { id: incompleteTasks }


    Component.onCompleted: {
        plasmoid.addEventListener("ConfigChanged", configChanged)

        Logic.parseConfig("completeTasks", completeTasks)
        Logic.parseConfig("incompleteTasks", incompleteTasks)

        plasmoid.popupIcon = QIcon("kde");
    }


    function configChanged() {
        pomodoroLenght = plasmoid.readConfig("pomodoroLenght");
        shortBreakLenght = plasmoid.readConfig("shortBreakLenght");
        longBreakLenght = plasmoid.readConfig("longBreakLenght");
        pomodorosPerLongBreak = plasmoid.readConfig("pomodorosPerLongBreak");
    }


    property Component compactRepresentation: Component {
        TomatoidIcon {
            id: iconComponent
        }
    }




    PlasmaComponents.ToolBar {
        id: toolBar
        tools: TopBar {
            id: topBar
            icon: "kde"
        }
    }

    PlasmaComponents.TabBar {
        id: tabBar
        height: 30

        PlasmaComponents.TabButton { tab: incompleteTaskList; text: "Tasks" }
        PlasmaComponents.TabButton { tab: completeTaskList; text: "Completed" }

        anchors {
            top: toolBar.bottom
            left: parent.left
            right: parent.right
            margins: 7
            leftMargin: 10
            rightMargin: 10
        }
    }


    PlasmaCore.FrameSvgItem {
        id: taskFrame
        anchors.fill: toolBarLayout
        imagePath: "widgets/frame"
        prefix: "sunken"
    }


    PlasmaComponents.TabGroup {
        id: toolBarLayout
        anchors {
            top: tabBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: timerRunning ? 32 : 5
            margins: 5

            Behavior on bottomMargin {
                NumberAnimation {
                    duration: 400
                    easing.type: Easing.OutQuad
                }
            }
        }

        TaskList {
            id: incompleteTaskList

            model: incompleteTasks
            done: false

            onDoTask: Logic.doTask(taskIdentity)
            onRemoveTask: Logic.removeIncompleteTask(taskIdentity)
            onStartTask: Logic.startTask(taskIdentity, taskName)
        }

        TaskList {
            id: completeTaskList

            model: completeTasks
            done: true

            onDoTask: Logic.undoTask(taskIdentity)
            onRemoveTask: Logic.removeCompleteTask(taskIdentity)
        }
    }

    property QtObject timer: TomatoidTimer {
        id: timer

        onTimeout: {
            if(inPomodoro) {
                console.log(taskId)
                Logic.completePomodoro(taskId)
                Logic.startBreak()
                Logic.notify("Pomodoro completed", "Great job! Now take a break and relax for a moment.");
                } else if(inBreak) {
                    Logic.stop()
                    Logic.notify("Relax time is over", "Get back to work. Choose a task and start again.");
                }
            }
        }

    //chronometer with action buttons and regressive progress bar in the bottom. This will get the time from TomatoidTimer
    Chronometer {
        id: chronometer
        height: 22
        seconds: timer.seconds
        totalSeconds: timer.totalSeconds
        opacity: timerRunning * 1

        Behavior on opacity {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutQuad
            }
        }

        onPlayPressed: {
            timer.running = true
        }

        onPausePressed: {
            timer.running = false
        }

        onStopPressed: {
            Logic.stop()
        }

        anchors {
            left: tomatoid.left
            right: tomatoid.right
            bottom: tomatoid.bottom
            leftMargin: 5
            bottomMargin: 5
        }
    }
}
