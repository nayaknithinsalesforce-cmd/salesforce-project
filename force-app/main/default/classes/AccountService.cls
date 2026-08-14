public class AccountService {
	
    public static void createAccount(String name){
        
        Account acc = new Account(Name=name);
        
        insert acc;
    }
}