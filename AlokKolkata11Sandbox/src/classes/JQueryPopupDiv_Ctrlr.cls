global class JQueryPopupDiv_Ctrlr {
	// ApexPages.StandardSetController must be instantiated
    // for standard list controllers
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Id, Name FROM My_Candidate__c]));
            }
            return setCon;
        }
        set;
    }

    // Initialize setCon and return a list of records
    public List<My_Candidate__c> getCandidates() {
        return (List<My_Candidate__c>) setCon.getRecords();
    }
    
    webService static string retrieveRecord(String strId){
    	String retStr = '';
    	List<My_Candidate__c> curCandidate = [SELECT Id, Name, Education__c, My_Manager__c
    										  FROM My_Candidate__c WHERE Id =: strId];
    	if(curCandidate != null && curCandidate.size() > 0){
    		retStr = Json.serialize(curCandidate[0]);
    	}
    	return retStr;
    }
}