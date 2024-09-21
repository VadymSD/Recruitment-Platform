import LightningDatatable from 'lightning/datatable';
import customPicklistColums from './customPicklistColumn.html';

export default class CustomDatatable extends LightningDatatable {
    static customTypes = {
        statusPicklist: {
            template: customPicklistColums,
            typeAttributes: ['name', 'label', 'value', 'placeholder', 'options', 'variant', 'context']
        }
    }
}   