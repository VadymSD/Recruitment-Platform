public with sharing class UpdateOldPositionsScheduler implements Schedulable {
    public void execute(SchedulableContext context) {
        UpdateOldPositionsBatch batchJob = new UpdateOldPositionsBatch();
        Database.executeBatch(batchJob);
    }
}
