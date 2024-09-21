import { LightningElement, api, wire} from 'lwc';
import getCandidates from '@salesforce/apex/CandidateRelatedListController.getCandidates';
import DataRetrievalError from '@salesforce/label/c.DataRetrievalError';
import OoopsLabel from '@salesforce/label/c.OoopsLabel';

export default class CandidateRelatedList extends LightningElement {
    candidates;
    errorMessage;
    dataRetrievalError = DataRetrievalError;
    errorLabel = OoopsLabel;
    visibleCandidates;
    @api limitNumber = 5;
    @api pageSize = 5;
    @api recordId;
    @api showImage;
    hasError = false;

    renderedCallback(){
        this.fetchCandidateData();
    }

    @wire(getCandidates, { limitNumber: '$limitNumber', positionId: '$recordId' })
    wiredCandidates({ data, error }) {
        if (data) {
            this.candidates = data;
            this.errorMessage = undefined;
            setTimeout(() => {
                this.fetchCandidateData();
            });
        } else if (error) {
            this.handleError(this.dataRetrievalError, error);
            this.candidates = undefined;
        }
    }

    fetchCandidateData(){
        this.template.querySelectorAll('c-candidate-custom-tile').forEach(candidateTile => {
            candidateTile.fetchFields();
        });
    }
    
    updateCandidateHandler(event){
        this.visibleCandidates = [...event.detail.records];
    }

    handleErrorFromChild(event){
        const error = event.detail.error;
        const errorType = event.detail.errorType;
        this.handleError(errorType, error);
    }
    
    handleError(errorType, error){
        this.hasError = true;
        if (Array.isArray(error.body)) {
            this.errorMessage = errorType + error.body.map(e => e.message).join(', ');
        } 
        else if (typeof error.body.message === 'string') {
            this.errorMessage = errorType + error.body.message;
        }
    }

    dismissError(){
        this.hasError = false;
        this.errorMessage = undefined;
    }
}