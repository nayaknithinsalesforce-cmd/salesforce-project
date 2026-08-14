import { LightningElement } from 'lwc';

export default class ParentComp extends LightningElement {

     parentVar = '';
     input = '';

    
      handleChild(event){
          this.parentVar = event.detail.value;
     }

     handleChange(event){
          this.input = event.target.value;
          
     }


     handleClick(){
          const child = this.template.querySelector('c-child-comp');
          const parameter = {value: 'Parent Component value sent as parameter', name : this.input};
          child.childMethod(parameter);
     }

     
}