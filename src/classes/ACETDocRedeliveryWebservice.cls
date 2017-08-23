public with sharing class ACETDocRedeliveryWebservice extends ACETWebservice {
	
	public List<String> searchParameters ;
	public override void GetEndpoint(){    
        GetEndpointDetail('DocumentRedelivery');
    }
    
    private void GetRequestBody(){
        RequestBody = GetRequestBody('DocumentRedeliveryRequest',searchParameters);
    }
    
    public ACETWSCalloutResult docRedeliveryWS(String redeliveryID, String memId, String recepientType, String memFName, String memMName, String memLName, String memSuffix, String perAdd1 , String perAdd2, String perCity , String perState ,String perZip,ACETCommunicationSearchResult selComResult){
    	searchParameters = new String[] {redeliveryID,memId,recepientType,memFName,memMName,memLName,memSuffix,perAdd1,perAdd2,perCity,perState,perZip};
    	ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
    	ACETRedeliveryJSON2Apex redelivery;
    	try{
	    	GetEndpoint();
	    	GetRequestBody();
	    	HttpResponse Response = Send(OAuthConfig);
	    	system.debug('Respone--->'+Response.getbody());
	    	if (Response.getStatusCode() == 200){
	    		String ResponseBody = Response.getBody().replace('transaction', 'transaction_Z');
	    		
	    		ACETRedeliveryJSON2Apex ACTRedJSON2Apex = (ACETRedeliveryJSON2Apex)JSON.deserialize(ResponseBody, ACETRedeliveryJSON2Apex.class);
	    		selComResult.Resend_Status = String.valueof(ACTRedJSON2Apex.redeliveryDocumentResult.redeliveryDocumentResponseType.acknowledgeMsg.acknowledge.validationResults.transaction_ZLevelAck.transaction_z[0].transaction_zStatus);
	    		selComResult.Resend_Date_Time = String.valueof(ACTRedJSON2Apex.redeliveryDocumentResult.redeliveryDocumentResponseType.acknowledgeMsg.header.msgDate)+' ' +String.Valueof(ACTRedJSON2Apex.redeliveryDocumentResult.redeliveryDocumentResponseType.acknowledgeMsg.header.msgTime);
	    		
	    		oACETWSCalloutResult.Success = true;
	            oACETWSCalloutResult.Message = '';
	            oACETWSCalloutResult.Response = selComResult;
	    		
	    		system.debug('redStatus-->'+selComResult.redStatus);
	    	}
	    	
    	}catch(Exception ex){
           system.debug(LoggingLevel.INFO, 'Exception in Redelivery Letter Webservice. Details: ' + ex); 
           oACETWSCalloutResult.Success = false;
           oACETWSCalloutResult.Message = ex.getMessage();
           oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
    	return oACETWSCalloutResult;	
    }
    
}