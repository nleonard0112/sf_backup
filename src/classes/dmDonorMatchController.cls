public with sharing class dmDonorMatchController {

	private Id donorMatchId;
	
	public dmDonorMatchController(ApexPages.StandardController sc) {
        donorMatchId = sc.getId();
	}

	public PageReference generateThanks() {
		PageReference pg = new PageReference('/' + donorMatchId);
		pg.setRedirect(true);
        
        PageReference pdf = new PageReference('/apex/dmDonorMatchPDFNew');
        pdf.getParameters().put('id',donorMatchId);

        dm_Donor_Match__c donorMatch = [select Client__c, Donor__r.Name,Donor_Thank__c from dm_Donor_Match__c where Id =: donorMatchId];
        rsc_Client__c client = [select Id, Age__c,Public_Story__c,Media_Name__c from rsc_Client__c where Id =: donorMatch.Client__c];

        String fileName = 'Matching_' + client.Media_Name__c + '_' + donorMatch.Donor__r.Name;
        fileName = fileName.replace(' ', '_');
        fileName = fileName.replaceAll('[\'-+.^:,]','_');
        fileName += '_DEVELOPMENT_CONFIDENTIAL.pdf';
       
        insert new Attachment(
            Body = pdf.getContentAsPDF(),
            Name = fileName,
            ParentId = donorMatchId
        );
		return pg;

	}


}