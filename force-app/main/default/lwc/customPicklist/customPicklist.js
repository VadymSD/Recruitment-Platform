import  { LightningElement, api} from 'lwc';

export default class CustomPicklist extends LightningElement {
    @api name;
    @api value;
    @api variant;
    @api options;
    @api label;
    @api placeholder;
    @api recordId;
    @api context;

    handleChange(event) {
        event.preventDefault();
        //show the selected value on UI
        this.selectedValue = event.detail.value;
        this.recordId = event.target.dataset.id;

        //fire event to send context and selected value to the data table
        this.dispatchEvent(new CustomEvent('select', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                value: this.selectedValue,
                context: this.context
            }
        }));
    }
}