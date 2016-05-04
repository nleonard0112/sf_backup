@RestResource(urlMapping='/lead/*')
global without sharing class  wbWSLeadController {
	
	@HttpPost
    global static void createLead() {


       Map<String,Object> payload 
           = (Map<String,Object>)JSON.deserializeUntyped(
           	                         RestContext.request.requestBody.toString());

        Lead lead = new Lead();
        Set<String> fields = payload.keySet();
        Map<String, Schema.DescribeFieldResult> finalMap =  getFieldMetaData(Lead.getSObjectType().getDescribe(), fields);


        for(String f : fields) {
          
             Object o = payload.get(f);
             if(finalMap.get(f).getType() == Schema.DisplayType.Date) {
             	lead.put(f,Date.parse(String.valueOf(o)));
             }
             else if (finalMap.get(f).getType() == Schema.DisplayType.Double) {
                lead.put(f,Decimal.valueOf(String.valueOf(o)));
             }
             else {
             	lead.put(f,o);
             }
        }

        String sig = RestContext.request.params.get('signature');
        if(String.isNotEmpty(sig)) {
            lead.Signed__c = isAuthentic(lead,sig);
        }


        insert lead;
       


        Map<String,String> resp = new Map<String,String>();
        resp.put('status','OK');
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.addHeader('Access-Control-Allow-Origin', '*');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
    }

    public static Boolean isAuthentic(Lead lead, String token) {
    
        if(String.isEmpty(token)) return false;
        Blob data = Blob.valueOf(lead.Firstname + lead.LastName + lead.Email);
        Blob secret = Blob.valueOf(Funraise_Env__c.getInstance('Default').Secret__c);

        Blob blobSignature = Crypto.generateMac('hmacSHA256', data, secret);
        if(token ==  EncodingUtil.base64Encode(blobSignature)) {
            return true;    
        }
        return false;

    }

    public static Map<String, Schema.DescribeFieldResult> getFieldMetaData(  
	  Schema.DescribeSObjectResult dsor, Set<String> fields) {

	  // the map to be returned with the final data
	  Map<String,Schema.DescribeFieldResult> finalMap = 
	    new Map<String, Schema.DescribeFieldResult>();
	  // map of all fields in the object
	  Map<String, Schema.SObjectField> objectFields = dsor.fields.getMap();

	  // iterate over the requested fields and get the describe info for each one. 
	  // add it to a map with field name as key
	  for(String field : fields){
	    // skip fields that are not part of the object
	    if (objectFields.containsKey(field)) {
	      Schema.DescribeFieldResult dr = objectFields.get(field).getDescribe();
	      // add the results to the map to be returned
	      finalMap.put(field, dr); 
	    }
	  }
	  return finalMap;
	}
}