public with sharing class ProfileMetadataService {

    public static final String INTERVIEWER = 'Interviewer';
    public static final String RECRUITER = 'Recruiter';

    public class YouDoNotHavePermissionsException extends Exception {}

    public static String getUserProfileName() {
        return [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId() WITH SECURITY_ENFORCED LIMIT 1].Name;
    }

    public static String getUserPermissionSetName() {
        String permissionSet = '';
        List<PermissionSetAssignment> assignments = [SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId() WITH SECURITY_ENFORCED];
        if(!assignments.isEmpty()){
            for(PermissionSetAssignment assignment : assignments) {
                if(assignment.PermissionSet.Name == INTERVIEWER) {
                    permissionSet = assignment.PermissionSet.Name;
                }
            }
        }
        return permissionSet;
    }
    
    public static String getUserProfileOrPermissionSet() {
        try {
            String profile = getUserProfileName();
            String permissionSet = getUserPermissionSetName();
            
            if (profile != null && profile.equalsIgnoreCase(RECRUITER)) {
                return profile;
            } else if (Schema.SObjectType.Candidate__c.isDeletable() && Schema.SObjectType.Job_Application__c.isDeletable()){
                return RECRUITER;
            } 
            else if (permissionSet != null && permissionSet.equalsIgnoreCase(INTERVIEWER)) {
                return permissionSet;
            } else {
                throw new YouDoNotHavePermissionsException(System.Label.YouDoNotHaveRightsException);
            }
        } catch (Exception e) {
            throw e;
        } 
    }    
}