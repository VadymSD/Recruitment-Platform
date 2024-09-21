public with sharing class CandidateRelatedListService {
    public class NoCandidatesFoundException extends Exception {}
    public class FieldSetsNotFoundException extends Exception {}

    public static List<Candidate__c> getCandidates(String positionId, Integer limitNumber) {
        String profileOrPermissionSetName = ProfileMetadataService.getUserProfileOrPermissionSet();
        String candidateFieldSet = '';
        String jobAppFieldSet = '';
    
        try {
            List<String> twoFieldSets = getProfileFieldSets(profileOrPermissionSetName, null);
            if(twoFieldSets.size() >= 2){
                candidateFieldSet = twoFieldSets[0];
                jobAppFieldSet = twoFieldSets[1];
            } else {
                throw new FieldSetsNotFoundException(System.Label.FieldSetsRetrievalError);
            }
    
            List<Candidate__c> candidates = CandidateRelatedListSelector.getCandidates(positionId, candidateFieldSet, jobAppFieldSet, limitNumber);
    
            if(candidates.isEmpty()){
                throw new NoCandidatesFoundException(System.Label.CandidateQueryError);
            }
    
            return candidates;
        } catch (Exception e) {
            throw e;
        }
    }

    public static List<String> getProfileFieldSets(String userProfileName, String fieldSetType) {
        List<String> fieldSetMapping = new List<String>();
    
        try {
            List<Field_Set_Configuration__mdt> metadataRecords = CandidateRelatedListSelector.getMetadataRecord(userProfileName);
            Field_Set_Configuration__mdt metadataRecord = new Field_Set_Configuration__mdt();
            if (!metadataRecords.isEmpty()) {
                metadataRecord = metadataRecords[0];
            }
    
            if (fieldSetType != null) { 
                if (fieldSetType == 'Candidate_Modal_Field_Set__c') {
                    fieldSetMapping.add(metadataRecord.Candidate_Modal_Field_Set__c);
                } else if (fieldSetType == 'Candidate_Tile_Field_Set__c') {
                    fieldSetMapping.add(metadataRecord.Candidate_Tile_Field_Set__c);
                } else if (fieldSetType == 'Job_Application_Field_Set__c') {
                    fieldSetMapping.add(metadataRecord.Job_Application_Field_Set__c);
                }
            } else {
                fieldSetMapping.add(metadataRecord.Candidate_Modal_Field_Set__c);
                fieldSetMapping.add(metadataRecord.Job_Application_Field_Set__c);
            }
        } catch (Exception e) {
            throw e;
        }
    
        return fieldSetMapping; 
    }
    

    public static String getFields(String fieldSetType, SObject record) {
        String fieldSet = '';
        String profileOrPermissionSetName = ProfileMetadataService.getUserProfileOrPermissionSet();
        try {
            List<String> fieldSets = getProfileFieldSets(profileOrPermissionSetName, fieldSetType);
            if (!fieldSets.isEmpty()) {
                fieldSet = fieldSets[0];
            }
        } catch (Exception e) {
            throw e;
        }
        return getFieldsSetUp(fieldSet, record);
    }
    
    public static String getFieldsSetUp(String fieldSetName, SObject record) {
        List<FieldWrapper> fieldList = new List<FieldWrapper>();

        try {
            for (Schema.FieldSetMember f : record.getSObjectType().getDescribe().fieldSets.getMap().get(fieldSetName).getFields()) {
                FieldWrapper fieldWrapper = new FieldWrapper(
                    f.getDBRequired() || f.getRequired(),
                    f.getType(),
                    f.getLabel(),
                    f.getFieldPath(),
                    String.valueOf(record.get(f.getFieldPath()))
                );
                fieldList.add(fieldWrapper);
            }
        } catch(Exception ex) {
            throw ex;
        }
        String jsonList = JSON.serialize(fieldList);
        return jsonList;
    }    

    public class FieldWrapper {
        public Boolean required;
        public Schema.DisplayType type;
        public String label;
        public String name;
        public String value;

        public FieldWrapper(Boolean required, Schema.DisplayType type, String label, String name, String value) {
            this.required = required;
            this.type = type;
            this.label = label;
            this.name = name;
            this.value = value;
        }
    }
} 