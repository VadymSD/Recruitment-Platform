public with sharing class CandidateButtonOverrideSelector {
    public static List<Override_FieldSet_Setting__mdt> getFieldSetName(String recordName) {
        return [SELECT Field_Set_Name__c
                FROM Override_FieldSet_Setting__mdt	
                WHERE DeveloperName = :recordName
                WITH SECURITY_ENFORCED];
    }
}