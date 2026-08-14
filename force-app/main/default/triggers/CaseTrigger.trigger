trigger CaseTrigger on Case (before insert, before update, after insert,before delete) {
    
    if(Trigger.isbefore && Trigger.isupdate){
       // CaseHandler.caseMethod1(Trigger.new, Trigger.oldMap);
       // CaseHandler.caseMethod2(Trigger.new, Trigger.oldMap);
        //CaseHandler.caseMethod3(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isinsert){
       // CaseHandler.caseMethod4(Trigger.new);
    }
    
    if(Trigger.isBefore && Trigger.isInsert){
       // CaseHandler.caseMethod5(Trigger.new);
    }
    
    if(Trigger.isBefore && Trigger.isDelete){
        CaseHandler.caseMethod6(Trigger.old);
    }

}