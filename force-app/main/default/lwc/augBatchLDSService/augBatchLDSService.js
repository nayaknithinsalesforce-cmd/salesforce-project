import { LightningElement } from 'lwc';
import {createRecord} from  'lightning/uiRecordApi';


export default class AugBatchLDSService extends LightningElement {

    name;
    phone;

    handleName(event){
        this.name = event.target.value;
    }

    handlePhone(event){
        this.phone = event.target.value;
    }

    handleClick(){
        let recordInput = {
            "apiName" : "Account",
            "fields" : {
                "Name": this.name,
                "Phone" : this.phone
            }
        };

        createRecord(recordInput).then(result => {
            console.log(result);
        }).catch(error => {
            console.log(error);
        })

    }
}