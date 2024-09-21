public with sharing class CandidateRelatedListController {

    @AuraEnabled(cacheable=true)
    public static List<Candidate__c> getCandidates(String positionId, Integer limitNumber) {
        try {
            return CandidateRelatedListService.getCandidates(positionId, limitNumber);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static String getFields(String fieldSetName, SObject record) {
        try {
            return CandidateRelatedListService.getFields(fieldSetName, record);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}