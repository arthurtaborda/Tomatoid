/*
 *   Copyright 2012 Arthur Taborda <arthur.hvt@gmail.com>
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