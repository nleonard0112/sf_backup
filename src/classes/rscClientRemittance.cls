public with sharing class rscClientRemittance extends rscModel {
	
	public static Finder find = new Finder('rsc_Client_Remittance__c');

	public rscClientRemittance(rsc_Client_Remittance__c m) {
        super(m);
    }

    public rscClientRemittance(rscModel m) {
        this((rsc_Client_Remittance__c)m.getObj());
    }

    public Date getDate() {
    	return (Date) getObj().get('Date__c');
    }

    public String getCurrency() {
    	return (String) getObj().get('Currency_Type__c');
    }

    public Decimal getAmount() {
    	return (Decimal) getObj().get('Amount__c');
    }

    public void setAmountUSD(Decimal usdAmt) {
    	getObj().put('Amount_USD__c',usdAmt);
    }

    public void convertCurrencyToUSD() {
       Datetime dt = Datetime.newInstance(getDate(), Time.newInstance(0, 0, 0, 0));
       String src = getCurrency();
       Decimal amt = getAmount();
       Decimal usdAmt = rscCurrencyHelper.convertCurrency(dt, src, 'USD', amt);
       setAmountUSD(usdAmt);
    }

    public class Finder extends rscFinder {

        public Finder(String sObjectName) {
            super(sObjectName);
        }

        public rscClientRemittance byClientRemittanceId(Id rId) {
            return new rscClientRemittance(byId(rId));
        }
    }

}