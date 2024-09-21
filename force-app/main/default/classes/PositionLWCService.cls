public with sharing class PositionLWCService {
    private static final String STATUS_ALL = 'All';
    
    public static List<Position__c> getPositions(Integer limitNumber) {
        return PositionLWCSelector.getAllPositions(limitNumber);
    }

    public static List<Position__c> getFilteredPositions(String statusValue, Integer limitNumber) {
        if (statusValue == STATUS_ALL) {
            return PositionLWCSelector.getAllPositions(limitNumber);
        } else {
            return PositionLWCSelector.filterPositionsByStatus(statusValue, limitNumber);
        }
    }

    public static List<Position__c> updatePositions(String positionsToUpdate, String statusValue, Integer limitNumber) {
        if (Schema.sObjectType.Position__c.isUpdateable() && Schema.sObjectType.Position__c.fields.Status__c.isUpdateable()) {
            List<Position__c> updatedPositions = (List<Position__c>) System.JSON.deserialize(positionsToUpdate, List<Position__c>.class);
            update updatedPositions;
        }
        // Return the filtered positions after the update
        return getFilteredPositions(statusValue, limitNumber);
    }
}