@isTest
public class UpdateOldPositionsSchedulerTest {

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
        static void testUpdateOldPositions() {
            Test.startTest();

            String jobId = System.schedule('Test Update Old Positions', '0 0 0 * * ?', new UpdateOldPositionsScheduler());

            UpdateOldPositionsBatch batchJob = new UpdateOldPositionsBatch();
            Database.executeBatch(batchJob);

            Test.stopTest();

            List<Position__c> updatedPositions = [SELECT Id, Status__c FROM Position__c LIMIT :NUM_TEST_POS];

            System.assertEquals(NUM_TEST_POS, updatedPositions.size());
            for (Position__c pos : updatedPositions) {
                System.assertEquals('Closed', pos.Status__c);
            }
        }
}
