@RestResource(urlMapping='/funraise/opportunity/*')
global without sharing class frWSFunraiseOpportunity {

    @HttpPost
    global static void createOpportunity() {

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
        
        String funraiseId = String.valueOf(m.get('id'));
        Opportunity op = null;
        List<Opportunity> ops = [select Id from Opportunity where Funraise_Id__c =: funraiseId limit 1];
        if(ops == null || ops.size() == 0) op = new Opportunity(); 
        else op = ops[0];


        op.Name = String.valueOf(m.get('name'));
        op.Amount = Double.valueOf(m.get('amount'));
        op.stayclassy__donation_total__c = op.Amount;
        op.Type = Boolean.valueOf(m.get('recurring')) ? 'Recurring' : 'One-time';


        
        op.CloseDate = DateTime.newInstance(Long.valueOf(String.valueOf(m.get('cretime')))).date();
        
        String status = String.valueOf(m.get('status'));

        if(status == 'Complete') {
            op.StageName = 'Closed: Contract';
            op.Probability = 100;
        }
        else if(status == 'Pending') {
            op.StageName = 'Pending';
            op.Probability = 50;
        }
        else if(status == 'Failed') {
            op.StageName = 'Closed: Denied';
            op.Probability = 0;
        }
        else if(status == 'Refunded') {
            op.StageName = 'Closed: Denied';
            op.Probability = 0;
        }

        op.Funraise_Id__c = String.valueOf(m.get('id'));

        op.RecordTypeId = [select Id from RecordType where DeveloperName =: 'Classy_Donation'].Id;
        
        op.stayclassy__gateway_transaction_id__c = String.valueOf(m.get('transactionId'));
        op.stayclassy__Payment_Method__c = String.valueOf(m.get('paymentMethod'));
        op.stayclassy__order_date__c = DateTime.newInstance(Long.valueOf(String.valueOf(m.get('cretime'))));
        op.stayclassy__Credit_Card_Type__c = String.valueOf(m.get('cardType'));
        op.stayclassy__Credit_Card_Last_Four_Digits__c = String.valueOf(m.get('lastFour'));
        op.stayclassy__Credit_Card_Expiration_Date__c = String.valueOf(m.get('expirationDateCompat'));
        op.stayclassy__cc_zip__c = String.valueOf(m.get('billingZip'));
        op.stayclassy__Billing_First_Name__c = String.valueOf(m.get('billingFirstName'));
        op.stayclassy__Billing_Last_Name__c = String.valueOf(m.get('billingLastName'));
        op.stayclassy__gateway_name__c = String.valueOf(m.get('gatewayType'));

        String campaignName = String.valueOf(m.get('formName'));
        try {
            op.stayclassy__Campaign__c = [select Id from Campaign where Name =: campaignName].Id;
            op.CampaignId = op.stayclassy__Campaign__c;
        }
        catch(Exception e) {
             resp.put('camapaignWarning','Campaign not found');
        }

        String donorId = RestContext.request.params.get('donorId');
        try {
            Contact donor = [select Id,Funraise_Id__c from Contact where Id =: donorId limit 1];
            op.stayclassy__sf_contact_id__c = donor.Id;
        }
        catch(Exception e) {
             resp.put('donorWarning','Donor not found: Id: ' + donorId);
        }


        if(op.Type == 'Recurring') {

            stayclassy__sc_recurring_profile__c rp = null;

            String recurringId = String.valueOf(m.get('recurringDonationId'));
            List<stayclassy__sc_recurring_profile__c> rps 
            = [select Id from stayclassy__sc_recurring_profile__c where Funraise_Id__c =: recurringId limit 1];

            if(rps != null && rps.size() > 0) rp = rps[0];
            else {

                rp = new stayclassy__sc_recurring_profile__c();
                rp.name = 'F' + recurringId;
                rp.stayclassy__CampaignId__c = op.stayclassy__Campaign__c;
                rp.stayclassy__sf_contact_id__c = op.stayclassy__sf_contact_id__c;
                rp.stayclassy__cc_exp_date__c =  op.stayclassy__Credit_Card_Expiration_Date__c;
                rp.stayclassy__cc_type__c = op.stayclassy__Credit_Card_Type__c;
                rp.stayclassy__donation_amount__c =  op.Amount;
                rp.stayclassy__cc_last_4_digits__c = op.stayclassy__Credit_Card_Last_Four_Digits__c;
                rp.stayclassy__gateway_name__c = op.stayclassy__gateway_name__c; 
                rp.stayclassy__gateway_name__c = op.stayclassy__gateway_name__c; 
                rp.stayclassy__status__c = String.valueOf(m.get('recurringDonationStatus'));
                rp.stayclassy__start_date__c = op.CloseDate;
                rp.stayclassy__sc_recurring_id__c = Integer.valueOf(recurringId);
                rp.Funraise_Id__c = recurringId;
                insert rp;
            }
            op.stayclassy__sf_recurring_id__c = rp.Id;

            //Add history.
            stayclassy__Classy_Recurring_History__c hist = new stayclassy__Classy_Recurring_History__c();
            hist.stayclassy__Classy_Recurring_Donor__c = rp.Id;
            hist.stayclassy__History_Date__c = DateTime.newInstance(Long.valueOf(String.valueOf(m.get('cretime'))));

            if(String.valueOf(m.get('recurringDonationStatus')) == 'Cancelled') {
                hist.stayclassy__History_Type__c = 'Cancelled';
            }
            else {
                hist.stayclassy__Donation_Amount__c = op.Amount;
                //hist.stayclassy__Recurring_Donor_ID__c = donor.Funraise_Id__c;
                String hstatus = String.valueOf(m.get('status'));
                if(hstatus == 'Complete') {
                    hist.stayclassy__History_Type__c = 'Payment';
                }
                else if(hstatus == 'Refunded') {
                    hist.stayclassy__History_Type__c = 'Refunded';
                }
                else {
                    hist.stayclassy__History_Type__c = 'Payment Failed';
                }
            }
            insert hist;

        }
        upsert op;
               
        resp.put('status','OK');
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.addHeader('Access-Control-Allow-Origin', '*');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
    }
}