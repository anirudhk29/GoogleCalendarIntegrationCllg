@isTest
global class CalendarCalloutTest implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"id" : "dkcr7mhl94mfja7ekvgp1cp5fp"}');
        res.setStatusCode(200);
        return res;
    }
    /*global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"id" : "Failed"}');
        res.setStatusCode(400);
        return res;
    }*/
}