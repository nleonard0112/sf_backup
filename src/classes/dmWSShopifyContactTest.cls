@isTest
private class dmWSShopifyContactTest {

	private static testmethod void testShopContactCreate() {


	 	RestRequest req = new RestRequest();
	    RestResponse res = new RestResponse();

	    req.requestBody = Blob.valueOf('{"accepts_marketing":true,"created_at":null,"email":"bob@biller.com","first_name":"Bob","id":null,"last_name":"Biller","last_order_id":null,"multipass_identifier":null,"note":"This customer loves ice cream","orders_count":0,"state":"disabled","tax_exempt":false,"total_spent":"0.00","updated_at":null,"verified_email":true,"tags":"","last_order_name":null,"addresses":[]}');
        req.params.put('action','create');
        req.headers.put('X-Shopify-Hmac-Sha256','c564MrVxBd/zVE+RjXYLYbyWbExDz2KCb/m6AiPTb2c=');

	    req.requestURI = '/services/apexrest/shopify/contact';  //Request URL
	    req.httpMethod = 'POST';//HTTP Request Type
	    RestContext.request = req;
	    RestContext.response = res;

	   
	 	Test.startTest();
	 	dmWSShopifyContact.createContact();
	 	Test.stopTest();

	 
	 }
}