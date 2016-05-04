public with sharing class dmTaxReceiptController {
	
	public List<Opportunity> donations {get; set;}

    public Decimal amount {get; set;}
    public String email {get; set;}
    public String name  {get; set;}
    public Integer year {get; set;}

	public dmTaxReceiptController() {
		email = ApexPages.currentPage().getParameters().get('email');
		name = ApexPages.currentPage().getParameters().get('name');
		year = ApexPages.currentPage().getParameters().get('year') == null ? Date.today().year() : Integer.valueOf(ApexPages.currentPage().getParameters().get('year'));
		Id contactId = ApexPages.currentPage().getParameters().get('id');
		amount = 0;
		donations = [select Id,Name,CloseDate,Amount,stayclassy__sc_order_id__c,stayclassy__Campaign__r.Name 
		             from Opportunity where (stayclassy__sf_contact_id__c =: contactId) AND (CALENDAR_YEAR(CloseDate) =: year)];
		for(Opportunity o : donations) {
			amount += o.Amount;
		}
		
	}
}