public class ACETGetDocWebservice extends ACETWebservice{
    
    public override void GetEndpoint()
    {
        GetEndpointDetail('getDocument');
    }
    
    public override void GetMethod(){
        Method = 'POST';
    }
    
    public override void GetHeaders(ISL_Webservice_Config__c OAuthConfig){
        
        Headers.put('accept','multipart/form-data' );
        
        if (WSConfigurations.containsKey('OILHttpHeaderScope')){
            Headers.put('scope', WSConfigurations.get('OILHttpHeaderScope').Value__c);
        }
        if (WSConfigurations.containsKey('OILHttpHeaderActor')){
            Headers.put('actor', WSConfigurations.get('OILHttpHeaderActor').Value__c);
        }
        Headers.put('Content-Type', 'application/json;charset=UTF-8');
        Headers.put('userName', 'oil_docu_1');
        system.debug('OAuthConfig.Value__c is '+OAuthConfig.Value__c);
        Headers.put('authorization', 'Bearer ' + OAuthConfig.Value__c);
    }
    
    public void GetRequestBody(){
        RequestBody = GetRequestFormatByName('getDocumentpdf_HardcodedRequest');
        system.debug('RequestBody is '+RequestBody);
    }
    
    public void GetRequestBody(String repositoryId, String documentId){
    	RequestBody = '';
		RequestBody += '{';
		RequestBody +=    '"getDocument": {';
		RequestBody +=        '"getDocumentRequest": {';
		RequestBody +=             '"repositoryId": "' + repositoryId + '",';
		RequestBody +=             '"documentId": "' + documentId + '"';
		RequestBody +=        '}';
		RequestBody +=	  '}';
		RequestBody += '}';
    }
    
    public ACETWSCalloutResult fetchDocument(String repositoryId, String documentId){        
        ACETWSCalloutResult result = new ACETWSCalloutResult();
        try{
            GetEndpoint();
            GetRequestBody(repositoryId, documentId);
            GetMethod();
            HttpResponse Response = Send(OAuthConfig);
            
            String b = Response.getBody();
            system.debug('body string:');
            system.debug(b);
            
            //blob value = Response.getBodyAsBlob();                        
            //string val = EncodingUtil.base64Encode(value);
            
            //system.debug('Response string is '+val);
            //oACETWSCalloutResult.Success = true;
            //oACETWSCalloutResult.Message = val;
            result.Attach = new Attachment();
            result.Attach.body = Response.getBodyAsBlob();
            
            /**
            Temp_Document__c td = new Temp_Document__c();
            insert td;
            Attachment a = new Attachment();
            a.Name = documentId;
            a.parentId = td.Id;
            a.body = Response.getBodyAsBlob();
            insert a;
            */
            
            //system.debug('oACETWSCalloutResult.Attach.body is '+oACETWSCalloutResult.Attach.body);
            //oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            //system.debug('Response.getBodyAsBlob() is'+Response.getBodyAsBlob());
            //system.debug('Status code is '+Response.getStatusCode()+'body is '+Response.getBody());
        }
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in getDocument Webservice,Message: ' + ex.getMessage()+'at line '+ex.getLineNumber()); 
            //oACETWSCalloutResult.Success = false;
            //oACETWSCalloutResult.Message = ex.getMessage();
            //oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        return result;
    }       
}