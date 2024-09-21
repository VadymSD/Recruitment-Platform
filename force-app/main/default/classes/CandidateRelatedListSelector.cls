public with sharing class CandidateRelatedListSelector {

    public static List<Candidate__c> getCandidates(String positionId, String candidateFieldSet, String jobAppFieldSet, Integer limitNumber) {
        try {
            String queryString = 'SELECT Id, Name, Avatar__c';
            for(Schema.FieldSetMember fld : Schema.SObjectType.Candidate__c.fieldSets.getMap().get(candidateFieldSet).getFields()) {
                queryString += ', ' + fld.getFieldPath();
            }
            queryString += ', (SELECT Id';
            for(Schema.FieldSetMember fld : Schema.SObjectType.Job_Application__c.fieldSets.getMap().get(jobAppFieldSet).getFields()) {
                queryString += ', ' + fld.getFieldPath();
            }
            queryString += ' FROM Job_Applications__r WHERE Position__c = :positionId) FROM Candidate__c WHERE Id IN (SELECT Candidate__c FROM Job_Application__c WHERE Position__c = :positionId) WITH SECURITY_ENFORCED LIMIT :limitNumber';  
    
            List<Candidate__c> candidateList = Database.query(queryString);
            return candidateList;
        } catch (Exception e) {
            throw e;
        }
    }
    
    public static List<Field_Set_Configuration__mdt> getMetadataRecord(String userProfileName) {
        return [SELECT Candidate_Modal_Field_Set__c, Candidate_Tile_Field_Set__c, Job_Application_Field_Set__c
                FROM Field_Set_Configuration__mdt
                WHERE DeveloperName = :userProfileName
                WITH SECURITY_ENFORCED];
    }
}