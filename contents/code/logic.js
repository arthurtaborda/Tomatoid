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

 function parseConfig(configName, model) {
    var tasksSourcesString = plasmoid.readConfig(configName).toString();
    var tasks = new Array();
    if (tasksSourcesString.length > 0)
        tasks = tasksSourcesString.split("|");


    for(var i = 0; i < tasks.length; i++) {
        var task = tasks[i].split(",");
        model.append({"taskId":parseInt(task[0]),"name":task[1],"pomodoros":parseInt(task[2])});
    }
}


function newTask(taskName) {
    addTask(taskName, 0, incompleteTasks, "incompleteTasks");
}


function insertIncompleteTask(taskName, pomodoros) {
    addTask(taskName, pomodoros, incompleteTasks, "incompleteTasks");
}


function insertCompleteTask(taskName, pomodoros) {
    addTask(taskName, pomodoros, completeTasks, "completeTasks");
}


function addTask(taskName, pomodoros, model, configName) {
    var tasks = "";

    for(var i = 0; i < model.count; i++) {
        tasks += model.get(i).taskId + "," + model.get(i).name + "," + model.get(i).pomodoros + "|"
    }

    var id = 0;

    if(model.count > 0) {
        var id = parseInt(model.get(model.count-1).taskId) + 1
    }


    tasks += id + "," + taskName + "," + pomodoros


    console.log(tasks);
    plasmoid.writeConfig(configName, tasks);
    model.append({"taskId":id,"name":taskName,"pomodoros":pomodoros});
}


function removeIncompleteTask(id) {
    return removeTask(id, incompleteTasks, "incompleteTasks");
}


function removeCompleteTask(id) {
    return removeTask(id, completeTasks, "completeTasks");
}


function removeTask(id, model, configName) {
    var removedTask = "";
    var tasks = "";
    var index = 0;

    for(var i = 0; i < model.count; i++) {
        if(id != model.get(i).taskId) {
            if(tasks != "") {
                tasks += "|";
            }
            tasks += model.get(i).taskId + "," + model.get(i).name + "," + model.get(i).pomodoros;

        } else {
            removedTask = model.get(i).name + "," + model.get(i).pomodoros;
            index = i;
        }
    }

    console.log(tasks);
    plasmoid.writeConfig(configName, tasks);
    model.remove(index);

    return removedTask; //return taskName,pomodoros
}


function doTask(id) {
    var removedTask = removeIncompleteTask(id);
    var split = removedTask.split(",");

    console.log(removedTask);
    console.log(split);

    insertCompleteTask(split[0], split[1]);
}


function undoTask(id) {
    var removedTask = removeCompleteTask(id);
    var split = removedTask.split(",");

    console.log(removedTask);
    console.log(split);

    insertIncompleteTask(split[0], split[1]);
}



function startTask(id, name) {
    console.log(plasmoid.popupIcon)
    timer.taskId = id;
    timer.taskName = name;
    timer.totalSeconds = //5;
    pomodoroLenght * 60;
    timer.running = true;
    inPomodoro = true;
    inBreak = false;
}



function startBreak() {
    console.log(plasmoid.popupIcon)

    if(completedPomodoros % pomodorosPerLongBreak == 0) {
        timer.totalSeconds = //5;
        longBreakLenght * 60;
    } else {
        timer.totalSeconds = //5;
        shortBreakLenght * 60;
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
    console.log(taskId)

    var tasks = "";
    var index = 0;

    for(var i = 0; i < incompleteTasks.count; i++) {

        var pomodoros = incompleteTasks.get(i).pomodoros
        if(taskId == incompleteTasks.get(i).taskId) {
            pomodoros += 1;
            index = i;
        }

        tasks += incompleteTasks.get(i).taskId + "," + incompleteTasks.get(i).name + "," + pomodoros;
        if(i < incompleteTasks.get(i) + 1) {
            tasks += "|";
        }
    }

    completedPomodoros += 1
    plasmoid.writeConfig("incompleteTasks", tasks);
    incompleteTasks.setProperty(index, "pomodoros", incompleteTasks.get(index).pomodoros + 1)
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