public class AccountHandler {
    
    //Write a trigger on Account that converts the Account Name to UPPERCASE when a record is created.
    public static void accMethod1(List<Account> accList){
        for(Account acc : accList){
            acc.Name = acc.Name.toUpperCase();
        }
    }
    
    //Write a trigger on Account that prevents users from changing the Account Type once it is set to Customer.
    public static void accMethod2(List<Account> accList, Map<Id,Account> accMap){
        for(Account accNewRec : accList){
            Account accOldRec = accMap.get(accNewRec.id);
            if(accOldRec.Type != accNewRec.Type){
            	if(accOldRec.Type == 'Customer - Direct' || accOldRec.Type == 'Customer - Channel'){
					accNewRec.addError('Cant change the type');
                }
            }
        }
    }
    
    //Write a trigger on Account that updates the Description to 'Account Updated' whenever the Account record is modified.
    public static void accMethod3(List<Account> accList, Map<Id,Account> accMap){
        for(Account accNewRec : accList){
            Account accOldRec = accMap.get(accNewRec.id);
            if(accOldRec != accNewRec){
                accNewRec.Description = 'Account Updated';
            }
        }
    }
    
    
    //Whenever an Account’s Phone is updated, copy the same value into a custom field Previous_Phone__c
    public static void accMethod4(List<Account> accList, Map<Id,Account> accMap){
        for(Account accNewRec : accList){
            Account accOldRec = accMap.get(accNewRec.id);
            if(accOldRec.Phone != accNewRec.Phone){
                accNewRec.Previous_Phone__c = accOldRec.Phone;
            }
        }
    }

    
    
    //If an Account’s Industry is updated, prevent saving if the value is blank.
    public static void accMethod5(List<Account> accList, Map<Id,Account> accMap){
        for(Account accNewRec : accList){
            Account accOldRec = accMap.get(accNewRec.id);
            if(accOldRec.Industry != accNewRec.Industry && String.isBlank(accNewRec.Industry)){
                accNewRec.addError('Industry cant be blank');
            }
        }
    }
    
    
    //Whenever an Account Rating is updated, store the old value in a custom field Old_Rating__c.
    public static void accMethod6(List<Account> accList, Map<Id,Account> accMap){
        for(Account accNewRec : accList){
            Account accOldRec = accMap.get(accNewRec.id);
            if(accOldRec.Rating != accNewRec.Rating && accNewRec.Rating != null){
                accNewRec.Old_Rating__c = accOldRec.Rating;
            }
        }
        
    }
    
    
    //When an Account’s Phone is updated, update all related Contacts’ Phone numbers with the same value
    public static void accMethod7(List<Account> accList, Map<Id,Account> accMap){
        
        Map<Id,String> accPhoneMap = new Map<Id,String>();
        
        for(Account accNewRec : accList){
            Account accOldRec = accMap.get(accNewRec.id);
            if(accOldRec.Phone != accNewRec.Phone && accNewREc.Phone != null){
                accPhoneMap.put(accNewRec.id, accNewRec.Phone);
            }
        }
        
        if(accPhoneMap.isEmpty()){
            return;
        }
        
        List<Contact> conList = new List<Contact>();
        
        for(Contact con: [SELECT Id, Name,Phone, AccountId FROM Contact
                          WHERE AccountId in :accPhoneMap.keySet()]){
                
               con.Phone = accPhoneMap.get(con.AccountId);
               conList.add(con);
        }
        
        if(!conList.isEmpty()){
            update conList;
        }
    }
    
    
    //If Account Industry changes → update Opportunities field Account_Industry__c with the Account Industry value
    public static void accMethod8(List<Account> accList, Map<Id,Account> accMap){
        
        Map<Id,String> accIndustryMap = new Map<Id,String>();
        
        for(Account accNewRec : accList){
            Account accOldRec = accMap.get(accNewRec.id);
            if(accOldRec.Industry != accNewRec.Industry){
                accIndustryMap.put(accNewRec.id, accNewRec.Industry);
            }
        }
        
        if(accIndustryMap.isEmpty()){
            return;
        }
        
        List<Opportunity> oppList = new List<Opportunity>();
        
        for(Opportunity opp: [SELECT Id, Account_Industry__c, AccountId FROM Opportunity
                              WHERE AccountId in :accIndustryMap.keySet()]){
                                  
                                  opp.Account_Industry__c = accIndustryMap.get(opp.AccountId);
                                  oppList.add(opp);
                              }
        
        if(!oppList.isEmpty()){
            update oppList;
        }
    }
    
    
   // If Account Industry is changed, update a field Industry_Last_Updated_Date__c with today’s date.
    public static void accMethod9(List<Account> accList, Map<Id,Account> accMap){
        for(Account accNewRec : accList){
            Account accOldRec = accMap.get(accNewRec.id);
            if(accOldRec.Industry != accNewRec.Industry && accOldRec != null){
                accNewRec.Industry_Last_Updated_Date__c = Date.today();
            }
        }
    }
    
    
    //When Account Owner is changed, update all related Open Opportunities owner to the same user.
    public static void accMethod10(List<Account> accList, Map<Id,Account> accMap){
        
        Map<Id,Id> accUserMap = new Map<Id,Id>();
        
        for(Account accNewRec : accList){
            Account accOldRec = accMap.get(accNewRec.Id);
            if(accOldRec.OwnerId != accNewRec.OwnerId && accOldRec.OwnerId != null){
                accUserMap.put(accNewRec.Id , accNewRec.OwnerId);
            }
        }
        
        if(accUserMap.isEmpty()){
            return;
        }
        
        List<Opportunity> oppList = new List<Opportunity>();
        for(Opportunity opp : [SELECT Id,Name,OwnerId FROM Opportunity WHERE StageName not in ('Closed Won','Closed Lost') AND AccountID in :accUserMap.keySet() ]){
            opp.OwnerId = accUserMap.get(opp.AccountId);
            oppList.add(opp);
        }
        
        if(!oppList.isEmpty()){
            update oppList;
        }
    }
    
    
  //Before updating Account Rating, allow only values: Hot, Warm, Cold. Otherwise block the update
    public static void accMethod11(List<Account> accList, Map<Id,Account> accMap){
        
        Set<String> validRatingSet = new Set<String>{'Hot', 'Warm', 'Cold'};
        for(Account accNewRec : accList){
            Account accOldRec = accMap.get(accNewRec.id);
            
            if(accOldRec.Rating != accNewRec.Rating){
                if(accNewRec.Rating == null &&  !validRatingSet.contains(accNewRec.Rating) ){
                    accNewRec.addError('InValid Ratings ');
                }
            }
        }
    }	
    
    
    //When an Account is created, automatically create 3 default Contacts linked to it.
    public static void accMethod12(List<Account> accList){
        List<Contact> conList = new List<Contact>();
        for(Account accNewRec : accList){
            for(Integer i=1 ; i<=3; i++){
                Contact con = new Contact();
                con.FirstName = 'Default';
                con.LastName = 'Contact' + i;
                con.AccountId = accNewRec.id;
                conList.add(con);
                
            }
            
            if(!conList.isEmpty()){
                insert conList;
            }
        }
    }
    
    
    //Write a trigger whenever  an account is created automatically 2 contact and 2 opportunity should be created
    public static void accMethod13(List<Account> accList){
        List<Contact> conList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        for(Account accNewRec : accList){
            for(Integer i=1; i<=2; i++){
                Contact con = new Contact();
                con.AccountId = accNewRec.Id;
                con.LastName = 'Contact' + i;
                conList.add(con);
                
                Opportunity opp = new Opportunity();
                opp.AccountId = accNewRec.Id;
                opp.Name = 'Opportunity'+ i;
                opp.StageName = 'Prospecting';
                opp.CloseDate = Date.today().addDays(30);
                oppList.add(opp);
            }  
    }
        if(!conList.isEmpty()){
            insert conList;
        }
        if(oppList.isEmpty()){
            insert oppList;
        }
     
    } 
    
    
    //If an Account with Industry Agriculture and Type Apparel is updated and Ownership is set to Private, do not allow user to set this ownership
    public static void accMethod14(List<Account> accList, Map<Id,Account> accMap){
        for(Account accNewRec : accList){
            Account accOldRec = accMap.get(accNewRec.Id);
            if( accNewRec.Industry == 'Agriculture' &&
                accNewRec.Type == 'Apparel' && accOldRec.Ownership != 'Private' &&  accNewRec.Ownership == 'Private'){
                   accNewRec.addError('Ownership cannot be changed once it has been set to private');
               }
        }
    }
    
    
    
    
    //Every time an Account Website is updated, update the website field on all child contacts for the account
    public static void accMethod15(List<Account> accList, Map<Id,Account> accMap){
        Map<Id,String> accWebsiteMap = new Map<Id,String>();
        for(Account accNewRec : accList){
            Account accOldRec = accMap.get(accNewRec.Id);
            if(accOldRec.Website != accNewRec.Website){
                accWebsiteMap.put(accNewRec.Id, accNewRec.Website);
            }
        }
        
        if(accWebsiteMap.isEmpty()){
            return;
        }
        
        List<Contact> conList = new List<Contact>();
        for(Contact con : [SELECT Id, Website__c, AccountId FROM CONTACT WHERE AccountId In :accWebsiteMap.keySet()]){
            con.Website__c = accWebsiteMap.get(con.AccountId);
            conList.add(con);      
        }
        
        if(!conList.isEmpty()){
            update conList;
        }
    }
    
    
    //Create Contact records based on Create N Contacts fields on Account record
    public static void accMethod16(List<Account> accList){
        List<Contact> conList = new List<Contact>();
        for(Account accNewRec : accList){
            if(accNewRec.Create_N_Contacts__c != null && accNewRec.Create_N_Contacts__c > 0){
                Integer n = Integer.valueOf(accNewRec.Create_N_Contacts__c);
                for(Integer i=1;i<=n;i++){
                Contact con  = new Contact();
                con.AccountId = accNewRec.Id;
                con.LastName = 'Contact'+ i;
                conList.add(con);
            }
            }
            
        }
        
        if(!conList.isEmpty()){
            insert conList;
        }
    }
        
        
    
    //when an account is created set account type as customer
    public static void accMethod17(List<Account> accList){
        for(Account accNewRec : accList){
            accNewRec.Type = 'Customer - Direct';
        }
    }
    
    
    //Update Contact when Account Industry changes
    public static void accMethod18(List<Account> accList, Map<Id,Account> accMap){
        Map<Id,String> accountMap = new Map<Id,String>();
        for(Account accNewRec : accList){
            Account accOldRec = accMap.get(accNewRec.Id);
            if(accOldRec.Industry != accNewRec.Industry && accNewRec.Industry != null){
                accountMap.put(accNewRec.Id, accNewRec.Description);
            }
        }
        
        if(accountMap.isEmpty()){
            return;
        }
        
        List<Contact> conList = new List<Contact>();
        for(Contact con : [SELECT Id,AccountId, Description FROM CONTACT WHERE AccountId IN :accountMap.keySet()]){
            con.Description = accountMap.get(con.AccountId);
            conList.add(con);
        }
        
        if(!conList.isEmpty()){
            update conList;
        }
    }
    
    
    
    
    
    
    
    
    
    
    
        
        
        
        
        
        
}