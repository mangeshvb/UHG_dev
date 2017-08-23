public class ACETFindProducerWebservice extends ACETWebservice
{
    private string p_producerID;
    private string p_producerTaxID;
    private string p_producerSSN;
    private string p_companyName;
    private string p_groupNumber;
    private string p_LastName;
    private string p_FirstName;
    private string p_State;
    private string p_FilterBy;
    private string p_SortBy;
    private string p_SortOrder;
    private string currentDate;
    
    //init service query params
    public void init(String producerSSN,String producerTaxID,String producerID, String companyName,string groupNumber, String LastName, String FirstName, String State,
                        String SortBy, String SortOrder, String FilterBy){ 
        p_producerID = producerID;
        p_companyName = companyName;
        p_groupNumber = groupNumber;
        p_LastName = LastName;
        p_FirstName = FirstName;
        p_State = State;
        p_SortBy = SortBy;
        p_SortOrder = SortOrder;
        p_FilterBy = FilterBy;
        p_producerSSN = producerSSN;
        p_producerTaxID = producerTaxID;
                                        
    }
    
    public override void GetEndpoint()
    {
        GetEndpointDetail('FindProducersEndPoint');
    }
    
    
    private void getAdapterReqBody(String producerSSN,String producerTaxID, String producerID, String companyName, string groupNumber, String LastName, String FirstName, String State, String FilterBy)
    {
        Date d = Date.today();
		String dTXT = d.format();
		currentDate = cleanDate(dTXT);
		system.debug('!!! dTXT ' + dTXT); 
		system.debug('!!! new date ' + cleanDate(dTXT)); 
        system.debug('!!!curerntDate'+CurrentDate);
        
        RequestBody = '{"request":{"serviceAttributes":{"applicationIdentifier":"IVR","requestIdentifier":"","producerGroupAssociation":"","producerAndGroupFlag":"N","pageNumber": "1","recordsPerPage": "50"},"findProducerRequest":{'
                      +'"producerId":"'+producerID+'"'
                      +',"producerSSN":"'+producerSSN+'"'
                      +',"producerTIN":"'+producerTaxID+'"'
                      +',"memberGroupNumber":"'+groupNumber+'","memberGroupName":""'
                      +',"producerFirstName":"'+FirstName+'"'
                      +',"producerMiddleInitial":"","producerLastName":"'+LastName+'"'
                      +',"producerCompanyName":"'+companyName+'"'
                      +',"producerState":"'+State+'"'
                      +',"producerStatus":"ACTIVE"'
                      +',"requestedDate":"'+currentDate+'"'
                      +',"legacyBrokerCode":""}}}'; 
        if(groupNumber != Null && groupNumber != '')
        {
            
            RequestBody = '{"request":{"serviceAttributes":{"applicationIdentifier":"IVR","producerAndGroupFlag":"Yes","producerGroupAssociation":"active"},"findProducerRequest":{"producerId":"","producerSSN":"","producerTIN":"","memberGroupNumber":"'+groupNumber+'","memberGroupName":"","producerFirstName":"","producerMiddleInitial":"","producerLastName":"","producerCompanyName":"","producerState":"","producerStatus":"","requestedDate":"","legacyBrokerCode":""}}}';
        }
        //RequestBody = '{"request":{"serviceAttributes":{"applicationIdentifier":"IVR"},"findProducerRequest":{"producerId":"167106","producerSSN":"","producerTIN":"","memberGroupNumber":"","memberGroupName":"","producerFirstName":"","producerMiddleInitial":"","producerLastName":"","producerCompanyName":"","producerState":"","producerStatus":"ACTIVE","producerEffectiveAsOfDate":"04/12/2017","legacyBrokerCode":""}}}';
    
    }
     
    @TestVisible private void GetRequestBody(String producerID, String companyName, String LastName, String FirstName, String State, String FilterBy)
    {
        if(!String.isEmpty(producerID)){
            RequestBody = '{"findProducer": {'
                           + '"findProducerRequestType": {'
                           +'"body":{'
                           +'"request":[{'
                           + '"producerIdentifier":  {"id" : "' + producerID + '"} '                              
                           + '}]}}}}';
        }else if(!String.isEmpty(companyName)){
            RequestBody = '{"findProducer": {'   
                           +'"findProducerRequestType": {'
                           +'"body":{'
                           +'"request":[{'
                           +'"producerCompanyName": "' + companyName + '" '                              
                           + '}]}}}}';
        }else{
            RequestBody = '{"findProducer": {'   
                           +'"findProducerRequestType": {'
                           +'"body":{'
                           +'"request":[{'
                           +'"producerFirstName": "' + FirstName + '",'    
                           +'"producerLastName": "' + LastName + '" '                          
                           + '}]}}}}';            
        }
    }
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord){  
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProducerSearchResult> producersSearchResult;     
        List<ACETFindProducersAdaptJSON2Apex.FindProducerResponse> SRProducers;  
        ACETProducerSearchResult Producer;
        
        try
        {
            GetEndpoint();
            
            getAdapterReqBody(p_producerSSN,p_producerTaxID,p_producerID,p_companyName,p_groupNumber,p_LastName, p_FirstName, p_State, p_FilterBy); 
            RequestBody = RequestBody.replace('"pageNumber": "1"','"pageNumber": "' + pageNumber + '"');
            RequestBody = RequestBody.replace('"pageSize": "1"','"pageSize": "' + pageSize + '"');
            RequestBody = RequestBody.replace('"startRecord": "1"','"startRecord": "' + startRecord + '"');
            system.debug('RequestBody --->'+RequestBody );
            HttpResponse Response = Send(OAuthConfig);
            system.debug('**OAuthConfig.response'+response);
            
            if (Response.getStatusCode() == 200)
            {
                if(response.getBody() != null){
                  
                   String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                    
                    system.debug('**responseBody in find group ==>'+responseBody);
                    
                    //ACETFindProducersJSON2Apex ACTFPJSON2Apex = (ACETFindProducersJSON2Apex)JSON.deserialize(responseBody, ACETFindProducersJSON2Apex.class);
                    ACETFindProducersAdaptJSON2Apex ACTFPJSON2Apex = (ACETFindProducersAdaptJSON2Apex)JSON.deserialize(responseBody, ACETFindProducersAdaptJSON2Apex.class);
                    system.debug('**ACTFPJSON2Apex : ' + ACTFPJSON2Apex);
                    
                    producersSearchResult= new List<ACETProducerSearchResult>(); 
                    SRProducers = ACTFPJSON2Apex.response.FindProducerResponse;
                    system.debug('**SRProducers :----> ' + SRProducers );
                    if(SRProducers != Null)
                    {
                        for (ACETFindProducersAdaptJSON2Apex.FindProducerResponse producers: SRProducers){
                            Producer = new ACETProducerSearchResult();
                            Producer.ProducerID = producers.producerId;
                            Producer.CompanyName = (producers.producerCompanyName != null)?producers.producerCompanyName:'';
                            Producer.LastName = (producers.producerName.lastName != null)?producers.producerName.lastName:'';
                            Producer.FirstName = (producers.producerName.firstName != null)?producers.producerName.firstName:'';
                            Producer.MiddleInitial = (producers.producerName.middleInitial != null)?producers.producerName.middleInitial:'';
                            Producer.ProducerType = (producers.producerType != null)?producers.producerType:'';
                            Producer.producerMemberGrpStartDate = producers.memberGroupDetails[0].producerMemberGrpStartDate;
                            Producer.producerMemberGrpEndDate = producers.memberGroupDetails[0].producerMemberGrpEndDate;
                            Producer.producerContact = (producers.producerContact != null)?producers.producerContact:'';
                            Producer.producerState  = (producers.producerState != null)?producers.producerState:'';
                            Producer.producerCity = (producers.producerCity != null)?producers.producerCity:'';
                            Producer.producerPhoneNumber = (producers.producerPhoneNumber != null)?producers.producerPhoneNumber:'';
                            Producer.producerEffectiveAsOfDate = (producers.producerEffectiveAsOfDate != null)?producers.producerEffectiveAsOfDate:'';
                            if(Producer.ProducerType == 'B')
                            {
                                Producer.producerTIN = (producers.producerTIN != null || producers.producerTIN != '')?producers.producerTIN:'';
                            }
                            else if(Producer.ProducerType == 'I')
                            {
                                Producer.producerTIN = (producers.producerSSN != null || producers.producerSSN != '')?getMaskedSSN(producers.producerSSN):'';
                            }
                            else
                            {
                                Producer.producerTIN = '';
                            }
                            producersSearchResult.add(Producer);
                        }
                    }
                    if (producersSearchResult != null)
                    {
                        ACETProducerSearchResult.SortBy = p_SortBy;
                        ACETProducerSearchResult.SortOrder = p_SortOrder;
                        producersSearchResult.Sort();
                        system.debug('ACTFPJSON2Apex.response.serviceAttributes--->'+ACTFPJSON2Apex.response.serviceAttributes);
                        oACETWSCalloutResult.Success = true;
                        oACETWSCalloutResult.Message = '';
                        oACETWSCalloutResult.Response = producersSearchResult;
                        oACETWSCalloutResult.pageNumber =  ACTFPJSON2Apex.response.serviceAttributes.pageNumber; 
                        oACETWSCalloutResult.pageSize = ACTFPJSON2Apex.response.serviceAttributes.recordsPerPage;  
                        oACETWSCalloutResult.recordCount = ACTFPJSON2Apex.response.serviceAttributes.recordsPerPage; 
                        oACETWSCalloutResult.totalCount = ACTFPJSON2Apex.response.serviceAttributes.totalNumberOfRecords; 
                        //oACETWSCalloutResult.totalPages = '';  
                    }
                        
                }     
            }
            else if(response.getStatusCode() == 500){
                
                //currently servce returns 500 if no records found
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
                oACETWSCalloutResult.Success = true;                
                oACETWSCalloutResult.Response = new List<ACETProducerSearchResult>();
                system.debug(oACETWSCalloutResult);                
            }
            
                
            
        }catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        
        return oACETWSCalloutResult;    
    
    }
    
    
    public ACETWSCalloutResult FindProducers(String producerSSN,String producerTaxID,String producerID, String companyName,string groupNumber, String LastName, String FirstName, String State,
                        String SortBy, String SortOrder, String FilterBy)
    {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProducerSearchResult> producersSearchResult;     
        List<ACETFindProducersAdaptJSON2Apex.FindProducerResponse> SRProducers;  
        ACETProducerSearchResult Producer;
        
        try
        {
            GetEndpoint();
            
            getAdapterReqBody(producerSSN,producerTaxID,producerID,companyName,groupNumber,LastName, FirstName, State, FilterBy); 
            system.debug('RequestBody --->'+RequestBody );
            HttpResponse Response = Send(OAuthConfig);
            system.debug('**OAuthConfig.response'+response);
            
            if (Response.getStatusCode() == 200)
            {
                if(response.getBody() != null){
                  
                   String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                    
                    system.debug('**responseBody in find group ==>'+responseBody);
                    
                    //ACETFindProducersJSON2Apex ACTFPJSON2Apex = (ACETFindProducersJSON2Apex)JSON.deserialize(responseBody, ACETFindProducersJSON2Apex.class);
                    ACETFindProducersAdaptJSON2Apex ACTFPJSON2Apex = (ACETFindProducersAdaptJSON2Apex)JSON.deserialize(responseBody, ACETFindProducersAdaptJSON2Apex.class);
                    system.debug('**ACTFPJSON2Apex : ' + ACTFPJSON2Apex);
                    
                    producersSearchResult= new List<ACETProducerSearchResult>(); 
                    SRProducers = ACTFPJSON2Apex.response.FindProducerResponse;
                    system.debug('**SRProducers :----> ' + SRProducers );
                    if(SRProducers != Null)
                    {
                        for (ACETFindProducersAdaptJSON2Apex.FindProducerResponse producers: SRProducers){
                            Producer = new ACETProducerSearchResult();
                            Producer.ProducerID = producers.producerId;
                            Producer.CompanyName = (producers.producerCompanyName != null)?producers.producerCompanyName:'';
                            Producer.LastName = (producers.producerName.lastName != null)?producers.producerName.lastName:'';
                            Producer.FirstName = (producers.producerName.firstName != null)?producers.producerName.firstName:'';
                            Producer.MiddleInitial = (producers.producerName.middleInitial != null)?producers.producerName.middleInitial:'';
                            Producer.ProducerType = (producers.producerType != null)?producers.producerType:'';
                            Producer.producerMemberGrpStartDate = producers.memberGroupDetails[0].producerMemberGrpStartDate;
                            Producer.producerMemberGrpEndDate = producers.memberGroupDetails[0].producerMemberGrpEndDate;
                            Producer.producerContact = (producers.producerContact != null)?producers.producerContact:'';
                            Producer.producerState  = (producers.producerState != null)?producers.producerState:'';
                            Producer.producerCity = (producers.producerCity != null)?producers.producerCity:'';
                            Producer.producerPhoneNumber = (producers.producerPhoneNumber != null)?producers.producerPhoneNumber:'';
                            Producer.producerEffectiveAsOfDate = (producers.producerEffectiveAsOfDate != null)?producers.producerEffectiveAsOfDate:'';
                            
                            if(Producer.ProducerType == 'B')
                            {
                                Producer.producerTIN = (producers.producerTIN != null || producers.producerTIN != '')?producers.producerTIN:'';
                            }
                            else if(Producer.ProducerType == 'I')
                            {
                                Producer.producerTIN = (producers.producerSSN != null || producers.producerSSN != '')?getMaskedSSN(producers.producerSSN):'';
                            }
                            else
                            {
                                Producer.producerTIN = '';
                            }
                            
                            producersSearchResult.add(Producer);
                        }
                    }
                        
                }     
            }
            else if(response.getStatusCode() == 500){
                
                //currently servce returns 500 if no records found
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
                oACETWSCalloutResult.Success = true;                
                oACETWSCalloutResult.Response = new List<ACETProducerSearchResult>();
                system.debug(oACETWSCalloutResult);                
            }
            
            if (producersSearchResult != null)
            {
                ACETProducerSearchResult.SortBy = SortBy;
                ACETProducerSearchResult.SortOrder = SortOrder;
                producersSearchResult.Sort();
                
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = producersSearchResult;
            }    
            
        }catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        
        return oACETWSCalloutResult;
    }  
						
    public String getMaskedSSN(String ssn){
        if(String.isEmpty(ssn) || ssn.length() < 4) return '';
        
        return 'xxx-xx-' + ssn.substring(ssn.length() - 4);
    } 
    
      public String cleanDate(String theDate){
        String [] s = theDate.split('/');
        String newDate= '';
        if(s[0].length() == 1){
            newDate = '0'+s[0];
        }else{
            newDate = s[0];
        }
        newDate = newDate+'/'+s[1]+'/'+s[2];
        return newDate;
    }
       
}