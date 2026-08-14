public class ContactHandler {
    
    //Write a trigger on Contact that automatically sets Description = 'New Contact' when a new Contact record is created.
    public static void conMethod1(List<Contact> conList){
        for(Contact con : conList){
            con.Description = 'New Contact';
        }
    }
    
    //Write a trigger on Contact that prevents record creation if the Phone field is empty
    public static void conMethod2(List<Contact> conList){
        for(Contact con : conList){
            if(con.Phone == null){
                con.Phone.addError('Please Fill the Phone Field');
            }
        }
    }
    
    //Write a trigger on Contact that copies Email into a custom field Backup_Email__c whenever the email is changed.
    public static void conMethod3(List<Contact> conList, Map<Id,Contact> conMap){
        for(Contact conRecNew : conList){
            Contact conRecOld = conMap.get(conRecNew.id);
            if(conRecNew.Email != conRecOld.Email){
					conRecNew.Backup_Email__c = conRecOld.Email;                
            }
        }
        
    }
    
    //Write a trigger on Contact that automatically converts the Last Name to UPPERCASE when an existing Contact is edited.
    public static void conMethod4(List<Contact> conList, Map<Id,Contact> conMap){
        for(Contact conNewRec : conList){
            Contact conOldRec = conMap.get(conNewRec.id);
            if(conOldRec != conNewRec){
                conNewRec.LastName = conNewRec.LastName.toUpperCase();
            }
        }
    }
    
    
    //When a Contact’s Email is updated, convert it into lowercase before saving.
    public static void conMethod5(List<Contact> conList, Map<Id,Contact> conMap){
        for(Contact conNewRec : conList){
            Contact conOldRec = conMap.get(conNewRec.id);
            if(conOldRec.Email != conNewRec.Email && conNewRec.Email != null){
                conNewRec.Email = conNewRec.Email.toLowerCase();
            }
        }
    }
    
    
    //When a Contact Phone is modified, remove all spaces and special characters before saving.
    public static void conMethod6(List<Contact> conList, Map<Id,Contact> conMap){
        for(Contact conNewRec : conList){
            Contact conOldRec = conMap.get(conNewRec.id);
                if(conOldRec.Phone != conNewRec.Phone && conNewRec.Phone != null){
                    conNewRec.Phone = conNewRec.phone.replaceAll('[^0-9]','');
                }
        }
    }
    
    
    
    //When a Contact Email is updated, check for duplicate emails in Salesforce and prevent saving if a duplicate exists.
    
    public static void conMethod7(List<Contact> conList, Map<Id,Contact> conMap){
        
        set<String> conEmailSet = new set<String>();
        
        for(Contact conNewRec : conList){
            Contact conOldRec = conMap.get(conNewRec.id);
            if(conOldRec.Email != conNewRec.Email && conOldRec.Email != null){
                conEmailSet.add(conNewRec.Email.toLowerCase());
            }
        }
        
        if(conEmailSet.isEmpty()){
            return;
        }
        
        Map<String,Id> EmailToConMap = new Map<String,Id>();
        
        for(Contact con : [SELECT Id, Name, Email from Contact where Email in :conEmailSet]){
            EmailToConMap.put(con.Email, con.id);
        }
        
        for(Contact conNewRec : conList){
            if(conNewRec.Email != null){
                
                String conEmail = conNewRec.Email.toLowerCase();
                
                if(EmailToConMap.containsKey(conEmail) && EmailToConMap.get(conEmail) != conNewRec.Id){
                    conNewRec.addError('Duplicate Email Found');
                }
                
               
            }
        }
    }
    
    
    
    
    //When a Contact Phone is updated, check for duplicate phone in Salesforce and prevent saving if a duplicate exists.
    //If Contact Phone is updated, check whether the same phone exists on any other Contact and block the update if found.
    public static void conMethod8(List<Contact> conList, Map<Id,Contact> conMap){
        
        Set<String> conPhoneSet = new Set<String>();
        
        for(Contact conNewRec : conList){
            Contact conOldRec = conMap.get(conNewRec.id);
            if(conOldRec.Phone != conNewRec.Phone && conOldRec.Phone != null){
                conPhoneSet.add(conNewRec.Phone);
            }
        }
        
        if(conPhoneSet.isEmpty()){
            return;
        }
        
        Map<String,Id> conPhoneMap = new Map<String,Id>();
        for(Contact con : [SELECT Id, Name, Phone FROM Contact WHERE Phone in :conPhoneSet]){
            conPhoneMap.put(con.Phone, con.Id);
        }
        
        for(Contact conNew : conList){
            if(conNew.Phone != null){
                if(conPhoneMap.containsKey(conNew.Phone) && conPhoneMap.get(conNew.Phone) != conNew.Id){
                    conNew.addError('Duplicate Phone Found');
                }
            }
        }  
    }
    
    
    //When a Contact is created, populate Account’s Description with Contact Name.	
    public static void conMethod9(List<Contact> conList){
        
        Map<Id,List<String>> accMap = new Map<Id,List<String>>();
        
        for(Contact conNewRec : conList){
            if(conNewRec.AccountId != null){
                if(!accMap.containsKey(conNewRec.AccountId)){
                    accMap.put(conNewRec.AccountId, new List<String>());
                }
                String fullName = (conNewRec.FirstName != null ? conNewRec.FirstName : '') 
                        + ' ' + conNewRec.LastName;

                accMap.get(conNewRec.AccountId).add(fullName.trim());
            }
        }
        
        if(accMap.isEmpty()){
            return;
        }
        
        
       	List<Account> accUpdatedList = new List<Account>();
        for(Account acc : [SELECT Id, Description FROM ACCOUNT WHERE Id in :accMap.keyset()]){
            acc.Description = String.join(accMap.get(acc.Id),', ');
			accUpdatedList.add(acc);            
        }
        
        update accUpdatedList;
    }
             
             
     
    //After creating a Contact, copy its Phone into a custom field Original_Phone__c
    public static void conMethod10(List<Contact> conList){
        for(Contact conNewRec : conList){
            if(conNewRec.Phone != null){
                conNewRec.Original_Phone__c = conNewRec.Phone;
            } 
        }
    }
    
    
    
    
    //Write a trigger whenever contact is created, updated , delete  and undelete then count the 
    //total no of contact and rollup to account object (custom field Total_Contact__c)
    public static void conMethod11(List<Contact> newConList,
                                   List<Contact> oldConList,
                                   Map<Id,Contact> conMap){
                           			
                                     Set<Id> accIds = new Set<Id>();
                                       
                                     //Insert & Undelete  
                                     if(newConList != null){
                                         for(Contact conNewRec : newConList){
                                             if(conNewRec.AccountId != null){
                                                 accIds.add(conNewRec.AccountId);
                                             }
                                         }
                                     }
                                     
                                     //Delete
                                       if(oldConList != null){
                                           for(Contact conOldRec : oldConList){
                                               if(conOldRec.AccountId != null){
                                                   accIds.add(conOldRec.AccountId);
                                               }
                                           }
                                       }
        							
                                       
                                       //Update
                                       if(newConList != null && conMap != null){
                                           for(Contact conNewRec : newConList){
                                               Contact conOldRec = conMap.get(conNewRec.Id);
                                               if(conNewRec.AccountId != conOldRec.AccountId){
                                                   if(conNewRec.AccountId != null){
                                                       accIds.add(conNewRec.AccountId);
                                                   }
                                                   if(conOldRec.AccountId != null){
                                                       accIds.add(conOldRec.AccountId);
                                                   }
                                               }
                                           }
                                       }
                                       
                                       if(accIds.isEmpty()){
                                           return;
                                       }
                                       
                                       
                                       //Aggregate Query
                                       Map<Id,Integer> accCountMap = new Map<Id,Integer>();
                                
                                       for(AggregateResult ar : [SELECT AccountId, COUNT(Id) cnt FROM CONTACT
                                                                 WHERE AccountId IN :accIds GROUP BY AccountId]){
                                           accCountMap.put(
                                           				(Id) ar.get('AccountId'),
                                               			(Integer) ar.get('cnt')
                                                        );
                                       }
                                       
                                       //Update the Accounts field 
                                       
                                       List<Account> accToUpdate = new List<Account>();
                                    
                                       for(Id accId : accIds){
                                           Integer countVal = accCountMap.containsKey(accId) ? accCountMap.get(accId) : 0;
                                           accToUpdate.add(new Account(
                                           					Id = accId,
                                           					Total_Contact__c = countVal));
                                           
                                       }
        
                                       if(!accToUpdate.isEmpty()){
                                           update accToUpdate;
                                       }
                                               
    }
	  
    
    //If a Contact is Created without a parent account, do not allow user to create the contact record
    public static void conMethod12(List<Contact> conList){
        for(Contact conNewRec : conList ){
            if(conNewRec.AccountId == null){
                conNewRec.addError('Contact must be related to parent account');
            }
        }
    }
    
    
   
    //Check if a Contact record exist with the same last name, email & phone. if so, do not let new contact creation 
    public static void conMethod13(List<Contact> conList){
        
        Set<String> lastNameSet = new Set<String>();
        Set<String> emailSet = new Set<String>();
        Set<String> phoneSet = new Set<String>();
        
        Set<String> uniqueKeys = new Set<String>();
        
        for(Contact conNewRec : conList){
            if(conNewRec.Email != null && conNewRec.LastName != null && conNewRec.Phone != null){
                lastNameSet.add(conNewRec.LastName);
                emailSet.add(conNewRec.Email);
                phoneSet.add(conNewRec.phone);
                
                String key = conNewRec.LastName + '|' + conNewRec.Email + '|' + conNewRec.Phone;
                
                if(uniqueKeys.contains(key)){
                    conNewRec.addError('Duplicate Contact in same transaction');
                }
                else{
                    uniqueKeys.add(key);
                    
                }
            }
        }
        
        if(uniqueKeys.isEmpty()){
            return;
        }
        
        List<Contact> existingConList = [SELECT LastName, Email, Phone FROM CONTACT 
                                         WHERE LastName IN :lastNameSet 
                                         AND Email IN :emailSet
                                         AND Phone IN :phoneSet];
        Set<String> existingkeySet = new Set<String>();
        for(Contact con : existingConList){
            String existingKeys = con.LastName + '|' + con.Email + '|' + con.Phone;
            existingkeySet.add(existingKeys);
        }
        
        for(Contact conNewRec : conList){
            if(conNewRec.Email != null && conNewRec.LastName != null && conNewRec.Phone != null){
                String key = conNewRec.LastName + '|' + conNEwRec.Email + '|' + conNewRec.Phone;
                if(existingkeySet.contains(key)){
                    conNewRec.addError('Duplicate Contact exists with same LastName, Email, and Phone');
                }
            }
        }
    }
    
    
    
    //As soon as a Contact is Cretaed, share the contact record with all users who are part of the contact Innovators Public group
    public static void conMethod14(List<Contact> conList){
        
        Id conInnovPublicGroup = [SELECT Id, Name FROM GROUP WHERE Name = 'Contact Innovators' LIMIT 1].Id;
        
        List<ContactShare> conSList = new List<ContactShare>();
            
        for(Contact conNewRec : conList){
            ContactShare conShare = new ContactShare();
            conShare.ContactId = conNewRec.Id;
            conShare.RowCause = 'Manual';
            conShare.UserOrGroupId = conInnovPublicGroup;
            conShare.ContactAccessLevel = 'Edit';
            conSList.add(conShare);
        }
        
        if(!conSList.isEmpty()){
            insert conSList;
        }
        
    }
    
    
    
    
    //Prevent Contact creation if account is inactive
    public static void conMethod15(List<Contact> conList){
        Set<Id> conAccSet = new Set<Id>();
        for(Contact conNewRec : conList){
            if(conNewRec.AccountId != null){
                conAccSet.add(conNewRec.AccountId);
            }
        }
        
        if(conAccSet.isEmpty()){
            return;
        }
        
        Map<Id,Account> accMap = new Map<Id,Account>([SELECT Id, Active__c FROM Account Where Id in:conAccSet]);
        
        for(Contact conNewRec : conList){
            if(conNewRec.AccountId != null){
                Account acc = accMap.get(conNewRec.AccountId);
                if(acc != null && acc.Active__c == 'false'){
                    conNewRec.addError('Account is not active, cannot create contact');
                }
            }
        }
        
    }
    
}