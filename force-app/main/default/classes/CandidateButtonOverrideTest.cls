@isTest
public with sharing class CandidateButtonOverrideTest {

    public static final String CANDIDATE_API_NAME = 'Candidate__c';
    public static final String JOB_APPLICATION_API_NAME = 'Job_Application__c';
    public static final String CANDIDATE_FIELD_SET = 'New_Candidate_Field_Set';
    public static final String JOB_APPLICATION_FIELD_SET = 'New_Job_Application_Field_Set';
    public static final String FAKE_API_NAME = 'TestName';

    @isTest
    static void getFieldsForCandidateTest() {
        String fields = '';
        Test.startTest();
        fields = CandidateButtonOverrideController.getFields(CANDIDATE_API_NAME);
        Test.stopTest();

        List<Candidate__c> candidates = (List<Candidate__c>) JSON.deserialize(fields, List<Candidate__c>.class);

        List<Schema.FieldSetMember> fieldSetFields =  Schema.getGlobalDescribe().get(CANDIDATE_API_NAME).getDescribe().fieldSets.getMap().get(CANDIDATE_FIELD_SET).getFields();
        System.assertEquals(fieldSetFields.size(), candidates.size());
    }

    @isTest
    static void getFieldsForJobAppTest() {
        String fields = '';
        Test.startTest();
        fields = CandidateButtonOverrideController.getFields(JOB_APPLICATION_API_NAME);
        Test.stopTest();

        List<Job_Application__c> jobApps = (List<Job_Application__c>) JSON.deserialize(fields, List<Job_Application__c>.class);

        List<Schema.FieldSetMember> fieldSetFields =  Schema.getGlobalDescribe().get(JOB_APPLICATION_API_NAME).getDescribe().fieldSets.getMap().get(JOB_APPLICATION_FIELD_SET).getFields();
        System.assertEquals(fieldSetFields.size(), jobApps.size());
    }

    @isTest 
    static void getFieldsSetUpTest() {
        Boolean exceptionOccurred = false;
        
        Test.startTest();
        try {
            CandidateButtonOverrideService.getFieldsSetUp(CANDIDATE_FIELD_SET, FAKE_API_NAME);
        } catch(Exception ex) {
            exceptionOccurred = true;
        }
        Test.stopTest();

        System.assert(exceptionOccurred, 'An Exception was not thrown');

    }

    @isTest
    static void getFieldsErrorTest() {
        Boolean exceptionOccurred = false;

        Test.startTest();
        try {
            CandidateButtonOverrideController.getFields(FAKE_API_NAME);
        } catch(Exception ex) {
            exceptionOccurred = true;
        }
        Test.stopTest();

        System.assert(exceptionOccurred, 'An Exception was not thrown');
    }
}