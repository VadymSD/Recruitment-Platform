public with sharing class UpdateStructure implements EndpointDTO {
    public UpdateRequest data {get; set;}
    
    public String getRecordId(){
        String recordId;
        if (data != null) {
            recordId = data.jobAppId;
        }
        return recordId;
    }
}