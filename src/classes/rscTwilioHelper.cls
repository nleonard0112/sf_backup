public with sharing class rscTwilioHelper {
	
    
    public static void sendNotification(String toNumber, String fromNumber, String body) {

	    HttpRequest req = new HttpRequest();
	    HttpResponse res = new HttpResponse();
	    Http http = new Http();

	    String username = 'ACdd7ce5f252c64188bd6aecb5947e0251';
	    String password = '03ddf2742b54d931eca5b5b215157002';

	    Blob headerValue = Blob.valueOf(username + ':' + password);
		String authorizationHeader = 'BASIC ' +
		EncodingUtil.base64Encode(headerValue);
		req.setHeader('Authorization', authorizationHeader);

	    req.setEndpoint('https://api.twilio.com/2010-04-01/Accounts/ACdd7ce5f252c64188bd6aecb5947e0251/Messages.json');
	    req.setMethod('POST');
	    req.setBody('To='+EncodingUtil.urlEncode(toNumber, 'UTF-8')
	    	       +'&From='+EncodingUtil.urlEncode(fromNumber, 'UTF-8')
	    	       +'&Body='+EncodingUtil.urlEncode(body, 'UTF-8'));

	    try {
	        res = http.send(req);
	    } catch(System.CalloutException e) {
	        System.debug('Callout error: '+ e);
	        System.debug(res.toString());
	    }

    }

    @future(callout=true)
    public static void sendBulkNotifications(List<String> toNumbers, String body) {

    	for(String notificationNumber : toNumbers) {
    		sendNotification(notificationNumber,'510-592-6398',body);
    	}

    }




}