trigger AccountTrigger2 on Account (before insert, before update) {
    
    if(Trigger.isbefore && Trigger.isInsert){
       // AccountTriggerHandler.accMethod1(Trigger.new);
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
        //AccountTriggerHandler.accMethod2(Trigger.new, Trigger.oldMap);
        //AccountTriggerHandler.accMethod3(Trigger.new, Trigger.oldMap);
        //AccountTriggerHandler.accMethod4(Trigger.new, Trigger.oldMap);
        //AccountTriggerHandler.accMethod5(Trigger.new, Trigger.oldMap);
        AccountTriggerHandler.accMethod6(Trigger.new, Trigger.oldMap);
    }

}