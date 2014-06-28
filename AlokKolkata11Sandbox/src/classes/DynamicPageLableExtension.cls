public class DynamicPageLableExtension{
    public My_Candidate__c myCandidate {get; set;}
    public string myLabel{get; set;}
    public DynamicPageLableExtension(){
        myCandidate = new My_Candidate__c();
    }
    
    public void setValue(){
        myLabel = myCandidate.Education__c;
    }
    
    public String[] getStringsVal() {
        return new String[]{'ONE','TWO','THREE'};
    }
    
}