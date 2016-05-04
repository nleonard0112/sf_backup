@isTest
private class frWSFunraiseContactTest {
	
	private static testMethod void testWS() {
	 
        //Campaign c = new Campaign();
        //c.Name = '';
        //insert c;
        RestRequest req = new RestRequest();
	    RestResponse res = new RestResponse();

	    req.requestBody = Blob.valueOf('{"id":2,"firstName":"Jason","lastName":"Swenski","email":"jswenski@linkglobal.org","postalCode":"80018","createdDate":1442414603777}');
        req.params.put('action','create');
        req.headers.put('X-FUNRaise-Hmac-Sha256','el36AjVMclEUFXzmlzdbEAzvCOIEsUGq2OBl0ZiGcxI=');

	    req.requestURI = '/services/apexrest/funraise/contact';  //Request URL
	    req.httpMethod = 'POST';//HTTP Request Type
	    RestContext.request = req;
	    RestContext.response = res;

        Test.startTest();
        frWSFunraiseContact.createContact();
        Test.stopTest();

	}
}