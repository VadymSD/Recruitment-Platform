public with sharing class SettingPageService {

    private static final String CANDIDATE = 'Candidate__c';
    private static final String RECRUITER = 'Recruiter';
    private static final String INTERVIEWER = 'Interviewer';

    public static List<Field_Set_Configuration__mdt> getFieldSetConfiguration(String recordId) {
        List<Field_Set_Configuration__mdt> fieldSetConfigs = new List<Field_Set_Configuration__mdt>();
    
        try {
            if (recordId == null) {
                fieldSetConfigs = SettingPageSelector.getFieldSetConfiguration();
            } else {
                fieldSetConfigs = SettingPageSelector.getFieldSetMetadata(recordId);
            }
            if (fieldSetConfigs.isEmpty()) {
                throw new NoRecordsFoundException(System.Label.NoRecordsFoundException);
            }
        } catch (Exception e) {
            throw e;
        }
    
        return fieldSetConfigs;
    }
    
    public static List<String> getObjectTypes(String recordId) {
        List<String> objectTypes = new List<String>();
    
        try {
            Field_Set_Configuration__mdt config = getConfigRecord(recordId);
    
            if (config != null) {
                String objectType = config.Object_Type__c;
                objectTypes = objectType.split(',');
            }
    
            if (objectTypes.isEmpty()) {
                throw new NoObjectsFoundException(System.Label.NoObjectsFoundException);
            }
        } catch (Exception e) {
            throw e;
        }
    
        return objectTypes;
    }
    
    public static List<String> getFieldSets(String recordId, String objectType) {
        List<String> fieldSets = new List<String>();
        Field_Set_Configuration__mdt config = getConfigRecord(recordId);
    
        try {
            if (config != null) {
                if (objectType.equals(CANDIDATE)) {
                    fieldSets.add(config.Candidate_Modal_Field_Set__c);
                    fieldSets.add(config.Candidate_Tile_Field_Set__c);
                } else {
                    fieldSets.add(config.Job_Application_Field_Set__c);
                }
            }
            if (fieldSets.isEmpty()) {
                throw new NoFieldSetsFoundException(System.Label.NoFieldSetsFoundException);
            }
        } catch (Exception e) {
            throw e;
        }
    
        return fieldSets;
    }

    public static List<List<String>> getFields(String fieldSetName, String objectType, String recordId) {
        List<List<String>> fieldLists = new List<List<String>>();
        Field_Set_Configuration__mdt config = getConfigRecord(recordId);
        Boolean checkboxValue = config.Display_Inaccessible_Records__c;
        String recordLabel = config.Label;
    
        List<String> trueFieldList = new List<String>();
        List<String> falseFieldList = new List<String>();
    
        List<Schema.FieldSetMember> fieldsSet = Schema.getGlobalDescribe().get(objectType).getDescribe().fieldSets.getMap().get(fieldSetName).getFields();
    
        for (Schema.FieldSetMember f : fieldsSet) {
            String field = f.getFieldPath();
            Boolean hasAccess = getAccess(field, recordLabel, objectType);
    
            if (checkboxValue && !hasAccess) {
                falseFieldList.add(field);
            } else {
                trueFieldList.add(field);
            }
        }
    
        fieldLists.add(trueFieldList);
    
        if (checkboxValue && !falseFieldList.isEmpty()) {
            fieldLists.add(falseFieldList);
        }
    
        return fieldLists;
    }
    
    public static void updateFieldSetMetadata(String recordId, Boolean checkboxValue) {
        List<Field_Set_Configuration__mdt> metaList = SettingPageSelector.getFieldSetMetadata(recordId);
        DeployFieldSetMetadata deploy = new DeployFieldSetMetadata();
        Metadata.DeployContainer container = deploy.constructDeploymentRequest(checkboxValue, metaList);
        deploy.deployMetadata(container);
    }    

    private static Field_Set_Configuration__mdt getConfigRecord(String recordId) {
        List<Field_Set_Configuration__mdt> configRecords = SettingPageSelector.getFieldSetMetadata(recordId);
        if (!configRecords.isEmpty()) {
            return configRecords[0];
        }
        return null;
    }

    @TestVisible private static Boolean getAccess(String field, String recordId, String objectType) {
        String objectField = objectType + '.' + field;
        List<FieldPermissions> permissions = new List<FieldPermissions>();
        if(recordId.equals(RECRUITER)){
            permissions = SettingPageSelector.getProfilePermissions(objectField, recordId);
        } else if (recordId.equals(INTERVIEWER)) {
            permissions = SettingPageSelector.getSetPermissions(objectField, recordId);    
        }

        if(!permissions.isEmpty()) {
            FieldPermissions perm = permissions[0];
            return perm.PermissionsRead;
        }  
        return false;
    }

    public class NoRecordsFoundException extends Exception {}
    public class NoFieldsFoundException extends Exception {}
    public class NoFieldSetsFoundException extends Exception {}
    public class NoObjectsFoundException extends Exception {}
}
