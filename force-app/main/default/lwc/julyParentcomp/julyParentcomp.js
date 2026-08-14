import { LightningElement } from 'lwc';

export default class julyParentcomp extends LightningElement {

   /* Parent to child communication
   
   name = ''
    rollno = 23;
    phoneno = 9876543210;
    selectedValue = '';
    parentVar = 'parent data';

    columns = [
        {label:'India', value:'India'},
        {label:'Japan', value:'Japan'},
        {label:'USA', value:'USA'},
        {label:'Canada', value:'Canada'}     
    ];

    handleChange(event){
        this.name = event.target.value;
    }

    handleSelected(event){
        this.selectedValue = event.target.value;
    }

        handleClick(){
           var childMethodCall = this.template.querySelector('c-july-childcomp');
           var  parameter = {'value' : 'parent' , 'name': 'Nithin'};
           childMethodCall.childMethod(parameter);
        }
        

    */

        /* child to parent
        message = '';
        value;
        handleChildEvent(event){
            this.message = event.detail.message;
            this.value = event.detail.value;
        }

       
        name = '';
        fatherName ='';
        handleChange(event){
            this.name = event.target.value;
        }

        handleFEvent(event){
            this.fatherName = event.detail.fatherName;
        }
        */
     

}