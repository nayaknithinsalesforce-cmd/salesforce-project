public with sharing class DatatableController {
    
    @AuraEnabled(Cacheable=true)
    public static List<Contact>  conList(Id accIds){
        return [select id, lastName, phone, Email, LeadSource from Contact where AccountId = :accIds];
    }

}