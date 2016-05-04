@isTest
global class dmMockClassyFundrasierResponse implements HttpCalloutMock {
	
			
    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status_code":"SUCCESS","fundraisers":[{"fundraising_campaign_id":376383,"fundraiser_url":"https://www.classy.org/undraise?fcid=376383","donation_url":"https://www.classy.org/checkout/donation?fcid=376383","member_id":1113241,"page_title":"Today, we GIVE back!","first_name":"#Giving","last_name":"Tuesday","member_email":"donorrelations@libertyinnorthkorea.org","member_address":" ","member_city":" ","member_state":"","member_zip":"","member_country":"","member_image_small":"https://c394391.ssl.cf2.rackcdn.com/sm_1417468011.png","member_image_medium":"https://c394391.ssl.cf2.rackcdn.com/mid_1417468011.png","member_image_large":"https://c394391.ssl.cf2.rackcdn.com/full_1417468011.png","charity_id":5321,"charity_name":"Liberty in North Korea","project_id":5367,"project_name":"","event_id":37335,"event_name":"NK REFUGEE RESCUES","team_id":0,"team_name":"","goal":12000,"total_raised":13170,"num_donors":0}]}');
        res.setStatusCode(200);
        return res;
    }
}