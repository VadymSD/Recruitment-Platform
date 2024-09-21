public with sharing class ReviewTriggerHelper {
    public Set<Id> processReviews(List<Review__c> reviews, Map<Id, Review__c> oldReviewsMap) {
        Set<Id> jobApplicationIds = new Set<Id>();
        for (Review__c review : reviews) {
            if (oldReviewsMap == null) {
                if (review.Job_Application__c != null) {
                    jobApplicationIds.add(review.Job_Application__c);
                }
            } else {
                if (review.Job_Application__c != oldReviewsMap.get(review.Id).Job_Application__c) {
                    if (oldReviewsMap.get(review.Id).Job_Application__c != null) {
                        jobApplicationIds.add(oldReviewsMap.get(review.Id).Job_Application__c);
                    }
                    if (review.Job_Application__c != null) {
                        jobApplicationIds.add(review.Job_Application__c);
                    }
                }
            }
        }
        return jobApplicationIds;
    }

    public Set<Id> processReviewRatingUpdate(List<Review__c> newReviews, Map<Id, Review__c> oldReviewsMap) {
        Set<Id> jobApplicationIds = new Set<Id>();
        for (Review__c review : newReviews) {
            if (review.Rating__c != oldReviewsMap.get(review.Id).Rating__c && oldReviewsMap.get(review.Id).Rating__c != null) {
                if (oldReviewsMap.get(review.Id).Job_Application__c != null) {
                    jobApplicationIds.add(oldReviewsMap.get(review.Id).Job_Application__c);
                }
                if (review.Job_Application__c != null) {
                    jobApplicationIds.add(review.Job_Application__c);
                }
            }
        }
        return jobApplicationIds;
    }
    
    public Map<Id, Integer> calculateReviewCount(Set<Id> jobApplicationIds) {
        Map<Id, Integer> reviewCount = new Map<Id, Integer>();
        for (AggregateResult ar : [SELECT Job_Application__c, COUNT(Id) reviewCount
                                    FROM Review__c
                                    WHERE Job_Application__c IN :jobApplicationIds
                                    WITH SECURITY_ENFORCED
                                    GROUP BY Job_Application__c]) {
            reviewCount.put((Id) ar.get('Job_Application__c'), (Integer) ar.get('reviewCount'));
        }
        return reviewCount;
    }

    public Map<Id, Decimal> calculateReviewRating(Set<Id> jobApplicationIds) {
        Map<Id, Decimal> reviewRating = new Map<Id, Decimal>();
        for (AggregateResult ar : [SELECT Job_Application__c, AVG(Rating__c) avgRating
                                    FROM Review__c
                                    WHERE Job_Application__c IN :jobApplicationIds
                                    WITH SECURITY_ENFORCED
                                    GROUP BY Job_Application__c]) {
            reviewRating.put((Id) ar.get('Job_Application__c'), (Decimal) ar.get('avgRating'));
        }
        return reviewRating;
    }

    public void updateJobApplications(Set<Id> jobApplicationIds, Map<Id, Integer> reviewCount, Map<Id, Decimal> reviewRating) {
        List<Job_Application__c> jobApplicationsToUpdate = new List<Job_Application__c>();
        for (Job_Application__c jobApp : [SELECT Id, Review_Count__c
                                            FROM Job_Application__c
                                            WHERE Id IN :jobApplicationIds
                                            WITH SECURITY_ENFORCED
        ]) {
            jobApp.Review_Count__c = reviewCount.containsKey(jobApp.Id) ? reviewCount.get(jobApp.Id) : 0;
            jobApp.Avarage_Rating__c = reviewRating.containsKey(jobApp.Id) ? reviewRating.get(jobApp.Id) : 0;
            jobApplicationsToUpdate.add(jobApp);
        }
        if (!jobApplicationsToUpdate.isEmpty()) {
            if (Schema.sObjectType.Job_Application__c.isUpdateable() && Schema.sObjectType.Job_Application__c.fields.Review_Count__c.isUpdateable()) {
                update jobApplicationsToUpdate;
            }
        }
    }
}