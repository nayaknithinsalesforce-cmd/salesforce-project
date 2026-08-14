public class AccountTriggerHandler {
    
    //Write a trigger on Account that converts the Account Name to UPPERCASE when a record is created.
    public static void accMethod1(List<Account> accList){
        for(Account accNewRec : accList ){
            accNewRec.Name = accNewRec.Name.toUpperCase();        }
    }
    
    
    //Write a trigger on Account that prevents users from changing the Account Type once it is set to Customer.
    public static void accMethod2(List<Account> accList, Map<Id,Account> accMap){
        for(Account accNewRec : accList){
            Account accOldRec = accMap.get(accNewRec.Id);
                if( accNewRec.Type != accOldRec.Type  && (accOldRec.Type == 'Customer - Direct' || accOldRec.Type == 'Customer - Channel' )){
                    accNewRec.Type.addError('Type cannot be changed once set to Customer');
                }
                        
        }
    }
    
    
    //Write a trigger on Account that updates the Description to 'Account Updated' whenever the Account record is modified.
    public static void accMethod3(List<Account> accList, Map<Id,Account> accMap){
        for(Account accNewRec : accList){
            Account accOldRec = accMap.get(accNewRec.Id);
            if(accOldRec != accNewRec){
                accNewRec.Description = 'Account Updated';
            }
        }
    }
    
    
    //Whenever an Account’s Phone is updated, copy the same value into a custom field Previous_Phone__c
    public static void accMethod4(List<Account> accList, Map<Id,Account> accMap){
        for(Account accNewRec : accList){
            Account accOldRec = accMap.get(accNewRec.Id);
            if(accOldRec.Phone != accNewRec.Phone && String.isNotBlank(accOldRec.Phone)){
                accNewRec.Previous_Phone__c = accOldRec.Phone;
            }
        }
    }
    
    
    //If an Account’s Industry is updated, prevent saving if the value is blank.
    public static void accMethod5(List<Account> accList, Map<Id,Account> accMap){
        for(Account accNewRec : accList){
            Account accOldRec = accMap.get(accNewRec.Id);
            if(accOldRec.Industry != accNewRec.Industry && String.isBlank(accNewRec.Industry)){
                accNewRec.Industry.addError('Cannot keep Industry blank');
            }
        }
        
    }


   //Whenever an Account Rating is updated, store the old value in a custom field Old_Rating__c.
    public static void accMethod6(List<Account> accList, Map<Id,Account> accMap){
        for(Account accNewRec : accList){
            Account accOldRec = accMap.get(accNewRec.Id);
            if(accOldRec.Rating != accNewRec.Rating && String.isNotBlank(accOldRec.Rating)){
                accNewRec.Old_Rating__c = accOldRec.Rating;
            }
        }
        
    }    
    
    
    
    
    
    
    
}