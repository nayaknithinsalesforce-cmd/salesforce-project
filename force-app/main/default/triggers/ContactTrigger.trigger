trigger ContactTrigger on Contact (before insert, before update, after insert, after update, after delete, after undelete ) {
    
    if(Trigger.isbefore && Trigger.isinsert){
        //ContactHandler.conMethod1(Trigger.new);
       // ContactHandler.conMethod2(Trigger.new);
      	//  ContactHandler.conMethod10(Trigger.new);
      	//ContactHandler.conMethod12(Trigger.new);
        
    }
    
    if(Trigger.isbefore && Trigger.isupdate){
      //  ContactHandler.conMethod3(Trigger.new, Trigger.oldMap);
      //  ContactHandler.conMethod4(Trigger.new, Trigger.oldMap);
      //  ContactHandler.conMethod5(Trigger.new, Trigger.oldMap);
       // ContactHandler.conMethod6(Trigger.new, Trigger.oldMap);
       // ContactHandler.conMethod7(Trigger.new, Trigger.oldMap);
       // ContactHandler.conMethod8(Trigger.new, Trigger.oldMap);
       // ContactHandler.conMethod9(Trigger.new);
    }
    
    if(Trigger.isafter && Trigger.isinsert){
        //ContactHandler.conMethod9(Trigger.new);
        ContactHandler.conMethod14(Trigger.new);
    }
    
    if(Trigger.isAfter){
       // ContactHandler.conMethod11(Trigger.new, Trigger.old, Trigger.oldMap);
    }

}