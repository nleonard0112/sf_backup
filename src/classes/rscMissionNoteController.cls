public with sharing class rscMissionNoteController {

	private List<rsc_Mission_Notes__c> mNotes;
	private rsc_Mission_Notes__c mNote;

	private Integer index = 0;
     
	public rscMissionNoteController(ApexPages.StandardController sc) {
 
        mNote = [select Id,Mission__c from rsc_Mission_Notes__c where Id =: sc.getId()];  
	    mNotes = [select Id from rsc_Mission_Notes__c where Mission__c =: mNote.Mission__c order by CreatedDate];

	    for(Integer i = 0; i < mNotes.size(); i++) {
	    	if(mNotes[i].Id != mNote.Id) {
	    		index++;
	    	}
	    	else {
	    		break;
	    	}
	    }	
	}

	public PageReference gotoNext() {
        return new PageReference('/' + mNotes[Math.mod(index + 1, mNotes.size()) ].Id);
	}

	public PageReference gotoPrev() {
		return new PageReference('/' + mNotes[Math.mod(Math.abs(index - 1), mNotes.size()) ].Id);
	}
}