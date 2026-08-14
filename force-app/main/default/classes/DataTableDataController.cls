public with sharing class DataTableDataController {
    
    @AuraEnabled(Cacheable=true)
    public static List<Contact> conListMethod(Id accIds){
        return[
            SELECT Id, LastName, LeadSource, Email, Phone 
            FROM Contact 
            WHERE AccountId = :accIds 
        ];
    }
    @AuraEnabled
    public static void deleteRelatedCon(Id contactId){
        contact con =  [
            select Id
            FROM Contact
            where Id = :contactId
            LIMIT 1
        ];
        
        delete con;
    }
}