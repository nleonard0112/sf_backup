@isTest
private class dmWSCampaignTest {

	private static testMethod void testWS() {
	 
        dmTestUtils.setupTestData();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        Campaign c = [select Id from Campaign limit 1];

        req.params.put('Id',c.Id);
 
        req.requestURI = '/services/apexrest/campaign/';  //Request URL
        req.httpMethod = 'GET';//HTTP Request Type
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new dmMockClassyFundrasierResponse());

       
        dmWSCampaign.getCampaign();
        Test.stopTest();

	}
}