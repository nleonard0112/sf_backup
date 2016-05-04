@RestResource(urlMapping='/shopify/order/*')
global without sharing class dmWSShopifyOrder {
	

	/*

    {  
	   "buyer_accepts_marketing":true,
	   "cancel_reason":"customer",
	   "cancelled_at":"2015-06-29T14:03:34-04:00",
	   "cart_token":null,
	   "checkout_token":null,
	   "closed_at":null,
	   "confirmed":false,
	   "created_at":"2015-06-29T14:03:34-04:00",
	   "currency":"USD",
	   "device_id":null,
	   "email":"jon@doe.ca",
	   "financial_status":"voided",
	   "gateway":null,
	   "id":123456,
	   "landing_site":null,
	   "location_id":null,
	   "name":"#9999",
	   "note":null,
	   "number":234,
	   "processed_at":null,
	   "reference":null,
	   "referring_site":null,
	   "source_identifier":null,
	   "source_url":null,
	   "subtotal_price":"229.94",
	   "taxes_included":false,
	   "test":true,
	   "token":null,
	   "total_discounts":"0.00",
	   "total_line_items_price":"229.94",
	   "total_price":"239.94",
	   "total_price_usd":null,
	   "total_tax":"0.00",
	   "total_weight":0,
	   "updated_at":"2015-06-29T14:03:34-04:00",
	   "user_id":null,
	   "browser_ip":null,
	   "landing_site_ref":null,
	   "order_number":1234,
	   "discount_codes":[  

	   ],
	   "note_attributes":[  

	   ],
	   "payment_gateway_names":[  
	      "bogus"
	   ],
	   "processing_method":"",
	   "source":"browser",
	   "checkout_id":null,
	   "source_name":"web",
	   "fulfillment_status":"pending",
	   "tax_lines":[  

	   ],
	   "tags":"",
	   "line_items":[  
	      {  
	         "fulfillment_service":"manual",
	         "fulfillment_status":null,
	         "gift_card":false,
	         "grams":5000,
	         "id":56789,
	         "price":"199.99",
	         "product_id":327475578523353102,
	         "quantity":1,
	         "requires_shipping":true,
	         "sku":"SKU2006-001",
	         "taxable":true,
	         "title":"Sledgehammer",
	         "variant_id":null,
	         "variant_title":null,
	         "vendor":null,
	         "name":"Sledgehammer",
	         "variant_inventory_management":null,
	         "properties":[  

	         ],
	         "product_exists":true,
	         "fulfillable_quantity":1,
	         "total_discount":"0.00",
	         "tax_lines":[  

	         ]
	      },
	      {  
	         "fulfillment_service":"manual",
	         "fulfillment_status":null,
	         "gift_card":false,
	         "grams":500,
	         "id":98765,
	         "price":"29.95",
	         "product_id":327475578523353102,
	         "quantity":1,
	         "requires_shipping":true,
	         "sku":"SKU2006-020",
	         "taxable":true,
	         "title":"Wire Cutter",
	         "variant_id":null,
	         "variant_title":null,
	         "vendor":null,
	         "name":"Wire Cutter",
	         "variant_inventory_management":null,
	         "properties":[  

	         ],
	         "product_exists":true,
	         "fulfillable_quantity":1,
	         "total_discount":"0.00",
	         "tax_lines":[  

	         ]
	      }
	   ],
	   "shipping_lines":[  
	      {  
	         "code":null,
	         "price":"10.00",
	         "source":"shopify",
	         "title":"Generic Shipping",
	         "tax_lines":[  

	         ]
	      }
	   ],
	   "billing_address":{  
	      "address1":"123 Billing Street",
	      "address2":null,
	      "city":"Billtown",
	      "company":"My Company",
	      "country":"United States",
	      "first_name":"Bob",
	      "last_name":"Biller",
	      "latitude":null,
	      "longitude":null,
	      "phone":"555-555-BILL",
	      "province":"Kentucky",
	      "zip":"K2P0B0",
	      "name":"Bob Biller",
	      "country_code":"US",
	      "province_code":"KY"
	   },
	   "shipping_address":{  
	      "address1":"123 Shipping Street",
	      "address2":null,
	      "city":"Shippington",
	      "company":"Shipping Company",
	      "country":"United States",
	      "first_name":"Steve",
	      "last_name":"Shipper",
	      "latitude":null,
	      "longitude":null,
	      "phone":"555-555-SHIP",
	      "province":"Kentucky",
	      "zip":"K2P0S0",
	      "name":"Steve Shipper",
	      "country_code":"US",
	      "province_code":"KY"
	   },
	   "fulfillments":[  

	   ],
	   "refunds":[  

	   ],
	   "customer":{  
	      "accepts_marketing":false,
	      "created_at":null,
	      "email":"john@test.com",
	      "first_name":"John",
	      "id":null,
	      "last_name":"Smith",
	      "last_order_id":null,
	      "multipass_identifier":null,
	      "note":null,
	      "orders_count":0,
	      "state":"disabled",
	      "tax_exempt":false,
	      "total_spent":"0.00",
	      "updated_at":null,
	      "verified_email":true,
	      "tags":"",
	      "last_order_name":null,
	      "default_address":{  
	         "address1":"123 Elm St.",
	         "address2":null,
	         "city":"Ottawa",
	         "company":null,
	         "country":"Canada",
	         "first_name":null,
	         "id":null,
	         "last_name":null,
	         "phone":"123-123-1234",
	         "province":"Ontario",
	         "zip":"K2H7A8",
	         "name":"",
	         "province_code":"ON",
	         "country_code":"CA",
	         "country_name":"Canada",
	         "default":true
	      }
	   }
	}*/

	private static void updateShippingInfo(dm_Shop_Order__c order, Map<String, Object> ord) {
        
        Map<String, Object> shipping = (Map<String, Object>) ord.get('shipping_address');

        if(shipping == null) return;

        order.Address_1__c = String.valueOf(shipping.get('address1'));
        order.Address_2__c = String.valueOf(shipping.get('address2'));
        order.City__c = String.valueOf(shipping.get('city'));
        order.Country__c = String.valueOf(shipping.get('country'));
        order.State__c = String.valueOf(shipping.get('province'));
        order.Postal_Code__c = String.valueOf(shipping.get('zip'));
        order.Phone__c = String.valueOf(shipping.get('phone'));
	}

	private static void updateOrderInfo(dm_Shop_Order__c order, Map<String, Object> ord) {

		order.Cart_Token__c = String.valueOf(ord.get('cart_token'));
		order.Cancelled_Reason__c = String.valueOf(ord.get('cancel_reason'));
		order.Shop_Order_ID__c = String.valueOf(ord.get('id'));
		order.Order_Number__c = String.valueOf(ord.get('order_number'));
        //order.Closed_At__c = 
        //order.Created_At__c =
		//created_at
		//closed_at

	}

	private static dm_Shop_Order__c getExistingOrder(Map<String, Object> ord) {
		String orderNumber = String.valueOf(ord.get('order_number'));
		List<dm_Shop_Order__c> orders = [select Id from dm_Shop_Order__c where Order_Number__c =: orderNumber limit 1];
	    if(orders.size() > 0) return orders[0];
	    return null;	
	}

	private static void dropLineItems(Id orderId) {
		delete [select id from dm_Order_Item__c where Shop_Order__c =: orderId];
	}

	private static void updateOrder(Map<String, Object> ord) {

		Contact customer = getCustomer(ord);
    	dm_Shop_Order__c order = getExistingOrder(ord);
    	updateShippingInfo(order,ord);
    	updateOrderInfo(order,ord);
        update order;

        dmDonorSummaryUtil.alignAddress(customer, order.Address_1__c, order.City__c, order.Country__c, order.Postal_Code__c, order.State__c);
        update customer;

        dropLineItems(order.Id);
        createLineItems(order,ord);
     
	}

    private static void createOrder(Map<String, Object> ord) {

    	Contact customer = getCustomer(ord);
        
        dm_Shop_Order__c order = getExistingOrder(ord);
        if(order == null) {
        	order = new dm_Shop_Order__c(
    		    Contact__c = customer.Id
    	    );
        }
    	updateShippingInfo(order,ord);
    	updateOrderInfo(order,ord);

        dmDonorSummaryUtil.alignAddress(customer, order.Address_1__c, order.City__c, order.Country__c, order.Postal_Code__c, order.State__c);
        update customer;
        insert order;
        createLineItems(order,ord);

    
    }


    /*
      "line_items":[  
	      {  
	         "fulfillment_service":"manual",
	         "fulfillment_status":null,
	         "gift_card":false,
	         "grams":5000,
	         "id":56789,
	         "price":"199.99",
	         "product_id":327475578523353102,
	         "quantity":1,
	         "requires_shipping":true,
	         "sku":"SKU2006-001",
	         "taxable":true,
	         "title":"Sledgehammer",
	         "variant_id":null,
	         "variant_title":null,
	         "vendor":null,
	         "name":"Sledgehammer",
	         "variant_inventory_management":null,
	         "properties":[  

	         ],
	         "product_exists":true,
	         "fulfillable_quantity":1,
	         "total_discount":"0.00",
	         "tax_lines":[  

	         ]
	      },




    */
    private static void createLineItems(dm_Shop_Order__c order, Map<String, Object> ord) {

        List<Object> lineItems = (List<Object>) ord.get('line_items');

        Contact customer = getCustomer(ord);


        List<dm_Order_Item__c> items = new List<dm_Order_Item__c>();
    	for(Object i : lineItems) {

            Map<String,Object> item = (Map<String,Object>) i;

    		dm_Order_Item__c orderItem = new dm_Order_Item__c(
                Shop_Order__c = order.Id,
                SKU__c = String.valueOf(item.get('sku')),
                Title__c = String.valueOf(item.get('title')),
                Quantity__c = Integer.valueOf(item.get('quantity')),
                Price__c = Double.valueOf(item.get('price')),
                Contact__c = order.Contact__c
                                
    	    );
 

            //TODO hack to get around stupid pardot limitations.
            if(orderItem.SKU__c == 'gala_donation') {
            	customer.Tags__c = 'Gala Donation';
            }
            if(orderItem.SKU__c == 'gala_general_admission') {
            	customer.Tags__c = 'Gala General Admission';
            }

    	    items.add(orderItem);
    	}

        update customer;

    	insert items;
    }

    private static Contact getCustomer(Map<String, Object> ord) {

        Contact c = null;
    	Map<String,Object> customer = (Map<String,Object>) ord.get('customer');
    	String email = String.valueOf(customer.get('email'));
    	List<Contact> contacts = [select Id,OtherStreet,OtherCity,OtherCountry,OtherState,OtherPostalCode from Contact where Email =: email limit 1];
        if(contacts != null && contacts.size() > 0) c = contacts[0];
        return c;

    }


	@HttpPost
    global static void processOrder() {

    	String action = RestContext.request.params.get('action');
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(RestContext.request.requestBody.toString());

        System.debug(RestContext.request.requestBody.toString());

        if(action == 'create') createOrder(m);
        if(action == 'update') updateOrder(m);

        Map<String,String> resp = new Map<String,String>();
        resp.put('status','OK');
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.addHeader('Access-Control-Allow-Origin', '*');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
		
	}
}