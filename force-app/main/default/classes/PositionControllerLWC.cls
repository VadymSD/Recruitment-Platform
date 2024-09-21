public with sharing class PositionControllerLWC {

    @AuraEnabled(cacheable=true)
    public static List<Position__c> getPositions(Integer limitNumber) {
        try {
            // Call the updatePositions method in the service layer
            return PositionLWCService.getPositions(limitNumber);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static List<Position__c> filterPositions(String statusValue, Integer limitNumber){
        try {
            // Call the updatePositions method in the service layer
            return PositionLWCService.getFilteredPositions(statusValue, limitNumber);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static List<Position__c> updatePositions(String positionsToUpdate, String statusValue, Integer limitNumber) {
        try {
            // Call the updatePositions method in the service layer
            return PositionLWCService.updatePositions(positionsToUpdate, statusValue, limitNumber);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}

