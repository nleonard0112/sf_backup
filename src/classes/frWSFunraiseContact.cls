@RestResource(urlMapping='/funraise/contact/*')
global without sharing class frWSFunraiseContact {

    @HttpPost
    global static void createContact() {

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

       
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(RestContext.request.requestBody.toString());
        String email = String.valueOf(m.get('email'));
        String fId = String.valueOf(m.get('id'));
     
        String fname = String.valueOf(m.get('firstName'));
        String lname = String.valueOf(m.get('lastName')); 
        String street = String.valueOf(m.get('address1')); 
        String city = String.valueOf(m.get('city'));
        String state = String.valueOf(m.get('state'));
        String zip = String.valueOf(m.get('postalCode')); 
        Boolean emailOptOut = 'true'.equals(String.valueOf(m.get('emailOptOut'))); 


        Contact c = null;

     


        List<Contact> contacts = [select Id,Funraise_Id__c from Contact 
            where (Email =: email and Email != null) or 
            (Funraise_Id__c =: fId and Funraise_Id__c != null) or
            (
                (FirstName =: fname and FirstName != null) and
                (LastName =: lname and LastName != null) and
                (OtherStreet =: street and OtherStreet != null) and
                (OtherCity =: city and OtherCity != null) and
                (OtherState =: state and OtherState != null) and
                (OtherPostalCode =: zip and OtherPostalCode != null)
            )
            ];

        if(contacts != null && contacts.size() > 0) {
            //Take the one with a FUNraise ID
            for(Contact i : contacts) {
                if(i.Funraise_Id__c != null) {
                    c = i;
                    break;
                }
            }
            if(c == null) c = contacts[0];
        }
        else c = new Contact();
   
        c.Email = email;
        c.FirstName = fname;
        c.LastName = lname; 
        c.OtherStreet = street;
        c.OtherCity = city;
        c.OtherState = state;
        c.OtherPostalCode = zip;
        if(emailOptOut) c.HasOptedOutOfEmail = true;
        if(c.Funraise_Id__c == null) c.Funraise_Id__c = fId;
        upsert c;
        
        
          	                       
        resp.put('status','OK');
        resp.put('id',c.Id);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.addHeader('Access-Control-Allow-Origin', '*');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
    }
}