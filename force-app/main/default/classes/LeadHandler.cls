public class LeadHandler {
    
    //Write a trigger on Lead that sets LeadSource = 'Website' if the field is left blank while creating a Lead.
    public static void leadMethod1(List<Lead> leadList){
        for(Lead led : leadList){
            if(led.LeadSource == null){
                led.leadSource = 'Web';
            }
        }
    }
    
    //Write a trigger on Lead that automatically updates a custom field Last_Modified_Date_Custom__c when the Lead record is edited.
    public  static void leadMethod2(List<Lead> leadList, Map<Id,Lead> leadMap){
        for(Lead ledNewRec : leadList){
            Lead ledOldRec = leadMap.get(ledNewRec.id);
            if(ledOldRec != ledNewRec){
                ledNewRec.Last_Modified_Date_Custom__c = Date.today();
            }
        }
    }
    
    //Write a trigger on Lead that updates a custom field Last_Updated_By_User__c with the current user whenever the Lead is edited.
    public static void leadMethod3(List<Lead> leadList, Map<Id,Lead> leadMap){
        for(Lead ledNewRec : leadList){
            Lead ledOldRec = leadMap.get(ledNewRec.id);
            if(ledOldRec != ledNewRec){
                ledNewRec.Last_Updated_By_User__c = UserInfo.getName();
            }
        }
    }
    
    
    //When a Lead’s Status changes to “Converted”, populate the Converted Date field with today’s date.
    public static void leadMethod4(List<Lead> leadList, Map<Id,Lead> leadMap){
        for(Lead ledNewRec : leadList){
            Lead ledOldRec = leadMap.get(ledNewRec.id);
            if(ledOldRec.Status != 'Converted' && ledNewRec.Status == 'Converted'){
                ledNewRec.Converted_Date__c = date.today();
                
            }
        }
    }
    
    
    //When a Lead’s Company name is updated, capitalize the first letter of each word
    public static void leadMethod5(List<Lead> leadList, Map<Id,Lead> leadMap){
        for(Lead ledNewRec : leadList){
            Lead ledOldRec = leadMap.get(ledNewRec.id);
            if(ledOldRec.Company != ledNewRec.Company){
                List<String> strList =  ledNewRec.Company.toLowerCase().split(' ');
                String result= '';
                for(String str : strList){
                    if(str.length() >0){
                        result  += str.subString(0,1).toUpperCase() + str.subString(1) + ' ' ;
                        
                    }    
                }
                
                ledNewRec.Company = result.trim();
            }
            
        }
    }
     
    
    //When a Lead Status is updated, track the number of times it was changed using a counter field.
    public static void leadMethod6(List<Lead> leadList, Map<Id,Lead> leadMap){
        
        for(Lead leadNewRec : leadList){
            Lead leadOldRec = leadMap.get(leadNewRec.Id);
            if(leadOldRec.Status != leadNewRec.Status && leadOldRec.Status != null){
               if(leadNewRec.counter__c == null){
                   leadNewRec.counter__c = 1;
               }
                else{
                    leadNewRec.counter__c = leadNewRec.counter__c + 1;
                }
            }
        }
    }
    
    
    //Whenever a Lead is inserted, assign it to a default queue.
    public static void leadMethod7(List<Lead> leadList){
        //Queue is stored in GROUP object
        Group queue = [SELECT Id FROM GROUP WHERE Type = 'Queue' AND Name = 'Lead Queue' LIMIT 1];

        for(Lead leadNewRec : leadList){
            leadNewRec.OwnerId = queue.Id;
        }
    }
    
    //Whenever a Lead Record is updated, set the Lead Status to Working-Contacted
    public static void leadMethod8(List<Lead> leadList, Map<Id,Lead> leadMap){
        for(Lead leadNewRec : leadList){
            Lead leadOldRec = leadMap.get(leadNewRec.Id);
            if(leadOldRec != leadNewRec){
                leadNewRec.Status = 'Working - Contacted';
                    
            }
        }
    }
    
    
    //Whenever a Lead is updated and Industry is Healthcare, set Lead Source as Purchased List, SIC Code as 1100, Primary as Yes
    public static void leadMethod9(List<Lead> leadList, Map<Id,Lead> leadMap){
        for(Lead leadNewRec : leadList){
            Lead leadOldRec = leadMap.get(leadNewRec.Id);
            if(leadOldRec != leadNewRec && leadNewRec.Industry == 'Healthcare'){
                leadNewRec.LeadSource = 'Purchased List';
                leadNewRec.SICCode__c = '1100';
                leadNewRec.Primary__c = 'Yes';
            }
            
        }
    }
    
    
    //As Soon as a Lead Record is Created, create a Task for the Lead Owner to follow up with the Customer
    public static void leadMethod10(List<Lead> leadList){
        List<Task> tskList = new List<Task>();
        for(Lead leadNewRec : leadList){
            Task tsk = new Task();
            tsk.WhoId = leadNewRec.Id;
            tsk.OwnerId = leadNewRec.OwnerId;
            tsk.Subject = 'Follow Up with the Customer';
            tskList.add(tsk);
        }
        if(!tskList.isEmpty()){
            insert tskList;
        }
    }
    

	//Do not allow Lead deletion if it is Working-Contacted
    public static void leadMethod11(List<Lead> leadList){
        for(Lead leadNewRec : leadList){
            if(leadNewRec.Status == 'Working - Contacted'){
                leadNewRec.addError('Cannot delete the lead as 	Working - Contacted');
            }
        }
    }



	
    
}