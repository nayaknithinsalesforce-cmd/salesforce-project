trigger OpportunityTrigger on Opportunity (before insert ,before update,after update, after insert, after delete ) {
    
    if(Trigger.isbefore && Trigger.isinsert){
       // OpportunityHandler.oppMethod1(Trigger.new);
       // OpportunityHandler.oppMethod11(Trigger.new);
    }
    
    if(Trigger.isbefore && Trigger.isUpdate){
       // OpportunityHandler.oppMethod2(Trigger.new, Trigger.oldMap);
       // OpportunityHandler.oppMethod3(Trigger.new, Trigger.oldMap);
       // OpportunityHandler.oppMethod4(Trigger.new, Trigger.oldMap);
       // OpportunityHandler.oppMethod5(Trigger.new, Trigger.oldMap);
       // OpportunityHandler.oppMethod6(Trigger.new, Trigger.oldMap);
       // OpportunityHandler.oppMethod8(Trigger.new, Trigger.oldMap);
       // OpportunityHandler.oppMethod9(Trigger.new, Trigger.oldMap);
       //OpportunityHandler.oppMethod16(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
       // OpportunityHandler.oppMethod7(Trigger.new, Trigger.oldMap);
       // OpportunityHandler.oppMethod9(Trigger.new, Trigger.oldMap);
       //OpportunityHandler.oppMethod12(Trigger.new, Trigger.oldMap);
      // OpportunityHandler.oppMethod13(Trigger.new, Trigger.oldMap);
      //OpportunityHandler.oppMethod15(Trigger.new, Trigger.oldMap);
      OpportunityHandler.oppMethod19(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isinsert){
      //  OpportunityHandler.oppMethod10(Trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isDelete){
        //OpportunityHandler.oppMethod17(Trigger.old);
        OpportunityHandler.oppMethod17(Trigger.old);
    }

}