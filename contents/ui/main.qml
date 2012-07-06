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
    property string completeTaskIconImage: "task-complete"
    property string incompleteTaskIconImage: "task-accepted"

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

    PlasmaComponents.TabBar {
        id: tabBar
        height: 30

        PlasmaComponents.TabButton { tab: incompleteTaskPage; text: "Undone Tasks" }
        PlasmaComponents.TabButton { tab: completeTaskPage; text: "Done Tasks" }

        anchors {
            top: topBar.bottom
            left: parent.left
            right: parent.right
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
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
                }

                TaskItem {
                    id: undoneItem
                    height: 25
                    iconImage: tomatoid.incompleteTaskIconImage
                    taskName: "Undone Task"
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }
                }

                TaskItem {
                    id: undoneItem2
                    height: 25
                    iconImage: tomatoid.incompleteTaskIconImage
                    taskName: "Undone Task"
                    anchors {
                        top: undoneItem.bottom
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
                    height: 10
                    iconImage: tomatoid.completeTaskIconImage
                    taskName: "Done Task"
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
