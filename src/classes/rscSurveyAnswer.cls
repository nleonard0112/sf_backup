public with sharing class rscSurveyAnswer extends rscModel {

	public static Finder find = new Finder('rsc_Resettlement_Survey_Answer__c');
	private static Map<String,String> mAnswerFieldMap 
	    = new Map<String,String>{'Text'=>'Answer_Text__c',
	                             'Select'=>'Answer_Choice__c',
	                             'Multi-Select'=>'Answer_Choice__c',
	                             'Rating'=>'Answer_Number__c'
	                             };

	private String mAnswerType;

    public rscSurveyAnswer(rscSurveyQuestion q, rscSurvey s) {
        this(new rsc_Resettlement_Survey_Answer__c(
        	Resettlement_Survey_Question__c = q.getId(),
        	Resettlement_Survey__c = s.getId()

        ));

        mAnswerType = q.getType();
    }

    public void setAnswer(Object o) {
        if(mAnswerType != null) {
        	String field = mAnswerFieldMap.get(mAnswerType);
        	getObj().put(field,o);
        }
        else {
        	getObj().put(mAnswerFieldMap.get('Text'),o);
        }
    }

    public String getAnswer() {
    	if(mAnswerType != null) {
        	String field = mAnswerFieldMap.get(mAnswerType);
        	return String.valueOf(getObj().get(field));
        }
        return (String)getObj().get(mAnswerFieldMap.get('Text'));
    }

    public rscSurveyAnswer(rsc_Resettlement_Survey_Answer__c o) {
        super(o);
    }

    public rscSurveyAnswer(rscModel m) {
        this((rsc_Resettlement_Survey_Answer__c)m.getObj());
    }

	public class Finder extends rscFinder {

        public Finder(String sObjectName) {
            super(sObjectName);
        }
       
        public rscSurveyAnswer bySurveyAnswerId(Id objId) {
            return new rscSurveyAnswer(byId(objId));
        }
    }
}