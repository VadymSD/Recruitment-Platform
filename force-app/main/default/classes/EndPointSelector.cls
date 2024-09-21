public with sharing class EndPointSelector {
    public static Job_Application__c getJobApplication(String jobAppId) {
        return [SELECT Name, Candidate__c, Position__c, Cover_Letter__c,
                Link_To_Application__c, Status__c
                FROM Job_Application__c
                WHERE Id = :jobAppId
                WITH SECURITY_ENFORCED];
    }   
}