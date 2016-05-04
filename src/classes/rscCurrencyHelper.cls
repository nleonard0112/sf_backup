public with sharing class rscCurrencyHelper {
	
	//http://api.fixer.io/2015-04-21?symbols=KRW&base=USD

	public static Decimal convertCurrency(Datetime transactionDate, String source, String target, Decimal amount) {
        HttpRequest req = new HttpRequest();
	    HttpResponse res = new HttpResponse();
	    Http http = new Http();

	    req.setEndpoint('http://api.fixer.io/'+transactionDate.format('YYYY-MM-DD')+'?symbols='+target+'&base='+source);
	    req.setMethod('GET');
	   
	    try {
	        res = http.send(req);

	        Map<String,Object> data = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
            Map<String,Object> rates = (Map<String,Object>) data.get('rates');

            Decimal conversionRate = Decimal.valueOf(String.valueOf(rates.get(target)));

            return amount*conversionRate;


	    } catch(System.CalloutException e) {
	        System.debug('Callout error: '+ e);
	        System.debug(res.toString());
	    }

	    return null;




	}
}