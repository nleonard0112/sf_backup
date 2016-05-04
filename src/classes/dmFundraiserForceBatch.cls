global class dmFundraiserForceBatch implements Database.Batchable<sObject>, Schedulable {
    
    String query = 'select Id from dm_Campaign_Member__c order by createddate desc';

    global dmFundraiserForceBatch() {}

    //global static void start() {
    //    System.schedule('dmFundraiserForceBatch Job 1', '0 0 * * * ?', new dmFundraiserForceBatch());
    //}

    global void execute(SchedulableContext sc) {
        dmFundraiserForceBatch b = new dmFundraiserForceBatch();
        database.executebatch(b,5000);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {

        List<dm_Campaign_Member__c> membs = [select Id from dm_Campaign_Member__c where Id in: scope];
        update membs;
    }

    global void finish(Database.BatchableContext BC) {}
    
}