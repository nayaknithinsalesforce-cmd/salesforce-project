public with sharing class AccountDetails{
    
    @AuraEnabled(Cacheable = true)
    public static List<Account> getAccountDetails(){
        try{
            return [SELECT Id, Name, AnnualRevenue From Account where AnnualRevenue != null Order by AnnualRevenue Desc Limit 5];
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
    }
}