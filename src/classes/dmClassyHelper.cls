public with sharing class dmClassyHelper {

    public class Fundraiser {

    	public String name;
    	public Double raised;
    	public Double goal;
    	public String image;
        public String donation_url;
        public String fundraiser_url;
    	public Double goalComplete = 0;

    }

    public static List<Fundraiser> getFundraisers(String campaignId, String eventId) {
        HttpRequest req = new HttpRequest();
	    HttpResponse res = new HttpResponse();
	    Http http = new Http();

        //https://www.classy.org/api1/fundraisers?cid=5321&token=we96S2VPwrNohxzQDFX5&eid=37335&limit=10&order=total_raised
	    req.setEndpoint('https://www.classy.org/api1/fundraisers?cid=5321&token=we96S2VPwrNohxzQDFX5&eid='+eventId+'&limit=10&order=total_raised');
	    req.setMethod('GET');
	   
	    try {
	        res = http.send(req);

	        Map<String,Object> data = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
            List<Object> frData = (List<Object>) data.get('fundraisers');
           
            List<Fundraiser> frArray = new List<Fundraiser>();
            for(Object d : frData) {

                Map<String,Object> o = (Map<String,Object>) d;
                Fundraiser f = new Fundraiser();
                f.name = String.valueOf(o.get('first_name')) + ' ' + String.valueOf(o.get('last_name'));
                f.raised = Double.valueOf(o.get('total_raised')); 
                f.goal = Double.valueOf(o.get('goal'));
                f.donation_url = String.valueOf(o.get('donation_url'));
                f.fundraiser_url = String.valueOf(o.get('fundraiser_url'));
                if(f.goal > 0) {
                    f.goalComplete = (f.raised/f.goal)*100;
                }


                f.image = String.valueOf(o.get('member_image_medium'));
                frArray.add(f);
            }
            return frArray;

	    } catch(System.CalloutException e) {
	        
	    }

	    return null;






	}
}