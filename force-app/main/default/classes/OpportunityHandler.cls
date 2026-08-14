public class OpportunityHandler {
    
    //Write a trigger on Opportunity that assigns StageName = 'Prospecting' by default when a new Opportunity is created.
    public static void oppMethod1(List<Opportunity> oppList){
        for(Opportunity opp : oppList){
            if(String.isBlank(opp.StageName)){
                opp.StageName = 'Prospecting';
            }
            
        }
    }

    
    // Write a trigger on Opportunity that updates a checkbox Amount_Updated__c to true whenever the Amount field is modified.
    public static void oppMethod2(List<Opportunity> oppList, Map<Id,Opportunity> oppMap){
        for(Opportunity oppNewRec : oppList){
            Opportunity oppOldRec = oppMap.get(oppNewRec.id);
            if(oppOldRec.Amount != oppNewRec.Amount){
                oppNewRec.Amount_Updated__c = true;
            }
        }
    }
    
    
    //Write a trigger on Opportunity that prevents users from changing the StageName back to Prospecting once it has moved ahead.
    public static void oppMethod3(List<Opportunity> oppList, Map<Id,Opportunity> oppMap){
        for(Opportunity oppNewRec : oppList){
            Opportunity oppOldRec = oppMap.get(oppNewRec.id);
            if(oppOldRec.StageName != oppNewRec.StageName && oppOldRec.StageName != 'Prospecting' && oppNewRec.StageName == 'Prospecting' ){
                oppNewRec.StageName.addError('Cant change the StageName back to Prospecting once it has moved ahead');
            }
        }
    }
    
    
    //If Opportunity stagename is changed then update that stagename in that records description
    public static void oppMethod4(List<Opportunity> oppList, Map<Id,Opportunity> oppMap){
        for(Opportunity oppNewRec : oppList){
            Opportunity oppOldRec = oppMap.get(oppNewRec.id);
            if(oppOldRec.StageName != oppNewRec.StageName){
                oppNewRec.Description = oppNewRec.StageName; 
            }
        }
    }
    
    
    //If an Opportunity Close Date is updated to a past date, prevent the record from saving and show an error
    public static void oppMethod5(List<Opportunity> oppList, Map<Id,Opportunity> oppMap){
        for(Opportunity oppNewRec : oppList){
            Opportunity oppOldRec = oppMap.get(oppNewRec.id);
            if(oppOldRec.CloseDate != oppNewRec.CloseDate && oppNewRec.CloseDate < date.today()){
                oppNewRec.addError('Close Date Cannot be the past date');
            }
        }
    }
    
    
    
    //If Opportunity Stage is updated to “Closed Won”, prevent saving if Amount is less than 50,000.
    public static void oppMethod6(List<Opportunity> oppList, Map<Id,Opportunity> oppMap){
        for(Opportunity oppNewRec : oppList){
            Opportunity oppOldRec = oppMap.get(oppNewRec.id);
                if(oppOldRec.StageName != 'Closed Won' && oppNewRec.StageName == 'Closed Won' && oppNewRec.Amount < 50000){
                    oppNewRec.addError('Amount must be greater than 50k');
                }
            
        }
    }
    
    
    //If Opportunity Close Date is changed, update all related Tasks due dates to match the new Close Date.
    public static void oppMethod7(List<Opportunity> oppList, Map<Id,Opportunity> oppMap){
        
        Map<Id,Date> oppIdDateMap = new Map<Id,Date>();
        for(Opportunity oppNewRec : oppList){
            Opportunity oppOldRec = oppMap.get(oppNewRec.Id);
            if(oppOldRec.CloseDate != oppNewRec.CloseDate && oppOldRec.CloseDate != null){
                oppIdDateMap.put(oppNewRec.Id, oppNewRec.CloseDate);
            }
        }
        
        if(oppIdDateMap.isEmpty()){
            return;
        }
        
        List<Task> tskList = new List<Task>();
        for(Task tsk : [SELECT Id, WhatId, ActivityDate FROM Task WHERE WhatId in :oppIdDateMap.keySet()]){
        	tsk.ActivityDate = oppIdDateMap.get(tsk.WhatId);
            tskList.add(tsk);
        }
        
        if(!tskList.isEmpty()){
            update tskList;
        }
    }
    
    
    //If Opportunity Amount is modified, calculate and update a custom field Tax_Amount__c as 18% of Amount.
    public static void oppMethod8(List<Opportunity> oppList, Map<Id,Opportunity> oppMap){
        for(Opportunity oppNewRec : oppList){
            Opportunity oppOldRec = oppMap.get(oppNewRec.id);
            if(oppOldRec.Amount != oppNewRec.Amount && oppNewRec.Amount != null){
                oppNewRec.Tax_Amount__c = oppNewRec.Amount *0.18;
            }
        }
    }
    
    
    //When Opportunity Stage changes, maintain stage change history in a custom object.
    public static void oppMethod9(List<Opportunity> oppList, Map<Id,Opportunity> oppMap){
        List<Opportunity_Stage_History__c> oppNewList = new List<Opportunity_Stage_History__c>();
        for(Opportunity oppNewRec : oppList){
            Opportunity oppOldRec = oppMap.get(oppNewRec.Id);
            if(oppOldRec.StageName != oppNewRec.StageName && oppOldRec.StageName != null){
              Opportunity_Stage_History__c newOppStageHistory = new Opportunity_Stage_History__c();
                newOppStageHistory.Opportunity__c = oppNewRec.Id;
                newOppStageHistory.Old_Stage__c = oppOldRec.StageName;
                newOppStageHistory.New_Stage__c = oppNewRec.StageName;
                newOppStageHistory.Changed_Date__c = Date.today();
                
                oppNewList.add(newOppStageHistory);
                
 
            }
        }
        
        if(!oppNewList.isEmpty()){
            insert oppNewList;
        }
    }
    
    
    //When an Opportunity is created, create a Task reminder for the Opportunity owner.(Checks for Duplicate Task cretaion)
   
    public static void oppMethod10(List<Opportunity> oppList){
        List<Task> tskNewList = new List<Task>();
        for(Opportunity oppNewRec : oppList){
            Task tsk = new Task();
            tsk.Subject = 'Follow up On Opprtunity';
            tsk.WhatId = oppNewRec.Id;
            tsk.OwnerId = oppNewRec.OwnerId;
            tsk.Status = 'Not Started';
            tsk.ActivityDate = System.today().addDays(2);
            tskNewList.add(tsk);
        }
        
        if(!tskNewList.isEmpty()){
            insert tskNewList;
        }
    }
    
    
    
    //After creating an Opportunity, update a custom field Created_Date_Copy__c with today’s date.
    public static void oppMethod11(List<Opportunity> oppList){
        for(Opportunity oppNewRec : oppList){
            oppNewRec.Created_Date_Copy__c = Date.today();
            
        }
    }
    
    
    //Write a trigger whenever opportunity stage is changed then populate opportunity stagename to description field of account object
    public static void oppMethod12(List<Opportunity> oppList, Map<Id,Opportunity> oppMap){
        
        Map<Id,String> oppStageMap = new Map<Id,String>();
        
        for(Opportunity oppNewRec : oppList){
            Opportunity oppOldRec = oppMap.get(oppNewRec.Id);
            if(oppOldRec.StageName != oppNewRec.StageName && oppNewRec.AccountId != null){
                oppStageMap.put(oppNewRec.Id, oppNewRec.StageName);
            }
        }
        
        if(oppStageMap.isEmpty()){
            return;
        }
        
        List<Account> acc = new List<Account>();
        for(Opportunity opp : [SELECT Id, StageName, Account.Description FROM Opportunity WHERE Id in: oppStageMap.keySet()]){
            opp.Account.Description = oppStageMap.get(opp.Id);
            acc.add(opp.Account);
        }
        
        if(!acc.isEmpty()){
            update acc;
        }
        
    }
    
    public static void oppMethod13(List<Opportunity> oppList, Map<Id,Opportunity> oppMap){
        Map<Id,Account> accStageMap = new Map<Id,Account>();
        for(Opportunity oppNewRec : oppList){
            Opportunity oppOldRec = oppMap.get(oppNewRec.Id);
            if(oppOldRec.StageName != oppNewRec.StageName && oppNewRec.StageName != null){
                accStageMap.put(oppNewRec.AccountId, new Account(Id = oppNewRec.AccountId, Description = oppNewRec.StageName));
            }
        }
        if(!accStageMap.isEmpty()){
            update accStageMap.values();
        }
    }
    
    
    public static void oppMethod14(List<Opportunity> oppList, Map<Id,Opportunity> oppMap){
        
        Map<Id,List<String>> oppToAccountMap = new Map<Id,List<String>>();
        
        for(Opportunity oppNewRec : oppList){
            Opportunity oppOldRec = oppMap.get(oppNewRec.Id);
            if(oppOldRec.StageName != oppNewRec.StageName && oppNewRec.StageName != null){
                if(oppToAccountMap.containsKey(oppNewRec.AccountId)){
                    oppToAccountMap.get(oppNewRec.AccountId).add(oppNewRec.StageName);
                }
                else{
                    List<String> stageList = new List<String>();
                    stageList.add(oppNewRec.StageName);
                    oppToAccountMap.put(oppNewRec.AccountId, stageList);
                    
                }
            }
        }
        
        List<Account> accList = [SELECT Id, Description FROM ACCOUNT WHERE Id in :oppToAccountMap.keySet()];
        List<Account> accToUpdateList = new List<Account>();
        for(Account acc : accList){
            acc.Description = String.join(oppToAccountMap.get(acc.id),', ');
            accToUpdateList.add(acc);
        }
        
        if(!accToUpdateList.isEmpty()){
            update accToUpdateList;
        }
        
    }
    



	//Whenever an opportunity is Closed Won, create a Task for the Opportunity owner to split the revenue among the team with high priority
    public static void oppMethod15(List<Opportunity> oppList, Map<Id,Opportunity> oppMap){
        
        List<Task> tskList = new List<Task>();
        for(Opportunity oppNewRec : oppList){
            Opportunity oppOldRec = oppMap.get(oppNewRec.Id);
            if(oppOldRec.StageName != 'Closed Won' && oppNewRec.StageName == 'Closed Won' && oppOldRec != null){
                Task tsk = new Task();
            	tsk.WhatId = oppNewRec.Id;
                tsk.OwnerId = oppNewRec.OwnerId;
            	tsk.Subject = 'To Split the Revenue among the team';
            	tsk.Priority = 'High';
            	tskList.add(tsk);
            }
        }

        if(!tskList.isEmpty()){
            insert tskList;
        }
    }    
    
    
    //If Opportunity Stage is Modified, update Opportunity Amount, based on Probability * Expected Revenue 
    public static void oppMethod16(List<Opportunity> oppList, Map<Id,Opportunity> oppMap){
        for(Opportunity oppNewRec : oppList){
            Opportunity oppOldRec = oppMap.get(oppNewRec.Id);
            if(oppOldRec.StageName != oppNewRec.StageName && oppNewRec.Probability != null && oppNewRec.ExpectedRevenue != null){
                oppNewRec.Amount = oppNewRec.Probability * oppNewRec.ExpectedRevenue;
            }
        }
    }
    
    
	//As soon as an Opportunity is Deleted, create a task for the Opportunity Account Owner
	// to investigate why the record was deleted and submit the information 
    public static void oppMethod17(List<Opportunity> oppList){
        
        Set<Id> accIdsSet = new Set<Id>();
        
        for(Opportunity oppNewRec : oppList){
            if(oppNewRec.AccountId != null){
                accIdsSet.add(oppNewRec.AccountId);
            }
        }
        
        if(accIdsSet.isEmpty()){
            return;
        }
        
        Map<Id,Account> accMap = new Map<Id,Account>();
        for(Account acc : [SELECT Id, OwnerId FROM ACCOUNT WHERE Id IN :accIdsSet]){
            accMap.put(acc.id, acc);
        }
        
        List<Task> tskList = new List<Task>();
        for(Opportunity opp : oppList){
            if(opp.AccountId != null && accMap.containsKey(opp.AccountId)){
                Task tsk = new Task();
                tsk.OwnerId = accMap.get(opp.AccountId).OwnerId;
                tsk.WhatId = opp.AccountId;
                tsk.Subject = 'Investigate why the Opportunity was deleted and submit the information';
                tskList.add(tsk);
            }
        }
        
        if(!tskList.isEmpty()){
            insert tskList;
        }
        
        
    }
    
    
    
    //As soon as Opportunity Closed Lost, remove all opportunity team members from the opportunity
  /*public static void oppMethod18(List<Opportunity> oppList, Map<Id,Opportunity> oppMap){
        Set<Id> oppIds = new Set<Id>();
        for(Opportunity oppNewRec : oppList){
            Opportunity oppOldRec = oppMap.get(oppNewRec.Id);
            if(oppOldRec.StageName != 'Closed Lost' && oppNewRec.StageName == 'Closed Lost'){
                oppIds.add(oppNewRec.Id);
            }
        }
        
        if(oppIds.isEmpty()){
            return;
        }
        
        List<OpportunityTeamMember> oppTeamMember = [
    						SELECT Id, OpportunityId, UserId 
    						FROM OpportunityTeamMember 
    						WHERE OpportunityId IN :oppIds
			];
        
        if(!oppTeamMember.isEmpty()){
            delete oppTeamMember;
        }
   
    }
    
    */
    
    
    //As soon as Opportunity Stage reaches Needs Analysis, add all users of role: Opportunists to the team
    public static void oppMethod19(List<Opportunity> oppList, Map<Id,Opportunity> oppMap){
        
        List<OpportunityTeamMember> oppMemberList = new List<OpportunityTeamMember>();
        
        List<User> opportunists = [SELECT Id, UserRole.Name FROM User WHERE isActive = true AND UserRole.Name = 'Opportunists'];
        for(Opportunity oppNewRec : oppList){
            Opportunity oppOldRec = oppMap.get(oppNewRec.Id);
            if(oppNewRec.StageName == 'Needs Analysis' && oppOldRec.StageName != 'Needs Analysis' && oppNewRec.StageName != null){
                for(User userRec : opportunists){
                     OpportunityTeamMember oppMember = new OpportunityTeamMember();
               		 oppMember.OpportunityId = oppNewRec.Id;
                	 oppMember.OpportunityAccessLevel = 'Edit';
                	 oppMember.userId = userRec.Id;
                	 oppMemberList.add(oppMember);
                }
               
            }
        }
        if(!oppMemberList.isEmpty()){
            insert oppMemberList;
        }
    }
    
    
    
    
    
    
    
}