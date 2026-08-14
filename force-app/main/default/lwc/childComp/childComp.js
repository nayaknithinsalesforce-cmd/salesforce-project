import { LightningElement, api} from 'lwc';

export default class ChildComp extends LightningElement {

 childVar = '';
 @api childParam = '';
 childMethodParam1='';
 childMethodParam2='';

 @api childMethod(param){
      this.childMethodParam1 = param.value;
      this.childMethodParam2 =param.name;
 }

 handleChange(event){
   this.childVar = event.target.value;
 }

 handleClick(){
   this.dispatchEvent(new CustomEvent('childata',{
      detail : {
         value : this.childVar
      },
      bubbles : true,
      composed : true
   }));
 }
     

}