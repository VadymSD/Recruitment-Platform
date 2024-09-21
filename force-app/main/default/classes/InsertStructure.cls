public with sharing class InsertStructure implements EndpointDTO {
    public InsertRequest data {get; set;}
    
    public String getRecordId(){
        String recordId;
        if (data != null) {
            recordId = data.jobAppId;
        }
        return recordId;
    }
}