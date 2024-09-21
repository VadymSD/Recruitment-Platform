@isTest
private class JobApplicationTriggerTest {

    private static final Integer NUM_TEST_POS = 10;

    private static final String STATUS_OPEN = 'Open';
    private static final String STATUS_NEW = 'New';

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

        List<Job_Application__c> jobApps = new List<Job_Application__c>();
        for (Position__c pos : positions) {
            Job_Application__c jobApp = new Job_Application__c(
                Status__c = STATUS_NEW,
                Candidate__c = System.Label.CandidateId,
                Position__c = pos.Id,
                Link_To_Application__c = 'asd.com'
            );
            jobApps.add(jobApp);
        }
        insert jobApps;
        
    }

    @isTest
    static void testAfterJobAppUpdate(){
        List<Job_Application__c> jobApps = [SELECT Id, Name, Status__c, Position__c FROM Job_Application__c];

        List<Job_Application__c> jobAppsToUpdate = new List<Job_Application__c>();
        for(Job_Application__c jobApp : jobApps){
            if(jobApp.Status__c != 'Offer Accepted'){
                jobApp.Status__c = 'Offer Accepted';
                jobAppsToUpdate.add(jobApp);
            }
        }

        Test.startTest();
        update jobAppsToUpdate;
        Test.stopTest();

        List<Position__c> positions = [SELECT Id, Status__c, Close_Date__c FROM Position__c WHERE Id IN (SELECT Position__c FROM Job_Application__c WHERE Id IN :jobAppsToUpdate)];

        for(Position__c pos : positions){
            System.assertEquals('Closed', pos.Status__c);
            System.assertEquals(Date.today(), pos.Close_Date__c);
        }
    }
}   