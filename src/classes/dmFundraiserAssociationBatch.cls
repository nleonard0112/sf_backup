global class dmFundraiserAssociationBatch implements Database.Batchable<sObject>, Schedulable {
    
    String query = 'select Id from Campaign order by createddate desc';

    global dmFundraiserAssociationBatch() {}

    //global static void start() {
    //    System.schedule('dmFundraiserAssociationBatch Job 1', '0 0 * * * ?', new dmFundraiserAssociationBatch());
    //    System.schedule('dmFundraiserAssociationBatch Job 2', '0 15 * * * ?', new dmFundraiserAssociationBatch());
    //    System.schedule('dmFundraiserAssociationBatch Job 3', '0 30 * * * ?', new dmFundraiserAssociationBatch());
    //    System.schedule('dmFundraiserAssociationBatch Job 4', '0 45 * * * ?', new dmFundraiserAssociationBatch());
    //}

    global void execute(SchedulableContext sc) {
        dmFundraiserAssociationBatch b = new dmFundraiserAssociationBatch();
        database.executebatch(b,10);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void finish(Database.BatchableContext BC) {}

    global void execute(Database.BatchableContext BC, List<sObject> scope) {

       
        //list of campaigns
        List<Campaign> campaigns = [select Id,stayclassy__sf_contact_id__c,Funraise_Campaign_Member__c,stayclassy__campaign_url__c,
                                     (select Id,ContactId from CampaignMembers where Campaign_Member__c = null and ContactId != null and Status !=: 'Donor' limit 200), 
                                     (select Id,stayclassy__sf_contact_id__c,CampaignId from stayclassy__Opportunities2__r where Campaign_Member__c = null and stayclassy__sf_contact_id__c != null limit 200) 
                                        from Campaign where Id in: scope order by createddate desc];
 

        List<dm_Campaign_Member__c> newMembers = new List<dm_Campaign_Member__c>();

        Map<Id,Contact> pageUpdate = new Map<Id,Contact>();

        for(Campaign c : campaigns) {

            
            
            //Don't duplicate
            if(c.Funraise_Campaign_Member__c == null) {
                dm_Campaign_Member__c campaignOwner = new dm_Campaign_Member__c(
                    Campaign__c = c.Id,
                    Contact__c = c.stayclassy__sf_contact_id__c,
                    Type__c = 'Fundraiser',
                    Source__c = 'Campaign',
                    Target__c = c.Id
                );
                newMembers.add(campaignOwner);
                if(c.stayclassy__sf_contact_id__c != null) {

                    if(!pageUpdate.containsKey(c.stayclassy__sf_contact_id__c)) {
                        pageUpdate.put(c.stayclassy__sf_contact_id__c, new Contact(
                                                                               Id = c.stayclassy__sf_contact_id__c, 
                                                                               Fundraising_Page__c = c.stayclassy__campaign_url__c));
                    }
                }
            }


        	for(CampaignMember m : c.CampaignMembers) {
                
                //skip the owner if we already have it
                if(c.stayclassy__sf_contact_id__c == m.ContactId) continue;
                dm_Campaign_Member__c member = new dm_Campaign_Member__c(
                    Campaign__c = c.Id,
                    Contact__c = m.ContactId,
                    Type__c = 'Fundraiser',
                    Source__c = 'CampaignMember',
                    Target__c = m.Id
                );
                newMembers.add(member);
        	}

        	for(Opportunity o : c.stayclassy__Opportunities2__r) {

                dm_Campaign_Member__c donor = new dm_Campaign_Member__c(
                    Campaign__c = o.CampaignId,
                    Contact__c = o.stayclassy__sf_contact_id__c,
                    Opportunity__c = o.Id,
                    Type__c = 'Donor',
                    Source__c = 'Opportunity',
                    Target__c = o.Id
                );
                newMembers.add(donor);
                
        	}
        }
        insert newMembers;

        List<Opportunity> backPointersO = new List<Opportunity>();
        List<CampaignMember> backPointersCM = new List<CampaignMember>();
        List<Campaign> backPointersC = new List<Campaign>();
        for(dm_Campaign_Member__c dcm : newMembers) {
            if(dcm.Source__c == 'Opportunity') backPointersO.add(new Opportunity(Id = dcm.Target__c, Campaign_Member__c = dcm.Id));
     
            else if(dcm.Source__c == 'CampaignMember') backPointersCM.add(new CampaignMember(Id = dcm.Target__c, Campaign_Member__c = dcm.Id));
          
            else if(dcm.Source__c == 'Campaign') backPointersC.add(new Campaign(Id = dcm.Target__c, Funraise_Campaign_Member__c = dcm.Id));
          
             
            
        }

        update backPointersO;
        update backPointersCM;
        update backPointersC;
        update pageUpdate.values();
    }
}