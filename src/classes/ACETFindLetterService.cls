public class ACETFindLetterService extends ACETWebservice {

    public List<String> SearchParameters ;
	
	public override void GetEndpoint(){
    	GetEndpointDetail('FindLetter');
    }
    private void GetRequestBody(){
    	RequestBody = GetRequestBody('FindLetterRequest',SearchParameters);
    }
    
    public override void GetMethod(){
        Method = 'POST';
    }
    
    public override void GetHeaders(ISL_Webservice_Config__c OAuthConfig){
        if (WSConfigurations.containsKey('OILHttpHeaderAccept')){
            Headers.put('accept',WSConfigurations.get('OILHttpHeaderAccept').Value__c );
        }
        if (WSConfigurations.containsKey('OILHttpHeaderScope')){
            Headers.put('scope', WSConfigurations.get('OILHttpHeaderScope').Value__c);
        }
        if (WSConfigurations.containsKey('OILHttpHeaderActor')){
            Headers.put('actor', WSConfigurations.get('OILHttpHeaderActor').Value__c);
        }
        Headers.put('Content-Type', 'application/json;charset=UTF-8');
        system.debug('OAuthConfig.Value__c is '+OAuthConfig.Value__c);
        Headers.put('authorization', 'Bearer ' + OAuthConfig.Value__c);
    }
    
    public ACETWSCalloutResult FindLetterWS(String workItemId){
    	SearchParameters = new String[] {workItemId};
    	ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
    	try{
           GetEndpoint();
           GetRequestBody();
           GetMethod();
           HttpResponse Response = Send(OAuthConfig);
           if (Response.getStatusCode() == 200){
               String responsebody = Response.getBody();
               responsebody = responsebody.replace('Content-ID', 'ContentID');
               responsebody = responsebody.replace('Content-Type', 'ContentType');
               responsebody = responsebody.replace('object', 'object_Z');
               responsebody = responsebody.replace('date', 'dates');
               //responsebody = responsebody.replace('type', 'type_Z');
               //responsebody = responsebody.replace('subtype_Z', 'subtype');
               system.debug('responsebody is '+responsebody);
               ACETFindLetterJSON2Apex FLjson2apex = (ACETFindLetterJSON2Apex)JSON.deserializeStrict (responsebody, ACETFindLetterJSON2Apex.class);
               system.debug('FLjson2apex is '+FLjson2apex);
               ACETFindLetterResult result = new ACETFindLetterResult();
               result.Status = FLjson2apex.MultipartBody.rootAttachment.object_Z.workItems.letterWorkItem[0].status;
           	   oACETWSCalloutResult.Success = true;
               oACETWSCalloutResult.Message = result.Status;
           }
    	}
    	catch(Exception ex){
           system.debug(LoggingLevel.INFO, 'Exception in Find Letter Webservice. Details: ' + ex+'line '+ex.getLineNumber()); 
           oACETWSCalloutResult.Success = false;
           oACETWSCalloutResult.Message = 'Exception in Find Letter Webservice. Details: '+ex.getMessage();
           oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug('oACETWSCalloutResult-->'+oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
}