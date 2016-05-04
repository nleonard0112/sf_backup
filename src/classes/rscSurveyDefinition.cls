public with sharing class rscSurveyDefinition extends rscModel {

    public static Finder find = new Finder('rsc_Resettlement_Survey_Definition__c');


	public rscSurveyDefinition() {
        this(new rsc_Resettlement_Survey_Definition__c());
    }

    public rscSurveyDefinition(rsc_Resettlement_Survey_Definition__c o) {
        super(o);
    }

    public Integer getNumberOfQuestions() {
    	 return Integer.valueOf(getObj().get('Number_of_Questions__c'));
    }

    public rscSurveyDefinition(rscModel m) {
        this((rsc_Resettlement_Survey_Definition__c)m.getObj());
    }

    public class Finder extends rscFinder {

        public Finder(String sObjectName) {
            super(sObjectName);
        }
       
        public rscSurveyDefinition bySurveyDefinitionId(Id objId) {
            return new rscSurveyDefinition(byId(objId));
        }
    }
}