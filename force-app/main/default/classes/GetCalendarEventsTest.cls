@isTest
public class GetCalendarEventsTest {
    @isTest
    public static void testPostBulkCalloutWithDesc() {
        Test.setMock(HttpCalloutMock.class, new CalendarCalloutTest());
        List<Event> testEvents = new List<Event>();
        for(Integer i=0;i<20;i++) {
            testEvents.add(new Event(StartDateTime = DateTime.now().addMinutes(i),
                                     EndDateTime = DateTime.now().addMinutes(i+20), Subject = 'Test Event',Description = 'This is a Test'));   
        }
        Database.SaveResult[] insertResult = Database.insert(testEvents,false);
        List<Event> insertQueryResult = [ SELECT StartDateTime,EndDateTime,Subject FROM Event ];
        for(Event e : insertQueryResult) {
            System.assertEquals('Test Event', e.Subject);
        }
        Test.startTest();
        GetCalendarEvents eventsForTest = new GetCalendarEvents();
        Id batchId = Database.executeBatch(eventsForTest);
        Test.stopTest();
        insertQueryResult = [ SELECT StartDateTime,EndDateTime,Subject,Google_Id__c FROM Event ];
        for(Event e : insertQueryResult) {
            System.assertEquals('dkcr7mhl94mfja7ekvgp1cp5fp', e.Google_Id__c);
        }
    }
    @isTest
    public static void testPostBulkCalloutWithoutDesc() {
        Test.setMock(HttpCalloutMock.class, new CalendarCalloutTest());
        List<Event> testEvents = new List<Event>();
        for(Integer i=0;i<20;i++) {
            testEvents.add(new Event(StartDateTime = DateTime.now().addMinutes(i),
                                     EndDateTime = DateTime.now().addMinutes(i+20), Subject = 'Test Event'));   
        }
        Database.SaveResult[] insertResult = Database.insert(testEvents,false);
        List<Event> insertQueryResult = [ SELECT StartDateTime,EndDateTime,Subject FROM Event ];
        for(Event e : insertQueryResult) {
            System.assertEquals('Test Event', e.Subject);
        }
        Test.startTest();
        GetCalendarEvents eventsForTest = new GetCalendarEvents();
        Id batchId = Database.executeBatch(eventsForTest);
        Test.stopTest();
        insertQueryResult = [ SELECT StartDateTime,EndDateTime,Subject,Google_Id__c FROM Event ];
        for(Event e : insertQueryResult) {
            System.assertEquals('dkcr7mhl94mfja7ekvgp1cp5fp', e.Google_Id__c);
        }
    }
    @isTest
    public static void testPostBulkCalloutUpdate(){
        Test.setMock(HttpCalloutMock.class, new CalendarCalloutTest());
        List<Event> testEvents = new List<Event>();
        for(Integer i=0;i<20;i++) {
            testEvents.add(new Event(StartDateTime = DateTime.now().addMinutes(i),
                                     EndDateTime = DateTime.now().addMinutes(i+20), Subject = 'Test Event',
                                     Google_Id__c = 'dkcr7mhl94mfja7ekvgp1cp5fp'));   
        }
        Database.SaveResult[] insertResult = Database.insert(testEvents,false);
        List<Event> insertQueryResult = [ SELECT StartDateTime,EndDateTime,Subject,Google_Id__c FROM Event ];
        for(Event e : insertQueryResult) {
            System.assertEquals('Test Event', e.Subject);
            System.assertEquals('dkcr7mhl94mfja7ekvgp1cp5fp', e.Google_Id__c);
        }
        for(Event e : insertQueryResult) {
            e.Subject = 'Test Event Update';
        }
        update insertQueryResult;
        Test.startTest();
        GetCalendarEvents eventsForTest = new GetCalendarEvents();
        Id batchId = Database.executeBatch(eventsForTest);
        Test.stopTest();
        List<Event> updateQuery = [ SELECT StartDateTime,EndDateTime,Subject,Google_Id__c FROM Event ];
        for(Event e :  updateQuery) {
            System.assertEquals('Test Event Update', e.Subject);
            System.assertEquals('dkcr7mhl94mfja7ekvgp1cp5fp' , e.Google_Id__c);
        }
        
    }
    @isTest
    public static void testPostBulkCalloutWithDescFail(){
        Test.setMock(HttpCalloutMock.class, new CalendarCalloutTestFail());
        List<Event> testEvents = new List<Event>();
        for(Integer i=0;i<20;i++) {
            testEvents.add(new Event(StartDateTime = DateTime.now().addMinutes(i),
                                     EndDateTime = DateTime.now().addMinutes(i+20), Subject = 'Test Event',Description = 'This is a Test'));   
        }
        Database.SaveResult[] insertResult = Database.insert(testEvents,false);
        List<Event> insertQueryResult = [ SELECT StartDateTime,EndDateTime,Subject FROM Event ];
        for(Event e : insertQueryResult) {
            System.assertEquals('Test Event', e.Subject);
        }
        Test.startTest();
        GetCalendarEvents eventsForTest = new GetCalendarEvents();
        Id batchId = Database.executeBatch(eventsForTest);
        Test.stopTest();
        insertQueryResult = [ SELECT StartDateTime,EndDateTime,Subject,Google_Id__c FROM Event ];
        for(Event e : insertQueryResult) {
            System.assertEquals('Failed', e.Google_Id__c);
        }
    }
    @isTest
    public static void testPostBulkCalloutWithoutDescFailUpdate(){
        Test.setMock(HttpCalloutMock.class, new CalendarCalloutTestFail());
        List<Event> testEvents = new List<Event>();
        for(Integer i=0;i<20;i++) {
            testEvents.add(new Event(StartDateTime = DateTime.now().addMinutes(i),
                                     EndDateTime = DateTime.now().addMinutes(i+20), Subject = 'Test Event',
                                     Google_Id__c = 'dkcr7mhl94mfja7ekvgp1cp5fp'));   
        }
        Database.SaveResult[] insertResult = Database.insert(testEvents,false);
        List<Event> insertQueryResult = [ SELECT StartDateTime,EndDateTime,Subject FROM Event ];
        for(Event e : insertQueryResult) {
            System.assertEquals('Test Event', e.Subject);
        }
        Test.startTest();
        GetCalendarEvents eventsForTest = new GetCalendarEvents();
        Id batchId = Database.executeBatch(eventsForTest);
        Test.stopTest();
        insertQueryResult = [ SELECT StartDateTime,EndDateTime,Subject,Google_Id__c FROM Event ];
        for(Event e : insertQueryResult) {
            System.assertEquals('dkcr7mhl94mfja7ekvgp1cp5fp', e.Google_Id__c);
        }
    }
    @isTest
    public static void testPostBulkCalloutUpdateFail(){
        Test.setMock(HttpCalloutMock.class, new CalendarCalloutTestFail());
        List<Event> testEvents = new List<Event>();
        for(Integer i=0;i<20;i++) {
            testEvents.add(new Event(StartDateTime = DateTime.now().addMinutes(i),
                                     EndDateTime = DateTime.now().addMinutes(i+20), Subject = 'Test Event',
                                     Google_Id__c = 'dkcr7mhl94mfja7ekvgp1cp5fp'));   
        }
        Database.SaveResult[] insertResult = Database.insert(testEvents,false);
        List<Event> insertQueryResult = [ SELECT StartDateTime,EndDateTime,Subject,Google_Id__c FROM Event ];
        for(Event e : insertQueryResult) {
            System.assertEquals('Test Event', e.Subject);
            System.assertEquals('dkcr7mhl94mfja7ekvgp1cp5fp', e.Google_Id__c);
        }
        for(Event e : insertQueryResult) {
            e.Subject = 'Test Event Update';
        }
        update insertQueryResult;
        Test.startTest();
        GetCalendarEvents eventsForTest = new GetCalendarEvents();
        Id batchId = Database.executeBatch(eventsForTest);
        Test.stopTest();
        List<Event> updateQuery = [ SELECT StartDateTime,EndDateTime,Subject,Google_Id__c FROM Event ];
        for(Event e :  updateQuery) {
            System.assertEquals('Test Event Update', e.Subject);
            System.assertEquals('dkcr7mhl94mfja7ekvgp1cp5fp' , e.Google_Id__c);
        }
        
    }
    @isTest
    public static void testPostBulkCalloutWithDescUpdate(){
        Test.setMock(HttpCalloutMock.class, new CalendarCalloutTestFail());
        List<Event> testEvents = new List<Event>();
        for(Integer i=0;i<20;i++) {
            testEvents.add(new Event(StartDateTime = DateTime.now().addMinutes(i),
                                     EndDateTime = DateTime.now().addMinutes(i+20), Subject = 'Test Event', Description = 'This is a Test',
                                     Google_Id__c = 'dkcr7mhl94mfja7ekvgp1cp5fp'));   
        }
        Database.SaveResult[] insertResult = Database.insert(testEvents,false);
        List<Event> insertQueryResult = [ SELECT StartDateTime,EndDateTime,Subject,Description FROM Event ];
        for(Event e : insertQueryResult) {
            System.assertEquals('Test Event', e.Subject);
            System.assertEquals('This is a Test', e.Description);
        }
        Test.startTest();
        GetCalendarEvents eventsForTest = new GetCalendarEvents();
        Id batchId = Database.executeBatch(eventsForTest);
        Test.stopTest();
        insertQueryResult = [ SELECT StartDateTime,EndDateTime,Subject,Google_Id__c FROM Event ];
        for(Event e : insertQueryResult) {
            System.assertEquals('dkcr7mhl94mfja7ekvgp1cp5fp', e.Google_Id__c);
        }
    }
    @isTest
    public static void testForException() {
        Test.setMock(HttpCalloutMock.class, new CalendarCalloutTest());
        List<Event> testEvents = new List<Event>();
        for(Integer i=0;i<20;i++) {
            testEvents.add(new Event(StartDateTime = DateTime.now().addMinutes(i),
                                     EndDateTime = DateTime.now().addMinutes(i+20), Description = 'This is a Test'));  
        }
        Database.SaveResult[] res = Database.insert(testEvents,false);
        Test.startTest();
        GoogleCalendarSchedule schedule = new GoogleCalendarSchedule();
        String sch = '0 0 0 ? * *';
        String jobId = System.schedule('Daily Sync Job', sch, schedule);
        Test.stopTest();
        testEvents = [ SELECT StartDateTime,EndDateTime,Subject,Description,Google_Id__c FROM Event  ];
        for(Event e : testEvents ) {
            System.assertEquals(null, e.Google_Id__c);
        }
        
    } 
}