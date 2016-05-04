trigger dmRecurringHistoryTrigger on stayclassy__Classy_Recurring_History__c (after insert, after update) {

	stayclassy__Classy_Recurring_History__c[] historyItems = Trigger.new;

    historyItems = [select stayclassy__History_Type__c,stayclassy__History_Date__c,stayclassy__Classy_Recurring_Donor__r.stayclassy__sf_contact_id__c from stayclassy__Classy_Recurring_History__c where Id in: historyItems];

    // Admin Canceled
    // Canceled Failed Payments
    // Created
    // Member Canceled
    // Payment
    // Payment Failed
    // Updated Profile

    List<Contact> contacts = new List<Contact>();
	for(stayclassy__Classy_Recurring_History__c h : historyItems) {

        if(h.stayclassy__Classy_Recurring_Donor__r.stayclassy__sf_contact_id__c == null) continue;

        Contact c = new Contact(Id = h.stayclassy__Classy_Recurring_Donor__r.stayclassy__sf_contact_id__c);
        if(h.stayclassy__History_Type__c == 'Admin Canceled') c.Recurring_Donation_Status__c = 'Cancelled';
        else if(h.stayclassy__History_Type__c == 'Canceled Failed Payments') c.Recurring_Donation_Status__c = 'Cancelled';
        else if(h.stayclassy__History_Type__c == 'Created') c.Recurring_Donation_Status__c = 'Attempted Setup';
        else if(h.stayclassy__History_Type__c == 'Member Canceled') c.Recurring_Donation_Status__c = 'Cancelled';
        else if(h.stayclassy__History_Type__c == 'Payment') c.Recurring_Donation_Status__c = 'Active';
        else if(h.stayclassy__History_Type__c == 'Payment Failed') { 
        	c.Recurring_Donation_Status__c = 'Failing Payment';
        	c.Last_Failed_Payment__c = h.stayclassy__History_Date__c;
        }
        contacts.add(c);
	}

	update contacts;


}