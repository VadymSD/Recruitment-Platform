public with sharing class JobApplicationTriggerHelper {

    private static final String STATUS_OFFER_ACCEPTED = 'Offer Accepted';
    private static final String STATUS_CLOSED = 'Closed';

    public Set<Id> createPositionsIdsToUpdate(List<Job_Application__c> newJobApps, Map<Id,Job_Application__c> oldJobAppMap){
        Set<Id> positionIdsToUpdate = new Set<Id>();
        if(Schema.SObjectType.Job_Application__c.isAccessible()){
            for (Job_Application__c jobApp : newJobApps) {
                Job_Application__c oldJobApp = oldJobAppMap.get(jobApp.Id);
                if (oldJobApp != null && oldJobApp.Status__c != STATUS_OFFER_ACCEPTED && jobApp.Status__c == STATUS_OFFER_ACCEPTED) {
                    positionIdsToUpdate.add(jobApp.Position__c);
                }
            }
        }
        return positionIdsToUpdate;
    }

    public void updatePositionStatus(Set<Id> positionIdsToUpdate) {
        List<Position__c> positionsToUpdate = [SELECT Id, Name, Status__c 
                                                FROM Position__c 
                                                WHERE Id IN :positionIdsToUpdate 
                                                WITH SECURITY_ENFORCED];
        for (Position__c pos : positionsToUpdate) {
            pos.Status__c = STATUS_CLOSED;
        }
        if(!positionsToUpdate.isEmpty()){
            if(Schema.sObjectType.Position__c.isUpdateable() && Schema.sObjectType.Position__c.fields.Status__c.isUpdateable()){
                update positionsToUpdate;
            }
        }
    }
}