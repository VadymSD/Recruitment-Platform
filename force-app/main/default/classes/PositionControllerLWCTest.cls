@isTest
public class PositionControllerLWCTest {

    @testSetup
    static void setupTestData() {
        List<Position__c> positions = new List<Position__c>();
        for (Integer i = 1; i <= 10; i++) {
            Position__c position = new Position__c(
                Name = 'Position ' + String.valueOf(1000 + i),
                Status__c = 'Open'
            );
            positions.add(position);
        }
        insert positions;
    }

    @isTest 
    static void testGetPositions() {
        Test.startTest();
        List<Position__c> result = PositionControllerLWC.getPositions(100);
        Test.stopTest();

        System.assertEquals(10, result.size(), 'Incorrect number of positions returned');
        System.assertEquals('Position 1001', result[0].Name, 'Incorrect name for Position 1001');
        System.assertEquals('Position 1002', result[1].Name, 'Incorrect name for Position 1002');
    }

    @isTest
    static void testFilterPositionsAll() {
        Test.startTest();
        List<Position__c> resultAll = PositionControllerLWC.filterPositions('All', 5);
        Test.stopTest();

        System.assertEquals(5, resultAll.size(), 'Returned positions should be limited to 5');
    }

    @isTest
    static void testFilterPositionsOpen() {
        Test.startTest();
        List<Position__c> resultOpen = PositionControllerLWC.filterPositions('Open', 3);
        Test.stopTest();

        System.assertEquals(3, resultOpen.size(), 'Returned positions should be limited to 3');
    }

    @isTest
    static void testFilterPositionsClosed() {
        Test.startTest();
        List<Position__c> resultClosed = PositionControllerLWC.filterPositions('Closed', 5);
        Test.stopTest();

        System.assertEquals(0, resultClosed.size(), 'No positions should be returned for Closed status');
    }

    @isTest
    static void testFilterPositionsPending() {
        Test.startTest();
        List<Position__c> resultPending = PositionControllerLWC.filterPositions('Pending', 5);
        Test.stopTest();

        System.assertEquals(0, resultPending.size(), 'No positions should be returned for Pending status');
    }

    @isTest
    static void testUpdatePositions() {
        List<Position__c> positions = [SELECT Id, Status__c FROM Position__c];

        List<Position__c> updatedPositions = new List<Position__c>();
        for (Position__c position : positions) {
            position.Status__c = 'Closed';
            updatedPositions.add(position);
        }

        String positionsToUpdate = JSON.serialize(updatedPositions);
        String statusValue = 'Closed';
        Integer limitNumber = 5;

        Test.startTest();
        List<Position__c> updatedPositionsResult = PositionControllerLWC.updatePositions(positionsToUpdate, statusValue, limitNumber);
        Test.stopTest();

        System.assertEquals(limitNumber, updatedPositionsResult.size(), 'Incorrect number of positions returned');
        for (Position__c position : updatedPositionsResult) {
            System.assertEquals('Closed', position.Status__c, 'Incorrect status for Position');
        }
    }

    @isTest
    public static void testUpdatePositionsException() {
        // Prepare invalid JSON input
        String invalidJson = '{"InvalidField": "InvalidValue"}';
        Boolean exceptionOccurred = false;
        String statusValue = 'Closed';
        Integer limitNumber = 5;
        
        Test.startTest();
        try {
            PositionControllerLWC.updatePositions(invalidJson, statusValue, limitNumber);
            System.assert(false, 'Expected exception was not thrown');
        } catch(Exception ex) {
            exceptionOccurred = true;
        }    
        Test.stopTest();

        System.assert(exceptionOccurred, 'An Exception was not thrown');    
    }
}  

