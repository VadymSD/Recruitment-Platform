import { LightningElement, api } from 'lwc';
import OoopsLabel from '@salesforce/label/c.OoopsLabel';


export default class CustomErrorPopUp extends LightningElement {
    @api errorMessage;
    errorLabel = OoopsLabel;

    dismissError() {
        this.dispatchEvent(new CustomEvent('dismiss'));
    }
}