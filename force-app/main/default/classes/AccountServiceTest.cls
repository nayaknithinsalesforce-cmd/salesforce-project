@isTest
public class AccountServiceTest {
	
    @isTest
    static void testCreateAccount(){
        
        //Arrange
        String accName = 'Test Account';
        
        //Act
        Test.startTest();
        AccountService.createAccount(accName);
        Test.stopTest();
        
        //Assert 
        Account acc = [SELECT Name FROM Account where Name = :accName];
        System.assertEquals(accName,acc.Name);
        
    }
}