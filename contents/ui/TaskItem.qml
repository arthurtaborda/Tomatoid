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
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1 as QtExtras

Item {
    id: taskItem
    property string taskName
    property bool completeTask: false
    
    property string completeTaskIconImage: "task-complete"
    property string completeIconImage: "dialog-ok-apply"
    property string removeIconImage: "edit-delete"
    
    property int iconSize: 16
    property int toolIconSize: 22
    
    Row {
        spacing: 10
        anchors.left: parent.left
        
        PlasmaComponents.Switch {
            visible: !taskItem.completeTask            
        }
        
        QtExtras.QIconItem {
            icon: new QIcon(taskItem.completeTaskIconImage)
            visible: taskItem.completeTask
            height: taskItem.toolIconSize
            width: taskItem.toolIconSize
        }
        
        PlasmaComponents.Label {            
            text: taskName
        }
    }
    
    
    
    Row {
        id: toolBar
        visible: !tomatoid.inPomodoro && !tomatoid.inBreak
        anchors.right: parent.right
        
        PlasmaComponents.ToolButton {
            id: completeButton
            visible: true
            iconSource: taskItem.completeIconImage
            width: taskItem.toolIconSize
            height: taskItem.toolIconSize
        }
        
        PlasmaComponents.ToolButton {
            id: removeButton
            visible: true
            iconSource: taskItem.removeIconImage
            width: taskItem.toolIconSize
            height: taskItem.toolIconSize
        }
    }
}
