public with sharing class AccountDataHandler {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(){
        return [SELECT Id, Name, Phone, Industry, Rating FROM Account LIMIT 50];
    }
    
    @AuraEnabled
    public static void updateAccounts(List<Account> accList){
        update accList;
    }

}