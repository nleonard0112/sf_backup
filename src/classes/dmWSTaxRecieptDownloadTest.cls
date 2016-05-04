@isTest
private class dmWSTaxRecieptDownloadTest {
	

	private static testMethod void testWS() {
	 
            dmTestUtils.setupTestData();

            Contact c = [select Name,Email from Contact limit 1];


            Attachment att = new Attachment();
            att.Body = Blob.valueOf('');
            att.ParentId = c.Id;
            att.Name = '2015 Tax Receipt.pdf';
            insert att;

            Map<String,Object> payload = new Map<String,Object>();
            Map<String,String> jsonContact = new Map<String,String>();
            jsonContact.put('Email',c.Email);
            jsonContact.put('Name',c.Name);
            payload.put(c.Id,jsonContact);

            RestRequest req = new RestRequest();
	        RestResponse res = new RestResponse();

            req.params.put('year','2015');
            req.params.put('id',c.Id);


	        req.requestURI = '/services/apexrest/receipt/download/';  //Request URL
	        req.httpMethod = 'GET';//HTTP Request Type
	        RestContext.request = req;
	        RestContext.response = res;

            Test.startTest();
            dmWSTaxReceiptDownload.downloadReceipt();
            Test.stopTest();

	}
}