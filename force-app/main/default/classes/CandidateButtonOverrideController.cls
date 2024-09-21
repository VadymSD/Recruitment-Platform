public with sharing class CandidateButtonOverrideController {
    @AuraEnabled(cacheable=true)
    public static String getFields(String sObjectName) {
        try {
            return CandidateButtonOverrideService.getFields(sObjectName);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}