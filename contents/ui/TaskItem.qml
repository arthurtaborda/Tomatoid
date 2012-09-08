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
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.core 0.1 as PlasmaCore

Item {
    id: taskItem
    
    property bool done
    property int pomos
    property int identity
    property string taskName
    
    property string startIconImage: "chronometer"
    property string removeIconImage: "edit-delete"
    
    property int iconSize: 22
    property int margin: 8
    
    signal entered(int index)
    signal taskDone()
    signal removed()
    signal started()
    signal exited()
    
    height: 32
    anchors.leftMargin: margin
    anchors.rightMargin: margin
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            taskItem.entered(index)
        }
        
        onExited: {
            taskItem.exited(index)
        }
        
        
        Item {
            id: row
            width: parent.width
            height: parent.height
            
            PlasmaComponents.CheckBox {
                id: checkBox
                checked: done
                enabled: !tomatoid.timerRunning
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                
                onClicked: taskDone()            
            }
            
            
            PlasmaComponents.Label {            
                text: "( " + pomos + " ) " + taskName
                anchors.left: checkBox.right
                anchors.leftMargin: 4
                anchors.verticalCenter: parent.verticalCenter
            }
            
            
            Row {
                id: toolBar
                spacing: 5
                visible: !tomatoid.timerRunning
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                
                PlasmaComponents.ToolButton {
                    id: removeButton
                    iconSource: removeIconImage
                    width: iconSize
                    height: iconSize
                    
                    onClicked: removed()
                }
                
                PlasmaComponents.Button {
                    id: startButton
                    visible: !done
                    text: "Start"
                    iconSource: startIconImage
                    width: 58
                    height: iconSize
                    
                    onClicked: started()
                }
            }
        }        
    }    
}
