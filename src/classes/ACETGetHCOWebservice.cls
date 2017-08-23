public class ACETGetHCOWebservice extends ACETWebservice
{
    public String returningFromService;
    private Map<String, Provider_Taxonomy__mdt> mapTaxonomyMDT = new Map<String, Provider_Taxonomy__mdt>();
    public ACETProviderUtility providerUtility = new ACETProviderUtility();
        
    public override void GetEndpoint()  {
        GetEndpointDetail('getHCOEndpoint');
    }

    private void GetRequestBody(String strproviderId, String strproviderStatusCode, String strproviderTIN, String strproviderTINStatusCode, String strproviderTINTypeCode,string straddressId, String straddressTypeCode)   {
      /*  if (returningFromService == 'providerSearch') {
            RequestBody = GetRequestFormatByName('getHCO_HardcodedRequest');
        } else {    */
            String strstaticfilename = 'getHCO_AdapterRequestTemplate';
            StaticResource sr = [SELECT Id,NamespacePrefix,SystemModstamp FROM StaticResource WHERE Name = :strstaticfilename LIMIT 1];
            String prefix = sr.NamespacePrefix;
            if( String.isEmpty(prefix) ) {
                prefix = '';
            } else {
                prefix += '__';
            }
            String srPath = '/resource/' + sr.SystemModstamp.getTime() + '/' + prefix + strstaticfilename; 
            PageReference pg = new PageReference(srPath);
            if(!Test.isRunningTest()) {        
                RequestBody = pg.getContent().toString();
            } else {
                RequestBody = 'UNIT.TEST';
            }
            RequestBody = (strproviderId != null) ? RequestBody.replace('@@providerId@@',strproviderId) : RequestBody.replace('@@providerId@@', '') ;
            RequestBody = (strproviderStatusCode != null) ? RequestBody.replace('@@providerStatusCode@@',strproviderStatusCode) : RequestBody.replace('@@providerStatusCode@@', '') ;
            RequestBody = (strproviderTIN != null) ? RequestBody.replace('@@providerTIN@@',strproviderTIN) : RequestBody.replace('@@providerTIN@@', '') ;
            RequestBody = (strproviderTINStatusCode != null) ? RequestBody.replace('@@providerTINStatusCode@@',strproviderTINStatusCode) : RequestBody.replace('@@providerTINStatusCode@@', '') ;
            RequestBody = (strproviderTINTypeCode != null) ? RequestBody.replace('@@providerTINTypeCode@@',strproviderTINTypeCode) : RequestBody.replace('@@providerTINTypeCode@@', '') ;
            RequestBody = (straddressId!= null) ? RequestBody.replace('@@addressId@@',straddressId) : RequestBody.replace('@@addressId@@', '') ;
            RequestBody = (straddressTypeCode!= null) ? RequestBody.replace('@@addressTypeCode@@',straddressTypeCode) : RequestBody.replace('@@addressTypeCode@@', '') ;      
      //  }
    }
    
    @TestVisible
    private ACETProviderDetailController.ACETProviderDetail ParseSuccessResponse(String ResponseBody, String providerTINOwner)  {
        ACETProviderDetailController.ACETProviderDetail providerDetail = new ACETProviderDetailController.ACETProviderDetail();
        ACETGetHCOJSON2Apex ACTPDGIJSON2Apex = (ACETGetHCOJSON2Apex)JSON.deserialize(ResponseBody, ACETGetHCOJSON2Apex.class);
        if(ACTPDGIJSON2Apex.getMedicalHealthcareOrganizationResult != null){
        	if(ACTPDGIJSON2Apex.getMedicalHealthcareOrganizationResult.getMedicalHealthcareOrganizationResponseType != null){
            if(ACTPDGIJSON2Apex.getMedicalHealthcareOrganizationResult.getMedicalHealthcareOrganizationResponseType.medicalHealthcareOrganization != null){
                ACETGetHCOJSON2Apex.medicalHealthcareOrganization generalInformation = ACTPDGIJSON2Apex.getMedicalHealthcareOrganizationResult.getMedicalHealthcareOrganizationResponseType.medicalHealthcareOrganization;
                system.debug(LoggingLevel.INFO, 'generalInformation*** '+ generalInformation);
                if(generalInformation != null){
                    if(String.isNotBlank(generalInformation.hco.providerName)){
                        providerDetail.generalInfo.lastName = generalInformation.hco.providerName;
                    }
                    if(String.isNotBlank(generalInformation.providerTIN.id)){
                        providerDetail.generalInfo.taxId = generalInformation.providerTIN.id;
                    }
                    if(String.isNotBlank(generalInformation.npi[0].hcoNPI)){
                        providerDetail.generalInfo.npi = generalInformation.npi[0].hcoNPI;
                    }
                    if(String.isNotBlank(generalInformation.hco.providerId)){
                        providerDetail.generalInfo.providerID = generalInformation.hco.providerId;
                    }
                    if(String.isNotBlank(generalInformation.providerTIN.owner)){
                        providerDetail.generalInfo.providerTINOwner = generalInformation.providerTIN.owner;
                    }
                    if(String.isNotBlank(generalInformation.hco.hcoTypeCode)){
                        providerDetail.generalInfo.hcoTypeCode = generalInformation.hco.hcoTypeCode;
                    }
                }
                //Start of Specialty snippet
                List<ACETGetHCOJSON2Apex.Specialty> practiceInformationLst = new List<ACETGetHCOJSON2Apex.Specialty>();
                practiceInformationLst = ACTPDGIJSON2Apex.getMedicalHealthcareOrganizationResult.getMedicalHealthcareOrganizationResponseType.medicalHealthcareOrganization.specialty;
                system.debug('practiceInformationLst :: ' + practiceInformationLst.size());
                if(practiceInformationLst != null){
                    for(Integer index =0; index < practiceInformationLst.size(); index++){
                        ACETProviderDetailController.ACETProviderSpeciality specialityObj = new ACETProviderDetailController.ACETProviderSpeciality();
                        if(String.isNotBlank(practiceInformationLst[index].primarySpecialtyIndicator)){
                            specialityObj.primarySpeciality = practiceInformationLst[index].primarySpecialtyIndicator;
                        }else{
                            specialityObj.primarySpeciality = 'N';
                        }
                        
                        /*** Added this snippet as a part of US638204 by Avish on 05192017 ***/
                        String typeCodeCMD = practiceInformationLst[index].typeCode;   
                        if(String.isNotBlank(practiceInformationLst[index].typeCode)) {
                            mapTaxonomyMDT = providerUtility.getProviderTaxonomy();
                            if(mapTaxonomyMDT.get(typeCodeCMD) != null ){
                                system.debug(LoggingLevel.INFO,'Speciality__c:: ' + typeCodeCMD);
                                specialityObj.speciality = (mapTaxonomyMDT.get(typeCodeCMD).Speciality__c != null) ? mapTaxonomyMDT.get(typeCodeCMD).Speciality__c : typeCodeCMD;
                            }else{
                                specialityObj.speciality = typeCodeCMD;
                            }
                        }    
                        /***** End of Code ***/      
                      //  specialityObj.boardCert = practiceInformationLst[index].typeDescription;
                     //   specialityObj.cancelDate = ChangeDateFormat(practiceInformationLst[index].cancelDate);
                        providerDetail.specialities.add(specialityObj);
                    }
                }
                
                //End of Specialty snippet
                
                //Code Snippet for TPSM
                List<ACETGetHCOJSON2Apex.tpsm> tpsmLst = new List<ACETGetHCOJSON2Apex.tpsm>();
                tpsmLst = ACTPDGIJSON2Apex.getMedicalHealthcareOrganizationResult.getMedicalHealthcareOrganizationResponseType.medicalHealthcareOrganization.tpsm;    
                if(tpsmLst!=null){                             
                    for(ACETGetHCOJSON2Apex.Tpsm platinum :tpsmLst) {
                        if(platinum != null){
                            if(platinum.code == '99Z'){
                                providerDetail.generalInfo.platinumProvider = 'No';                                        
                            }else if(String.isBlank(platinum.code)){
                                providerDetail.generalInfo.platinumProvider = '';
                            }else{
                                providerDetail.generalInfo.platinumProvider = 'Yes - ' +  platinum.code;   
                            }
                        }
                    }    
                 }
                //End of Code Snippet fot TPSM
                
                //Start of NPI snippet
                List<ACETGetHCOJSON2Apex.NPI> npisLst = new List<ACETGetHCOJSON2Apex.NPI>();
                npisLst = ACTPDGIJSON2Apex.getMedicalHealthcareOrganizationResult.getMedicalHealthcareOrganizationResponseType.medicalHealthcareOrganization.npi;    
                    if(npisLst != null){
                        for(Integer index =0; index < npisLst.size(); index++){
                            ACETProviderDetailController.NPI npiObj = new ACETProviderDetailController.NPI(); 
                            npiObj.npiName = npisLst[index].hcoNPI;
                            providerDetail.npis.add(npiObj);
                        }
                    }               
                //End of NPI snippet
            }
        }
  }
        return providerDetail;
    }

    
    public Continuation StartRequest(String providerId, String providerTIN, String providerStatusCode, String providerTINStatusCode, 
            String providerTINTypeCode, String addressId, String addressTypeCode, String returningFrom, 
            String CallbackMethodName, Continuation oContinuation)
    {
        system.debug(LoggingLevel.INFO, 'providerId: ' + providerId +', providerStatusCode: ' + providerStatusCode + ', providerTIN: ' + providerTIN);
        system.debug(LoggingLevel.INFO, 'providerTINStatusCode: ' + providerTINStatusCode +', providerTINTypeCode: ' + providerTINTypeCode);
        system.debug(LoggingLevel.INFO, 'addressId: ' + addressId + ', addressTypeCode: ' + addressTypeCode + ', returningFrom: ' + returningFrom);
        system.debug(LoggingLevel.INFO, 'CallbackMethodName: ' + CallbackMethodName + ', oContinuation: ' + oContinuation);
        
        this.returningFromService = returningFrom;
        GetEndpoint();
        GetRequestBody(ProviderId, providerStatusCode, providerTIN, providerTINStatusCode,providerTINTypeCode, addressId,addressTypeCode);
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        return oContinuation;         
    }
    
    public ACETWSCalloutResult ProcessResponse(String providerTINOwner, String HttpRequestLabel)
    {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult(); 
        
        try {
            HttpResponse Response = GetHttpResponse(HttpRequestLabel);
            if (Response.getStatusCode() == 200) {
                ACETProviderDetailController.ACETProviderDetail ProviderDetail = ParseSuccessResponse(Response.getBody(), providerTINOwner);
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = ProviderDetail;
            } else {
                oACETWSCalloutResult = ParseFailureResponse(Response);
            }   
        }
        catch(Exception ex) {
            system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }

        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);        
        return oACETWSCalloutResult;
    }
    
    public ACETWSCalloutResult GetProvider(String providerId,String providerStatusCode,String providerTIN,String providerTINStatusCode,String providerTINTypeCode,String addressId,String addressTypeCode, String returningFrom) {
        this.returningFromService = returningFrom;
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETGetHCOJSON2Apex ACTGPJSON2Apex;
        ACETProviderDetailController.ACETProviderDetail providerDetail = new ACETProviderDetailController.ACETProviderDetail();        
        try {
            GetEndpoint();
            GetRequestBody(ProviderId, providerStatusCode, providerTIN, providerTINStatusCode,providerTINTypeCode, addressId,addressTypeCode);
            HttpResponse Response = Send(OAuthConfig);
            if (returningFromService == 'providerSearch') {      
                if (Response.getStatusCode() == 200) {
                    ACTGPJSON2Apex = (ACETGetHCOJSON2Apex)JSON.deserialize(Response.getBody(), ACETGetHCOJSON2Apex.class);
                    System.debug('ACTGPJSON2Apex : ' + ACTGPJSON2Apex);
                    oACETWSCalloutResult.Success = true;
                    oACETWSCalloutResult.Message = '';
                    oACETWSCalloutResult.Response = ACTGPJSON2Apex;
                } else {
                    oACETWSCalloutResult = ParseFailureResponse(Response);        
                }
            } else if(returningFromService == 'providerLookup') {
                ACTGPJSON2Apex = (ACETGetHCOJSON2Apex)JSON.deserialize(Response.getBody(), ACETGetHCOJSON2Apex.class);
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = ACTGPJSON2Apex;
            }
        }
        catch(Exception ex) {
            system.debug(LoggingLevel.INFO, 'Exception in GetProvider. Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }

        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);        
        return oACETWSCalloutResult;
    }
}