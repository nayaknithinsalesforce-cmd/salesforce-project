public with sharing class AccountSearch {
	@AuraEnabled
    public static List<Account> AccountSearchResult(String accName){
        return [select Id, Name, AnnualRevenue, Industry From Account where Name = :accName];
    }
}