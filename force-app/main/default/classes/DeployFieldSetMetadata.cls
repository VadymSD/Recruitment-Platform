public with sharing class DeployFieldSetMetadata {
    public Metadata.DeployContainer constructDeploymentRequest(Boolean checkboxValue, List<Field_Set_Configuration__mdt> metaList) {
        Metadata.DeployContainer container = new Metadata.DeployContainer();
        UpdateFieldSetMetadata updateMetadata = new UpdateFieldSetMetadata();
        Metadata.CustomMetadata customMetadata = updateMetadata.updateMetadata(checkboxValue, metaList);
        container.addMetadata(customMetadata);
        return container;
    }

    public void deployMetadata(Metadata.DeployContainer container) {
        CreateUpdateMetadataUtils callback = new CreateUpdateMetadataUtils();
        Id asyncResultId = Metadata.Operations.enqueueDeployment(container, callback);
    }
}