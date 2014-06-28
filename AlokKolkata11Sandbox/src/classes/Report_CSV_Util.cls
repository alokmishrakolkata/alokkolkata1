global class Report_CSV_Util implements Database.Batchable<sObject>,  Database.Stateful {
	
	global final string queryStr;
	global string columnNames;
	global final map<string, string> fldLabelName_Map;
	global final string sendToAddresses;
	
	private List<Blob> blobLst;
	
	public Report_CSV_Util(string qStr, map<string, string> colNames, string toAddresses){
		
		if(colNames != null){
			fldLabelName_Map = colNames;
		}else{
			throw new MyReportException('No Column Label Name pair suplied!');	
		}

		sendToAddresses = toAddresses;
		queryStr = qStr;
		columnNames = '';
		blobLst = new List<blob>();
		if(colNames != null){
			for(String strCol : colNames.keySet()){
				if(!columnNames.trim().equals('')){
					columnNames += ',';
				}
				columnNames = columnNames + '"' + strCol + '"';
			}
		}
		columnNames += '\n';

		blobLst.add(Blob.valueOf(columnNames));
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(queryStr);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope){
     	String strRow = '';
     	for(sObject sObj : scope){
     		for(string strFldName : fldLabelName_Map.values()){
     			if(!strRow.trim().equals('')){
					strRow += ',';
				}
				strRow = strRow + '"' + sObj.get(strFldName) + '"';
     		}
     		strRow = strRow + '\n';
     	}
     	blobLst.add(Blob.valueOf(strRow));
	}

   	global void finish(Database.BatchableContext BC){
   		Blob myBIGblob = blob.valueOf(''); 
 
		// loop through list of blobs 
		for(Blob thisB:blobLst){
		  myBIGblob = blob.valueOf(myBIGblob.toString() + thisB.toString());
		} 
   		
   		
   		String[] toAddresses = sendToAddresses.split(',');
   		
   		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	   	//String[] toAddresses = new String[] {a.CreatedBy.Email};
	   	mail.setToAddresses(toAddresses);
	   	mail.setSubject('Custom Report Run ');
	   	mail.setPlainTextBody('Please find attachment!');
	   	Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
   	 	efa.setFileName('attachment.csv');
    	efa.setBody(myBIGblob);
    	mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
	   	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   		
   	}
   	
   	public class MyReportException extends Exception{
   		
   	}


//////////////////////////////////////////////////////////////////////
	public static void TestRun(){
		Map<String,String> fldLabelName_Map = new Map<String, String>();
		fldLabelName_Map.put('Name', 'Name');
		fldLabelName_Map.put('Education', 'Education__c');
		fldLabelName_Map.put('Manager', 'My_Manager__c');
		fldLabelName_Map.put('Serial No', 'S_No__c');
		
		String qryStr = 'SELECT Id, Name, Education__c, My_Manager__c, S_No__c FROM My_Candidate__c';
		string sendToAddress = 'alokmishrakolkata@gmail.com, alokmishrakolkata@gmail.com';
		
		Integer batchSize = 2; //this can be set to the optimum size like 500/700 etc
		
		Id batchInstanceId = Database.executeBatch(new Report_CSV_Util(qryStr, fldLabelName_Map, sendtoaddress), 2); 
	}

}