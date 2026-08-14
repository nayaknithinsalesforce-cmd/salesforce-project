trigger LeadTrigger on Lead (before insert, before update, after insert, before delete) {
    
    if(Trigger.isbefore && Trigger.isinsert){
        //LeadHandler.leadMethod1(Trigger.new);
		//LeadHandler.leadMethod7(Trigger.new);
    }
    
    if(Trigger.isbefore && Trigger.isupdate){
        //LeadHandler.leadMethod2(Trigger.new, Trigger.oldMap);
       // LeadHandler.leadMethod3(Trigger.new, Trigger.oldMap);
       // LeadHandler.leadMethod4(Trigger.new, Trigger.oldMap);
        //LeadHandler.leadMethod5(Trigger.new, Trigger.oldMap);
        //LeadHandler.leadMethod6(Trigger.new, Trigger.oldMap);
        //LeadHandler.leadMethod8(Trigger.new,Trigger.oldMap);
        //LeadHandler.leadMethod9(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
       // LeadHandler.leadMethod10(Trigger.new);
    }

    
    if(Trigger.isBefore && Trigger.isDelete){
        LeadHandler.leadMethod11(Trigger.old);
    }
}