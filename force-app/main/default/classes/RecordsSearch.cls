public with sharing class RecordsSearch {
    final static String SEARCH_WORD = 'develop';
    final static String EXCEPTION_TEXT = System.label.RecordSearchError;
    // Retrieve all objects which contain 'develop' created more than a week ago
    public List<List<SObject>> getRecordsWithDevelop() {
        try {
        return [FIND :SEARCH_WORD IN ALL FIELDS
                    RETURNING Position__c(Name WHERE CreatedDate < LAST_WEEK), 
                                Candidate__c(Name WHERE CreatedDate < LAST_WEEK), 
                                Review__c(Name WHERE CreatedDate < LAST_WEEK)];
        } catch(SearchException ex){
            throw new RecordsSearchException(EXCEPTION_TEXT + ex.getMessage());
        }
    }

    public class RecordsSearchException extends Exception{}
}