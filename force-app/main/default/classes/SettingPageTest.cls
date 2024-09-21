@isTest
public with sharing class SettingPageTest {
    
    private static final String RECRUITER_ID = System.Label.FieldSetConfigMetadataIdReal;
    private static final String INTERVIEWER_ID = System.Label.InterviewerCustomMetadataId;
    private static final String FAKE_ID = System.Label.FieldSetConfigMetadataIdFake;
    private static final String RECRUITER_LABEL = 'Recruiter';
    private static final String INTERVIEWER_LABEL = 'Interviewer';
    private static final String OBJECT_TYPE = 'Candidate__c, Job_Application__c';
    private static final String CANDIDATE = 'Candidate__c';
    private static final String EMAIL_FIELD = 'Email__c';
    private static final String JOB_APPLICATION = 'Job_Application__c';
    private static final String RECRUITER_MODAL_FIELD_SET = 'Recruiter_Modal_Field_Set';
    private static final String FAKE_FIELD_SET = 'Fake_Field_Set';
    private static final Boolean CHECKBOX_VALUE = true;
    private static final String EXCEPTION_NOT_THROWN = 'An Exception was not thrown';

    @isTest
    static void getFieldSetConfigurationTestWithRecordId() {
        Test.startTest();
        List<Field_Set_Configuration__mdt> fieldSetConfig = SettingPageController.getFieldSetConfiguration(RECRUITER_ID);
        Test.stopTest(); 
        
        fieldSetConfig = [SELECT Id, Label FROM Field_Set_Configuration__mdt WHERE Id =: RECRUITER_ID];
        for(Field_Set_Configuration__mdt f : fieldSetConfig){
            System.assertEquals(RECRUITER_LABEL, f.Label);
        }
    }

    @isTest
    static void getFieldSetConfigurationTestWithNullRecordId() {
        Test.startTest();
        List<Field_Set_Configuration__mdt> fieldSetConfig = SettingPageController.getFieldSetConfiguration(null);
        Test.stopTest(); 
        
        fieldSetConfig = [SELECT Id, Label FROM Field_Set_Configuration__mdt];
        System.assertEquals(2, fieldSetConfig.size());
    }

    @isTest
    static void getFieldSetConfigurationExceptionTest() {
        Boolean exceptionOccurred = false;
        Test.startTest();
        try {
            SettingPageController.getFieldSetConfiguration(FAKE_ID);
        } catch(Exception ex) {
            exceptionOccurred = true;
        }
        Test.stopTest();

        System.assert(exceptionOccurred, EXCEPTION_NOT_THROWN);
    }

    @isTest
    static void getObjectTypesTest() {
        Test.startTest();
        List<String> objectTypes = SettingPageController.getObjectTypes(RECRUITER_ID);
        Test.stopTest();

        System.assertEquals(2, objectTypes.size());
    } 

    @isTest
    static void getObjectTypesExceptionTest() {
        Boolean exceptionOccurred = false;
        Test.startTest();
        try {
            SettingPageController.getObjectTypes(FAKE_ID);
        } catch(Exception ex) {
            exceptionOccurred = true;
        }
        Test.stopTest();

        System.assert(exceptionOccurred, EXCEPTION_NOT_THROWN);
    }

   
    @isTest
    static void getFieldSetsTestForCandidate() {
        Test.startTest();
        List<String> fieldSets = SettingPageController.getFieldSets(RECRUITER_ID, CANDIDATE);
        Test.stopTest();

        System.assertEquals(2, fieldSets.size());
    }
    
    
    @isTest
    static void getFieldSetsTestForJobApplication() {
        Test.startTest();
        List<String> fieldSets = SettingPageController.getFieldSets(RECRUITER_ID, JOB_APPLICATION);
        Test.stopTest();

        System.assertEquals(1, fieldSets.size());
    }

    @isTest
    static void getFieldSetsExceptionTest() {
        Boolean exceptionOccurred = false;
        Test.startTest();
        try {
            SettingPageController.getFieldSets(FAKE_ID, JOB_APPLICATION);
        } catch(Exception ex) {
            exceptionOccurred = true;
        }
        Test.stopTest();

        System.assert(exceptionOccurred, EXCEPTION_NOT_THROWN);
    }

    @isTest
    static void getFieldsRecruiterTest() {
        Test.startTest();
        List<List<String>> fields = SettingPageController.getFields(RECRUITER_MODAL_FIELD_SET, CANDIDATE, RECRUITER_ID);
        Test.stopTest();
        System.assertEquals(1, fields.size());
    }

    @isTest
    static void getFieldsInterviewerTest() {

        Test.startTest();
        List<List<String>> fields = SettingPageController.getFields(RECRUITER_MODAL_FIELD_SET, CANDIDATE, INTERVIEWER_ID);
        Test.stopTest();

        List<Field_Set_Configuration__mdt> config = SettingPageSelector.getFieldSetMetadata(INTERVIEWER_ID);
        Boolean checkboxValue = config[0].Display_Inaccessible_Records__c;
        if(checkboxValue == true) {
            System.assertEquals(2, fields.size());
        } else {
            System.assertEquals(1, fields.size());
        }
    }

    @isTest
    static void getFieldsExceptionTest() {
        Boolean exceptionOccurred = false;
        Test.startTest();
        try {
            SettingPageController.getFields(FAKE_FIELD_SET, CANDIDATE, RECRUITER_ID);
        } catch(Exception ex) {
            exceptionOccurred = true;
        }
        Test.stopTest();

        System.assert(exceptionOccurred, EXCEPTION_NOT_THROWN);
    }

    @isTest
    static void getAccessRecruiterTest(){

        Test.startTest();
        Boolean value = SettingPageService.getAccess(EMAIL_FIELD, RECRUITER_LABEL, CANDIDATE);
        Test.stopTest();

        System.assertEquals(true, value);
    }

    @isTest
    static void getAccessInterviewerTest(){

        Test.startTest();
        Boolean value = SettingPageService.getAccess(EMAIL_FIELD, INTERVIEWER_LABEL, CANDIDATE);
        Test.stopTest();

        System.assertEquals(false, value);
    }

    @isTest
    static void testDeployment() {
        List<Field_Set_Configuration__mdt> metaList = [SELECT Id, MasterLabel, DeveloperName, Label, Display_Inaccessible_Records__c, Candidate_Modal_Field_Set__c, 
                                                        Candidate_Tile_Field_Set__c, Job_Application_Field_Set__c, Object_Type__c
                                                        FROM Field_Set_Configuration__mdt];
        DeployFieldSetMetadata deploy = new DeployFieldSetMetadata();                                               
        Metadata.DeployContainer container = deploy.constructDeploymentRequest(CHECKBOX_VALUE, metaList);
        List<Metadata.Metadata> contents = container.getMetadata();
        System.assertEquals(1, contents.size());
    }

    
    @isTest
    static void testMyCallback() {
        Metadata.DeployCallback callback = new CreateUpdateMetadataCallBack();
        Metadata.DeployResult result = new Metadata.DeployResult();
        result.numberComponentErrors = 1;
        Metadata.DeployCallbackContext context = new Metadata.DeployCallbackContext();
        callback.handleResult(result, context);
    }
}