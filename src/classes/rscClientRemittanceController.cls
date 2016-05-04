public with sharing class rscClientRemittanceController  {

    private rscClientRemittance mRemittance;

	public rscClientRemittanceController(ApexPages.StandardController sc)  {
		mRemittance = rscClientRemittance.find.byClientRemittanceId(sc.getId());
	}

	public PageReference convertCurrency() {

		mRemittance.convertCurrencyToUSD();
		mRemittance.save();
        PageReference pg = new PageReference('/'+mRemittance.getId());
        pg.setRedirect(true);
		return pg;
	}
	
	
}