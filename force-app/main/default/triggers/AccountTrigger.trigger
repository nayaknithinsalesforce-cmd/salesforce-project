trigger AccountTrigger on Account (before insert, before update, after update, after insert) {
    
    if(Trigger.isbefore && Trigger.isinsert){
        //AccountHandler.accMethod1(Trigger.new);
       // AccountHandler.accMethod17(Trigger.new);
    }

    if(Trigger.isbefore && Trigger.isupdate){
       // AccountHandler.accMethod2(Trigger.new , Trigger.oldMap);
       // AccountHandler.accMethod3(Trigger.new , Trigger.oldMap);
        //AccountHandler.accMethod4(Trigger.new , Trigger.oldMap);
       // AccountHandler.accMethod5(Trigger.new , Trigger.oldMap);
       // AccountHandler.accMethod6(Trigger.new, Trigger.oldMap);
       // AccountHandler.accMethod9(Trigger.new, Trigger.oldMap);
       // AccountHandler.accMethod11(Trigger.new, Trigger.oldMap);
      // AccountHandler.accMethod14(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
      //  AccountHandler.accMethod7(Trigger.new, Trigger.oldMap);
       // AccountHandler.accMethod8(Trigger.new, Trigger.oldMap);
       // AccountHandler.accMethod10(Trigger.new, Trigger.oldMap);
       //AccountHandler.accMethod15(Trigger.new, Trigger.oldMap);
        //AccountHandler.accMethod18(Trigger.new, Trigger,oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
       // AccountHandler.accMethod12(Trigger.new);
       //AccountHandler.accMethod13(Trigger.new);
       //AccountHandler.accMethod16(Trigger.new);
    }
}