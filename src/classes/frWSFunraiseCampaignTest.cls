@isTest
private class frWSFunraiseCampaignTest {

		private static testMethod void testWS() {
	 
        RestRequest req = new RestRequest();
	    RestResponse res = new RestResponse();

	    req.requestBody = Blob.valueOf('{"id":2,"name":"TestForm1","header":"Test Header","goal":20000.0,"paymentOptions":null,"prefill":20,"preset1":20,"preset2":20,"preset3":20,"preset4":20,"buttonColor":"#2e697b","buttonLabel":"Donate Test","buttonSize":null,"buttonStyle":null,"status":null,"sendEmail":false,"imageUrl":null,"emailResponse":"Test","summary":{"donationTotal":null,"donationCount":0,"goal":20000.0,"percentGoal":0.0}');
        req.params.put('action','create');
        req.headers.put('X-FUNRaise-Hmac-Sha256','f6RMuETfGJ8tBI5lKZrp7A1kJHCcXlenOe2Dszv8Wsk=');

	    req.requestURI = '/services/apexrest/funraise/campaign';  //Request URL
	    req.httpMethod = 'POST';//HTTP Request Type
	    RestContext.request = req;
	    RestContext.response = res;

        Test.startTest();
        frWSFunraiseCampaign.createCampaign();
        Test.stopTest();

	}
}