import { LightningElement, wire, track, api } from 'lwc';
import getPositions from '@salesforce/apex/PositionControllerLWC.getPositions';
import updatePositions from '@salesforce/apex/PositionControllerLWC.updatePositions';
import filterPositions from '@salesforce/apex/PositionControllerLWC.filterPositions';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import POSITION_OBJECT from '@salesforce/schema/Position__c';
import STATUS_FIELD from '@salesforce/schema/Position__c.Status__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import DataRetrievalError from '@salesforce/label/c.DataRetrievalError';
import FilterError from '@salesforce/label/c.FilterError';
import PicklistRetrievalError from '@salesforce/label/c.PicklistRetrievalError';


// Column configurations
const columns = [
    { label: 'Position Name', fieldName: 'Name', type: 'text', hideDefaultActions: true,
        cellAttributes: {
            alignment: 'left'
        },
    },
    { label: 'Status', fieldName: 'Status__c', type: 'statusPicklist', hideDefaultActions: true, wrapText: true,
        typeAttributes:  {
            name: 'Picklist',
            label: { fieldName: 'Status__c' },
            value: { fieldName: 'Status__c'},
            placeholder: 'Choose Status',
            variant: 'label-hidden',
            options: { fieldName: 'picklistOptions'},
            context: { fieldName: 'Id'}
        },
    },
    { label: 'Opening Date', fieldName: 'Open_Date__c', type: 'date', hideDefaultActions: true,
        cellAttributes: {
            alignment: 'left'
        },
    },
    { label: 'Closing Date', fieldName: 'Closed_Date__c', type: 'date', hideDefaultActions: true,
        cellAttributes: {
            alignment: 'left'
        },
    },
    { label: 'Min Salary', fieldName: 'Min_Salary__c', type: 'currency', hideDefaultActions: true,
        cellAttributes: {
            alignment: 'left'
        },
    },
    { label: 'Max Salary', fieldName: 'Max_Salary__c', type: 'currency', hideDefaultActions: true,
        cellAttributes: {
            alignment: 'left'
        },
    },
];

const saveCompletedTitle = 'Save completed';
const saveCompletedMessage = 'The saving operation was successful.';
const somethingWentWrongTitle = 'Something went wrong';

export default class Positions extends LightningElement {

    // Class properties
    columns = columns;
    positions;
    options;
    statusOptions;
    statusOptionValues;
    selectedStatus = 'All';
    @api limitNumber = 2000;
    visiblePositions;
    @api pageSize = 5;
    hasError = false;
    dataRetrievalError = DataRetrievalError;
    picklistRetrievalError = PicklistRetrievalError;
    filterError = FilterError;

     // Wire service to get object info for Position__c
    @wire(getObjectInfo, { objectApiName: POSITION_OBJECT })
    positionObjectInfo;

    // Wire service to get picklist values for Status__c field
    @wire(getPicklistValues,  { 
        recordTypeId: '$positionObjectInfo.data.defaultRecordTypeId', 
        fieldApiName: STATUS_FIELD
    })
    wirePicklist({ data, error }) {
        if (data)  {
            this.options = data.values;
            this.statusOptions = [{ label: 'All', value: 'All' }, ...data.values];
            this.fetchPositions();
            this.errorMessage = undefined;
        } else if (error) {
            this.handleError(this.picklistRetrievalError, error);
            this.options = undefined;
            this.statusOptions = undefined;
        }
    }
    
    // Fetch positions from server using Apex method
    fetchPositions() {
        getPositions({ limitNumber: this.limitNumber })
            .then((result) => {
                this.statusOptionValues = [];
                for (var key in this.options) {
                    this.statusOptionValues.push({ label: this.options[key].label, value: this.options[key].value });
                }
                this.positions = result.map((record) => {
                    return {
                        ...record,
                        'picklistOptions': this.statusOptionValues
                    };
                });
                this.errorMessage = undefined;
            })
            .catch((error) => { 
                this.handleError(this.dataRetrievalError, error);
                this.positions = undefined;
            });
    }

    // Handle status change event
    handleStatusChange(event) {
        this.selectedStatus = event.detail.value;
        this.filter();
        this.template.querySelector('c-pagination').setCurrentPageToOne();
    }

    filter() {
        filterPositions({ statusValue: this.selectedStatus, limitNumber: this.limitNumber })
        .then((result) => {
            this.positions = result.map((record) => {
                return {
                    ...record,
                    'picklistOptions': this.statusOptionValues
                };
            });
            this.error = undefined;
        })
        .catch((error) => {
            this.handleError(this.filterError, error);
            this.positions = undefined;
        });
    }

    // Handle select event on picklist
    handleSelect(event) {
        event.preventDefault();
        const value = event.detail.value;
        const recordId = event.detail.context;
        this.positions = this.positions.map((pos) => {
            if (pos.Id === recordId && pos.Status__c !== value) {
                return { ...pos, Status__c: value };
            }
            return pos;
        });
    }

    // Handle save button click
    handleSave() {
        // Remove picklistOptions property from positions array
        const positionsToUpdate = this.positions.map((pos) => {
            const { picklistOptions, ...updatedPos } = pos;
            return updatedPos;
        }); 
        updatePositions({ positionsToUpdate: JSON.stringify(positionsToUpdate), statusValue: this.selectedStatus, limitNumber: this.limitNumber })
        .then((result) => {
            // Handle success
            this.showToast(saveCompletedTitle, saveCompletedMessage, 'success');
            this.positions = result.map((record) => {
                return {
                    ...record,
                    'picklistOptions': this.statusOptionValues
                };
            });
            this.errorMessage = undefined;
        })  
        .catch((error) => {
            // Handle error
            this.showToast(somethingWentWrongTitle, error.body.message, 'error');
        });
    }

    updatePositionHandler(event){
        this.visiblePositions = [...event.detail.records];
        console.log(event.detail.records);
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

    dismissError(){
        this.hasError = false;
        this.errorMessage = undefined;
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}
