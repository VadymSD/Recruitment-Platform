({
    handleInit : function(component, event, helper) {
        component.find('candidateButtonOverride').connectedCallback();
    }, 
    
    navigateToRecord: function(component, event, helper) {
        var recordId = event.getParam("recordId");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": "detail"
        });
        navEvt.fire();
    }
});
