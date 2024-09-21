public with sharing class ReviewTriggerHandler {
    
    private ReviewTriggerHelper helper;

    public ReviewTriggerHandler() {
        this.helper = new ReviewTriggerHelper();
    }

    public void afterInsert(List<Review__c> newRecords, Map<Id, Review__c> newRecordMap) {
        processReviewTrigger(newRecords, null);
    }
    public void afterUpdate(List<Review__c> newRecords, Map<Id, Review__c> oldRecordMap) {
        processReviewTrigger(newRecords, oldRecordMap);
        processReviewRatingUpdateTrigger(newRecords, oldRecordMap);
    }

    public void afterDelete(List<Review__c> oldRecords, Map<Id, Review__c> oldRecordMap) {
        processReviewTrigger(oldRecords, null);
    }

    public void afterUndelete(List<Review__c> newRecords, Map<Id, Review__c> newRecordMap) {
        processReviewTrigger(newRecords, null);
    }

    private void processReviewTrigger(List<Review__c> records, Map<Id, Review__c> newRecordMap) {
        Set<Id> jobApplicationIds = helper.processReviews(records, newRecordMap);
        calculateReviewsAndUpdateJobApplications(jobApplicationIds);
    }

    private void processReviewRatingUpdateTrigger(List<Review__c> records, Map<Id, Review__c> recordMap) {
        Set<Id> jobApplicationIds = helper.processReviewRatingUpdate(records, recordMap);
        calculateReviewsAndUpdateJobApplications(jobApplicationIds);
    }

    private void calculateReviewsAndUpdateJobApplications(Set<Id> jobApplicationIds){
        Map<Id, Integer> reviewCount = helper.calculateReviewCount(jobApplicationIds);
        Map<Id, Decimal> reviewRating = helper.calculateReviewRating(jobApplicationIds);
        helper.updateJobApplications(jobApplicationIds, reviewCount, reviewRating);
    }
}
