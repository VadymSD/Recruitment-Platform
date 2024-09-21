public with sharing class PositionTriggerHandler {
    private PositionTriggerHelper helper;

    public PositionTriggerHandler() {
        this.helper = new PositionTriggerHelper();
    }

    public void beforeUpdate(List<Position__c> newRecords, Map<Id, Position__c> oldRecordMap) {
        helper.updatePositionDate(newRecords, oldRecordMap);
    }
}