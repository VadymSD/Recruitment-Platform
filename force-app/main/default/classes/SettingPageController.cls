public with sharing class SettingPageController {
    @AuraEnabled(cacheable=true)
    public static List<Field_Set_Configuration__mdt> getFieldSetConfiguration(String recordId) {
        try {
            return SettingPageService.getFieldSetConfiguration(recordId);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getObjectTypes(String recordId) {
        try {
            return SettingPageService.getObjectTypes(recordId);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    } 

    @AuraEnabled(cacheable=true)
    public static List<String> getFieldSets(String recordId, String objectType) {
        try {
            return SettingPageService.getFieldSets(recordId, objectType);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<List<String>> getFields(String fieldSetName, String objectType, String recordId) {
        try {
            return SettingPageService.getFields(fieldSetName, objectType, recordId);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static void updateFieldSetMetadata(String recordId, Boolean checkboxValue) {
        try {
            SettingPageService.updateFieldSetMetadata(recordId, checkboxValue);
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}
