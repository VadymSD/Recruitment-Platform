public with sharing class JobApplicationsSelector {
    static final String RECRUITER = 'Recruiter';
    static final String EXCEPTION_TEXT = System.Label.JobApplicationRetrievalError;

    // Retrieve Job Applications with Profile Recruiter created during last week
    public List<Job_Application__c> getRecentJobApplicationsForRecruiter() {
        try {
            return [SELECT Name, (SELECT Name FROM Reviews__r), Candidate__c, Position__c 
                    FROM Job_Application__c 
                    WHERE Candidate__r.Owner.Profile.Name =: RECRUITER
                    AND CreatedDate <= LAST_N_DAYS:7
                    WITH SECURITY_ENFORCED];
        } catch(QueryException ex) {
            throw new JobApplicationsSelectorException(EXCEPTION_TEXT + ex.getMessage());
        }
    }

    public class JobApplicationsSelectorException extends Exception{}
}
