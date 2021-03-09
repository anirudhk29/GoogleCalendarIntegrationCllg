global class GoogleCalendarSchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        GetCalendarEvents e = new GetCalendarEvents();
        Id batchId = Database.executeBatch(e);
        AsyncApexJob job = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID = :batchId ];
        System.debug(job);
    }
    
}