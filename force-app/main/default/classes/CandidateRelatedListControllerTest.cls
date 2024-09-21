@isTest
public with sharing class CandidateRelatedListControllerTest {

    private static final Integer NUM_TEST_CAN = 10;
    private static final String STATUS_OPEN = 'Open';
    private static final String STATUS_NEW = 'New';
    private static final String RESUME = 'asdasqw.com';
    private static final String LINKEDIN = 'asdasdasdqw.com';
    private static final String JOB_APPLICATION_FIELD_SET = 'Job_Application_Field_Set__c';
    private static final String CANDIDATE_TILE_FIELD_SET = 'Candidate_Tile_Field_Set__c';
    private static final String CANDIDATE_TILE_FAKE_FIELD_SET = 'Candidate_Tile_Fake_Field_Set__c';
    private static final String RECRUITER = 'Recruiter';
    private static final String STANDARD_EMPLOYEE = 'Standard employee';
    private static final String INTERVIEWER = 'Interviewer';

    @testSetup
    static void setupTestData() {
        Test_Validation_Settings__c validationSettings = new Test_Validation_Settings__c(Disable_Validation_Rule__c = true);
        insert validationSettings;

        List<Candidate__c> candidates = new List<Candidate__c>();
        for (Integer i = 1; i <= NUM_TEST_CAN; i++) {
            Candidate__c candidate = new Candidate__c(
                First_Name__c = 'Candidate First Name' + String.valueOf(1000 + i),
                Last_Name__c = 'Candidate Last Name' + String.valueOf(1000 + i),
                Date_Of_Birth__c = Date.newInstance(1960, 2, 17),
                Resume__c = RESUME,
                Linkedin_Profile__c = LINKEDIN
            );
            candidates.add(candidate);
        }
        insert candidates;

        Position__c testPosition = new Position__c(Name = 'Test Position');
        insert testPosition;

        List<Job_Application__c> jobApps = new List<Job_Application__c>();
        for (Candidate__c can : candidates) {
            Job_Application__c jobApp = new Job_Application__c(
                Status__c = STATUS_NEW,
                Candidate__c = can.Id,
                Position__c = testPosition.Id,
                Link_To_Application__c = 'asd.com'
            );
            jobApps.add(jobApp);
        }
        insert jobApps;
    }

    private static User createUser(String profileName) {
        Profile prof = [SELECT Id FROM Profile WHERE NAME = :profileName];
        User testUser = new User(
        LastName = 'Test User',
        Username = 'profileName'+'test.user@example.com',
        Email = 'test@example.com',
        Alias = 'testu',
        TimeZoneSidKey = 'GMT',
        LocaleSidKey = 'en_GB',
        EmailEncodingKey = 'ISO-8859-1',
        ProfileId = prof.Id,
        LanguageLocaleKey = 'en_US'
        );
        return testUser;
    }

    @isTest
    static void testGetCandidates() {
        List<Position__c> positions = [SELECT Id, Name FROM Position__c LIMIT 1];
        Position__c position = positions[0];

        Test.startTest();
        List<Candidate__c> resultCandidates = CandidateRelatedListController.getCandidates(position.Id, 3);
        Test.stopTest();

        System.assertEquals(3, resultCandidates.size());
    }

    @isTest
    static void testGetCandidateError() {
        String invalidId = '123123123@@@@12312j3lk12jlkasjdkljasdk';
        Boolean exceptionOccurred = false;

        Test.startTest();
        try {
            CandidateRelatedListController.getCandidates(invalidId, 3);
        } catch(Exception ex) {
            exceptionOccurred = true;
        }
        Test.stopTest();

        System.assert(exceptionOccurred, 'An Exception was not thrown');
    }

    @isTest
    static void testGetFields() {

        List<Candidate__c> candidates = [SELECT Id, (SELECT Id, Name, Link_To_Application__c, Status__c, Review_Count__c, Average_Rating__c FROM Job_Applications__r) FROM Candidate__c LIMIT 1];

        List<Job_Application__c> jobApplications = new List<Job_Application__c>();
        
        for (Candidate__c candidate : candidates) {
            List<Job_Application__c> applications = candidate.Job_Applications__r;
            jobApplications.addAll(applications);
        }

        List<String> fieldList = new List<String>();
        String fields = '';
        Test.startTest();
        fields = CandidateRelatedListController.getFields(JOB_APPLICATION_FIELD_SET, jobApplications[0]);
        Test.stopTest();

        List<Job_Application__c> jobApps = (List<Job_Application__c>) JSON.deserialize(fields, List<Job_Application__c>.class);

        System.assertEquals(5, jobApps.size());
    }

    @isTest
    static void testGetFieldError() {

        List<Candidate__c> candidates = [SELECT Id, Name, Phone__c, Email__c, Ready_To_Relocate__c, Qualifications__c FROM Candidate__c LIMIT 1]; 
        Boolean exceptionOccurred = false;

        Test.startTest();
        try {
            CandidateRelatedListController.getFields(CANDIDATE_TILE_FAKE_FIELD_SET, candidates[0]);
        } catch(Exception ex) {
            exceptionOccurred = true;
        }
        Test.stopTest();

        System.assert(exceptionOccurred, 'An Exception was not thrown');
    }

    @isTest
    static void testInterviewerGetUserProfileOrPermissionSet() {
        String interviewer = '';
        String profile = STANDARD_EMPLOYEE;
        User testUser = createUser(profile);
        insert testUser;

        PermissionSet permissionSet = [SELECT Id, Name FROM PermissionSet WHERE Name = 'Interviewer'];
        PermissionSetAssignment psAssignment = new PermissionSetAssignment(
            AssigneeId = testUser.Id,
            PermissionSetId = permissionSet.Id
        );
        insert psAssignment;

        Test.startTest();
        System.runAs(testUser) {
            interviewer = ProfileMetadataService.getUserProfileOrPermissionSet();
        }
        Test.stopTest();
        
        System.assertEquals(INTERVIEWER, interviewer);
    }

    @isTest
    static void testRecruiterGetUserProfileOrPermissionSet() {
        String recruiter = '';
        String profile = 'Recruiter';
        User testUser = createUser(profile);      
        Test.startTest();
        System.runAs(testUser) {
            recruiter = ProfileMetadataService.getUserProfileOrPermissionSet();
        }
        Test.stopTest();

        System.assertEquals(RECRUITER, recruiter);
    }

    @isTest
    static void testExceptionHandling() {

        List<Position__c> positions = [SELECT Id, Name FROM Position__c LIMIT 1];
        Position__c position = positions[0];

        String profile = STANDARD_EMPLOYEE;
        User testUser = createUser(profile);

        Boolean exceptionOccurred = false;
         
        Test.startTest();
        System.runAs(testUser){
            try {
                CandidateRelatedListController.getCandidates(position.Id, 3);
            } catch (Exception e) {
                exceptionOccurred = true;
            }
        }
        Test.stopTest();

        System.assert(exceptionOccurred, 'An Exception was not thrown');
    }

    @isTest
    static void testGetCandidatesSelectorError() {
        List<Position__c> positions = [SELECT Id, Name FROM Position__c LIMIT 1];
        Position__c position = positions[0];
        Boolean exceptionOccurred = false;
        String normalFieldSet =  'Recruiter_Modal_Field_Set';
        String fakeFieldSet = 'Recruiter_JobApp_Field_Set';

        Test.startTest();
        try {
            CandidateRelatedListSelector.getCandidates(position.Id, normalFieldSet, fakeFieldSet, 3);
        } catch(Exception ex) {
            exceptionOccurred = true;
        }
        Test.stopTest();

        System.assert(exceptionOccurred, 'An Exception was not thrown');
    }
}