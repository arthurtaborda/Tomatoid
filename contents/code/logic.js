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
        console.log(model.get(i).taskId)
        tasks += model.get(i).taskId + "," + model.get(i).name + "," + model.get(i).pomodoros + "|"
    }
    
    var id = 0;
    
    if(model.count > 0)
        var id = parseInt(model.get(model.count-1).taskId) + 1
        
        tasks += id + "," + taskName + "," + pomodoros
        
        console.log(id)
        
        plasmoid.writeConfig(configName, tasks);
    model.append({"taskId":id,"name":taskName,"pomodoros":pomodoros});
}


function removeIncompleteTask(id) {
    removeTask(id, incompleteTasks, "incompleteTasks");
}


function removeCompleteTask(id) {
    removeTask(id, completeTasks, "completeTasks");
}


function removeTask(id, model, configName) {
    console.log(id)
    
    var tasks = "";
    var index = 0;
    
    for(var i = 0; i < model.count; i++) {
        if(id != model.get(i).taskId) {
            tasks += model.get(i).taskId + "," + model.get(i).name + "," + model.get(i).pomodoros;
            if(i < model.count + 1) {
                tasks += "|";
            }
        } else {
            index = i;
        }
    }
    
    plasmoid.writeConfig(configName, tasks);
    model.remove(index);
}


function doTask(id, name, pomodoros) {    
    insertCompleteTask(name, pomodoros);
    removeIncompleteTask(id);
}


function undoTask(id, name, pomodoros) {    
    insertIncompleteTask(name, pomodoros);
    removeCompleteTask(id);
}



function startTask(id) {
    console.log(id)
    tomatoidTimer.taskId = id;
    tomatoidTimer.totalSeconds = 5;
    tomatoidTimer.running = true;
    inPomodoro = true;
    inBreak = false;
}



function startBreak() {
    console.log(completedPomodoros)
    if(completedPomodoros % 4 == 0) {
        tomatoidTimer.totalSeconds = 15;
    } else {
        tomatoidTimer.totalSeconds = 5;
    }
    
    tomatoidTimer.running = true;
    inPomodoro = false;
    inBreak = true;
}


function stop() {
    tomatoidTimer.totalSeconds = 0;
    tomatoidTimer.running = false;
    inPomodoro = false;
    inBreak = false;
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