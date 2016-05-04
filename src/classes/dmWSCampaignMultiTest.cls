@isTest
private class dmWSCampaignMultiTest {
	
	private static testMethod void testWS() {
	 
        dmTestUtils.setupTestData();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        Campaign c = [select Id from Campaign limit 1];

        Date td = Date.today();
        td.addDays(-1);

        req.params.put('Id',c.Id);
        req.params.put('m', String.valueOf(td.month()));
        req.params.put('d', String.valueOf(td.day()));
        req.params.put('y',String.valueOf(td.year()));
 
        req.requestURI = '/services/apexrest/campaign/multi';  //Request URL
        req.httpMethod = 'GET';//HTTP Request Type
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new dmMockClassyFundrasierResponse());

       
        dmWSCampaignMulti.getCampaign();
        Test.stopTest();

	}
}