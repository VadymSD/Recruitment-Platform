@isTest
private class ReviewTriggerTest {

    private static final Integer NUM_TEST_APPS = 10;
    private static final Integer NUM_TEST_REVIEWS = 1;

    private static final String STATUS_NEW = 'New';
    private static final String REVIEW_TYPE_INTERVIEW = 'Interview';


    private static Job_Application__c createJobApplication() {
        return new Job_Application__c(
            Status__c = STATUS_NEW,
            Candidate__c = System.Label.CandidateId,
            Position__c = System.Label.PositionId,
            Link_To_Application__c = 'asd.com'
        );
    }

    private static Review__c createReview(Id jobAppId, Integer rating) {
        return new Review__c(
            Status__c = STATUS_NEW,
            Type__c = REVIEW_TYPE_INTERVIEW,
            Rating__c = rating,
            Job_Application__c = jobAppId
        );
    }

    @testSetup
    static void setupTestData() {
        List<Job_Application__c> jobApps = new List<Job_Application__c>();
        for (Integer i = 1; i <= NUM_TEST_APPS; i++) {
            jobApps.add(createJobApplication());
        }
        insert jobApps;
         
        List<Review__c> reviews = new List<Review__c>();
        Integer customRating = 10;
        for (Job_Application__c jobApp : jobApps) {
            for (Integer i = 1; i <= NUM_TEST_REVIEWS; i++) {
                reviews.add(createReview(jobApp.Id, customRating));
            }
        }
        insert reviews;
    }

    @isTest
    static void testAfterInsert() {
        List<Job_Application__c> jobApps = [SELECT Id, Avarage_Rating__c, Review_Count__c FROM Job_Application__c];
        List<Review__c> reviews = new List<Review__c>();
        Integer customRating = 20;
        for (Job_Application__c jobApp : jobApps) {
            for (Integer i = 1; i <= NUM_TEST_REVIEWS; i++) {
                reviews.add(createReview(jobApp.Id, customRating));
            }
        }
        
        Test.startTest();
        insert reviews;
        Test.stopTest();
    
        jobApps = [SELECT Id, Avarage_Rating__c, Review_Count__c FROM Job_Application__c WHERE Id IN :jobApps];
        for (Job_Application__c jobApp : jobApps) {
            System.assertEquals(NUM_TEST_REVIEWS * 2, jobApp.Review_Count__c);
            System.assertEquals(15, jobApp.Avarage_Rating__c);
        }
    }

    @isTest
    static void testAfterJobApplicationFieldUpdate(){
        List<Job_Application__c> jobApps = [SELECT Id, Avarage_Rating__c, Review_Count__c FROM Job_Application__c];
        List<Review__c> reviews = [SELECT Id FROM Review__c WHERE Job_Application__c IN :jobApps];

        Job_Application__c newJobApp = createJobApplication();
        insert newJobApp;

        List<Review__c> reviewsToUpdate = new List<Review__c>();
        for(Review__c review : reviews) {
            review.Job_Application__c = newJobApp.Id;
            reviewsToUpdate.add(review);
        }

        Test.startTest();
        update reviewsToUpdate;
        Test.stopTest();

        jobApps = [SELECT Id, Avarage_Rating__c, Review_Count__c FROM Job_Application__c WHERE Id IN :jobApps];
        for (Job_Application__c jobApp : jobApps) {
            System.assertEquals(0, jobApp.Review_Count__c);
            System.assertEquals(0, jobApp.Avarage_Rating__c);
        }
    }

    @isTest 
    static void testAfterReviewRatingUpdate(){
        List<Job_Application__c> jobApps = [SELECT Id, Avarage_Rating__c, Review_Count__c FROM Job_Application__c];
        List<Review__c> reviews = [SELECT Id FROM Review__c WHERE Job_Application__c IN :jobApps];

        List<Review__c> reviewsToUpdate = new List<Review__c>();
        Integer updatedRating = 20;
        for (Review__c review : reviews) {
            review.Rating__c = updatedRating;
            reviewsToUpdate.add(review);
        }

        Test.startTest();
        update reviewsToUpdate;
        Test.stopTest();

        jobApps = [SELECT Id, Avarage_Rating__c, Review_Count__c FROM Job_Application__c WHERE Id IN :jobApps];
        for (Job_Application__c jobApp : jobApps) {
            System.assertEquals(NUM_TEST_REVIEWS, jobApp.Review_Count__c);
            System.assertEquals(20, jobApp.Avarage_Rating__c);
        }
    }

    @isTest
    static void testAfterDelete() {
        List<Job_Application__c> jobApps = [SELECT Id, Avarage_Rating__c, Review_Count__c FROM Job_Application__c];
        
        Test.startTest();
        List<Review__c> reviewsToDelete = [SELECT Id FROM Review__c WHERE Job_Application__c IN :jobApps];
        delete reviewsToDelete;
        Test.stopTest();

        jobApps = [SELECT Id, Avarage_Rating__c, Review_Count__c FROM Job_Application__c WHERE Id IN :jobApps];
        for (Job_Application__c jobApp : jobApps) {
            System.assertEquals(0, jobApp.Review_Count__c);
            System.assertEquals(0, jobApp.Avarage_Rating__c);
        }
    }

    @isTest
    static void testAfterUndelete() {
        List<Job_Application__c> jobApps = [SELECT Id, Avarage_Rating__c, Review_Count__c FROM Job_Application__c];
        
        List<Review__c> reviewsToDelete = [SELECT Id FROM Review__c WHERE Job_Application__c IN :jobApps];
        delete reviewsToDelete;

        Test.startTest();
        undelete reviewsToDelete;
        Test.stopTest();

        jobApps = [SELECT Id, Avarage_Rating__c, Review_Count__c FROM Job_Application__c WHERE Id IN :jobApps];
        for (Job_Application__c jobApp : jobApps) {
            System.assertEquals(NUM_TEST_REVIEWS, jobApp.Review_Count__c);
            System.assertEquals(10, jobApp.Avarage_Rating__c);
        }
    }
}
