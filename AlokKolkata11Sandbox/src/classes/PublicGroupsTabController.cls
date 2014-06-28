public class PublicGroupsTabController {
    public Pagereference reDirect(){
        PublicGroupHelper.updateUserGroups();
        string prefix = User_Groups__c.sObjectType.getDescribe().getKeyPrefix();
        string baseUrl = '/'+prefix+'?nooverride=1';
        PageReference pageRef = new PageReference(baseUrl);
        return pageRef;
    }
    public PublicGroupsTabController(){} 
}