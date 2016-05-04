public virtual with sharing class rscFinder {
    
    private Set<String> mFieldSet;
    private String mSObjectName;

    public rscFinder(){}

    public rscFinder(String sObjectName) {
        this.mSObjectName = sObjectName;
        SObjectType objToken = Schema.getGlobalDescribe().get(sObjectName);
        mFieldSet = new Set<String>(objToken.getDescribe().fields.getmap().keyset());       
    }

    public Set<String> getFieldSet() {
        return mFieldSet; 
    }

    protected String getFields() {
        return String.join(
            new List<String>(mFieldSet),',');
    }

    protected void addFields(Set<String> newFields) {
        mFieldSet.addAll(newFields);
    }
 
    protected String getSelect() {
        return 'select ' + getFields() + ' from ' + mSObjectName + ' ';
    }
 
    public virtual rscModel byId(Id recId) {
        return new rscModel(Database.query(getSelect() + 'where Id =: recId'));
    }
}