import { LightningElement, api, wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getFields from '@salesforce/apex/CandidateRelatedListController.getFields';
import FieldsRetrievalError from '@salesforce/label/c.FieldsRetrievalError';

const HOVERED_CLASS = 'hovered';
const CLICKED_CLASS = 'clicked';
const ADD_ACTION = 'add';
const REMOVE_ACTION = 'remove';
const CANDIDATE_TILE_FIELD_SET = 'Candidate_Tile_Field_Set__c';
const CANDIDATE_MODAL_FIELD_SET = 'Candidate_Modal_Field_Set__c';
const JOB_APPLICATION_FIELD_SET = 'Job_Application_Field_Set__c';

export default class CandidateCustomTile extends NavigationMixin(LightningElement) {
    @api candidate;
    @api showImage;
    tileIsClicked = false;
    tileFields;
    fieldSetName;
    candidatesForTile;
    candidatesForModal;
    jobApplications;
    fieldsError = FieldsRetrievalError;
    errorDispatched = false;

    @api
    fetchFields(){
        this.fetchModal();
        this.fetchTile();
        this.fetchJobApps();
    }

    fetchTile() {
        this.fieldSetName = CANDIDATE_TILE_FIELD_SET;
        this.record = this.candidate;
        this.fetchData(result => {
            this.candidatesForTile = result.map(item => ({ label: item.label, value: item.value }));
        });
    }

    fetchModal() {
        this.fieldSetName = CANDIDATE_MODAL_FIELD_SET;
        this.record = this.candidate;
        this.fetchData(result => {
            this.candidatesForModal = result.map(item => ({ label: item.label, value: item.value }));
        });
    }

    fetchJobApps() {
        this.fieldSetName = JOB_APPLICATION_FIELD_SET;
        this.record = this.candidate.Job_Applications__r[0];
        this.fetchData(result => {
            this.jobApplications = result.map(item => ({ label: item.label, value: item.value }));
        });
    }

    fetchData(callback) {
        getFields({ fieldSetName: this.fieldSetName, record: this.record })
            .then(result => {
                result = JSON.parse(result);
                callback(result);
            })
            .catch(error => {   
                if (!this.errorDispatched) {
                    this.errorDispatched = true;
                    this.dispatchEvent(new CustomEvent('handleerror', {
                        composed: true,
                        bubbles: true,
                        cancelable: true,
                        detail: {
                            error: error,
                            errorType: this.fieldsError
                        }
                    }));
                }
            });
    }

    handleChildNavigate(event) {
        const recordId = event.detail;
        this.navigateToRecord(recordId);
    }

    handleParentNavigate(event) {
        const recordId = event.currentTarget.dataset.id;
        this.navigateToRecord(recordId);
    }

    navigateToRecord(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'view'
            }
        });
        setTimeout(() => {
            this.tileIsClicked = false;
        }, 300);
    }

    handleRecordClick() {
        this.tileClassAction(CLICKED_CLASS, ADD_ACTION);
        setTimeout(() => {
            this.tileIsClicked = true;
        }, 200);
    }

    handleRecordHover() {
        this.tileClassAction(HOVERED_CLASS, ADD_ACTION);
    }

    handleRecordUnhover() {
        this.tileClassAction(HOVERED_CLASS, REMOVE_ACTION);
    }

    closeModal(){
        this.tileIsClicked = false;
        this.tileClassAction(CLICKED_CLASS, REMOVE_ACTION);
    }

    tileClassAction(style, action) {
        const divElement = this.template.querySelector('.slds-tile');
        if(divElement) {
            if(action === ADD_ACTION) {
                divElement.classList.add(style);
            } else {
                divElement.classList.remove(style);
            }
        }
    }
}