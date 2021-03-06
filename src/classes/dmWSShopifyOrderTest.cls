@isTest
private class dmWSShopifyOrderTest {

	private static testmethod void testShopContactCreate() {


	 	RestRequest req = new RestRequest();
	    RestResponse res = new RestResponse();

	    Contact testDummy = new Contact(
            Email = 'john@test.com',
            FirstName = 'Jim',
            LastName = 'Bob'
	    );
	    insert testDummy;

	    req.requestBody = Blob.valueOf('{"buyer_accepts_marketing":true,"cancel_reason":"customer","cancelled_at":"2015-07-07T13:36:40-04:00","cart_token":null,"checkout_token":null,"closed_at":null,"confirmed":false,"created_at":"2015-07-07T13:36:40-04:00","currency":"USD","device_id":null,"email":"jon@doe.ca","financial_status":"voided","gateway":null,"id":123456,"landing_site":null,"location_id":null,"name":"#9999","note":null,"number":234,"processed_at":null,"reference":null,"referring_site":null,"source_identifier":null,"source_url":null,"subtotal_price":"229.94","taxes_included":false,"test":true,"token":null,"total_discounts":"0.00","total_line_items_price":"229.94","total_price":"239.94","total_price_usd":null,"total_tax":"0.00","total_weight":0,"updated_at":"2015-07-07T13:36:40-04:00","user_id":null,"browser_ip":null,"landing_site_ref":null,"order_number":1234,"discount_codes":[],"note_attributes":[],"payment_gateway_names":["bogus"],"processing_method":"","source":"browser","checkout_id":null,"source_name":"web","fulfillment_status":"pending","tax_lines":[],"tags":"","line_items":[{"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":5000,"id":56789,"price":"199.99","product_id":327475578523353102,"quantity":1,"requires_shipping":true,"sku":"SKU2006-001","taxable":true,"title":"Sledgehammer","variant_id":null,"variant_title":null,"vendor":null,"name":"Sledgehammer","variant_inventory_management":null,"properties":[],"product_exists":true,"fulfillable_quantity":1,"total_discount":"0.00","tax_lines":[]},{"fulfillment_service":"manual","fulfillment_status":null,"gift_card":false,"grams":500,"id":98765,"price":"29.95","product_id":327475578523353102,"quantity":1,"requires_shipping":true,"sku":"SKU2006-020","taxable":true,"title":"Wire Cutter","variant_id":null,"variant_title":null,"vendor":null,"name":"Wire Cutter","variant_inventory_management":null,"properties":[],"product_exists":true,"fulfillable_quantity":1,"total_discount":"0.00","tax_lines":[]}],"shipping_lines":[{"code":null,"price":"10.00","source":"shopify","title":"Generic Shipping","tax_lines":[]}],"billing_address":{"address1":"123 Billing Street","address2":null,"city":"Billtown","company":"My Company","country":"United States","first_name":"Bob","last_name":"Biller","latitude":null,"longitude":null,"phone":"555-555-BILL","province":"Kentucky","zip":"K2P0B0","name":"Bob Biller","country_code":"US","province_code":"KY"},"shipping_address":{"address1":"123 Shipping Street","address2":null,"city":"Shippington","company":"Shipping Company","country":"United States","first_name":"Steve","last_name":"Shipper","latitude":null,"longitude":null,"phone":"555-555-SHIP","province":"Kentucky","zip":"K2P0S0","name":"Steve Shipper","country_code":"US","province_code":"KY"},"fulfillments":[],"refunds":[],"customer":{"accepts_marketing":false,"created_at":null,"email":"john@test.com","first_name":"John","id":null,"last_name":"Smith","last_order_id":null,"multipass_identifier":null,"note":null,"orders_count":0,"state":"disabled","tax_exempt":false,"total_spent":"0.00","updated_at":null,"verified_email":true,"tags":"","last_order_name":null,"default_address":{"address1":"123 Elm St.","address2":null,"city":"Ottawa","company":null,"country":"Canada","first_name":null,"id":null,"last_name":null,"phone":"123-123-1234","province":"Ontario","zip":"K2H7A8","name":"","province_code":"ON","country_code":"CA","country_name":"Canada","default":true}}}');
        req.params.put('action','create');


	    req.requestURI = '/services/apexrest/shopify/order';  //Request URL
	    req.httpMethod = 'POST';//HTTP Request Type
	    RestContext.request = req;
	    RestContext.response = res;

	   
	 	Test.startTest();
	 	dmWSShopifyOrder.processOrder();
	 	Test.stopTest();

	 
	 }
}