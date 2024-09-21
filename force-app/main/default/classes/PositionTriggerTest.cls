@IsTest
private class PositionTriggerTest {

    private static final Integer NUM_TEST_POS = 10;
    private static final String STATUS_OPEN = 'Open';

    @testSetup
    static void setupTestData() {
        List<Position__c> positions = new List<Position__c>();
        for (Integer i = 1; i <= NUM_TEST_POS; i++) {
            Position__c position = new Position__c(
                Name = 'Position ' + String.valueOf(1000 + i),
                Status__c = STATUS_OPEN
            );
            positions.add(position);
        }
        insert positions;
    }

    @IsTest
    static void testAfterPositionUpdate() {
        List<Position__c> positions = [SELECT Id, Name, Status__c FROM Position__c];

        List<Position__c> positionsToUpdate = new List<Position__c>();
        for (Position__c pos : positions) {
            pos.Status__c = 'Closed';
            positionsToUpdate.add(pos);
        }
        Test.startTest();
        update positionsToUpdate;
        Test.stopTest();

        for (Position__c pos : [SELECT Id, Status__c, Close_Date__c FROM Position__c WHERE Id IN :positionsToUpdate]) {
            System.assertEquals('Closed', pos.Status__c);
            System.assertEquals(Date.today(), pos.Close_Date__c);
        }
    }
}
