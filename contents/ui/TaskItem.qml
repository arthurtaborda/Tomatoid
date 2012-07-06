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
import org.kde.qtextracomponents 0.1

Item {
    id: taskItem
    property string icon
    property string taskName

    property int iconSize: 22
    property int iconMargin: 8

    QIconItem {
        id: deviceIcon
        width: 22
        height: 22
        icon: new QIcon(parent.icon)
        anchors {
            left: parent.left
            leftMargin: 10
            top: parent.top
        }
    }


    PlasmaComponents.Label {
        id: taskLabel
        text: taskName
        anchors {
            top: parent.top
            left: deviceIcon.right
            leftMargin: 5
        }
        verticalAlignment: Text.AlignVCenter
    }

    PlasmaCore.Theme { id: theme }

    Item {
        id: freeSpaceBarPlaceholder
        anchors.fill: freeSpaceBar
        z: 900
    }

    PlasmaCore.ToolTip {
        target: freeSpaceBarPlaceholder
        subText: i18nc("@info:status Free disk space", "%1 free", model["Free Space Text"])
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: menuItem.clicked(source);
        onEntered: menuListView.currentIndex = index;
    }


    MouseArea {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: parent.width
        hoverEnabled: true

        Item {
            id: controlButtons
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: taskItem.iconMargin
            anchors.rightMargin: taskItem.iconMargin
            width: taskItem.width
            visible: false



            ToolButton {
                id: playButton
                anchors.top: parent.top
                anchors.right: parent.right
                visible: false
                iconSource: "kt-start"
                width: taskItem.iconSize
                height: taskItem.iconSize
            }

            ToolButton {
                id: removeButton
                anchors.top: parent.top
                anchors.right: playButton.left
                visible: false
                iconSource: "edit-delete"
                width: taskItem.iconSize
                height: taskItem.iconSize
                onClicked: {
                }
            }

            ToolButton {
                id: completeButton
                anchors.top: parent.top
                anchors.right: removeButton.left
                visible: false
                iconSource: "dialog-ok-apply"
                width: taskItem.iconSize
                height: taskItem.iconSize
                onClicked: {
                }
            }
        }

        onEntered: {
            menuListView.currentIndex = index; // same as in the MouseArea above
            controlButtons.visible = isApp && favoritesVisible
            playButton.visible = !isFavorite;
            removeFavoriteIcon.visible = isFavorite;
            moveFavoriteDownIcon.visible = isFavorite && isInFavoritesList && index < menuListView.count - 1;
            moveFavoriteUpIcon.visible = isFavorite && isInFavoritesList && index > 0;
        }
        onExited: {
            controlButtons.visible = false;
        }
        onClicked: menuItem.clicked(source); // same as in the MouseArea above
    }

    PlasmaCore.ToolTip {
        target: leftAction
        subText: {
            if (!model["Accessible"]) {
                return i18n("Click to mount this device.")
            } else if (model["Device Types"].indexOf("Optical Disk") != -1) {
                return i18n("Click to eject this disc.")
            } else if (model["Removable"]) {
                return i18n("Click to safely remove this device.")
            } else {
                return i18n("Click to access this device from other applications.")
            }
        }
    }

    PlasmaCore.ToolTip {
        target: deviceIcon
        subText: {
            if (model["Accessible"]) {
                if (model["Removable"]) {
                    return i18n("It is currently <b>not safe</b> to remove this device: applications may be accessing it. Click the eject button to safely remove this device.")
                } else {
                    return i18n("This device is currently accessible.")
                }
            } else {
                if (model["Removable"]) {
                    if (model["In Use"]) {
                        return i18n("It is currently <b>not safe</b> to remove this device: applications may be accessing other volumes on this device. Click the eject button on these other volumes to safely remove this device.");
                    } else {
                        return i18n("It is currently safe to remove this device.")
                    }
                } else {
                    return i18n("This device is not currently accessible.")
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: freeSpaceBar.bottom
            // to remove the gap between device items
            bottomMargin: -actionsList.anchors.topMargin
        }
        hoverEnabled: true
        onEntered: {
            notifierDialog.currentIndex = index;
            notifierDialog.highlightItem.opacity = 1;
        }
        onExited: {
            notifierDialog.highlightItem.opacity = expanded ? 1 : 0;
        }
        onClicked: {
            if (leftAction.visible
                    && mouse.x>=leftAction.x && mouse.x<=leftAction.x+leftAction.width
                    && mouse.y>=leftAction.y && mouse.y<=leftAction.y+leftAction.height)
            {
                leftActionTriggered();
            }
        }
    }
}
