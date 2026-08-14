public class DemoClass {
    
    public static void myMethod(){
        
        List<Account> acc = new List<Account> {
            new Account(Name='Demo Account4', Phone='1234567897'),
            new Account(Name=null,Phone='234532244')
        };
            
        Database.SaveResult[] results = Database.insert(acc,false);

        for(Database.SaveResult sr : results){
            if(sr.isSuccess()){
                System.debug('Inserted ' + sr.getId());
            }
            else{
                System.debug('Failed '+ sr.getErrors()[0].getMessage() );
            }
        }        
    }

}