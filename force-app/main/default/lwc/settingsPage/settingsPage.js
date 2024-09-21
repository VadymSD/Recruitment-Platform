import { LightningElement, wire } from 'lwc';
import getFieldSetConfiguration from '@salesforce/apex/SettingPageController.getFieldSetConfiguration';
import getObjectTypes from '@salesforce/apex/SettingPageController.getObjectTypes';
import getFieldSets from '@salesforce/apex/SettingPageController.getFieldSets';
import getFields from '@salesforce/apex/SettingPageController.getFields';
import updateFieldSetMetadata from '@salesforce/apex/SettingPageController.updateFieldSetMetadata';

export default class SettingsPage extends LightningElement {

    selectedProfileSetting;
    selectedObjectType
    selectedFieldSet;
    records;
    objectTypes;
    fieldSets;
    fields;
    forbiddenFields = false;
    checkboxValue;
    errorMessage;
    hasError = false;

    @wire(getFieldSetConfiguration, { 
        recordId : null
    })
    wiredFields({data, error}){
        if(data) {
            let options = [];
            for(var key in data) {
                options.push({label: data[key].Label, value: data[key].Id});
            }
            this.records = options;
            this.errorMessage = undefined;
        } else if(error) {
            this.records = undefined;
            this.handleError(this.picklistRetrievalError, error);
        }
    }

    handleProfilePick(event) {
        this.selectedProfileSetting = event.detail.value;
        this.selectedFieldSet = false;
        this.selectedObjectType = false;
        this.fetchObjectTypes();
        this.fetchDisplaySetting();  
    }

    handleObjectPick(event){
        this.selectedObjectType = event.detail.value;
        this.selectedFieldSet = false;
        this.fetchFieldSets();
    }

    handleFieldSetPick(event) {
        this.selectedFieldSet = event.detail.value;
        this.fetchFields();
    }   
    
    handleCheckBoxChange(event){
        this.checkboxValue = event.target.checked;
        updateFieldSetMetadata({ recordId: this.selectedProfileSetting, checkboxValue: this.checkboxValue });
    }

    fetchObjectTypes(){
        getObjectTypes({ recordId: this.selectedProfileSetting })
        .then((result) => {
            this.objectTypes = result.map(item => ({ label: item, value: item }));
            this.errorMessage = undefined;
        })
        .catch((error) => { 
            this.objectTypes = undefined; 
            this.handleError(this.picklistRetrievalError, error);
        });        
    }

    fetchDisplaySetting() {
        getFieldSetConfiguration({ recordId: this.selectedProfileSetting })
            .then((result) => {
                this.checkboxValue = result[0].Display_Inaccessible_Records__c;
                this.errorMessage = undefined;
            })
            .catch((error) => {
                this.checkboxValue = false;
                this.handleError(this.picklistRetrievalError, error);
            });
    }
    
    fetchFieldSets() {
        getFieldSets({ recordId: this.selectedProfileSetting, objectType: this.selectedObjectType })
            .then((result) => {
                this.fieldSets = result.map(item => ({ label: item, value: item }));
                this.errorMessage = undefined;
            })
            .catch((error) => {
                this.fieldSets = undefined;
                this.handleError(this.picklistRetrievalError, error);
            });
    }

    fetchFields() {
        getFields({ fieldSetName: this.selectedFieldSet, objectType: this.selectedObjectType, recordId: this.selectedProfileSetting })
            .then((result) => {
                this.fields = result[0];
                this.forbiddenFields = result[1];
                this.errorMessage = undefined;
            })
            .catch((error) => {
                this.fields = undefined;
                this.handleError(this.picklistRetrievalError, error);
            });
    }

    handleError(errorType, error){
        this.hasError = true;
        if (Array.isArray(error.body)) {
            this.errorMessage = errorType + error.body.map(e => e.message).join(', ');
        } 
        else if (typeof error.body.message === 'string') {
            this.errorMessage = errorType+ error.body.message;
        }
    }

    dismissError(event){
        this.hasError = false;
        this.errorMessage = undefined;
    }
}
  