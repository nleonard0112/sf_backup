public with sharing class dmDonorMatchPDFController {
	
    public rsc_Client__c client {get; set;}
    public dm_Donor_Match__c donorMatch {get; set;}
    public String attachmentId {get; set;}

    public String getPhoto() {
        return client.Gender__c == 'Male' ? 'man.png' : 'woman.png';
    }

    public String getHimHer() {
        return client.Gender__c == 'Male' ? 'him' : 'her';
    }

    public String getHeShe() {
        return client.Gender__c == 'Male' ? 'he' : 'she';
    }

    public String getHisHer() {
        return client.Gender__c == 'Male' ? 'his' : 'her';
    }

    public Boolean getTraveledWithFamily() {
        return 'Yes' == client.Traveled_With_Family__c;
    }

    public Boolean getReunitedWithFamily() {
        return 'Yes' == client.Reunited_With_Family__c;
    }

    public Boolean getBornNorthKorea() {
        return 'North Korea' == client.Birth_Country__c;
    }

    public Boolean getBornChina() {
        return 'China' == client.Birth_Country__c;
    }

	public dmDonorMatchPDFController() {

		Id donorMatchID = ApexPages.currentPage().getParameters().get('id');

        donorMatch = [select Client__c, Donor__r.Name,Donor_Thank__c from dm_Donor_Match__c where Id =: donorMatchID];
        
        client = [select Id, Age__c,Gender__c,
                         Reunited_With_Family__c,
                         Traveled_With_Family__c,
                         Birth_Country__c,
                         Public_Story__c,Media_Name__c from rsc_Client__c where Id =: donorMatch.Client__c];

		
	}
}