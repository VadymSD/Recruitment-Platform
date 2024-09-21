trigger ReviewTrigger on Review__c (after insert, after update, after delete, after undelete) {
    
    ReviewTriggerHandler handler = new ReviewTriggerHandler();

    System.TriggerOperation triggerEvent = Trigger.operationType;

    switch on triggerEvent {
        when AFTER_INSERT {
            handler.afterInsert(Trigger.new, Trigger.newMap);
        }
        when AFTER_UPDATE {
            handler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        when AFTER_DELETE {
            handler.afterDelete(Trigger.old, Trigger.oldMap);
        }
        when AFTER_UNDELETE {
            handler.afterUndelete(Trigger.new, Trigger.newMap);
        }
    }
}   