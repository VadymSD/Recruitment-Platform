public with sharing class PositionTriggerHelper {

    private static final String STATUS_CLOSED = 'Closed';

    public void updatePositionDate(List<Position__c> newPositions, Map<Id, Position__c> oldPositionMap) {
        if (Schema.sObjectType.Position__c.isUpdateable() && Schema.sObjectType.Position__c.fields.Close_Date__c.isUpdateable()){
            for (Position__c pos : newPositions) {
                Position__c oldPos = oldPositionMap.get(pos.Id);
                if (oldPos != null && oldPos.Status__c != STATUS_CLOSED && pos.Status__c == STATUS_CLOSED) {
                    pos.Close_Date__c = Date.today();
                }
            }
        }
    }
}

