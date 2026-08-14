trigger TaskTrigger on Task (before insert) {
    
    if(Trigger.isBefore && Trigger.isInsert){
        TaskHandler.taskMethod1(Trigger.new);
    }

}