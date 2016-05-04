@RestResource(urlMapping='/campaign/*')
global without sharing class dmWSCampaign {

 
    @Future(callout=true)
    private static void cacheResponse(String campaignId, String eventId) {
        String fundrasiers = JSON.serialize(dmClassyHelper.getFundraisers(campaignId, eventId));
        Campaign c = new Campaign(Id = campaignId, Fundraiser_Cache__c = fundrasiers, Fundraiser_Cache_Updated__c = Date.today());
        update c;
    }

    @HttpGet
    global static void getCampaign() {

        //https://www.classy.org/api1/fundraisers?cid=5321&token=we96S2VPwrNohxzQDFX5&eid=37335&limit=10&order=total_raised

    	Map<String,Object> resp = new Map<String,Object>();
        String id = RestContext.request.params.get('Id');
        id = String.escapeSingleQuotes(id);

        Date closeDate = Date.newInstance(9, 22, 2015);

        if(RestContext.request.params.get('m') != null) { 

            Integer m = Integer.valueOf(RestContext.request.params.get('m'));
            Integer d = Integer.valueOf(RestContext.request.params.get('d'));
            Integer y = Integer.valueOf(RestContext.request.params.get('y'));

            closeDate = Date.newInstance(y, m, d);
        }

        Campaign c = [select Id,Name,stayclassy__sc_event_id__c,
                                API_Total_Amount_Adj__c,
                                Fundraiser_Cache__c,
                                Fundraiser_Cache_Updated__c,
                                HierarchyExpectedRevenue,
                                ExpectedRevenue,
                                HierarchyAmountWonOpportunities, 
                                (select Id,Amount,stayclassy__sf_contact_id__r.Name,stayclassy__Anonymous_Donor__c
                                    from stayclassy__Opportunities2__r where stayclassy__sf_contact_id__c != null 
                                    order by createddate desc limit 10) 
                           from Campaign where Id =: id];

        if(c.Fundraiser_Cache_Updated__c == null || !Date.today().isSameDay(c.Fundraiser_Cache_Updated__c)) {
            cacheResponse(c.Id,String.valueOf(c.stayclassy__sc_event_id__c));
        }
        
        List<Campaign> members = [select stayclassy__sf_contact_id__r.Name,stayclassy__sf_contact_id__r.Email,AmountWonOpportunities,stayclassy__percent_goal_reached__c,ExpectedRevenue
                                  from Campaign 
                                  where (ParentId =: c.Id OR Parent.ParentId =: c.Id) AND stayclassy__Classy_Campaign_Type__c =: 'Fundraiser'
                                  order by AmountWonOpportunities desc limit 10];


        Integer numFund = 0;
        AggregateResult[] agro = [select count(Id) from Campaign where (ParentId =: c.Id OR Parent.ParentId =: c.Id) AND stayclassy__Classy_Campaign_Type__c =: 'Fundraiser'];
        for (AggregateResult ar : agro)  {
            numFund = Integer.valueOf(ar.get('expr0'));
        }

        AggregateResult[] donationAmounts = [select count(Id),sum(Amount) from Opportunity where 
        ((CampaignId =: id OR 
          Campaign.ParentId =: id OR 
          Campaign.Parent.ParentId =: id OR 
          Campaign.Parent.Parent.ParentId =: id OR 
          Campaign.Parent.Parent.Parent.ParentId =: id) AND CloseDate >: closeDate AND Amount > 0)];
    

        Double donationsTotal = 0;
        Integer donorsTotal = 0;
        for (AggregateResult ar : donationAmounts)  {
            donorsTotal = Integer.valueOf(ar.get('expr0'));
            donationsTotal = Integer.valueOf(ar.get('expr1'));
        } 


        
        List<Map<String,Object>> l = new List<Map<String,Object>>();
        for(Campaign cm : members) {
            Map<String,Object> m = new Map<String,Object>();
            
            if(cm.stayclassy__sf_contact_id__r.Email != null && cm.stayclassy__sf_contact_id__r.Email != '') {
                //https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mm
                Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(cm.stayclassy__sf_contact_id__r.Email));
                m.put('image','https://www.gravatar.com/avatar/' + EncodingUtil.convertToHex(hash));
            }
            else {
                m.put('image','https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mm');
            }

            m.put('name',cm.stayclassy__sf_contact_id__r.Name);
            m.put('raised',cm.AmountWonOpportunities);
            m.put('goal',cm.ExpectedRevenue);
            m.put('goalComplete',cm.stayclassy__percent_goal_reached__c);
            l.add(m);
        }

        List<Map<String,Object>> lastDonations = new List<Map<String,Object>>();

        for(Opportunity o : c.stayclassy__Opportunities2__r) {
            Map<String,Object> m = new Map<String,Object>();
            m.put('amount',o.Amount);
            if(o.stayclassy__Anonymous_Donor__c == false) m.put('name',o.stayclassy__sf_contact_id__r.Name);
            else m.put('name','Anonymous');
            lastDonations.add(m);
        }

        resp.put('name',c.Name);
        resp.put('numDonors',donorsTotal);
        resp.put('numDonations',donorsTotal); 
        resp.put('expectedRevenue',c.ExpectedRevenue);
        resp.put('amtDonations',(donationsTotal == null ? 0 : donationsTotal) - (c.API_Total_Amount_Adj__c == null ? 0 : c.API_Total_Amount_Adj__c));
        resp.put('numFundraisers',numFund);
        if(c.Fundraiser_Cache__c == null) resp.put('fundraisers',l);
        else {

            resp.put('fundraisers', (List<dmClassyHelper.Fundraiser>) System.JSON.deserialize(c.Fundraiser_Cache__c, List<dmClassyHelper.Fundraiser>.class));
            //resp.put('fundraisers', c.Fundraiser_Cache__c);
        }
        resp.put('lastDonations',lastDonations);

        resp.put('status','OK');

        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.addHeader('Access-Control-Allow-Origin', '*');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));

    }

}