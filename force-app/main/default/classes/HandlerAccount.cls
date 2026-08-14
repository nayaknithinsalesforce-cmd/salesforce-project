public with sharing class HandlerAccount {
    
    @AuraEnabled(Cacheable=true)
    public static List<Account> AccountListRetrive(){
        return [Select Id, Name, AnnualRevenue, BillingAddress, Industry From Account limit 5];
    }

}