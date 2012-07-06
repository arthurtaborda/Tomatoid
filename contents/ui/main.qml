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

Item {
    id: devicenotifier
    property int minimumWidth: 190
    property int minimumHeight: 240

    PlasmaCore.Theme {
        id: theme
    }


    TopBar {
        id: topBar
        icon: "rajce"
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
    }


    ListView {
        id: taskList
        anchors {
            top: topBar.bottom
            left: topBar.left
            right: topBar.right
            topMargin: 10
        }

        PlasmaComponents.Label {
            id: labelTasks
            text: "Tasks"
            font.italic: true
            font.pointSize: 8
            color: "#444444"
        }

        TaskItem {
            id: item
            height: 10
            icon: "rajce"
            taskName: "teste"
            anchors {
                top: labelTasks.bottom
            }
        }
    }


}
