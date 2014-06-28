public with sharing class CustomSettingLoader {
	Map<String, Map<String, PropertyHolder>> propHoldMap ;
	
	public CustomSettingLoader(){
		propHoldMap = new Map<String, Map<String, PropertyHolder>>();
		
		//load all the Custom Settings & prepare the map
		prepareAndLoadSettigMap();
		
	}
	
	
	public void prepareAndLoadSettigMap(){
		//load all the Custom Settings 
		List<My_Settings__c> csLst = My_Settings__c.getAll().values();
		Map<String, PropertyHolder> catMap;
		PropertyHolder propHoldObj;
		//now prepare map out of the custrom settign 
		for(My_Settings__c csObj : csLst){
			if(propHoldMap.containsKey(csObj.Section__c)){
				catMap = propHoldMap.get(csObj.Section__c);
			}else{
				catMap = new Map<String, PropertyHolder>();
				propHoldMap.put(csObj.Section__c, catMap);
			}
			
			if(!catMap.containsKey(csObj.Sub_Section__c)){
				propHoldObj = new PropertyHolder(csObj.Type__c, csObj.Value__c);
				catMap.put(csObj.Sub_Section__c, propHoldObj);
			}
		}
	}
	
	
	//method to get the value
	
	public Decimal getNumericValue(String section, String subSection){
		
		PropertyHolder propHoldObj = sectionSubSectionExits(section, subSection);
		
		
		Decimal retVal = Decimal.valueOf('-9999');
		if(null != propHoldObj){
            System.debug('1');
			if(propHoldObj.sType.equals('Numeric')){
				System.debug('2 : ' +  propHoldObj.sVal.trim().replace('.','').isNumeric() + ' : ' + propHoldObj.sVal.trim());
                if(propHoldObj.sVal.trim().isNumeric()){
                    System.debug('3');
					retVal = decimal.valueOf(propHoldObj.sVal);
				}
			}
		}
		return retVal;
	}
		
	public string getStringValue(String section, String subSection){
		String retVal = '';
		PropertyHolder propHoldObj = sectionSubSectionExits(section, subSection);
		if(null != propHoldObj){
			retVal =propHoldObj.sVal;
		}
		return retVal;
	}
	
	public PropertyHolder sectionSubSectionExits(String section, String subSection){
		PropertyHolder propHoldObj = null;
		if(propHoldMap.containsKey(section)){
			Map<String, PropertyHolder> catMap = propHoldMap.get(section);
			
			if(catMap.containsKey(subSection)){
				propHoldObj = catMap.get(subSection);
			}		
		}
		return propHoldObj;
	}
	
	////////////////////////////////////////////////////////////////////////////////
	
	class PropertyHolder{
		
		//Number : Text
		public String sType {get; set;}
		public String sVal {get; set;}
		//Type dType ;
		
		public PropertyHolder(String sType, String sVal){
			this.sVal = sVal;
			this.sType = sType;
		}
	}
	
}