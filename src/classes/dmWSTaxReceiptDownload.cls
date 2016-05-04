@RestResource(urlMapping='/receipt/download/*')
global without sharing class dmWSTaxReceiptDownload {
	@HttpGet
    global static void downloadReceipt() {

    	String contactId = RestContext.request.params.get('id');
    	Integer year = Integer.valueOf(RestContext.request.params.get('year'));
    	String fileName = year + ' Tax Receipt.pdf';
        
        Attachment a = [select Body from Attachment where ParentId =: contactId and Name =: fileName limit 1];

    	RestContext.response.addHeader('Content-Type', 'application/dummy');
    	RestContext.response.addHeader('Content-Disposition', 'inline; filename="' + fileName + '"');
    	RestContext.response.responseBody = a.Body;

    }
}