public with sharing class ACETProcessFulfillmentWebservice extends ACETWebservice  {
    
    public List<String> searchParameters ;
    
    public override void GetEndpoint(){    
        GetEndpointDetail('ProcessFulfillment');
    }
    
    private void GetRequestBody(){
        
        //fr person
        RequestBody = GetRequestBody('ProcessFulfillment',searchParameters);
        
     // RequestBody= GetRequestBody('ProcessFulfillment',{"processFulfillmentRequest":{"fulfillmentRequest":{"requestHeader":{"requestID":"ACET007500","sourceID":"ACET","requestDate":"2017-05-24T06:00:53.341-05:00","requestType":"Process","businessSegmentID":"EI","marketSegmentCd":"OXF","fulfillmentType":"10700","requestCategory":"TransactionalInlinePrintReadySingleItem","dataFormat":"JSON"},"requestDetail":{"transactionalRequestDetail":{"recipient":[{"recipientId":"23831817900","idQualifier":"MemberID","deliveryMethod1":"Mailed","recipientType":"Member","person":{"firstName":"Wayne","lastName":"Baker","suffix":"Sr"},"MailToAddress":{"Address1":"5788 Merchant Center","City":"BRISTOL","State":"CT","Zip":"06011"},"ReturnToAddress":{"Address1":"Address1","City":"City","Province":"Province","PostalCD":"PostalCD","Country":"Country"},"carbonCopyInd": "false"} ],"template":{"templateID":"AnyValue", "templateName":"ADA Dental Claim Form"},"data":{"embeddedDataType":{"templateType":{"key":"formItemID","value":"9314","key":"formItemQuanity","value":"10","key":"formItemUOM","value":"Each"}}}}}}}});
    }
    
    private void GetEndpoint(String strOrgReq){ 
        
        GetEndpointDetail(strOrgReq);
    }
    
    private void GetRequestBody(String strOrgReq){
        
        //for org
        RequestBody = GetRequestBody(strOrgReq,searchParameters);
    }
    
    
    public override void GetHeaders(ISL_Webservice_Config__c OAuthConfig){
        if (WSConfigurations.containsKey('OILHttpHeaderAccept')){
            Headers.put('accept','application/json');
        }
        if (WSConfigurations.containsKey('OILHttpHeaderScope')){
            Headers.put('scope', WSConfigurations.get('OILHttpHeaderScope').Value__c);
        }
        if (WSConfigurations.containsKey('OILHttpHeaderActor')){
            Headers.put('actor', WSConfigurations.get('OILHttpHeaderActor').Value__c);
        }
        Headers.put('authorization', 'Bearer ' + OAuthConfig.Value__c);           
        Headers.put('Content-Type','application/json');
        Headers.put('timestamp', String.valueOf(system.now().millisecond()));
        Headers.put('Accept', 'application/json');
    }
    
    public ACETWSCalloutResult processRedeliveryWS(String recepientId,String idQuali,String recipientType , String memFName, String memMName, String memLName, String memSuffix, String perAdd1 , String perAdd2, String perCity , String perState ,String perZip,Material_Forms__c matform,String personOrganization, String BusinessUnit){
        
        String currentDate = system.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
        if(String.ISBlank(memMName)){
            memMName = '.'; 
        }
        if(String.ISBlank(memSuffix)){
            memSuffix = '.';    
        }
        if(String.ISBlank(perAdd2)){
            perAdd2 = '.';  
        }
        //String requestId = 'ACET'+String.valueof(system.now());
        //requestId = requestId.trim();
        //requestId = requestId.replaceAll('(\\s+)', '');
        //String requestId = 'ACET'+String.valueof(system.now()).replaceAll( '\\s+', '')
        String requestId = 'ACET'+String.valueof(currentDate);
        
        String strrequestCategory = 'TransactionalInlinePrintReadySingleItem';
       /** if(matform.Quantity__c == '1'){
            strrequestCategory = 'TransactionalInlineDataOnly';
        }else{
            strrequestCategory = 'TransactionalInlineDataOnly';
        }**/
        
      /**  if(matform.Quantity__c == '1'){
        
           strrequestCategory = 'TransactionalInlinePrintReadySingleItem';

        }**/
        
        
        if(BusinessUnit.equalsIgnoreCase('provider')){
        
            //for org
            searchParameters = new String[] {requestId,currentDate,matform.FulfillmentType__c,recepientId,idQuali,recipientType,personOrganization,'','','','7399 Transport Alley','','COLLINSVILLE','CT','06022',matform.Document_Title__c,matform.MRE__c,matform.Quantity__c,strrequestCategory};    
            
        }else{
            
            //for person
            searchParameters = new String[] {requestId,currentDate,matform.FulfillmentType__c,recepientId,idQuali,recipientType,memFName,memMName,memLName,memSuffix,perAdd1,perAdd2,perCity,perState,perZip,matform.Document_Title__c,matform.MRE__c,matform.Quantity__c,strrequestCategory,personOrganization};
        }
        
       //  searchParameters = new String[] {"processFulfillmentRequest":{"fulfillmentRequest":{"requestHeader":{"requestID":"ACET007500","sourceID":"ACET","requestDate":"2017-05-24T06:00:53.341-05:00","requestType":"Process","businessSegmentID":"EI","marketSegmentCd":"OXF","fulfillmentType":"10700","requestCategory":"TransactionalInlineDataOnly","dataFormat":"JSON"},"requestDetail":{"transactionalRequestDetail":{"recipient":[{"recipientId":"23831817900","idQualifier":"MemberID","deliveryMethod1":"Mailed","recipientType":"Member","person":{"firstName":"Wayne","lastName":"Baker","suffix":"Sr"},"MailToAddress":{"Address1":"5788 Merchant Center","City":"BRISTOL","State":"CT","Zip":"06011"},"ReturnToAddress":{"Address1":"Address1","City":"City","Province":"Province","PostalCD":"PostalCD","Country":"Country"},"carbonCopyInd": "false"} ],"template":{"templateID":"AnyValue", "templateName":"ADA Dental Claim Form"},"data":{"embeddedDataType":{"templateType":{"key":"formItemID","value":"9314","key":"formItemQuanity","value":"10","key":"formItemUOM","value":"Each"}}}}}}}});
        //searchParameters = new String[] {'{"processFulfillmentRequest":{"fulfillmentRequest":{"requestHeader":{"requestID":"ACET0354351","sourceID":"ACET","requestDate":"2017-05-24T06:00:53.341-05:00","requestType":"Process","businessSegmentID":"EI","marketSegmentCd":"OXF","fulfillmentType":"10700","requestCategory":"TransactionalInlinePrintReadyMultItem","dataFormat":"JSON"},"requestDetail":{"transactionalRequestDetail":{"recipient":[{"recipientId":"23831817900","idQualifier":"MemberID","deliveryMethod1":"Mailed","recipientType":"Member","person":{"firstName":"Wayne","lastName":"Baker","suffix":"Sr"},"MailToAddress":{"Address1":"5788MerchantCenter","City":"BRISTOL","State":"CT","Zip":"06011"},"ReturnToAddress":{"Address1":"Address1","City":"City","Province":"Province","PostalCD":"PostalCD","Country":"Country"},"carbonCopyInd":"false"}],"template":{"templateID":"AnyValue","templateName":"CMS-1500MedicalClaimForm(formerlyHCFA-1500)"},"data":{"embeddedDataType":{"formData":[{"formItemID":"childRequest_1","formItemQuantity":"1","formItemUOM":"UOM"}]}}}}}}'};
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETProcessFulFillmentJSON2Apex proFulfillment;
        try{
            if(BusinessUnit.equalsIgnoreCase('provider')){
                
                GetEndpoint('ProcessFulfillmentOrg');
            }else{
                
                GetEndpoint();
            }
            
            if(BusinessUnit.equalsIgnoreCase('provider')){
                
                GetRequestBody('ProcessFulfillmentOrg');
            }else{
                
                GetRequestBody();
            }
            
            
            HttpResponse Response = Send(OAuthConfig);
            system.debug('Respone--->'+Response.getbody());
            
            if (Response.getStatusCode() == 200){
                String ResponseBody = Response.getBody().replace('transaction', 'transaction_Z');
                
                ACETProcessFulFillmentJSON2Apex ACTProJSON2Apex = (ACETProcessFulFillmentJSON2Apex)JSON.deserialize(ResponseBody, ACETProcessFulFillmentJSON2Apex.class);
                system.debug('ACTProJSON2Apex---->'+ACTProJSON2Apex); 
                String status = String.valueof(ACTProJSON2Apex.ProcessFulfillmentRequestResult.acknowledgeMsg.acknowledge.validationResults.transaction_zLevelAck.transaction_z[0].transaction_zStatus);
                
                system.debug('transaction status---->'+status);
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = status;
               
            }
        }
        catch(Exception ex){
           system.debug(LoggingLevel.INFO, 'Exception in Process fulfillment. Details: ' + ex); 
           oACETWSCalloutResult.Success = false;
           oACETWSCalloutResult.Message = ex.getMessage();
           oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR; 
        }
         return oACETWSCalloutResult;   
    }
   
}