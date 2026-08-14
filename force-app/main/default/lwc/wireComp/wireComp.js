import { LightningElement, wire  } from 'lwc';
import getAccountList from '@salesforce/apex/AccountDetails.getAccountDetails';


export default class WireComp extends LightningElement {

    listOfAccounts = [];

    @wire(getAccountList)
    wireMethod(response){
      const   {data, error} = response;
      if(data){
        this.listOfAccounts = data;
      }
      else{
        console.log('Error' + error);
      }


    }

   

    


}