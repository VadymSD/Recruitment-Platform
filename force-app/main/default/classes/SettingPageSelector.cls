public inherited sharing class SettingPageSelector {
   public static List<Field_Set_Configuration__mdt> getFieldSetConfiguration() {
        return [SELECT Id, Label, Display_Inaccessible_Records__c, Candidate_Modal_Field_Set__c, 
                Candidate_Tile_Field_Set__c, Job_Application_Field_Set__c, Object_Type__c
                FROM Field_Set_Configuration__mdt
                WITH SECURITY_ENFORCED];
   }

    public static List<Field_Set_Configuration__mdt> getFieldSetMetadata(String recordId) {
        return [SELECT Id, MasterLabel, DeveloperName, Label, Display_Inaccessible_Records__c, Candidate_Modal_Field_Set__c, 
                Candidate_Tile_Field_Set__c, Job_Application_Field_Set__c, Object_Type__c
                FROM Field_Set_Configuration__mdt
                WHERE Id = :recordId
                WITH SECURITY_ENFORCED];
    }

    public static List<FieldPermissions> getSetPermissions(String objectField, String recordId){
        return [SELECT Id, PermissionsRead
                FROM FieldPermissions 
                WHERE Field = :objectField
                AND Parent.Name = :recordId
                WITH SECURITY_ENFORCED
                LIMIT 1];
    } 

    public static List<FieldPermissions> getProfilePermissions(String objectField, String recordId){
        return [SELECT Id, PermissionsRead
                FROM FieldPermissions 
                WHERE Field = :objectField
                AND Parent.Profile.Name = :recordId
                AND Parent.IsOwnedByProfile = true
                WITH SECURITY_ENFORCED
                LIMIT 1];
    }
}