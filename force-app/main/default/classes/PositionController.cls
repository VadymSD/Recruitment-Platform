public with sharing class PositionController {

    // Get and Set properties for Positions List and Status
    public List<Position__c> positions { get; set; }
    public String selectedStatus { get; set; }

    // Constructor to retrieve position records
    public PositionController(){
        filterPositions();
    }
    
    // Creation of a list of options using SelectOption Apex class
    public List<SelectOption> getStatusOptions() {
        return PositionService.getStatusOptions();
    }

    // Method to filter Positions
    public PageReference filterPositions() {
        ApexPages.getMessages().clear();
        try {
            positions = PositionService.filterPositions(selectedStatus);
        } catch (QueryException ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }

     // Method to update Positions and catch possible errors
     public PageReference savePositions() {
        ApexPages.getMessages().clear();
        try {   
            PositionService.savePositions(positions);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, System.Label.SuccessfulSave));
        } catch (DmlException ex) {
            ApexPages.addMessages(ex);
        }
        filterPositions(); 
        return null;
    }
    
}