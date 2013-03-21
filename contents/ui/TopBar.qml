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

 import QtQuick 1.0
 import org.kde.plasma.core 0.1 as PlasmaCore
 import org.kde.plasma.components 0.1 as PlasmaComponents
 import org.kde.qtextracomponents 0.1 as QtExtras

 import "plasmapackage:/code/logic.js" as Logic

 PlasmaComponents.ToolBarLayout {
	id: topBar

	property string icon

	PlasmaComponents.Label {
		text: {
			if(tomatoid.inPomodoro)
			return "Running pomodoro #" + (tomatoid.completedPomodoros + 1)
			else if(tomatoid.inBreak)
			return "Time to relax"

			return ""
		}
		visible: tomatoid.inPomodoro || tomatoid.inBreak
	}

	Row {
		spacing: 2
		visible: !tomatoid.inPomodoro && !tomatoid.inBreak
		PlasmaComponents.TextField {
			id: taskField
			placeholderText: "Task Name"

			Keys.onReturnPressed: {
				add()
			}
		}


		PlasmaComponents.Button {
			id: addTaskButton
			iconSource: "list-add"
			text: "Add"
			width: 55

			onClicked: {
				add()
			}
		}
	}

	function add() {
		if(taskField.text != "") {
			Logic.newTask(taskField.text)
			taskField.text = ""
		}
	}
}
