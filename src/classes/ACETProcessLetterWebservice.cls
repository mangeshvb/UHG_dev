public class ACETProcessLetterWebservice extends ACETWebservice {
	
	public List<String> SearchParameters ;
	
	public override void GetEndpoint(){
    	GetEndpointDetail('ProcessLetter');
    }
    private void GetRequestBody(){
    	RequestBody = GetRequestBody('ProcessLetterRequest',SearchParameters);
    }
    
    public ACETWSCalloutResult ProcessLetterWS(String workItemId, String processName){
    	SearchParameters = new String[] {workItemId,processName};
    	ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
    	try{
           GetEndpoint();
           GetRequestBody();
           GetMethod();
           HttpResponse Response = Send(OAuthConfig);
           if (Response.getStatusCode() == 200){
           	   oACETWSCalloutResult.Success = true;
               oACETWSCalloutResult.Message = '';
           }
    	}
    	catch(Exception ex){
           system.debug(LoggingLevel.INFO, 'Exception in Process Letter Webservice. Details: ' + ex); 
           oACETWSCalloutResult.Success = false;
           oACETWSCalloutResult.Message = ex.getMessage();
           oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug('oACETWSCalloutResult-->'+oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
    
}