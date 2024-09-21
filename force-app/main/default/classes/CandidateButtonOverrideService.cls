public with sharing class CandidateButtonOverrideService {

    public static final String CANDIDATE_API_NAME = 'Candidate__c';
    public static final String JOB_APPLICATION_API_NAME = 'Job_Application__c';

    public static final String CANDIDATE_LABEL = 'Candidate';
    public static final String JOB_APPLICATION_LABEL = 'Job_Application';

    public static String getFields(String sObjectName) {
        String objectName = '';

        if (sObjectName == CANDIDATE_API_NAME) {
            objectName = CANDIDATE_LABEL;
        } else if (sObjectName == JOB_APPLICATION_API_NAME) {
            objectName = JOB_APPLICATION_LABEL;
        }        
        
        String fieldSetName = getFieldSetName(objectName);
        return getFieldsSetUp(fieldSetName, sObjectName);
    }

    public static String getFieldsSetUp(String fieldSetName, String sObjectName) {
        List<FieldWrapper> fieldList = new List<FieldWrapper>();

        try {
            for (Schema.FieldSetMember f : Schema.getGlobalDescribe().get(sObjectName).getDescribe().fieldSets.getMap().get(fieldSetName).getFields()) {
                FieldWrapper fieldWrapper = new FieldWrapper(
                    f.getDBRequired() || f.getRequired(),
                    f.getType(),
                    f.getLabel(),
                    f.getFieldPath()
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

        public FieldWrapper(Boolean required, Schema.DisplayType type, String label, String name) {
            this.required = required;
            this.type = type;
            this.label = label;
            this.name = name;
        }
    }

    private static String getFieldSetName(String sObjectName) {
        Override_FieldSet_Setting__mdt config = CandidateButtonOverrideSelector.getFieldSetName(sObjectName)[0];
        String fieldSet = config.Field_Set_Name__c;
        return fieldSet;
    }
}