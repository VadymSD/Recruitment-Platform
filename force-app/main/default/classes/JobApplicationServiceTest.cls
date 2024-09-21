@isTest
public with sharing class JobApplicationServiceTest {

    @isTest
    static void testGetJobApplication() {
        Job_Application__c jobApp = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.response = response;
        request.requestURI = '/services/apexrest/endpoint/' + jobApp.Id;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Test.startTest();
        JobApplicationService.getJobApplication();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode);
    }  

    @isTest 
    static void testDeleteJobApplication() {
        Job_Application__c jobApp = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.response = response;
        request.requestURI = '/services/apexrest/endpoint/' + jobApp.Id;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        
        // Call the method to test
        Test.startTest();
        JobApplicationService.deleteJobApplication();
        Test.stopTest();
        // Verify record is deleted
        List<Job_Application__c> jobApps = [SELECT Id FROM Job_Application__c WHERE Id = :jobApp.Id];
        System.assert(jobApps.size() == 0);
    }

    @isTest
    static void testGetJobApplicationError() {
        String ivalidId = 'invalidId';
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.response = response;
        request.requestURI = '/services/apexrest/endpoint/' + ivalidId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        Test.startTest();
        JobApplicationService.getJobApplication();
        Test.stopTest();

        System.assertEquals(500, RestContext.response.statusCode);
    } 

    @isTest 
    static void testDeleteJobApplicationError() {
        String ivalidId = 'invalidId';
        // Set up a test request
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.response = response;
        request.requestURI = '/services/apexrest/endpoint/' + ivalidId;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        
        // Call the method to test
        Test.startTest();
        JobApplicationService.deleteJobApplication();
        Test.stopTest();

        System.assertEquals(500, RestContext.response.statusCode);
    }

    @isTest
    static void testManipulateWithDataInsert() {
        // Create a mock request body
        InsertRequest mockRequestBody = new InsertRequest();
        mockRequestBody.candidate = System.Label.CandidateId;
        mockRequestBody.position = System.Label.PositionId;
        mockRequestBody.applicationDate = '2023-10-06';
        mockRequestBody.status = 'New';
        mockRequestBody.linkToApplication = 'https://example.com/application';
        mockRequestBody.coverLetter = 'Sample cover letter';

        CreateTestStructure mockInsertStructure = new CreateTestStructure();
        mockInsertStructure.name = 'create';
        mockInsertStructure.data = mockRequestBody;

        // Set up the RestContext
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf(JSON.serialize(mockInsertStructure));
        req.requestURI = '/services/apexrest/endpoint';
        req.httpMethod = 'POST';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
        JobApplicationService.maniputaleWithData();
        Test.stopTest();

        String responseBody = res.responseBody.toString();
        
        System.assertEquals(true, responseBody.contains('Created Job Application. Id:'));
    }

    @isTest
    static void testManipulateWithDataUpdate() {
        // Create a mock request body
        UpdateRequest mockRequestBody = new UpdateRequest();
        mockRequestBody.jobAppId = System.Label.JobApplicationTestId;
        mockRequestBody.status = 'Interviewing';
        mockRequestBody.applicationDate = '2023-10-05';
        mockRequestBody.linkToApplication = 'https://example.com/application';
        mockRequestBody.coverLetter = 'Sample cover letter';

        UpdateTestStructure mockUpdateStructure = new UpdateTestStructure();
        mockUpdateStructure.name = 'update';
        mockUpdateStructure.data = mockRequestBody;

        // Set up the RestContext
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf(JSON.serialize(mockUpdateStructure));
        System.debug(req.requestBody.toString());
        req.requestURI = '/services/apexrest/endpoint';
        req.httpMethod = 'POST';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
        JobApplicationService.maniputaleWithData();
        Test.stopTest();

        String responseBody = res.responseBody.toString();
        
        System.assertEquals(true, responseBody.contains('Updated Job Application. Id:'));
    }

    @isTest
    static void testManipulateWithDataError() {
        // Create a mock request body
        UpdateRequest mockRequestBody = new UpdateRequest();
        mockRequestBody.jobAppId = System.Label.JobApplicationTestId;
        mockRequestBody.status = 'Interviewing';

        UpdateTestStructure mockUpdateStructure = new UpdateTestStructure();
        mockUpdateStructure.name = 'update';
        mockUpdateStructure.data = mockRequestBody;

        // Set up the RestContext
        RestRequest req = new RestRequest();
        String invalidJSON = 'invalid JSON';
        req.requestBody = Blob.valueOf(invalidJSON + JSON.serialize(mockUpdateStructure));
        System.debug(req.requestBody.toString());
        req.requestURI = '/services/apexrest/endpoint';
        req.httpMethod = 'POST';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
        JobApplicationService.maniputaleWithData();
        Test.stopTest();

        System.assertEquals(500, RestContext.response.statusCode);
    }

    @isTest
    static void testGetRecordIdInsert() {
        InsertRequest mockRequestBody = new InsertRequest();
        mockRequestBody.jobAppId = System.Label.JobApplicationTestId;

        InsertStructure mockInsertStructure = new InsertStructure();
        mockInsertStructure.data = mockRequestBody;

        Test.startTest();
        String recordId = mockInsertStructure.getRecordId();
        Test.stopTest();

        System.assertEquals(System.Label.JobApplicationTestId, recordId);
    }

    @isTest
    static void testGetRecordIdUpdate() {
        UpdateRequest mockRequestBody = new UpdateRequest();
        mockRequestBody.jobAppId = System.Label.JobApplicationTestId;

        UpdateStructure mockUpdateStructure = new UpdateStructure();
        mockUpdateStructure.data = mockRequestBody;
        
        Test.startTest();
        String recordId = mockUpdateStructure.getRecordId();
        Test.stopTest();

        System.assertEquals(System.Label.JobApplicationTestId, recordId);
    }

    static Job_Application__c createTestRecord() {
        // Create test record
        Job_Application__c jobApp = new Job_Application__c();
        jobApp.Candidate__c = System.Label.CandidateId;
        jobApp.Position__c = System.Label.PositionId;
        jobApp.Status__c = 'New';
        jobApp.Application_Date__c = Date.today();
        jobApp.Link_To_Application__c = 'asdas.com';
        jobApp.Cover_Letter__c = 'asdasdasdsad';
        insert jobApp;
        return jobApp;
    }     
    
    private class UpdateTestStructure {
        private String name {get; set;}
        private UpdateRequest data {get; set;}
    }

    private class CreateTestStructure {
        private String name {get; set;}
        private InsertRequest data {get; set;}
    }
}