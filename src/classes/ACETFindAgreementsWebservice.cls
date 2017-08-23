public class ACETFindAgreementsWebservice extends ACETWebservice {
    public override void GetEndpoint() {
        GetEndpointDetail('findAgreementsEndpoint');
    }
    
    private void GetRequestBody(String strProviderId,String strProviderTIN, String strProviderTINTypeCode, String strAddressId, String strAddressTypeCode,String strBenefitPlanId) {
        String strstaticfilename = 'findMedicalProviderAgreementsRequestTemplate'; 
            
        StaticResource sr = [SELECT Id,NamespacePrefix,SystemModstamp FROM StaticResource WHERE Name = :strstaticfilename LIMIT 1];
        String prefix = sr.NamespacePrefix;
        if( String.isEmpty(prefix) ) {
           prefix = '';
        } else {
           prefix += '__';
        }
        
        String srPath = '/resource/' + sr.SystemModstamp.getTime() + '/' + prefix + strstaticfilename; 
        PageReference pg = new PageReference(srPath);
        if(!Test.isRunningTest())
        {        
            RequestBody = pg.getContent().toString();
        }
        else 
        {
            RequestBody = 'UNIT.TEST';
        }
        
        RequestBody = (strProviderId != null) ? RequestBody.replace('@@providerId@@',strProviderId) : RequestBody.replace('@@providerId@@', '') ;
        RequestBody = (strProviderTIN != null) ? RequestBody.replace('@@providerTIN@@',strProviderTIN) : RequestBody.replace('@@providerTIN@@', '') ;
        RequestBody = (strProviderTINTypeCode != null) ? RequestBody.replace('@@providerTINTypeCode@@',strProviderTINTypeCode) : RequestBody.replace('@@providerTINTypeCode@@', '') ;
        RequestBody = (strAddressId != null) ? RequestBody.replace('@@addressId@@',strAddressId) : RequestBody.replace('@@addressId@@', '') ; 
        RequestBody = (strAddressTypeCode != null)  ? RequestBody.replace('@@addressTypeCode@@',strAddressTypeCode) : RequestBody.replace('@@addressTypeCode@@', '') ;
        RequestBody = (strBenefitPlanId != null)  ? RequestBody.replace('@@benefitPlanId@@',strBenefitPlanId) : RequestBody.replace('@@benefitPlanId@@', '') ;
    }
    @TestVisible
    private List<ACETProviderContractResult> ParseSuccessResponse(String ResponseBody) {
        List<ACETProviderContractResult> Agreements = new List<ACETProviderContractResult>();
        ACETProviderContractResult Agreement;
        
        ResponseBody = ReplaceKeywords(ResponseBody);
        ACETFindProviderAgreementsJSON2APEX ACTFAJSON2Apex = (ACETFindProviderAgreementsJSON2APEX)JSON.deserialize(ResponseBody, ACETFindProviderAgreementsJSON2APEX.class);
        system.debug('ACTFAJSON2Apex : ' + ACTFAJSON2Apex);
        
        ACETFindProviderAgreementsJSON2APEX.FindMedicalProviderAgreementsResponseType SRAgreements = ACTFAJSON2Apex.findMedicalProviderAgreementsResult.findMedicalProviderAgreementsResponseType;
        system.debug('Agreements: ' + SRAgreements);

        if (SRAgreements.medicalproviderAgreements != null) {
            for(ACETFindProviderAgreementsJSON2APEX.medicalproviderAgreements SRAgreement : SRAgreements.medicalproviderAgreements){
                Agreement = new ACETProviderContractResult();
                
                if (String.isNotBlank(SRAgreement.network.id)){
                    Agreement.Network_ID = SRAgreement.network.Id;
                }
                if (String.isNotBlank(SRAgreement.network.name)){
                    Agreement.Network_Name = SRAgreement.network.name;
                }
                if (String.isNotBlank(SRAgreement.network.statusCode)){
                    Agreement.Network_Status = SRAgreement.network.statusCode;
                }
                if (String.isNotBlank(SRAgreement.contractDetail.effectiveDate)) {
                    Agreement.Effective = ChangeDateFormat(SRAgreement.contractDetail.effectiveDate);                    
                }    
                if (String.isNotBlank(SRAgreement.contractDetail.cancelDate)) {                 
                    Agreement.Cancel = ChangeDateFormat(SRAgreement.contractDetail.cancelDate);
                } 
                if (String.isNotBlank(SRAgreement.pricingSet.id)) {
                    Agreement.Pricing_Set_ID = SRAgreement.pricingSet.id;
                }  
               
                if (String.isNotBlank(SRAgreement.benefitPlan.productName)) {
                    Agreement.Product = SRAgreement.benefitPlan.planTypeCode;
                }  
                if (String.isNotBlank(SRAgreement.contractDetail.acceptingNewPatientsIndicator)) {
                    Agreement.Accepting_New_Patients = SRAgreement.contractDetail.acceptingNewPatientsIndicator;
                } 
                if (String.isNotBlank(SRAgreement.contractDetail.acceptingExistingPatientsIndicator)) {
                    Agreement.Accepting_Existing_Patients = SRAgreement.contractDetail.acceptingExistingPatientsIndicator;
                } 
                if (String.isNotBlank(SRAgreement.contractDetail.providerAssignmentTypeCode)) {
                    Agreement.ProviderAssignmentType = SRAgreement.contractDetail.providerAssignmentTypeCode;
                } 
                if (String.isNotBlank(SRAgreement.key.contractDetailId)) {
                    Agreement.ContractDetailId = SRAgreement.key.contractDetailId;
                }
                if (String.isNotBlank(SRAgreement.key.contractHeaderId)) {
                    Agreement.ContractHeaderId = SRAgreement.key.contractHeaderId;
                }                
                if (String.isNotBlank(SRAgreement.key.benefitPlanId)) {
                    Agreement.BenefitPlanId = SRAgreement.key.benefitPlanId;
                }
                if (String.isNotBlank(SRAgreement.key.networkScheduleId)) {
                    Agreement.NetworkSchedule = SRAgreement.key.networkScheduleId;
                }
                Agreements.add(Agreement);          
            }
        }    
        return Agreements;
    }

    public Continuation StartRequest(String providerId, String providerTIN, String providerTINTypeCode, String addressId, 
                String addressTypeCode, String benefitPlanId, String CallbackMethodName, Continuation oContinuation) {
        system.debug(LoggingLevel.INFO, 'providerId: ' + providerId +', providerTIN: ' + providerTIN + ', providerTINTypeCode: ' + providerTINTypeCode);
        system.debug(LoggingLevel.INFO, 'addressId: ' + addressId + ', addressTypeCode: ' + addressTypeCode);
        system.debug(LoggingLevel.INFO, 'CallbackMethodName: ' + CallbackMethodName + ', oContinuation: ' + oContinuation);
        
        GetEndpoint();
        GetRequestBody(providerId,providerTIN,providerTINTypeCode,addressId,addressTypeCode,benefitPlanId);
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        return oContinuation;
    }
    
    public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel) {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProviderContractResult> Agreements = new List<ACETProviderContractResult>();
        
        try {
            HttpResponse Response = GetHttpResponse(HttpRequestLabel);
            if (Response.getStatusCode() == 200) {
                Agreements = ParseSuccessResponse(Response.getBody());
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';    
                oACETWSCalloutResult.Response = Agreements;             
            }
            else {
                oACETWSCalloutResult = ParseFailureResponse(Response);
            }
        }
        catch(Exception ex) {
            system.debug(LoggingLevel.INFO, 'Exception in FindAgreements. Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResult.Response = null;
        }
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);         
        return oACETWSCalloutResult;
    }
    
    public ACETWSCalloutResult FindAgreement(String providerId, String providerTIN, String providerTINTypeCode, String addressId, String addressTypeCode, String benefitPlanId) {
        
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProviderContractResult> Agreements = new List<ACETProviderContractResult>();
        
        try {
            Headers.remove('Content-Type');
            Headers.put('accept', 'application/json');
            GetEndpoint();
            GetRequestBody(providerId,providerTIN,providerTINTypeCode,addressId,addressTypeCode,benefitPlanId);
            HttpResponse Response = Send(OAuthConfig);
            if (Response.getStatusCode() == 200) {
                Agreements = ParseSuccessResponse(Response.getBody());
                system.debug('Agreements Parsed :: ' + Agreements.size());
                if (Agreements != null && Agreements.size() > 0 ){
                    oACETWSCalloutResult.Success = true;
                    oACETWSCalloutResult.Message = '';    
                    oACETWSCalloutResult.Response = Agreements;             
                }else{
                    oACETWSCalloutResult.Success = false;
                    oACETWSCalloutResult.Message = '';
                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;  
                }

            }
            else {

                oACETWSCalloutResult = ParseFailureResponse(Response);
                system.debug(LoggingLevel.Info,'oACETWSCalloutResult for ParseFailureResponse*** '+ oACETWSCalloutResult);

                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            }
                       
        }
        catch(Exception ex) {
            system.debug(LoggingLevel.INFO, 'Exception in FindAgreements. Details***: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResult.Response=null;
        }
        system.debug('oACETWSCalloutResult***: ' + oACETWSCalloutResult);         
        return oACETWSCalloutResult;
    }
}