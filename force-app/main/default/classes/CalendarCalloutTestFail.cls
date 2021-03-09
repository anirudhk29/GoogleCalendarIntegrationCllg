@isTest
global class CalendarCalloutTestFail implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"id" : "Failed"}');
        res.setStatusCode(400);
        return res;
    }

}