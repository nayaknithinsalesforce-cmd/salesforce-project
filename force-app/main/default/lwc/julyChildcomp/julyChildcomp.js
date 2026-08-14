import { LightningElement, api } from 'lwc';

export default class JulyChildcomp extends LightningElement {

    /* Parent to child

    @api  childVar;

    @api childMethod(param){
        alert('This is the child method that is been called from parent and the parameter is been also set '+ param.value +' '+ param.name);
        
    }

    */

    /* child to parent
    handleClick(event){
        this.dispatchEvent(new CustomEvent('childevent', {
            detail:{
                'message' : 'This event has dispatched from child',
                'value' : 100
            },
            bubbles: true,
            composed : true
        }));
    }

    */
/*
    @api StudentName ;
    
    fName;

    handleChange(event){
        this.fName = event.target.value;
        this.dispatchEvent(new CustomEvent('fateherevent',{
            detail : {
                fatherName : this.fName
            }
        }));
    }
        */
}