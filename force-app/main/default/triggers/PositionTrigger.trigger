trigger PositionTrigger on Position__c (before update) {
    PositionTriggerHandler handler = new PositionTriggerHandler();

    System.TriggerOperation triggerEvent = Trigger.operationType;

    switch on triggerEvent {
        when BEFORE_UPDATE {
            handler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
