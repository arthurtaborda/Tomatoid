function parseConfig(configName, model) {
    var tasksSourcesString = plasmoid.readConfig(configName).toString();
    var tasks = new Array();
    if (tasksSourcesString.length > 0)
        tasks = tasksSourcesString.split("|");
    
    console.log(tasks[0])
    console.log(tasks[1])
    
    for(var i = 0; i < tasks.length; i++) {
        var task = tasks[i].split(",");
        model.append({"name":task[0],"pomodorosExpected":parseInt(task[1]),
                     "pomodorosCompleted":parseInt(task[2])});
    }
} 