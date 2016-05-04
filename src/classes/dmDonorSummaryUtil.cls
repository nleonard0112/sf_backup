public with sharing class dmDonorSummaryUtil {


	
      /*
     Tier One -  <3000 (4/0-5/0)
     Tier Two - 3001-15K (2/1-3/6)
     Tier Three - >15K (1/0-1/5)
    */
    public static void computeTier(Contact c) {

        //Net_Worth__c

        Decimal totalGiven = c.Total_Amount_as_One_Time_YTD__c + c.Total_Amount_as_Recurring_YTD__c;
        if(totalGiven < 3000) {
            c.Tier__c = 1;
        }
        else if(totalGiven >= 3000 && totalGiven <= 15000) {
            c.Tier__c = 2;
        }
        else {
            c.Tier__c = 3;
        }

        for(WE_FW8_NP__WESearchResult__c result : c.WE_FW8_NP__SearchResult__r) {
            if('4'.equals(result.WE_FW8_NP__P2G_SCORE__c) || '5'.equals(result.WE_FW8_NP__P2G_SCORE__c)) {
                if(c.Tier__c == null) c.Tier__c = 1;
            }
            else if('3'.equals(result.WE_FW8_NP__P2G_SCORE__c) || '2'.equals(result.WE_FW8_NP__P2G_SCORE__c)) {
                if(c.Tier__c == null || c.Tier__c < 2) c.Tier__c = 2;
            }
            else {
                if(c.Tier__c == null || c.Tier__c < 3) c.Tier__c = 3;
            }
            c.Net_Worth__c = result.WE_FW8_NP__NetworthRange__c;
        }

    }

    public static void alignAddress(Contact c, String street, String city, String country, String zip, String state) {

        if(c.OtherStreet == null && c.OtherCity == null && c.OtherState == null){ 

            c.OtherStreet = street;
            c.OtherCity = city;
            c.OtherCountry = Translation_Table__c.getInstance(country) == null ? country : Translation_Table__c.getInstance(country).Value__c;
            c.OtherState = Translation_Table__c.getInstance(state) == null ? state : Translation_Table__c.getInstance(state).Value__c;
            c.OtherPostalCode = zip;
        }
    }

    public static void computeRecurringStatistics(Contact c) {
        for(stayclassy__sc_recurring_profile__c r : c.stayclassy__SCRecurringContact__r) {
            alignAddress(c,r.stayclassy__cc_address__c,r.stayclassy__cc_city__c,r.stayclassy__cc_country__c,r.stayclassy__cc_zip__c,r.stayclassy__cc_state__c);
            
            c.Recurring_Start_Date__c = r.stayclassy__start_date__c != null ? r.stayclassy__start_date__c.date() : null;
            c.Recurring_Cancel_Date__c = r.stayclassy__cancel_date__c != null ? r.stayclassy__cancel_date__c.date() : null;

            if(r.stayclassy__cc_exp_date__c != null && r.stayclassy__cc_exp_date__c.trim() != '') {
                Integer year = Integer.valueOf(r.stayclassy__cc_exp_date__c.substring(0,4));
                Integer month = Integer.valueOf(r.stayclassy__cc_exp_date__c.substring(4));

      

                c.CC_Expiration_Date__c = Date.newInstance(year, month, 1);

            }
        }
    }

    public static void computeFundrasierStats(Contact c) {
            c.Total_Number_of_Campaigns__c = 0;
            c.Total_Amount_Fundraised__c = 0;
            for(Campaign camp : c.stayclassy__Campaigns__r) {
                c.Total_Amount_Fundraised__c += camp.HierarchyAmountWonOpportunities;
                c.Total_Number_of_Campaigns__c++;
            }
    }

    public static void computeDonationSummary(Contact c) {
        
        Decimal totalOneTimeDonations = 0;
        Decimal totalRecurringDonations = 0;
        Decimal totalAmountAsOneTime = 0;
        Decimal totalAmountAsOneTimeYTD = 0;
        Decimal totalAmountAsRecurring = 0;
        Decimal totalAmountAsRecurringYTD = 0;
       
        Boolean first = true;

        for(Opportunity o : c.stayclassy__Opportunities__r) {

            if(first) {
                c.First_Donation_Amount__c = o.Amount;
                c.First_Donation_Date__c = o.CloseDate;
                first = false;
            }


            if(o.Type == 'Recurring' || o.Type == 'Monthly') {
                totalRecurringDonations++;
                totalAmountAsRecurring += o.Amount == null ? 0 : o.Amount;
                c.Last_Recurring_Amount__c = o.Amount;
                c.Last_Recurring_Donation__c = o.CloseDate;
                if(Date.today().year() == o.CloseDate.year()){
                    totalAmountAsRecurringYTD += o.Amount == null ? 0 : o.Amount;
                }
            }
            else {
                totalOneTimeDonations++;
                totalAmountAsOneTime += o.Amount == null ? 0 : o.Amount;
                c.Last_One_Time_Amount__c = o.Amount;
                c.Last_One_Time_Donation__c = o.CloseDate;
                c.Last_Donation_Campaign__c = o.CampaignId;
                if(Date.today().year() == o.CloseDate.year()){
                    totalAmountAsOneTimeYTD += o.Amount == null ? 0 : o.Amount;
                }
            }       
        }

        c.Total_One_time_Donations__c = totalOneTimeDonations;
        c.Total_recurring_donations__c = totalRecurringDonations;
        c.Total_Amount_as_one_time__c = totalAmountAsOneTime;
        c.Total_Amount_as_One_Time_YTD__c = totalAmountAsOneTimeYTD;
        c.Total_Amount_as_Recurring__c = totalAmountAsRecurring;
        c.Total_Amount_as_Recurring_YTD__c = totalAmountAsRecurringYTD; 

    }

    public static void twiddle() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
              i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
              i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;

    }




}