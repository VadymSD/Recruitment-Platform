public with sharing class PositionService {

    public static List<Position__c> filterPositions(String selectedStatus) {
        if (selectedStatus != null) {
            return PositionSelector.getFilteredPositionsByStatus(selectedStatus);
        } else {
            return PositionSelector.getAllPositions();
        }
    }

    public static List<SelectOption> getStatusOptions() {
        List<SelectOption> options = new List<SelectOption>();
        if(Schema.SObjectType.Position__c.fields.Status__c.isAccessible()){
            try {
                SObjectField picklistField = Position__c.Status__c.getDescribe().getSObjectField();
                for (Schema.PicklistEntry entry : picklistField.getDescribe().getPicklistValues()) {
                    options.add(new SelectOption(entry.getValue(), entry.getLabel()));
                }
            } catch (Exception ex) {
                throw ex;
            }
        }
        
        return options;
    }

    public static void savePositions(List<Position__c> positions) {
        if (Schema.sObjectType.Position__c.isUpdateable() && Schema.sObjectType.Position__c.fields.Status__c.isUpdateable()) {
            try {
                update positions;
            } catch (DmlException ex) {
                throw ex; 
            }
        }
    }  
}
