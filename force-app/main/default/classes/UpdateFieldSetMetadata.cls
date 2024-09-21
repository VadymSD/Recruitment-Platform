public with sharing class UpdateFieldSetMetadata {
    public Metadata.CustomMetadata updateMetadata(Boolean checkboxValue, List<Field_Set_Configuration__mdt> metaList) {
        Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
        customMetadata.fullName = 'Field_Set_Configuration__mdt.' + metaList[0].DeveloperName;
        customMetadata.label = metaList[0].MasterLabel;

        Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
        customField.field = 'Display_Inaccessible_Records__c';
        customField.value = checkboxValue;
        customMetadata.values.add(customField);

        return customMetadata;
    }
}