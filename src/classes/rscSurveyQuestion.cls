public with sharing class rscSurveyQuestion extends rscModel {

    public static Finder find = new Finder('rsc_Resettlement_Survey_Question__c');

    public rscSurveyQuestion() {
        this(new rsc_Resettlement_Survey_Question__c());
    }

    public String getQuestionText() {
    	return (String)getObj().get('Question__c');
    }

    public Integer getQuestionNumber() {
    	return Integer.valueOf(getObj().get('Question_Number__c'));
    }

     public String getSectionName() {
    	return (String)getObj().get('Section_Name__c');
    }

    public List<String> getPossibleAnswers() {
    	return ((String)getObj().get('Possible_Answers__c')).split(';');
    }

    public String getType() {
    	return (String)getObj().get('Answer_Type__c');
    }

    public Boolean getIsRatingType() {
    	return getType() == 'Rating';
    }

    public Boolean getIsMultiselectType() {
    	return getType() == 'Multi-Select';
    }

    public Boolean getIsSelectType() {
    	return getType() == 'Select';
    }

    public Boolean getIsTextType() {
    	return getType() == 'Text';
    }

    public rscSurveyQuestion(rsc_Resettlement_Survey_Question__c o) {
        super(o);
    }

    public rscSurveyQuestion(rscModel m) {
        this((rsc_Resettlement_Survey_Question__c)m.getObj());
    }

    public class Finder extends rscFinder {

        public Finder(String sObjectName) {
            super(sObjectName);
        }
       
        public rscSurveyQuestion bySurveyQuestionNumber(Integer qNumber) {
            return new rscSurveyQuestion(Database.query(getSelect() + 'where Question_Number__c =: qNumber and Inactive__c = false'));
        }
    }


}