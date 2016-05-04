@isTest
private class frWSFunraiseOpportunityTest {
	
	private static testMethod void testWS() {
	 
        Campaign c = new Campaign();
        c.Name = 'ZZZZFALL2015TOUR';
        insert c;
        
        RestRequest req = new RestRequest();
	    RestResponse res = new RestResponse();

	    req.requestBody = Blob.valueOf('{"id":14,"amount":10.0,"gatewayResponse":"Succeeded!","transactionId":"48","recurring":false,"offline":false,"donationDate":1442850643303,"status":"Complete","cardType":"VISA","lastFour":"1111","clientIp":"","billingFirstName":"Jason","billingLastName":"Swenski","billingZip":"80018","paymentMethod":"card","expirationDate":1459525843301,"isDonateDouble":false,"donateDoubleCompanyName":null,"donateDoubleEmployeeEmail":null,"donateDoubleId":null,"donateDoubleResponse":null,"name":"Jason Swenski - 14","expirationDateCompat":"032016","donorFullName":"Jason Swenski","donorEmail":"jswenski@linkglobal.org","formName":"ZZZZFALL2015TOUR","gatewayType":"test"}');
        req.params.put('action','create');
        req.headers.put('X-FUNRaise-Hmac-Sha256','OzS/c+F3YJzWzr425ONz+NcTW3APT6OzTmsAyRkbCWM=');

	    req.requestURI = '/services/apexrest/funraise/opportunity';  //Request URL
	    req.httpMethod = 'POST';//HTTP Request Type
	    RestContext.request = req;
	    RestContext.response = res;

        Test.startTest();
        frWSFunraiseOpportunity.createOpportunity();
        Test.stopTest();

	}
}