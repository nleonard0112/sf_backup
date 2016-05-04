public with sharing class touNewContactFormController {

    public Contact AccountContact {get; set;}
    public Boolean SwitchCampaignOwner {get; set;}

    private Id mAccountId; 

	public touNewContactFormController(ApexPages.StandardController sc) {
		mAccountId = sc.getId();
		AccountContact = new Contact();
		AccountContact.AccountId = mAccountId;
		SwitchCampaignOwner = true;
	}

	public PageReference saveContact() {

		insert AccountContact;

        if(SwitchCampaignOwner) {
            //find the current opportunity. 
            List<Opportunity> opps = [select Id from Opportunity where AccountId =: mAccountId order by closedate desc limit 1];
            if(opps.size() > 0) {
            	opps[0].Contact__c = AccountContact.Id;
            	update opps;
            }
        }


        PageReference pg = new PageReference('/' + mAccountId);
        pg.setRedirect(true);
		return pg; 

	}

	public PageReference saveAndNewContact() {

	    saveContact();

        PageReference pg = new PageReference('/apex/touNewContactForm?id=' + mAccountId);
        pg.setRedirect(true);
		return pg;

	}

	public PageReference cancelContact() {
		PageReference pg = new PageReference('/' + mAccountId);
        pg.setRedirect(true);
		return pg; 
	}

}