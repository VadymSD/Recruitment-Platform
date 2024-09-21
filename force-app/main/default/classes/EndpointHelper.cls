public with sharing class EndpointHelper {

    public static void getJobApplication(String objectId) {
        Job_Application__c jobApp = EndPointSelector.getJobApplication(objectId);
        RestContext.response.responseBody = Blob.valueOf('{ "message" : "Returned Job Application ' + jobApp.Id 
                                                             + ', Name: ' + jobApp.Name + 
                                                             + ', Position: ' + jobApp.Position__c + 
                                                             + ', Candidate: ' + jobApp.Candidate__c +'"}');
    }

    public static void deleteJobApplication(String objectId) {
        Job_Application__c jobApp = EndPointSelector.getJobApplication(objectId);
        if(Schema.sObjectType.Job_Application__c.isDeletable()){
            delete jobApp;
        }
        RestContext.response.responseBody = Blob.valueOf('{ "message" : "Deleted Job Application ' + jobApp.Id 
                                                             + ', Name: ' + jobApp.Name + 
                                                             + ', Position: ' + jobApp.Position__c + 
                                                             + ', Candidate: ' + jobApp.Candidate__c +'"}');
    }

    public static void insertJobApplication(InsertStructure body) {
        
        Job_Application__c jobApp = new Job_Application__c();
        jobApp.Id = body.data.jobAppId;
        jobApp.Candidate__c = body.data.candidate;
        jobApp.Position__c = body.data.position;
        jobApp.Application_Date__c = Date.valueOf(body.data.applicationDate);
        jobApp.Status__c = body.data.status;
        jobApp.Link_To_Application__c = body.data.linkToApplication;
        jobApp.Cover_Letter__c = body.data.coverLetter;
        if(Schema.sObjectType.Job_Application__c.isCreateable() && Schema.sObjectType.Job_Application__c.isUpdateable()){
            upsert jobApp;
        }

        RestContext.response.responseBody = Blob.valueOf('{ "message" : "Created Job Application. Id: ' + jobApp.Id 
                                                                    + ', Position: ' + jobApp.Position__c + 
                                                                    + ', Candidate: ' + jobApp.Candidate__c +
                                                                    + ', Status: ' + jobApp.Status__c +
                                                                    + ', Cover Letter: ' + jobApp.Cover_Letter__c +
                                                                    + ', Link to Application: ' + jobApp.Link_To_Application__c +'"}');   
    }

    public static void updateJobApplication(UpdateStructure body) {
        
        Job_Application__c jobApp = new Job_Application__c();
        jobApp.Id = body.data.jobAppId;
        jobApp.Application_Date__c = Date.valueOf(body.data.applicationDate);
        jobApp.Status__c = body.data.status;
        jobApp.Link_To_Application__c = body.data.linkToApplication;
        jobApp.Cover_Letter__c = body.data.coverLetter;
        if(Schema.sObjectType.Job_Application__c.isUpdateable()){
            update jobApp;
        }

        jobApp = EndPointSelector.getJobApplication(jobApp.Id);

        if (body.data.jobAppId != '' || body.data.jobAppId != null) {
            RestContext.response.responseBody = Blob.valueOf('{ "message" : "Updated Job Application. Id: ' + jobApp.Id 
                                                                    + ', Position: ' + jobApp.Position__c + 
                                                                    + ', Candidate: ' + jobApp.Candidate__c +
                                                                    + ', Status: ' + jobApp.Status__c +
                                                                    + ', Cover Letter: ' + jobApp.Cover_Letter__c +
                                                                    + ', Link to Application: ' + jobApp.Link_To_Application__c +'"}');   
        }
    }
}