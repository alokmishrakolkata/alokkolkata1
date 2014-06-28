public class LicensesTabController {
    public LicensesTabController(){
        
    }
    public Pagereference reDirect(){
        string prefix = License__c.sObjectType.getDescribe().getKeyPrefix();
        string baseUrl = '/'+prefix+'?nooverride=1';
        PageReference pageRef = new PageReference(baseUrl);
        updateLicenses();
        return pageRef;
    }
    public void updateLicenses(){
        
        Organization orgDetails =[select Id from Organization limit 1];
        Id orgId = orgDetails.Id;
        PageReference pr=new PageReference('/'+orgId);
        String rawData='<div class="pbBody" id="00D90000000nBUC_RelatedUserLicenseList_body"><table class="list" border="0" cellspacing="0" cellpadding="0"><tr class="headerRow"><th scope="col" class=" zen-deemphasize">Name</th><th scope="col" class=" zen-deemphasize">Status</th><th scope="col" class="numericalColumn zen-deemphasize">Total Licenses</th><th scope="col" class="numericalColumn zen-deemphasize">Used Licenses</th><th scope="col" class="numericalColumn zen-deemphasize">Remaining Licenses</th><th scope="col" class=" zen-deemphasize">Expiration Date</th></tr><tr class=" dataRow even first" onblur="if (window.hiOff){hiOff(this);}" onfocus="if (window.hiOn){hiOn(this);}" onmouseout="if (window.hiOff){hiOff(this);}" onmouseover="if (window.hiOn){hiOn(this);}"><th scope="row" class=" dataCell  ">Salesforce Platform</th><td class=" dataCell  ">Active</td><td class=" dataCell  numericalColumn">3</td><td class=" dataCell  numericalColumn">0</td><td class=" dataCell  numericalColumn">3</td><td class=" dataCell  ">&nbsp;</td></tr>RelatedFeatureLicenseList_body';
        if(!Test.isRunningTest())
            rawData = pr.getContent().toString();
        
        rawData = rawData.subString(rawData.indexof('RelatedUserLicenseList_body'));
        rawData = rawData.subString(0,rawData.indexof('RelatedFeatureLicenseList_body'));
        
        List<License__c> usrLicenses = [Select Total_Licenses__c, Name From License__c];
        Map<String,License__c> mapUserLicenses = new Map<String,License__c>();
        for(License__c ul:usrLicenses){
            mapUserLicenses.put(ul.name,ul);
        }
        
        
        List<String> ls = new List<String>();
        
        integer isVal;
        integer index=0;
        do{
            isVal = rawData.indexOf('<th scope="row" class=" dataCell  ">');
            rawData = rawData.subString(isVal);
            String lName = rawData.subString(rawData.indexOf('>')+1,rawData.indexOf('</th>'));
            ls.add(lName);
            License__c ulNew= null;
            if(mapUserLicenses.get(lName)==null){
                ulNew = new License__c(name = lName);
                mapUserLicenses.put(lName,ulNew);
            }else{
                ulNew = mapUserLicenses.get(lName);
            }
            rawData = rawData.subString(rawData.indexOf('</th>')+5);
            
            
            rawData = rawData.subString(rawData.indexOf('<td class=" dataCell  numericalColumn">'));
            string tempString = rawData.subString(rawData.indexOf('>')+1,rawData.indexOf('</td>'));
            tempString = tempString.replace(',','');
            integer temp = Integer.valueOf(tempString);
            ulNew.Total_Licenses__c = temp;
            ls.add(rawData.subString(rawData.indexOf('>')+1,rawData.indexOf('</td>')));
            rawData = rawData.subString(rawData.indexOf('</td>')+5);
            
            rawData = rawData.subString(rawData.indexOf('<td class=" dataCell  numericalColumn">'));
            tempString = rawData.subString(rawData.indexOf('>')+1,rawData.indexOf('</td>'));
            tempString = tempString.replace(',','');
            temp = Integer.valueOf(tempString);
            ulNew.Used_Licenses__c = temp;
            rawData = rawData.subString(rawData.indexOf('</td>')+5);
            
            
            rawData = rawData.subString(rawData.indexOf('<td class=" dataCell  numericalColumn">'));
            tempString = rawData.subString(rawData.indexOf('>')+1,rawData.indexOf('</td>'));
            tempString = tempString.replace(',','');
            temp = Integer.valueOf(tempString);
            ulNew.Remaining_Licenses__c = temp;
            rawData = rawData.subString(rawData.indexOf('</td>')+5);            
            
            
            index++;
            
        }while(rawData.indexOf('<th scope="row" class=" dataCell  ">') > 0);
        
        upsert mapUserLicenses.values();
        
        system.debug('----------------------------------------------------------------------------------------------------'+ls);
        
        
    }
}