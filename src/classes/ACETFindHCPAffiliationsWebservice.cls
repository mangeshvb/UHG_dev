public class ACETFindHCPAffiliationsWebservice extends ACETWebservice
{
    public override void GetEndpoint()  {
        GetEndpointDetail('FindHCPAffEndpoint');
    }

    private void GetRequestBody(String healthcareProfessionalId, String providerStatusCode, String pageNumber, 
                String pageSize, String startRecord)   {
        RequestBody = GetRequestFormatByName('FindHCPAffiliationsRequestJSON');
        RequestBody = (String.isNotBlank(healthcareProfessionalId)) ? RequestBody.replace('@@healthcareProfessionalId@@',healthcareProfessionalId) : RequestBody.replace('@@healthcareProfessionalId@@', '');
        RequestBody = (String.isNotBlank(providerStatusCode)) ? RequestBody.replace('@@providerStatusCode@@',providerStatusCode) : RequestBody.replace('@@providerStatusCode@@', '');
        RequestBody = (String.isNotBlank(pageNumber)) ? RequestBody.replace('@@pageNumber@@',pageNumber) : RequestBody.replace('@@pageNumber@@', '');
        RequestBody = (String.isNotBlank(pageSize)) ? RequestBody.replace('@@pageSize@@',pageSize) : RequestBody.replace('@@pageSize@@', '');
        RequestBody = (String.isNotBlank(startRecord)) ? RequestBody.replace('@@startRecord@@',startRecord) : RequestBody.replace('@@startRecord@@', '');
        }
    
    private List<ACETProviderDetailController.ACETProviderAffiliation> ParseSuccessResponse(String ResponseBody)  {
        List<ACETProviderDetailController.ACETProviderAffiliation> Affiliations = new List<ACETProviderDetailController.ACETProviderAffiliation>();
        FindHCPAffiliationsJSON2Apex ACETFHCPAJSON2Apex = (FindHCPAffiliationsJSON2Apex)JSON.deserialize(ResponseBody, FindHCPAffiliationsJSON2Apex.class);
        FindHCPAffiliationsJSON2Apex.FindMedicalHealthcareProfessionalAffiliationsResult findHHCOAffiliationsResponse = ACETFHCPAJSON2Apex.findMedicalHealthcareProfessionalAffiliationsResult;
        FindHCPAffiliationsJSON2Apex.FindMedicalHealthcareProfessionalAffiliationsResponseType findHCOAffiliationsResponseType;
        if (findHHCOAffiliationsResponse != null) {
            findHCOAffiliationsResponseType = findHHCOAffiliationsResponse.findMedicalHealthcareProfessionalAffiliationsResponseType;
            if (findHCOAffiliationsResponseType != null) {
                List<FindHCPAffiliationsJSON2Apex.MedicalHealthcareOrganization> medHCOs = findHCOAffiliationsResponseType.medicalHealthcareOrganization;
                if (medHCOs != null) {
                    for (FindHCPAffiliationsJSON2Apex.MedicalHealthcareOrganization medHCO :medHCOs) {
                        ACETProviderDetailController.ACETProviderAffiliation Affiliation = new ACETProviderDetailController.ACETProviderAffiliation();                     
                        if (medHCO.hco != null) {
                            Affiliation.affiliation = medHCO.hco.name;
                            Affiliation.providerId = medHCO.hco.Id;
                        }
                        if (medHCO.affiliation != null) {
                            Affiliation.effective = ChangeDateFormat(medHCO.affiliation.effectiveDate);
                        }
                        Affiliations.add(Affiliation);
                    }
                } 
            }
        }
        return Affiliations;
    }
    
    public Continuation StartRequest(String healthcareProfessionalId, String providerStatusCode, String pageNumber, 
                String pageSize, String startRecord, String CallbackMethodName, Continuation oContinuation)
    {
        system.debug(LoggingLevel.INFO, 'healthcareProfessionalId: ' + healthcareProfessionalId +', providerStatusCode: ' + providerStatusCode + ', pageNumber: ' + pageNumber);
        system.debug(LoggingLevel.INFO, 'pageSize: ' + pageSize +', startRecord: ' + startRecord );
        system.debug(LoggingLevel.INFO, 'CallbackMethodName: ' + CallbackMethodName + ', oContinuation: ' + oContinuation);
        
        GetEndpoint();
        GetRequestBody(healthcareProfessionalId, providerStatusCode, pageNumber, pageSize, startRecord);
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        return oContinuation;         
    }
    
    public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel)
    {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult(); 
        
        try {
           HttpResponse Response = GetHttpResponse(HttpRequestLabel);
      	/*    HttpResponse Response = new HttpResponse();
            Response.setStatusCode(200);
            Response.setStatus('OK');
            Response.setBody('{"findMedicalHealthcareProfessionalAffiliationsResult": {"findMedicalHealthcareProfessionalAffiliationsResponseType": { "medicalHealthcareOrganization": [ { "key": { "healthcareProfessionalId": "803246196078757043", "healthcareOrganizationId": "787945240892612320" }, "hco": { "statusCode": "A", "id": "787945240892612320", "effectiveDate": "1982-12-29", "cancelDate": "9999-12-31", "name": "MARGARET R PARDEE MEMORIAL HOSPITAL" }, "affiliation": { "statusCode": "A", "effectiveDate": "2017-01-27", "cancelDate": "9999-12-31", "admittingPrivilegeTypeCode": "Active", "admittingPrivilegeTypeDescription": "" } }], "pagination": { "pageNumber": "0", "pageSize": "50", "recordCount": "1", "totalCount": "1", "totalPages": "1" } }}}');   
           // Response.setBody('{"findMedicalHealthcareProfessionalAffiliationsResult": {"findMedicalHealthcareProfessionalAffiliationsResponseType": {"errors": [{ "code": "W008", "name": "No records returned", "severity": "low", "origin": "Consumer", "description": "Consumer has requested a query for which no records have been found." }]}}}');
          */
           if (Response.getStatusCode() == 200) {
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = ParseSuccessResponse(Response.getBody());
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
    

}