public class AccountActionHandler {
    @InvocableMethod(label='update Account Rating')
    public static void updateRating(List<Id> accountIds){
        List<Account> accList = [
            SELECT Id, Rating
            FROM Account
            WHERE Id IN :accountIds
        ];

        for(Account acc : accList){
            acc.Rating = 'Hot';
        }

        update accList;
    }

}