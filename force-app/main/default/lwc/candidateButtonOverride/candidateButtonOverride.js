import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getFields from '@salesforce/apex/CandidateButtonOverrideController.getFields';
import DataRetrievalError from '@salesforce/label/c.DataRetrievalError';

const CANDIDATE = 'Candidate__c';
const JOB_APPLICATION = 'Job_Application__c';

const ERROR_MESSAGE_TYPE = 'error';
const SUCCESS_MESSAGE_TYPE = 'success';

const CANDIDATE_SUCCESS_TITLE = 'Candidate Record Saved Successfully';
const CANDIDATE_SUCCESS_MESSAGE = 'The candidate record was saved successfully.';

const CANDIDATE_ERROR_TITLE = 'Candidate Record not saved';
const CANDIDATE_ERROR_MESSAGE = 'An error occurred while saving the Candidate Record';

const JOB_APPLICATION_ERROR_TITLE = 'Job Application Record not saved';
const JOB_APPLICATION_ERROR_MESSAGE = 'An error occurred while saving the Job Application Record';

const JOB_APPLICATION_SUCCESS_TITLE = 'Job Application Record Saved Successfully';
const JOB_APPLICATION_SUCCESS_MESSAGE = 'The job application record was saved successfully.';


export default class CandidateButtonOverride extends LightningElement {

    fieldValues = [];
    fieldSetName;
    sObject;
    candidateFields;
    jobApplicationFields;
    hasError = false;
    errorMessage;
    objectName;
    jobApp = JOB_APPLICATION;
    candidate = CANDIDATE;
    recordId;
    dataRetrievalError = DataRetrievalError;

    @api
    connectedCallback(){
        this.fetchObjectFields();
    }
    
    fetchObjectFields() {
        this.fetchCandidateFields();
        this.fetchJobApplicationFields();
    }

    fetchCandidateFields(){
        this.sObject = CANDIDATE;
        this.objectName = CANDIDATE;
        this.fetchFields(result => {
            this.candidateFields = result;
        });
    }

    fetchJobApplicationFields(){
        this.sObject = JOB_APPLICATION;
        this.objectName = JOB_APPLICATION;
        this.fetchFields(result => {
            this.jobApplicationFields = result;
        });
    }

    fetchFields(callback) {
        getFields({ sObjectName: this.sObject })
            .then(result => {
                result = JSON.parse(result);
                callback(result);
            })
            .catch(error => {   
                this.handleError(dataRetrievalError + " ", error);
            });
    }

    handleCandidateSave(){
        this.template.querySelector('lightning-record-edit-form[data-id="candidateForm"]').submit();
    }

    handleChange(event) {
        const index = event.target.dataset.index;
        const newValue = event.target.value;
        this.fieldValues.splice(index, 1, newValue);
    }

    handleCandidateSuccess(event) {
        this.recordId = event.detail.id;
        this.showMessage(CANDIDATE_SUCCESS_TITLE, CANDIDATE_SUCCESS_MESSAGE, SUCCESS_MESSAGE_TYPE); 
        
        if(this.fieldValues.length === 0) {
            this.navigateToRecord();
        } else {
            this.template.querySelector('lightning-record-edit-form[data-id="jobAppForm"]').submit();
        }
    }
    
    handleJobAppSuccess() {
        this.showMessage(JOB_APPLICATION_SUCCESS_TITLE, JOB_APPLICATION_SUCCESS_MESSAGE, SUCCESS_MESSAGE_TYPE);
        this.navigateToRecord();
    }
    
    handleReset() {
        const inputFields = this.template.querySelectorAll('lightning-input-field');
        if (inputFields) {
            inputFields.forEach(field => {field.reset()});
        }
    }

    handleClose() {
        window.history.back(); 
    }

    handleCandidateError() {
        this.showMessage(CANDIDATE_ERROR_TITLE, CANDIDATE_ERROR_MESSAGE, ERROR_MESSAGE_TYPE);
    }    

    handleJobAppError() {
        this.showMessage(JOB_APPLICATION_ERROR_TITLE, JOB_APPLICATION_ERROR_MESSAGE, ERROR_MESSAGE_TYPE);
    }
    
    navigateToRecord() {
        const navigateToRecordEvent = new CustomEvent("navigate", {
            detail: {
                recordId: this.recordId
            }
        });
        this.dispatchEvent(navigateToRecordEvent);
    }

    handleIconHover() {
        const divElement = this.template.querySelector('.close-button');
        divElement.classList.add('hoveredIcon');
    }

    handleIconUnhover() {
        const divElement = this.template.querySelector('.close-button');
        divElement.classList.remove('hoveredIcon');
    }

    showMessage(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            variant: variant,
            mode: 'dismissable',
            message: message
        });
        this.dispatchEvent(event);
    }

    handleError(errorType, error) {
        this.hasError = true;
        if (Array.isArray(error.body)) {
            this.errorMessage = errorType + error.body.map(e => e.message).join(', ');
        } 
        else if (typeof error.body.message === 'string') {
            this.errorMessage = errorType + error.body.message;
        }
    }

    dismissError() {
        this.hasError = false;
        this.errorMessage = undefined;
    }
}
