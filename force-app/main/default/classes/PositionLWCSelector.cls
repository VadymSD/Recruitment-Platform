public inherited sharing class PositionLWCSelector {
    public static List<Position__c> getAllPositions(Integer limitNumber) {
        return [SELECT Id, Name, Status__c, Open_Date__c, Close_Date__c, Min_Salary__c, Max_Salary__c
                FROM Position__c WITH SECURITY_ENFORCED ORDER BY Name ASC LIMIT :limitNumber];
    }

    public static List<Position__c> filterPositionsByStatus(String statusValue, Integer limitNumber) {
        return [SELECT Id, Name, Status__c, Open_Date__c, Close_Date__c, Min_Salary__c, Max_Salary__c
                FROM Position__c WHERE Status__c = :statusValue WITH SECURITY_ENFORCED
                ORDER BY Name ASC LIMIT :limitNumber];
    }
}