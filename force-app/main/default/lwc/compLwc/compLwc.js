import { LightningElement, wire } from 'lwc';
import AccountList from '@salesforce/apex/HandlerAccount.AccountListRetrive'
import AccountSearchList from '@salesforce/apex/AccountSearch.AccountSearchResult';

export default class CompLwc extends LightningElement {

/*
    AccountsList = [];

    @wire(AccountList)
    AccountList(response){
        const {data,error} = response;

        if(data){
            this.AccountsList = data;
        }

        if(error){
            console.log('Error Occured');
            return;
        }
    }

    */

    AccountsList = [];
    AccountName;

    handleChange(event){
        this.AccountName = event.target.value;
    }

    handleClick(event){
        AccountSearchList({accName : this.AccountName})

          .then(result => {
                this.AccountsList = result;
          })

          .catch(error => {
                 console.log('Error Fetched', error)
    });

    }
    

    

}