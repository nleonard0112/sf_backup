public with sharing class touClonerUtil {
	
	@future
    public static void cloneOpps(String clDate, String season, String year) {
        //Name,Owner,Account,RecordType,Type,CloseDate,Probability,StageName
        //City__c,Region__c,State_or_Province__c,Contact__c

        List<Opportunity> opps = [select Id,Name,OwnerId,AccountId,RecordType.Id,Type,Probability,StageName,
                                         City__c,Region__c,State_or_Province__c,Contact__c from Opportunity where CloseDate = THIS_YEAR AND Type =: '2015 Spring Tour' limit 10000];

        List<Opportunity> newOpps = new List<Opportunity>();

        for(Opportunity op : opps) {

            Opportunity clOp = op.clone(false,true,false,false);
            clOp.Type = '2015 Fall Tour';
            clOp.Probability = 0;
            clOp.StageName = 'Prospecting';
            clOp.CloseDate = Date.parse(clDate);

            //name striped of last two words + season + year
            clOp.Name =  clOp.Name.replace('Spring 2015','Fall 2015'); //clOp.Name.replaceFirst('\\s*\\w+\\s+\\w+$', '') + ' ' + season + ' ' + year;


        	newOpps.add(clOp);
        }

        insert newOpps;



    }


}