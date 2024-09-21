@isTest
public class PositionControllerTest {
    // Create test data
    @TestSetup static void setup(){
        Position__c pos1 = new Position__c(Name='Pos1', Status__c='Open');
        insert pos1;
        Position__c pos2 = new Position__c(Name='Pos2', Status__c='Closed');
        insert pos2;
    }
    
    // Test filterPositons if selectedStatus = null
    @isTest
    static void filetPositionsSelectedStatusNullTest(){
        // New instance of controller
        PositionController customController = new PositionController();
        // Selected status assignment
        customController.selectedStatus = null;
        
        Test.startTest();
        customController.filterPositions();
        Test.stopTest();

        // Verify results
        System.assertEquals(2, customController.positions.size());
        System.assertEquals('Pos1', customController.positions[0].Name);
        System.assertEquals('Pos2', customController.positions[1].Name);
    }
	// filterPostionsTest if selectedStatus equals Open
    @isTest
    static void filterPositionsTest(){
        // New instance of controller
        PositionController customController = new PositionController();
        
        customController.selectedStatus = 'Open';
        //Selected status assignment
        Test.startTest();
        customController.filterPositions();
        Test.stopTest();

        // Verify positions are filtered correctly based on selectedStatus
        for (Position__c position : customController.positions) {
            System.assertEquals('Open', position.Status__c, 'Positions should be filtered with selectedStatus = "Open"');
        }
        System.assertEquals(customController.positions.size(), 1, 'There should be only one position with Open Status');
    }
	// Test of getStatusOptions method
    @isTest
    static void getStatusOptionsTest(){
        // New instance of controller
        PositionController customController = new PositionController();
        
        Test.startTest();
        List<SelectOption> options = customController.getStatusOptions();
        Test.stopTest();

    	// Verify results
        System.assertEquals(3, options.size(), 'The number of options should be 3');
        System.assertEquals('Open', options[0].getLabel(), 'The first option label should be "Open"');
        System.assertEquals('Open', options[0].getValue(), 'The first option value should be "Open"');
        System.assertEquals('Closed', options[1].getLabel(), 'The first option label should be "Closed"');
        System.assertEquals('Closed', options[1].getValue(), 'The first option value should be "Closed"');
    }

    @isTest
    static void testSavePositions() {

        // Create instances and set positions
        PositionController customController = new PositionController();
        customController.positions = [SELECT Id, Name, Status__c FROM Position__c];

        // Update positions to 'Pending' status
        for (Position__c position : customController.positions) {
            position.Status__c = 'Pending';
        }

        Test.startTest();
        customController.savePositions();
        Test.stopTest();

        // Verify results
        for (Position__c position : customController.positions) {
            System.assertEquals('Pending', position.Status__c, 'Positions should be updated to "Pending" status');
        }
    }
}