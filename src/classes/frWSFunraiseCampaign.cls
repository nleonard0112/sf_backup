@RestResource(urlMapping='/funraise/campaign/*')
global without sharing class frWSFunraiseCampaign {

    @HttpPost
    global static void createCampaign() {

        Map<String,String> resp = new Map<String,String>();

        String hmacSignature = RestContext.request.headers.get('X-FUNRaise-Hmac-Sha256');
        Blob blobSignature = Crypto.generateMac('hmacSHA256', Blob.valueOf(RestContext.request.requestBody.toString()), Blob.valueOf('Vth2o;X``qv>PiopUNkxMTnAm`_gQkWE@@^sfa<H:aTbzPw6R;TqL13R:xWTQL@8'));
        //TODO - factor out the shared secret into a custom setting or something..
        if(hmacSignature !=  EncodingUtil.base64Encode(blobSignature)) {
            resp.put('status','ERROR');
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.addHeader('Access-Control-Allow-Origin', '*');
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
            return;
        }

        String action = RestContext.request.params.get('action');    
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(RestContext.request.requestBody.toString());

        String id = String.valueOf(m.get('id'));
        
        if(id != null) {

            String name = String.valueOf(m.get('name'));
             
            Campaign c = null; 
            if(action == 'update') {
                List<Campaign> campaigns = [select Id from Campaign where Name =: name limit 1];
                if(campaigns != null && campaigns.size() > 0) c = campaigns[0];
            }
            else if(action == 'create') c = new Campaign();
            if(c != null) {
                c.Name = name;
                upsert c;
            }
        }
          	                       
       
        resp.put('status','OK');
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.addHeader('Access-Control-Allow-Origin', '*');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
    }
}