global class dmTaxReceiptBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {
	

	//TODO fix this so we're only grabbing contacts that have a donation this year.
	String query = 'select Name,Email,Id from Contact where Id in (select stayclassy__sf_contact_id__c from Opportunity where CloseDate = LAST_YEAR)';
	String sessionId;

	global dmTaxReceiptBatch() {}
	
	global dmTaxReceiptBatch(String sessionId) {
		this.sessionId = sessionId;
	}

	global static void start() {
		System.schedule('dmTaxReceiptBatch Job 1', '0 0 * * * ?', new dmTaxReceiptBatch());
	}

	global void execute(SchedulableContext sc) {
	    dmTaxReceiptBatch b = new dmTaxReceiptBatch(UserInfo.getSessionId());
        database.executebatch(b,50);
    }
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
	    
	    Map<String,Object> payload = new Map<String,Object>();
        for(sObject s : scope) {
             
            Contact c = (Contact) s;
            Map<String,String> jsonContact = new Map<String,String>();
            jsonContact.put('Email',c.Email);
            jsonContact.put('Name',c.Name);
            payload.put(c.Id,jsonContact);
        }

        HttpRequest req = new HttpRequest();
	    Http http = new Http();

	    req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/receipt/create');
	    req.setMethod('POST');
	    req.setHeader('Authorization', 'OAuth ' + sessionId);
	    req.setHeader('Content-type', 'application/json');
	    req.setBody(JSON.serialize(payload));
	   
	    try {

	    	HttpResponse res = new HttpResponse();
	        res = http.send(req);
	        JSON.deserializeUntyped(res.getBody());
        
	    } catch(System.CalloutException e) {}
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}