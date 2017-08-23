Public Class ACETCreateLetterWebservice extends ACETWebservice{
    
    Public String body{get;set;}
    Private final static string Boundary = '1ff13444ed8140c7a32fc4e6451aa76d';
    public String XMLattach{get;set;}
       
    public override void GetEndpoint(){
        GetEndpointDetail('CreateLetter');
    }
    
    private void GetRequestBody(String templatename){
        
        String testXML = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><data><datum name="CaseID">00011122C</datum></data>';   
        Blob beforeblob = Blob.valueOf(XMLattach);
        Blob bodyBlob = null;
        body = EncodingUtil.base64Encode(beforeblob);
        
        List<String> SearchParameters = new String[] {body,templatename};
        String header = '--'+boundary+'\nContent-Disposition: form-data; \nContent-Type: application/json';
        String footer = '--'+boundary+'--';             
        
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        while(headerEncoded.endsWith('=')){
            header+=' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        }
        
        String bodyEncoded = EncodingUtil.base64Encode(Blob.valueOf(GetRequestBody('CreateLetter_HardcodedRequest',SearchParameters))); 
        
        String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
           
        if(last4Bytes.endsWith('==')) {
            
            last4Bytes = last4Bytes.substring(0,2) + '0K';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        
        } else if(last4Bytes.endsWith('=')) {
        
            last4Bytes = last4Bytes.substring(0,3) + 'N';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            footer = '\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);              
        
        } else {
    
            footer = '\r\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);  
        }
        System.debug('RequestBody ********' + RequestBody);
        RequestBody = bodyBlob.toString();
        // Debug added by Pavan
        System.debug('RequestBody ********' + RequestBody);
    }
    
    public override void GetMethod(){
        Method = 'PUT';
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
        Headers.put('authorization', 'Bearer ' + OAuthConfig.Value__c);           
        Headers.put('mediatype', 'application/json');
        Headers.put('Content-Disposition', 'form-data; name="json"');
        Headers.put('Content-Type','multipart/form-data; charset="UTF-8"; boundary="' + Boundary + '"');
        Headers.put('MIME-Version','1.0');
        Headers.put('timestamp', String.valueOf(system.now().millisecond()));
    }
    
    public ACETWSCalloutResult CreateLetterWS(String attachXML,String templatename){
       XMLattach = attachXML; 
       ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
       ACETCreateLetterResult letterInfo = new ACETCreateLetterResult();
       try{
           GetEndpoint();
           GetRequestBody(templatename);
           GetMethod();
           HttpResponse Response = Send(OAuthConfig);
           system.debug('Respone--->'+Response.getBody());
           if (Response.getStatusCode() == 200){
               ACETCreateLetterJSON2Apex ACETCLJSON2Apex = (ACETCreateLetterJSON2Apex)JSON.deserialize(Response.getBody(), ACETCreateLetterJSON2Apex.class);
               system.debug('ACETCLJSON2Apex ****'+ ACETCLJSON2Apex );
               letterInfo.resultLetterId  = String.valueof(ACETCLJSON2Apex.createLetterResult.letterId); 
               
               oACETWSCalloutResult.Success = true;
               oACETWSCalloutResult.Message = '';
               oACETWSCalloutResult.Response = letterInfo;
               system.debug('letterInfo---->'+letterInfo);
               
           }
       }
       Catch(Exception ex){
           system.debug(LoggingLevel.INFO, 'Exception in Create Letter Webservice. Details: ' + ex); 
           oACETWSCalloutResult.Success = false;
           oACETWSCalloutResult.Message = ex.getMessage();
           oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        //system.debug('**oACETWSCalloutResult**'+oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }


}