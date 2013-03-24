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
var sep = "_,$";
var sep2 = "|&*";
var test = false;

// function newTaskDB(taskName) {
//     var db = openDataBaseSync("tomatoid_db", "1.0")
//     db.transaction(
//         function(tx) {
//             tx.executeSql('CREATE TABLE IF NOT EXISTS tasks(task_name TEXT, complete_pomo INT, estimate_pomo INT)');
//             tx.executeSql('INSERT INTO tasks VALUES(?, ?, ?)', [ taskName, 0, 0 ]);
//         }
//     )
// }

function parseConfig(configName, model) {
	var tasksSourcesString = plasmoid.readConfig(configName).toString();
	var tasks = new Array();
	if (tasksSourcesString.length > 0)
		tasks = tasksSourcesString.split(sep2);

	for(var i = 0; i < tasks.length; i++) {
		var task = tasks[i].split(sep);
		model.append({"taskId":parseInt(task[0]),"taskName":task[1],"donePomos":parseInt(task[2]),"estimatedPomos":parseInt(task[3])});
	}
}

function newTask(taskName, estimatedPomos) {
	addTask(taskName, 0, estimatedPomos, incompleteTasks, "incompleteTasks");
}

function insertIncompleteTask(taskName, donePomos, estimatedPomos) {
	addTask(taskName, donePomos, estimatedPomos, incompleteTasks, "incompleteTasks");
}
function insertCompleteTask(taskName, donePomos, estimatedPomos) {
	addTask(taskName, donePomos, estimatedPomos, completeTasks, "completeTasks");
}

function removeIncompleteTask(id) {
	return removeTask(id, incompleteTasks, "incompleteTasks");
}
function removeCompleteTask(id) {
	return removeTask(id, completeTasks, "completeTasks");
}


function addTask(taskName, donePomos, estimatedPomos, model, configName) {
	var id = 0;
	var tasks = "";

	if(model.count > 0) {
		var id = parseInt(model.get(model.count-1).taskId) + 1 //get next possible id

		for(var i = 0; i < model.count; i++) {
			tasks += model.get(i).taskId + sep + model.get(i).taskName + sep +
			model.get(i).donePomos + sep + model.get(i).estimatedPomos + sep2
		}
	}

	tasks += id + sep + taskName + sep + donePomos + sep + estimatedPomos

	console.log(tasks);
	plasmoid.writeConfig(configName, tasks);
	model.append({"taskId":id,"taskName":taskName,"donePomos":donePomos,"estimatedPomos":estimatedPomos});
}

function removeTask(id, model, configName) {
	var removedTask = "";
	var tasks = "";
	var index = 0;

	for(var i = 0; i < model.count; i++) {
		var task = model.get(i);
		if(id != task.taskId) {
			if(tasks != "") tasks += sep2;

			tasks += task.taskId + sep + task.taskName + sep + task.donePomos + sep + task.estimatedPomos;
		} else {
			removedTask = task.taskName + sep + task.donePomos + sep + task.estimatedPomos;
			index = i;
		}
	}

	console.log(tasks);
	plasmoid.writeConfig(configName, tasks);
	model.remove(index);

	return removedTask;
}


function renameTask(id, taskName) {
	var index = 0;
	var tasks = "";
	var model = incompleteTasks;

	console.log(id);
	console.log(taskName);

	for(var i = 0; i < model.count; i++) {
		var task = model.get(i);
		if(tasks != "") tasks += sep2;

		tasks += task.taskId + sep;

		if(id == task.taskId) {
			index = id;
			tasks += taskName; //if id matches, insert changed name
		} else {
			tasks += task.taskName;
		}

		tasks += sep + task.donePomos + sep + task.estimatedPomos;
	}

	console.log(tasks);
	console.log(index);
	plasmoid.writeConfig("incompleteTasks", tasks);
	model.setProperty(index, "taskName", taskName);
}


function doTask(id) {
	var removedTask = removeIncompleteTask(id);
	var split = removedTask.split(sep);

	console.log(removedTask);
	console.log(split);

	insertCompleteTask(split[0], split[1], split[2]);
}


function undoTask(id) {
	var removedTask = removeCompleteTask(id);
	var split = removedTask.split(sep);

	console.log(removedTask);
	console.log(split);

	insertIncompleteTask(split[0], split[1], split[2]);
}


function startTask(id, taskName) {
	console.log(plasmoid.popupIcon)
	timer.taskId = id;
	timer.taskName = taskName;
	timer.totalSeconds = test ? pomodoroLenght : pomodoroLenght * 60;
	timer.running = true;
	inPomodoro = true;
	inBreak = false;
}


function startBreak() {
	console.log(plasmoid.popupIcon)

	if(completedPomodoros % pomodorosPerLongBreak == 0) {
		timer.totalSeconds = test ? longBreakLenght : longBreakLenght * 60;
	} else {
		timer.totalSeconds = test ? shortBreakLenght : shortBreakLenght * 60;
	}
	timer.running = true;
	inPomodoro = false;
	inBreak = true;
}


function stop() {
	console.log(plasmoid.popupIcon)

	timer.running = false;
	inPomodoro = false;
	inBreak = false;
	timer.totalSeconds = 0;
}


function completePomodoro(taskId) {
	var tasks = "";
	var index = 0;

	for(var i = 0; i < incompleteTasks.count; i++) {
		var task = incompleteTasks.get(i);
		var donePomos = task.donePomos;

		if(tasks != "") tasks += sep2;

		if(taskId == task.taskId) {
			donePomos += 1;
			index = i;
		}

		tasks += task.taskId + sep +
		task.taskName + sep + donePomos + sep + task.estimatedPomos;
	}

	completedPomodoros += 1

	console.log(tasks);
	plasmoid.writeConfig("incompleteTasks", tasks);
	incompleteTasks.setProperty(index, "donePomos", incompleteTasks.get(index).donePomos + 1)
}


function notify(summary, body) {
	var engine = dataEngine("notifications");
	var service = engine.serviceForSource("notification");
	var op = service.operationDescription("createNotification");
	op["appName"] = tomatoid.appName;
	op["appIcon"] = "chronometer"
	op["summary"] = summary;
	op["body"] = body;
	op["timeout"] = 7000;

	service.startOperationCall(op);

	console.log(op)
}
