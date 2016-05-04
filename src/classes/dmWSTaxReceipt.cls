@RestResource(urlMapping='/receipt/create/*')
global without sharing class  dmWSTaxReceipt {
	
	@HttpPost
    global static void createReceipt() {

    	Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(RestContext.request.requestBody.toString());

        List<Attachment> attachments = new List<Attachment>();
        for(String contactId : m.keySet()) {
        
	        PageReference pg = new PageReference('/apex/dmTaxReceipt');
	        Map<String,Object> contact = (Map<String,Object>) m.get(contactId);

	   		pg.getParameters().put('email',String.valueOf(contact.get('Email')));
	   		pg.getParameters().put('name',String.valueOf(contact.get('Name')));
	   		pg.getParameters().put('id',contactId);
	   		pg.getParameters().put('year', String.valueOf(Date.today().year() - 1));
	        
	        Attachment att = new Attachment();
	        if(Test.isRunningTest()) att.Body = Blob.valueOf('');
	        else att.Body = pg.getContentAsPDF();
	        att.ParentId = contactId;
	        att.Name = String.valueOf(Date.today().year() - 1) + ' Tax Receipt.pdf';
	        attachments.add(att);
        }
        insert attachments;

        //TODO - maybe update a field on contact that has the download URL
                     
        Map<String,String> resp = new Map<String,String>();
        resp.put('status','OK');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
    }
}