public with sharing class GoogleCalendarService {
    public static string createEvent(DateTime startTime, DateTime endTime,String subject,String description) {
        JSONGenerator gen;
        if(description != null) {
            gen = generateJSONContent(startTime,endTime,subject,description);
        }
        else {
            gen = generateJSONContent(startTime,endTime,subject);
        }
        String googleId;
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('callout:Google_Calender_API/calendar/v3/calendars/c_eclebqvpo0unj32keffvs28em8@group.calendar.google.com/events');
		req.setBody(gen.getAsString());        
        HttpResponse res = http.send(req);
        if(res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
            Map<String,Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            googleId = (String) results.get('id');
        }
        else{
            googleId = 'Failed';
        }
        System.debug(googleId);
        return googleId;
    }
    public static String updateEvent(DateTime startTime, DateTime endTime,String subject,String description,String eventId) {
        JSONGenerator gen;
        if(description != null) {
            gen = generateJSONContent(startTime,endTime,subject,description);
        }
        else {
            gen = generateJSONContent(startTime,endTime,subject);
        }
        String googleId;
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('PUT');
        req.setEndpoint('callout:Google_Calender_API/calendar/v3/calendars/c_eclebqvpo0unj32keffvs28em8@group.calendar.google.com/events/'+eventId);
		req.setBody(gen.getAsString());        
        HttpResponse res = http.send(req);
        if(res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
            Map<String,Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            googleId = (String) results.get('id');
        }
        else{
            googleId = 'Failed';
        }
        System.debug(res.getBody());
        return googleId;
    }
    private static JSONGenerator generateJSONContent(DateTime startTime, DateTime endTime,String subject,String description) {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
		gen.writeFieldName('start');
        gen.writeStartObject();
        gen.writeDateTimeField('dateTime',startTime);
        gen.writeEndObject();
        gen.writeFieldName('end');
        gen.writeStartObject();
        gen.writeDateTimeField('dateTime',endTime);
        gen.writeEndObject();
        gen.writeStringField('summary', subject);
        gen.writeStringField('description', description);
        gen.writeEndObject();
        return gen;
    }
    private static JSONGenerator generateJSONContent(DateTime startTime, DateTime endTime,String subject) {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
		gen.writeFieldName('start');
        gen.writeStartObject();
        gen.writeDateTimeField('dateTime',startTime);
        gen.writeEndObject();
        gen.writeFieldName('end');
        gen.writeStartObject();
        gen.writeDateTimeField('dateTime',endTime);
        gen.writeEndObject();
        gen.writeStringField('summary', subject);
        gen.writeEndObject();
        return gen;
    }
}