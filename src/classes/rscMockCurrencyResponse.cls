@isTest
global class rscMockCurrencyResponse implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"base":"KRW","date":"2014-06-09","rates":{"USD":0.001}}');
        res.setStatusCode(200);
        return res;
    }
}