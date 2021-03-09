global class GetCalendarEvents implements Database.Batchable<sObject>,Database.AllowsCallouts {
    global Database.QueryLocator start(Database.BatchableContext context) {
        DateTime getTime = DateTime.now();
        getTime = getTime.addDays(-1);
        DateTime getTimeUpdate = getTime.addMinutes(1);
        String fail = 'Failed';
        return Database.getQueryLocator(
            'SELECT Id,StartDateTime,EndDateTime,Subject,Description,CreatedDate,LastModifiedDate,Google_Id__c From Event WHERE CreatedDate >= :getTime OR LastModifiedDate >= :getTimeUpdate OR Google_Id__c = :fail  '
        );
    }
    global void execute(Database.BatchableContext context, List<Event> events) {
        try{
            for(Event e : events) {
                String googleId;
                if(e.CreatedDate > DateTime.now().addDays(-1) && e.Google_Id__c == null ) {
                    googleId = GoogleCalendarService.createEvent(e.StartDateTime,e.EndDateTime,e.Subject,e.Description);
                    e.Google_Id__c = googleId;
                }
                else{
                    googleId = GoogleCalendarService.updateEvent(e.StartDateTime,e.EndDateTime,e.Subject,e.Description,e.Google_Id__c);
                    if(googleId == 'Failed') {
                        String temp = e.Google_Id__c;
                        e.Google_Id__c = 'Failed';
                        e.Google_Id__c = temp;
                    }
                }
            }
            update events;
        }
        catch(Exception exp) {
            System.debug('An error has occured : '+ exp.getMessage());
        }
        
    }
    global void finish(Database.BatchableContext context) {
    }
    
}