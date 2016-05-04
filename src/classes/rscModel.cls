public virtual class rscModel {
    
    protected sObject mObj {get; set;}

    public rscModel(sObject obj) {
        mObj = obj;
    }

    public Id getId(){
        return mObj.Id;
    }

    public virtual String getName() {
        return (String) mObj.get('Name');
    }

    public sObject getObj() {
        return mObj;
    }

    public virtual void save() {
        upsert mObj;
    }

    public virtual void destroy() {
        delete mObj;
    }

    public static void destroy(List<rscModel> modelList) {
        List<sObject> deleteList = new List<sObject>();
        for (rscModel tempModel : modelList) {
                deleteList.add(tempModel.getObj());
        }
        delete deleteList;
    }

    public static void save(List<rscModel> modelList) {
        List<sObject> updateList = new List<sObject>();
        List<sObject> insertList = new List<sObject>();
        for (rscModel tempModel : modelList) {
            if(tempModel.getId() != null) {
                updateList.add(tempModel.getObj());
            } else {
                insertList.add(tempModel.getObj());
            }
        }
        insert insertList;
        update updateList;
    }

}