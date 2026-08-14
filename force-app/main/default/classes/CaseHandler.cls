public class CaseHandler {
    
    //Write a trigger on Case that stops users from reopening a Case once its Status is Closed.
    public static void caseMethod1(List<Case> caseList, Map<Id,Case> caseMap){
        for(Case caseNewRec : caseList){
            Case caseOldRec = caseMap.get(caseNewRec.id);
            if(caseOldRec.Status == 'Closed' && caseNewRec.Status != 'Closed' ){
                caseNewRec.addError('Cannot Reopen a Closed Case');
            }
        }
        
    }
    
    //Whenever a Case Priority is changed, update a text field Priority_Changed_By__c with the current user name.
    public static void caseMethod2(List<Case> caseList, Map<Id,Case> caseMap){
        for(Case caseNewRec : caseList){
            Case caseOldRec = caseMap.get(caseNewRec.id);
            if(caseOldRec.Priority != caseNewRec.Priority){
                caseNewRec.Priority_Changed_By__c = UserInfo.getName();
            }
        }
    }
    
    
    //When a Case Status changes to “Closed”, auto-populate the Case Close Reason if it is blank.
    public static void caseMethod3(List<Case> caseList, Map<Id,Case> caseMap){
        for(Case caseNewRec : caseList){
            Case caseOldRec = caseMap.get(caseNewRec.id);
            if(caseOldRec.Status != 'Closed' && caseNewRec.Status == 'Closed' && caseOldRec.Status != null){
                if(caseNewRec.Reason != null){
                    caseNewRec.Reason = 'Case has been Closed';
                }      
            }
        }
    }
    
    
    //After inserting a Case, send an email notification to the Case owner.
    public static void caseMethod4(List<Case> caseList){
        //collected OwnerIds
        Set<Id> ownerIds = new Set<Id>();
        for(Case caseNewRec : caseList){
            ownerIds.add(caseNewRec.OwnerId);
        }
        //Query Users(only users can recieve email directly)
        Map<Id,User> userMap = new Map<Id,User>(
            [SELECT Id,Email FROM User WHERE Id in :ownerIds]);   
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(Case caseNewRec : caseList){
            //Check if Owner is a user
            if(userMap.containsKey(caseNewRec.OwnerId)){ 
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[]{userMap.get(caseNewRec.OwnerId).Email});
                mail.setSubject('New Case Assigned');
                mail.setPlainTextBody(
                'A new Case ha been assigned to you. \n\n'+
                'Case Number : '+ caseNewRec.CaseNumber + '\n'+
                'Subject : '+ caseNewRec.Subject
                );
                emails.add(mail);     
            }
        }
        if(!emails.isEmpty()){
            Messaging.sendEmail(emails);
        }
        
    }
    
    
    //Whenever a Case is Created & Case Origin is Phone, Set Priority as High, else set Priority as Low
    public static void caseMethod5(List<Case> caseList){
        for(Case caseNewRec : caseList){
            if(caseNewRec.Origin == 'Phone'){
                caseNewRec.Priority = 'High';
            }
            else{
                caseNewRec.Priority = 'Low';
            }
        }
    }
    
    //Allow case Deletion only by System Admin users
    public static void caseMethod6(List<Case> caseList){
        Id currentUserProfileId =  UserInfo.getProfileId();
        Id sysAdminProfileId = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'LIMIT 1].id;
        for(Case caseOldRec : caseList){
            if(sysAdminProfileId != currentUserProfileId){
                caseOldRec.addError('System Admin Can only delete the Case');
            }
    }
}
    
    
    
    
    
    
    
    
    
}