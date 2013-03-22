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

 Item {
	id: taskItem

	property bool done
	property int pomos
	property int identity
	property string taskName
	property bool editMode

	property string startIconImage: "media-playback-start"
	property string removeIconImage: "window-close"
	property string completeIconImage: "media-record"
	property string undoIconImage: "media-seek-backward"

	property int iconSize: 22
	property int margin: 8

	property QtObject timer: plasmoid.rootItem.timer
	property int seconds: timer.seconds
	property bool timerRunning: seconds > 0 || timer.running

	signal entered(int index)
	signal taskDone()
	signal removed()
	signal started()
	signal saved()
	signal exited()

	height: 32
	anchors.leftMargin: margin
	anchors.rightMargin: margin


	PlasmaCore.Theme { id: theme }

	MouseArea {
		id:mouseArea
		anchors.fill: parent
		hoverEnabled: true
		onEntered: {
			taskItem.entered(index)
		}

		onExited: {
			taskItem.exited(index)
		}

		onDoubleClicked: {
			if(!timerRunning)
				editMode = ! editMode
		}


		Item {
			id: row
			width: parent.width
			height: parent.height

			Text {
				text: "( " + pomos + " ) " + taskName
				anchors.left: parent.left
				anchors.right: toolBar.left
				anchors.leftMargin: 4
				anchors.verticalCenter: parent.verticalCenter
				visible: !editMode
				color: theme.textColor
			}

			PlasmaComponents.TextField {
				id: taskNameEdit
				text: taskName
				visible: editMode
				anchors.left: parent.left
				anchors.right: toolBar.left
				anchors.leftMargin: 4
				anchors.rightMargin: 8
				anchors.verticalCenter: parent.verticalCenter

				Keys.onReturnPressed: {
					if(taskNameEdit.text != "")
						taskName = taskNameEdit.text
					editMode = false
					saved()
				}
			}

			Row {
				id: toolBar
				spacing: 5
				visible: !tomatoid.timerRunning
				anchors.right: parent.right
				anchors.verticalCenter: parent.verticalCenter


				PlasmaComponents.Button {
					id: completeButton
					iconSource: {
						if(!done) return completeIconImage
						else return undoIconImage
					}
					width: iconSize
					height: iconSize
					enabled: !tomatoid.timerRunning
					opacity: mouseArea.containsMouse * 1

					onClicked: taskDone()
				}

				PlasmaComponents.Button {
					id: removeButton
					iconSource: removeIconImage
					width: iconSize
					height: iconSize
					opacity: mouseArea.containsMouse * 1

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
