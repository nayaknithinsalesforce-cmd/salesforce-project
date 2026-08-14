import { LightningElement, api} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import {encodeDefaultFieldValues} from 'lightning/pageReferenceUtils';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';


export default class LightningRec extends NavigationMixin(LightningElement) {

   recordUrl;

   option = [
       {label:'India', value: 'India'},
       {label:'US', value: 'US'},
       {label:'Canada', value: 'Canada'},
       {label:'Cuba', value: 'Cuba'}
        ];

   showToast(){
    this.dispatchEvent(
        new ShowToastEvent({
            title:'Success',
            message : 'Account Cretated Successfully',
            variant: 'info',
            mode : 'sticky'
        })
    );
   }

    saveRecord() {
    this.template
        .querySelector('lightning-record-edit-form')
        .submit();
}

    handleSubmit(){
        alert('Inside Submit');
    }

    handleSuccess(event){
        const recId = event.detail.id;

         

        /* Navigate to the Record Page to view the record */
        /*
        this[NavigationMixin.Navigate]({
            type:'standard__recordPage',
            attributes:{
                recordId : recId,
                objectApiName : 'Contact',
                actionName : 'view'
            }
        })

        */

        /* Navigate to the Object Page to create a New Record */
        /*
        this[NavigationMixin.Navigate]({
            type:'standard__objectPage',
            attributes:{
                objectApiName : 'Account',
                actionName: 'new'
            }
        });

        */

        /* Navigate to the list view */

        /*
        this[NavigationMixin.Navigate]({
            type : 'standard__objectPage',
            attributes: {
                objectApiName:'Account',
                actionName : 'list'
            },
            state:{
                filterName: 'Recent'
            }
        });

        */

        /* Navigate to the Web Page using URL */

        /*
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url:'https://www.google.com'
            }
        });

        */

        
        
        

    }

    handleError(){
        alert('inside Error');
    }


    generateLink(){

            const config = {
            type: 'standard__recordPage',
            attributes: {
                recordId : '001g8000006RNmfAAG',
                objectApiName : 'Account',
                actionName : 'view'
                    }
            };

             this[NavigationMixin.GenerateUrl](config)
                .then(url => {
                 window.open(url,'_blank');
                  });

        }
    

}