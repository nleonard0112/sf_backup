@RestResource(urlMapping='/campaign/multi/*')
global without sharing class dmWSCampaignMulti {
	    
	    @HttpGet
        global static void getCampaign() {

	        Map<String,Object> resp = new Map<String,Object>();
            String id = RestContext.request.params.get('Id');
            List<String> ids = id.split(',');


            Integer m = Integer.valueOf(RestContext.request.params.get('m'));
            Integer d = Integer.valueOf(RestContext.request.params.get('d'));
            Integer y = Integer.valueOf(RestContext.request.params.get('y'));

            Date closeDate = Date.newInstance(y, m, d);


            List<Campaign> campaigns = [select Id,Name,ExpectedRevenue from Campaign where Id in: ids];

            Double expectedRevenue = 0;
            for(Campaign c : campaigns) {
            	expectedRevenue += (c.ExpectedRevenue == null ? 0 : c.ExpectedRevenue);
            }

            AggregateResult[] donationAmounts = [select count(Id),sum(Amount) from Opportunity where 
            ((CampaignId in: ids OR 
            Campaign.ParentId in: ids OR 
            Campaign.Parent.ParentId in: ids OR 
            Campaign.Parent.Parent.ParentId in: ids OR 
            Campaign.Parent.Parent.Parent.ParentId in: ids) AND CloseDate >: closeDate AND Amount > 0)];

	        Double donationsTotal = Integer.valueOf(donationAmounts[0].get('expr1'));
	        Integer donorsTotal = Integer.valueOf(donationAmounts[0].get('expr0'));

            resp.put('numDonations',donorsTotal); 
            resp.put('amountDonations',donationsTotal); 
            resp.put('expectedRevenue',expectedRevenue);

            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.addHeader('Access-Control-Allow-Origin', '*');
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
	   
        }
}