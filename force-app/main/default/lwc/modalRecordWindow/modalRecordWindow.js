import { LightningElement,api } from 'lwc';

export default class ModalRecordWindow extends LightningElement {
    @api candidate;
    @api showImage;
    @api candidatesForModal;
    @api jobApplications;
    
    closeModal() {
        this.dispatchEvent(new CustomEvent ('close'));
    }

    navigateToRecord(event) {
        const recordId = event.currentTarget.dataset.id;
        this.dispatchEvent(new CustomEvent('navigate', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: recordId
        }));
    }
}