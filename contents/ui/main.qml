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

PlasmaComponents.Page {
    id: tomatoid
    property int minimumWidth: 190
    property int minimumHeight: 220
    property bool inPomodoro: false
    property bool inBreak: false

    property variant completeTasks: []
    property variant incompleteTasks: []

    Component.onCompleted: {
        configChanged()
    }

    function configChanged()
    {
        var tasksSourcesString = plasmoid.readConfig("tasks").toString();
        var tasks = new Array();
        if (tasksSourcesString.length > 0)
            tasks = tasksSourcesString.split("|");
        
        var complete = new Array();
        var incomplete = new Array();

        for(var i = 0; i < tasks.length; i++) {
            var task = tasks[i].split(",");
            if(task[0] == "1") {
                complete.push(task);
            } else {
                incomplete.push(task);
            }
        }
        
        completeTasks = complete;
        incompleteTasks = incomplete;
    }

    tools: topBar

    TopBar {
        id: topBar
        icon: "rajce"
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
    }

    TaskContainer {
        id: taskContainer
        completeTasks: completeTasks
        incompleteTasks: incompleteTasks
        
        anchors {
            top: topBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
}
