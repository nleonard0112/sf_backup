public with sharing class rscDispenseFormController {
	private rscMissionMember mMember;

    

    public List<rsc_Supply_Allocation__c> Supplies {get; set;}

    public rscDispenseFormController(ApexPages.StandardController sc) {
        mMember = rscMissionMember.find.byMemberId((Id)sc.getId());

        Supplies = new List<rsc_Supply_Allocation__c>();

        for(rsc_Supplies__c s : [select Id,Name,Dispense_Amount__c from rsc_Supplies__c where Inactive__c = false order by Name]) {
           
            rsc_Supply_Allocation__c sa = new rsc_Supply_Allocation__c();
            sa.Quantity__c = s.Dispense_Amount__c;
            sa.Client__c = mMember.getId();
            sa.Supplies__c = s.Id;
        	Supplies.add(sa);

        }
    }

    public PageReference doDispense() {
        insert Supplies;
        return new PageReference('/' + mMember.getId());
    }

    public PageReference doCancel() {
        return new PageReference('/' + mMember.getId());
    }
      
}