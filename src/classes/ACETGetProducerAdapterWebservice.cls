public class ACETGetProducerAdapterWebservice extends ACETWebservice
{
    public ACETProducerResult producerDetailresult { get; set;}
    public List<ACETProducerResult.ACETProducerDemography> addressDemographics { set; get;}
    public override void GetEndpoint()
    {
        GetEndpointDetail('GetProducerEndpoint');
    }
    
    private void GetRequestBody(String ProducerId)
    {
        RequestBody = '{"request": {'+
                            '"serviceAttributes": {'+
                                    '"applicationIdentifier": "ACET",'+
                                    '"requestIdentifier": "74a0a206-7fbb-4568-ad39-5de31abb6db3"'+
                             '},'+
                              '"getProducerRequest": {'+
                                 '"producerID":"'+ProducerId+'",'+
                                 '"memberGroupNumber": "",'+ 
                                 '"producerEffectiveAsofdate":"",'+   //'+currentDate+'
                                 '"legacyBrokerCode": ""'+
                            '}'+
                            '}}';
        System.debug('Request Body Json'+RequestBody);                       
            
    }
    
    public ACETProducerResult parseSuccessAdapterResponse(String ResponseBody)
    {
        producerDetailresult = new ACETProducerResult(); 
        producerDetailresult.addressInfo= new ACETProducerResult.ACETProducerDemography();
        producerDetailresult.addresslist = new  list<ACETProducerResult.ACETProducerDemography>();
        ACETGetProducerAdapterJSON2Apex.cls_getProducerResponse PDDetails; 
        ACETGetProducerAdapterJSON2Apex ACTGPJSON2Apex = (ACETGetProducerAdapterJSON2Apex)JSON.deserialize(ResponseBody, ACETGetProducerAdapterJSON2Apex.class);
        PDDetails = ACTGPJSON2Apex.response.getProducerResponse;
        generalProducerMapping(PDDetails);
        return producerDetailresult;
    } 
      private void generalProducerMapping(ACETGetProducerAdapterJSON2Apex.cls_getProducerResponse PDDetails)
      {
        try{
        system.debug('response for getproducers======='+PDDetails);
        if(PDDetails != null)
        {
                        producerDetailresult = new ACETProducerResult();                                             
                        producerDetailresult.ProducerID = (PDDetails.producerID != null)?PDDetails.producerID:'';
                        producerDetailresult.CompanyName =(PDDetails.producerCompanyName != null)?PDDetails.producerCompanyName:'';
                        producerDetailresult.LastName =(PDDetails.producerName.lastName != null)?PDDetails.producerName.lastName:'';
                        producerDetailresult.FirstName =(PDDetails.producerName.firstName != null)?PDDetails.producerName.firstName:'';
                        producerDetailresult.MiddleInitial =(PDDetails.producerName.middleInitial != null)?PDDetails.producerName.middleInitial:'';
                        producerDetailresult.legacyBrokerCode =( PDDetails.legacyBrokerCode != null)?PDDetails.legacyBrokerCode:''; 
                        producerDetailresult.primaryContactName =(PDDetails.producerContact != null)?PDDetails.producerContact:''; 
                        producerDetailresult.tax_SSN = (PDDetails.producerSSN != null)?PDDetails.producerSSN:'';
                        system.debug('typeeeeeeeeeeeeeeeeeeeee==='+PDDetails.etype); 
                        producerDetailresult.type = (PDDetails.etype != null)?PDDetails.etype:'';                          
                        producerDetailresult.tax_id = (PDDetails.producerTIN != null)?PDDetails.producerTIN:'';
                        producerDetailresult.ProducerType =(PDDetails.producerType != null)?PDDetails.producerType:'';
                        producerDetailresult.producerEffectiveStartDate =(PDDetails.producerEffectiveStartDate != null)?PDDetails.producerEffectiveStartDate :'';
                        producerDetailresult.producerEffectiveEndDate =(PDDetails.producerEffectiveEndDate != null)?PDDetails.producerEffectiveEndDate :'';
          
                        if(PDDetails.producerType != null)
                        {
                           if(PDDetails.producerType == 'I ')
                           {
                               producerDetailresult.taxSSNType = 'SSN';                          
                           }
                           else if(PDDetails.producerType == 'B ')
                           {
                               producerDetailresult.taxSSNType = 'TIN';
                           }
                        }
                        else
                        {
                           producerDetailresult.taxSSNType = '';
                        }
                                               
        }
        
        if(PDDetails.producerAddress != null)
        {
          
           ACETGetProducerAdapterJSON2Apex.cls_producerAddress demographics  = new ACETGetProducerAdapterJSON2Apex.cls_producerAddress();
           demographics = PDDetails.producerAddress;
           system.debug('Producer Address======'+demographics);
            producerDetailresult.addresslist = new  list<ACETProducerResult.ACETProducerDemography>();
                ACETProducerResult.ACETProducerDemography address = new ACETProducerResult.ACETProducerDemography();
                address.addressType = (demographics.addressTypeCode != null)?demographics.addressTypeCode:'';
                address.streetAddress = ((demographics.addressLine1 != null)?demographics.addressLine1:'')+''+((demographics.addressLine2 != null)?demographics.addressLine2:'');            
                address.city =(demographics.city != null)?demographics.city:'';               
                address.State  =(demographics.state != null)?demographics.state:'';  
                address.zip= (demographics.zipCode != null)?demographics.zipCode:'';
                address.phone =(demographics.phoneNumber != null)?demographics.phoneNumber:'';
                address.country =(demographics.country != null)?demographics.country:'';
                producerDetailresult.addresslist.add(address);
        }
        
        } catch(Exception ex){
                  system.debug(LoggingLevel.INFO, 'Issues in general producer detail' + ex);                 
                }
           
      }
    
    // Adding the changes for continuation webservice call
    public Continuation StartRequest(string producerId, String CallbackMethodName, Continuation oContinuation)
    {
        GetEndpoint();
        GetRequestBody(producerId);          
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        return oContinuation;
    }
    
    public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel)
    {
      ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult(); 
    
        try
        {
          HttpResponse Response = GetHttpResponse(HttpRequestLabel);
              if (Response.getStatusCode() == 200) {
               oACETWSCalloutResult.Success = true;
               oACETWSCalloutResult.Message = '';
               oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(Response.getBody()));
              }else {
                    oACETWSCalloutResult = ParseFailureResponse(Response);
              }  
          }
    catch(Exception ex){
      system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex); 
      oACETWSCalloutResult.Success = false;
      oACETWSCalloutResult.Message = ex.getMessage();
      oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
    }

    system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);        
    return oACETWSCalloutResult;
  }
  //Added for continuation call
  public ACETWSCalloutResult GetProducer(String ProducerId){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult(); 
        producerDetailresult = new ACETProducerResult();
        try{
            GetEndpoint();
            GetRequestBody(producerId);
            HttpResponse Response = Send(OAuthConfig);
            system.debug('Response----->'+Response);
            if (Response.getStatusCode() == 200){
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(Response.getBody()));
                }else {
                    oACETWSCalloutResult = ParseFailureResponse(Response);
                }  
        }
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        return oACETWSCalloutResult;
    } 
    
  
}