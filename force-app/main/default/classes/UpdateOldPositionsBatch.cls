public with sharing class UpdateOldPositionsBatch implements Database.Batchable<SObject> {

    private static final String POSITION_QUERY = 'SELECT Id, Status__c, Open_Date__c FROM Position__c WHERE Open_Date__c <= LAST_90_DAYS WITH SECURITY_ENFORCED';

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(POSITION_QUERY);
    }
    public void execute(Database.BatchableContext bc, List<Position__c> scope) {
        List<Position__c> positionsToUpdate = new List<Position__c>();
        
        for (Position__c pos : scope) {
            pos.Status__c = 'Closed';
            positionsToUpdate.add(pos);
        }
        if (Schema.sObjectType.Position__c.isUpdateable() && Schema.sObjectType.Position__c.fields.Status__c.isUpdateable()){
            Database.update(positionsToUpdate);
        }
    }

    public void finish(Database.BatchableContext bc) {
}
}