public with sharing class JobApplicationTriggerHandler {
    private JobApplicationTriggerHelper helper;

    public JobApplicationTriggerHandler() {
        this.helper = new JobApplicationTriggerHelper();
    }

    public void afterUpdate(List<Job_Application__c> newRecords, Map<Id, Job_Application__c> oldRecordMap) {
        Set<Id> positionsIdsToUpdate = helper.createPositionsIdsToUpdate(newRecords, oldRecordMap);
        helper.updatePositionStatus(positionsIdsToUpdate);
    }
}