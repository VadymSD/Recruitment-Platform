@isTest
public with sharing class UpdateOldPositionsBatchTest {
    
    private static final Integer NUM_TEST_POS = 10;
    private static final String STATUS_OPEN = 'Open';
    private static final Date OPEN_DATE = Date.today().addDays(-100);

    @testSetup
    static void setupTestData() {
        List<Position__c> positions = new List<Position__c>();
        for (Integer i = 1; i <= NUM_TEST_POS; i++) {
            Position__c position = new Position__c(
                Name = 'Position ' + String.valueOf(1000 + i),
                Status__c = STATUS_OPEN,
                Open_Date__c = OPEN_DATE
            );
            positions.add(position);
        }
        insert positions;
    }

    @isTest
    static void testUpdateOldPositionsBatch(){
        Test.startTest();
        UpdateOldPositionsBatch batchJob = new UpdateOldPositionsBatch();
        Database.executeBatch(batchJob);
        Test.stopTest();
        for(Position__c pos : [SELECT Id, Status__c, Open_Date__c FROM Position__c LIMIT :NUM_TEST_POS]){
            System.assertEquals('Closed', pos.Status__c);
        }
    }
}