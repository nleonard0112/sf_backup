public class dmTestUtils {

	public static stayclassy__Classy_Recurring_History__c createRecurringHistory(stayclassy__sc_recurring_profile__c p) {
        

        stayclassy__Classy_Recurring_History__c rh = new stayclassy__Classy_Recurring_History__c();
        rh.stayclassy__Classy_Recurring_Donor__c = p.Id;
        rh.stayclassy__Donation_Amount__c = 100;
        rh.Name = '1000000000002';
        rh.stayclassy__History_Type__c = 'Payment Failed';
        rh.stayclassy__Recurring_Donor_ID__c = 1001001001;
        rh.stayclassy__History_Date__c = DateTime.now();
        //rh.stayclassy__Recurring_History_ID__c = 1001001001;

        insert rh;

        return rh;

	}


    public static stayclassy__sc_recurring_profile__c createRecurringProfile(Contact c) {
        stayclassy__sc_recurring_profile__c p = new stayclassy__sc_recurring_profile__c();
        p.stayclassy__sf_contact_id__c = c.Id;
        p.stayclassy__donation_amount__c = 100;
        p.stayclassy__sc_recurring_id__c = 1001001001;
        p.stayclassy__start_date__c = Datetime.now();
        p.stayclassy__status__c = 'Active';
        p.stayclassy__cc_exp_date__c = '201501';

        insert p;

        return p;
    
    }

    public static void createTestWEResult(Contact c) {

        WE_FW8_NP__WESearchResult__c res = new WE_FW8_NP__WESearchResult__c();
        res.WE_FW8_NP__Contact__c = c.Id;
        res.WE_FW8_NP__P2G_SCORE__c = '5|0';
        res.WE_FW8_NP__NetworthRange__c = 'Unable to Rate';
        insert res;

    }

    public static Contact createTestDonor() {

    	Contact c = new Contact();
        c.LastName = 'Swenski';
        c.FirstName = 'Jason';
    	c.Email = 'jswenski-' + Math.random() + '@gmail.com';
    	insert c;

        createTestWEResult(c);

    	
    	return c;

    }

    public static void createTestDonations() {

    	RecordType r = [select Id from RecordType where Name = 'Classy Donation'];

    	Contact c = createTestDonor();
    	stayclassy__sc_recurring_profile__c p = createRecurringProfile(c);
       
        Campaign camp = new Campaign(Name = 'TestZZZZZZZZ');
        insert camp;

    	List<Opportunity> opps = new List<Opportunity>();
    	for(Integer i = 0; i < 2; i++) {
          
            Opportunity o = new Opportunity();
            o.stayclassy__sf_recurring_id__c = createRecurringHistory(p).Id;
    		o.stayclassy__sf_contact_id__c = c.Id;
            o.CampaignId = camp.Id;
    		o.StageName = 'Closed: Contract';
    		o.stayclassy__Campaign__c = camp.Id;
    		o.CloseDate = Date.today();
    		o.RecordTypeId = r.Id;
    		o.Amount = 1000;
    		opps.add(o);

    	}
    	for(Integer i = 0; i < 20; i++) {
    		Opportunity o = new Opportunity();
    		o.stayclassy__sf_contact_id__c = c.Id;
    		o.StageName = 'Closed: Contract';
    		o.CloseDate = Date.today();
    		o.stayclassy__Campaign__c = camp.Id;
    		o.Amount = 1000;
    		o.RecordTypeId = r.Id;
    		opps.add(o);
    		
    	}


    }

	public static dm_Donor_Match__c createTestDonorMatch() {

		Contact c = [select Id from Contact limit 1];
		rsc_Client__c cl =  [select Id from rsc_Client__c limit 1];

		dm_Donor_Match__c dm = new dm_Donor_Match__c();
		dm.Client__c = cl.Id;
		dm.Donor__c = c.Id;

 


		insert dm;


        Attachment att = new Attachment();
        att.Body = Blob.valueOf('');
        att.ParentId = dm.Id;
        att.Name = 'photo.png';
        insert att;

		return dm;

	}

	public static void createTestClient() {
		rscUnitTestUtils.getMissionSetup();
	}

	public static void setupTestData() {
        createTestClient();
        createTestDonations();
        createTestDonorMatch();
	}
	
}