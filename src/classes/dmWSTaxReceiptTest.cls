@isTest
private class dmWSTaxReceiptTest {

	private static testMethod void testWS() {
	 
            dmTestUtils.setupTestData();

            Contact c = [select Name,Email from Contact limit 1];

            Map<String,Object> payload = new Map<String,Object>();
            Map<String,String> jsonContact = new Map<String,String>();
            jsonContact.put('Email',c.Email);
            jsonContact.put('Name',c.Name);
            payload.put(c.Id,jsonContact);

            RestRequest req = new RestRequest();
	      RestResponse res = new RestResponse();

	      req.requestBody = Blob.valueOf(JSON.serialize(payload));
            //req.params.put('action','create');


	      req.requestURI = '/services/apexrest/receipt/create/';  //Request URL
	      req.httpMethod = 'POST';//HTTP Request Type
	      RestContext.request = req;
	      RestContext.response = res;



            Test.startTest();
            dmWSTaxReceipt.createReceipt();
            Test.stopTest();

	}
}