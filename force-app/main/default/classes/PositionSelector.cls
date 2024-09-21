public inherited sharing class PositionSelector {

    public static List<Position__c> getAllPositions() {
        return [SELECT Name, Status__c, Open_Date__c, Close_Date__c, Min_Salary__c, Max_Salary__c
                FROM Position__c WITH SECURITY_ENFORCED];
    }

    public static List<Position__c> getFilteredPositionsByStatus(String selectedStatus) {
        return [SELECT Name, Status__c, Open_Date__c, Close_Date__c, Min_Salary__c, Max_Salary__c
                FROM Position__c WHERE Status__c = :selectedStatus WITH SECURITY_ENFORCED];
    }

}

