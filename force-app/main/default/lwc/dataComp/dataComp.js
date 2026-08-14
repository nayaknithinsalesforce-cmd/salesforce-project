import { LightningElement, track , wire} from 'lwc';
import getAccounts from '@salesforce/apex/AccountDataHandler.getAccounts';
import updateAccounts from '@salesforce/apex/AccountDataHandler.updateAccounts';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {refreshApex} from '@salesforce/apex';

const COLUMNS  = [
            {label : 'Name', fieldName : 'Name', editable : true},
            {label : 'Phone', fieldName : 'Phone', editable : true},
            {label : 'Industry', fieldName : 'Industry', editable : true},
            {label : 'Rating', fieldName : 'Rating', editable : true}
];

export default class DataComp extends LightningElement {
    columns = COLUMNS;
    @track accounts;
    draftValues = [];
    wiredResult;

    @wire(getAccounts)
    wiredAccounts(result){
        this.wiredResult = result;

        if(result.data){
            this.accounts = result.data;
        }
        else if(result.error){
            console.log(result.error);
        }
    }


    handleSave(event){
        const updatedFields = event.detail.draftValues;

        updateAccounts({accList : updatedFields})
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title : 'Success',
                        message : 'Account Updated Successfully',
                        variant : 'success'
                    })
                );

                this.draftValues = [];
                return refreshApex(this.wiredResult);

            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title : 'Error Updating Record',
                        message : error.body.message,
                        variant : 'error'
                    })
                );
            });


    }
}