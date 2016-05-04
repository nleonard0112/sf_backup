public with sharing class rscSurvey extends rscModel {

    public static Finder find = new Finder('rsc_Resettlement_Survey__c');


	public rscSurvey() {
        this(new rsc_Resettlement_Survey__c());
    }

    public rscSurvey(rsc_Resettlement_Survey__c o) {
        super(o);
    }

    public rscSurvey(rscModel m) {
        this((rsc_Resettlement_Survey__c)m.getObj());
    }

    public void setLastQuestionNumber(Integer i) {
        getObj().put('Current_Question__c',i);
    }

    public void setStatusComplete() {
        getObj().put('Status__c','Complete');
    }

    public Integer getLastQuestionNumber() {
        
        Integer lastQuestion = (Integer)getObj().get('Current_Question__c');
    	if(lastQuestion == null || lastQuestion == 0) {
    		lastQuestion = 1;
    	}
    	return lastQuestion;
    }

    public Id getSurveyDefinitionId() {
        return (Id) getObj().get('Resettlement_Survey_Definition__c');
    }

    public class Finder extends rscFinder {

        public Finder(String sObjectName) {
            super(sObjectName);
        }
       
        public rscSurvey bySurveyId(Id objId) {
            return new rscSurvey(byId(objId));
        }
    }
}