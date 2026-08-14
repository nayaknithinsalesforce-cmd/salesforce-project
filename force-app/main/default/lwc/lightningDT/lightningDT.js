import { LightningElement, wire, api} from 'lwc';

import {NavigationMixin} from 'lightning/navigation';

import {refreshApex} from '@salesforce/apex';

import {ShowToastEvent} from 'lightning/platformShowToastEvent';

import deleteRelatedContact from '@salesforce/apex/DataTableDataController.deleteRelatedCon';

import getRelatedCon from '@salesforce/apex/DataTableDataController.conListMethod';

    const columns = [
        {label:'LastName', fieldName:'LastName', editable: true},
        {label:'LeadSource', fieldName:'LeadSource', editable: true},
        {label:'Email', fieldName:'Email', editable: true},
        {label:'Phone', fieldName:'Phone', editable: true},
        {
            type:'action',
            typeAttributes : {
                rowActions: [
                    {label: 'View', name : 'view'},
                    {label: 'Edit', name:'edit'},
                    {label: 'Delete', name:'delete'}
                ]
            }
        }
    ];



export default class LightningDT extends NavigationMixin(LightningElement) {
      
    @api recordId;
    columnArray = columns;
    dataList;

    @wire(getRelatedCon,{accIds : '$recordId'})
    wireResponce({data,error}){
        if(data){
            this.dataList = data;
        }
        if(error){
            alert(error);
        }
    }


    handleRowAction(event){

        const actionName  = event.detail.action.name;

        const row = event.detail.row;

        if(actionName == 'view'){
            this[NavigationMixin.Navigate]({
                type:'standard__recordPage',
                attributes : {
                    recordId : row.Id,
                    objectApiName: 'Contact',
                    actionName: 'view'
                }
            });
        }

        else if(actionName == 'edit'){
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes : {
                    recordId : row.Id,
                    objectApiName : 'Contact',
                    actionName : 'edit'
                }
            });

           
        }

        else if(actionName == 'delete'){
            deleteRelatedContact({contactId : row.Id})
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title : 'success',
                        message : 'Contact Deleted SuccessFully',
                        variant : 'success',
                        mode : 'dismissable'
                    })
                ) 

                return refreshApex(this.wireResponce);
            }
            )

            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title : 'Error',
                        message : 'Failed to Delete the Contact',
                        variant : 'error',
                        mode : 'pester'
                    })
                )
            }  
            )

            
        }
    }

    


}