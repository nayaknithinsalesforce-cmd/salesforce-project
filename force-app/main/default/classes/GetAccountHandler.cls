public with sharing class GetAccountHandler {
    
    public static List<Account> getAccountRecords(){    
          return [select Name, Id, AnnualRevenue from Account order by AnnualRevenue desc Limit 5];  
    }

}