/*
 *   Copyright 2011 Viranch Mehta <viranch.mehta@gmail.com>
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

PlasmaComponents.Page {
    id: tomatoid
    
    property int minimumWidth: 190
    property int minimumHeight: 220
    property bool inPomodoro: false
    property bool inBreak: false
    
    ListModel { id: completeTasks }
    ListModel { id: incompleteTasks }
    
    Component.onCompleted: {
        Logic.parseConfig("completeTasks", completeTasks)
        Logic.parseConfig("incompleteTasks", incompleteTasks)
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
        
        PlasmaComponents.TabButton { tab: incompleteTaskList; text: "Incomplete Tasks" }
        PlasmaComponents.TabButton { tab: completeTaskList; text: "Complete Tasks" }
        
        anchors {
            top: toolBar.bottom
            left: parent.left
            right: parent.right
            margins: 10
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
            
            model: incompleteTasks
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
            anchors.fill: parent
            
            model: completeTasks
            delegate: TaskItem {
                taskName: name
                completeTask: true
                height: 25
                anchors.margins: 10
                anchors.left: parent.left
                anchors.right: parent.right
                
                Component.onCompleted: console.log(model)
            }
        }       
    }
}
