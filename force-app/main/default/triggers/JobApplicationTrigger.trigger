trigger JobApplicationTrigger on Job_Application__c (after update) {

    JobApplicationTriggerHandler handler = new JobApplicationTriggerHandler();

    System.TriggerOperation triggerEvent = Trigger.operationType;

    switch on triggerEvent {

        when AFTER_UPDATE {
            handler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
