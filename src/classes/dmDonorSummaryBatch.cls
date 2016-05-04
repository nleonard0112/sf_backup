global class dmDonorSummaryBatch implements Database.Batchable<sObject>, Schedulable {
    
    String query = 'select Id from Contact order by createddate desc';

    global dmDonorSummaryBatch() {}


   /*
   System.schedule('dmDonorSummaryBatch Job 1', '0 0 0-23/6 * * ?', new dmDonorSummaryBatch());
   System.schedule('dmFundraiserForceBatch Job 1', '0 0 0-23/6 * * ?', new dmFundraiserForceBatch());
   System.schedule('dmFundraiserAssociationBatch Job 1', '0 0 * * * ?', new dmFundraiserAssociationBatch());
   System.schedule('dmFundraiserAssociationBatch Job 2', '0 15 * * * ?', new dmFundraiserAssociationBatch());
   System.schedule('dmFundraiserAssociationBatch Job 3', '0 30 * * * ?', new dmFundraiserAssociationBatch());
   System.schedule('dmFundraiserAssociationBatch Job 4', '0 45 * * * ?', new dmFundraiserAssociationBatch());
   */
 
    //global static void start() {
    //    System.schedule('dmDonorSummaryBatch Job 1', '0 0 * * * ?', new dmDonorSummaryBatch());
    //}

    global void execute(SchedulableContext sc) {
        dmDonorSummaryBatch b = new dmDonorSummaryBatch();
        database.executebatch(b,2500);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {

        List<Contact> contacts = [select Name,Email,Id,(select HierarchyAmountWonOpportunities, HierarchyNumberOfContacts from stayclassy__Campaigns__r),
                                                       (select WE_FW8_NP__P2G_SCORE__c,WE_FW8_NP__NetworthRange__c from WE_FW8_NP__SearchResult__r order by createddate limit 1),
                                                       (select Id,stayclassy__cc_address__c,stayclassy__cc_address2__c,stayclassy__cc_city__c,stayclassy__cc_country__c,
                                                                  stayclassy__cc_zip__c,stayclassy__cc_state__c,stayclassy__status__c,stayclassy__cc_exp_date__c,
                                                                  stayclassy__start_date__c,stayclassy__cancel_date__c from stayclassy__SCRecurringContact__r where stayclassy__status__c = 'Active' limit 1),
                                                       (select Id,CloseDate,CampaignId,Amount,Type from stayclassy__Opportunities__r where RecordType.Name = 'Classy Donation' order by CloseDate asc) 

                                                       from Contact where Id in: scope ];


        for(Contact c : contacts) {
            dmDonorSummaryUtil.computeDonationSummary(c);
            dmDonorSummaryUtil.computeTier(c);
            dmDonorSummaryUtil.computeRecurringStatistics(c);
            dmDonorSummaryUtil.computeFundrasierStats(c);

        }
        update contacts;
    }

    global void finish(Database.BatchableContext BC) {}
    
}