/**
* @name         :   ACETFindClaimWebService
* @description  :   Custom Wrapper class for the claims search result from service
* @author       :   Khoushik Selvaraj
* @userstories  :
* @createddate  :   26-08-2016
* @lastmodifiedby:  Moinuddin Ahmed -> Updated TotalCharged, TotalPaid and Deductible from Integer type to Decimal type
*
**/
public class ACETFindClaimWebservice extends ACETWebService
{
    public override void GetEndpoint()
    {
        GetEndpointDetail('SearchClaimsEndpoint');
        //GetEndpointDetail('dev_SearchClaimsEndpoint');
    }
    
    
    private void getRequestBody(String strTaxId,String strNetworkStatus, String strCoverageType, String strStartDate,String strEndDate, String strDeductibleOnly,String strClaimId, String strAuthorizationNumber,String strReferrelNumber, String filterBy){
        //TODO : as per the actual request structure
        
        String strstaticfilename = '';
        
        if(strCoverageType  == 'MD' && strTaxId !='')
        {
            strstaticfilename = 'findClaimAdapterRequestTemplate';
            //strstaticfilename = 'findClaimsrequesttemplate';
            
        }
        else if(strCoverageType  == 'PH')
        {
            strstaticfilename = 'findClaimsrequesttemplatePH';
        }
        else if(strCoverageType  == 'BH')
        {
            strstaticfilename = 'findClaimsrequesttemplateBH';
        }
        else if(strCoverageType  == 'All' || (strCoverageType  == 'MD' && strTaxId ==''))
        {
            strstaticfilename = 'findClaimAdapterRequestTemplate';
            //strstaticfilename = 'findClaimsAll';
        }
        else
        {
            //strstaticfilename = 'findClaimsrequesttemplate';  
            strstaticfilename = 'findClaimAdapterRequestTemplate';
        }
        
        
        
        
        system.debug('***2323***input'+ 'taxid:' + strTaxId + 'network' + strNetworkStatus + 'coveragetype' +  strCoverageType  + 'startdate' + strStartDate + 'enddate' + strEndDate + 'deductible' + strDeductibleOnly + 'claim' + strClaimId + 'authnumber' + strAuthorizationNumber + 'refnumber' + strReferrelNumber);
        StaticResource sr = [SELECT Id,NamespacePrefix,SystemModstamp FROM StaticResource WHERE Name = :strstaticfilename LIMIT 1];
        String prefix = sr.NamespacePrefix;
        if( String.isEmpty(prefix) ) {
            prefix = '';
        } else {
            //If has NamespacePrefix
            prefix += '__';
        }
        String srPath = '/resource/' + sr.SystemModstamp.getTime() + '/' + prefix + strstaticfilename; 
        PageReference pg = new PageReference(srPath);
        
        //Added by Harish for covering in the test class  
        if(!Test.isRunningTest())
        {        
            RequestBody = pg.getContent().toString();
        }
        else 
        {
            RequestBody = 'UNIT.TEST';
        }
        //////End of the covering Test Class  
        // RequestBody = pg.getContent().toString();
        system.debug('**requesttemplate' + RequestBody );
        
        //this is a temporary code it will be replaced after finalizing best practice
        
        if(strStartDate == null)
        {
            strStartDate ='';
        }
        if(strEndDate == null)
        {
            strEndDate ='';
        }
        if(strDeductibleOnly == 'false')
        {
            strDeductibleOnly = 'N';
        }
        else
        {
            strDeductibleOnly = 'Y';
        }
        
        RequestBody = strTaxId != '' ? RequestBody.replace('@@TaxId@@',strTaxId) : RequestBody.replace('@@TaxId@@', '') ;
        //RequestBody = strNetworkStatus != '' ? RequestBody.replace('@@TaxId@@',strTaxId) : RequestBody.replace('@@TaxId@@', '') ;
        //RequestBody = strCoverageType  != '' ? RequestBody.replace('@@code@@',strCoverageType) : RequestBody.replace('@@code@@', '') ;
        RequestBody = strCoverageType  != '' ? RequestBody.replace('@@code@@','M') : RequestBody.replace('@@code@@', '') ; 
        RequestBody = strStartDate != '' ? RequestBody.replace('@@startDate@@',strStartDate) : RequestBody.replace('@@startDate@@', '') ;
        RequestBody = strEndDate != '' ? RequestBody.replace('@@stopDate@@',strEndDate) : RequestBody.replace('@@stopDate@@', '') ;
        RequestBody = (String.isNotBlank(strClaimId) || String.isNotBlank(strDeductibleOnly)) ? RequestBody.replace('@@deductible@@',strDeductibleOnly) : RequestBody.replace('@@deductible@@', '') ;
        RequestBody = strClaimId != '' ? RequestBody.replace('@@ClaimId@@',strClaimId) : RequestBody.replace('@@ClaimId@@', '') ;
        RequestBody = strAuthorizationNumber != '' ? RequestBody.replace('@@authnum@@',strAuthorizationNumber) : RequestBody.replace('@@authnum@@', '') ;
        // @ Rama : Comment when needed
        RequestBody = (String.isNotBlank(strClaimId) || String.isNotBlank(strTaxId)) ? RequestBody.replace('@@EID@@','') : RequestBody.replace('@@EID@@', '1234') ;
        
        system.debug('*** my json' + RequestBody );
        
        
        
        /* @@ClaimId@@
@@TaxId@@
@@startDate@@
@@stopDate@@
@@birthDate@@
@@deductible@@
@@code@@
@@authnum@@
*/
        
        
        
    }
    @testvisible
    private string getStatusCodeDesc(String strcode)
    {
        String strdesc;
        
        if(strcode == 'P')
        {
            
            strdesc = 'Partial Denied';    
        }
        else if(strcode == 'D')
        {
            strdesc = 'Denied';
        }
        
        else if(strcode == 'A')
        {
            strdesc = 'Approved/Paid';
        }
        else if(strcode == 'C')
        {
            strdesc = 'Closed';
        }
        else
        {
            strdesc = '';
        }
        
        
        return strdesc;
    }
    
    
    
    public ACETWSCalloutResult findClaims(String strTaxId,String strNetworkStatus, String strCoverageType, String strStartDate,String strEndDate, String strDeductibleOnly,String strClaimId, String strAuthorizationNumber,String strReferrelNumber, String filterBy, String SortBy, String SortOrder, List<String> SystemLabels)
    {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETClaimSearchResult> Claims = new List<ACETClaimSearchResult>();
        ACETClaimSearchResult Claim;
        List<ACETFindMedicalClaimJSON2Apex.Claim> SRMClaims;
        
        try
        {
            GetEndpoint();
            GetRequestBody(strTaxId, strNetworkStatus, strCoverageType, strStartDate,strEndDate, strDeductibleOnly, strClaimId, strAuthorizationNumber, strReferrelNumber, filterBy);
            //HttpResponse Response = Send(ISL_Webservice_Config__c.getValues('dev_SearchClaimsEndpoint'));
            HttpResponse Response = Send(OAuthConfig);            
            System.debug('@@@Response'+Response.getStatusCode());
            if (Response.getStatusCode() == 200)
            {
                
                //// start the If here
                if(Response.getBody().contains('"findClaimResponseMsg"'))
                {
                    
                    string jsonfullstring = Response.getBody();
                    jsonfullstring = jsonfullstring .replace('"date":','"CAdate":');
                    jsonfullstring = jsonfullstring .replace('"desc":','"descz":');
                    system.debug('**fulljsonresponse' + jsonfullstring );
                    Type resultType = Type.forName('ACETFindMedicalClaimJSON2Apex');
                    ACETFindMedicalClaimJSON2Apex searchresults = (ACETFindMedicalClaimJSON2Apex)JSON.deserialize(jsonfullstring , resultType);
                    
                    SRMClaims = searchresults.FindClaimsResult.FindClaimResponseMsg.Body.claim;
                    if (SRMClaims != null && SRMClaims.size() > 0)
                    {
                        if (SRMClaims.size() > 0)
                        {
                            
                            for (ACETFindMedicalClaimJSON2Apex.Claim SRClaim: SRMClaims)
                            {
                                if(SRClaim != null){    
                                    system.debug('SRClaim'+SRClaim);
                                    Date dtprocessed = null;
                                    system.debug('**date' + SRClaim.ClaimTransactionDetail);
                                    system.debug('**date2323' + JSON.serialize(SRClaim.ClaimTransactionDetail));
                                    //system.debug('**date'+ SRClaim.ClaimTransactionDetail.ClaimAdjudicationDate.CAdate);
                                    if(SRClaim.ClaimTransactionDetail.ClaimAdjudicationDate !=null){
                                        if(SRClaim.ClaimTransactionDetail.ClaimAdjudicationDate.CAdate != null)
                                        {
                                            if(SRClaim.ClaimTransactionDetail.ClaimAdjudicationDate.CAdate != '')
                                            {
                                                dtprocessed  = Date.valueOf(SRClaim.ClaimTransactionDetail.ClaimAdjudicationDate.CAdate);
                                            }
                                        }
                                    }
                                    
                                    Claim = new ACETClaimSearchResult();
                                    
                                    Claim.PHIRestriction = SRClaim.ClaimTransactionDetail.phiRestrictionIndicator;
                                    //Claim.ClaimID = SRClaim.ClaimTransactionDetail.OtherClaimId[0].id;
                                    Claim.ClaimID = SRClaim.ClaimTransactionDetail.claimSubmittedId.id;
                                    if(SRClaim.ClaimTransactionDetail.BillingProvider.Organization!=null)
                                    {
                                        if(SRClaim.ClaimTransactionDetail.BillingProvider.Organization.TinOwner!=null)
                                        {
                                            Claim.TaxID = SRClaim.ClaimTransactionDetail.BillingProvider.Organization.TinOwner[0].Tin.taxIdNbr;
                                        }
                                    }
                                     //Claim.Provider = SRClaim.ClaimTransactionDetail.BillingProvider.Professional.firstName;
                                    if(SRClaim.ClaimTransactionDetail.RenderingProvider!=null)
                                    {   
                                        if(SRClaim.ClaimTransactionDetail.RenderingProvider.Organization.Name !=null){
                                            Claim.Provider = SRClaim.ClaimTransactionDetail.RenderingProvider.Organization.Name;
                                        }
                                        else{
                                            if(SRClaim.ClaimTransactionDetail.RenderingProvider.Professional!=null)
                                            {
                                                String claimProvider = '';
                                                if(String.isBlank(SRClaim.ClaimTransactionDetail.RenderingProvider.Professional.lastName)){
                                                    // Null value Logic
                                                }
                                                else{
                                                    claimProvider = SRClaim.ClaimTransactionDetail.RenderingProvider.Professional.lastName;
                                                    if(String.isBlank(SRClaim.ClaimTransactionDetail.RenderingProvider.Professional.firstName)){
                                                        // Null value Logic
                                                    }
                                                    else{
                                                        claimProvider = claimProvider + ',' + SRClaim.ClaimTransactionDetail.RenderingProvider.Professional.firstName;
                                                        if(String.isBlank(SRClaim.ClaimTransactionDetail.RenderingProvider.Professional.middleName)){
                                                            // Null value Logic
                                                        }
                                                        else{
                                                            claimProvider = claimProvider + ' ' + SRClaim.ClaimTransactionDetail.RenderingProvider.Professional.middleName;                                                        
                                                        }
                                                    }                                                
                                                }  
                                                Claim.Provider = claimProvider;
                                            }
                                        }
                                        
                                    }
                                    Claim.Network = SRClaim.ClaimTransactionDetail.inNetworkIndicator;
                                    Claim.ServiceStart = Date.valueOf(SRClaim.ClaimTransactionDetail.ClaimServiceDateRange.startDate);
                                    Claim.ServiceEnd = Date.valueOf(SRClaim.ClaimTransactionDetail.ClaimServiceDateRange.stopDate);
                                    Claim.Processed = dtprocessed ;                                                               
                                    Claim.TotalCharged = Decimal.valueOf(SRClaim.ClaimTransactionDetail.totalBilledChargeAmount.value);
                                    Claim.TotalPaid = Decimal.valueOf(SRClaim.ClaimTransactionDetail.totalClaimPaidAmount.value);
                                    Claim.Deductible = Decimal.valueOf(SRClaim.ClaimTransactionDetail.totalClaimDeductibleAmount.value);
                                    Claim.BenefitLevel = 'N/A';
                                    Claim.Status = SRClaim.ClaimTransactionDetail.StatusCode.descz;
                                    //@Rama @Purpose: For diagnosis code mapping
                                    system.debug('@@@diagnosisCode' + SRClaim.ClaimTransactionDetail.diagnosisCode);
                                    if(SRClaim.ClaimTransactionDetail.diagnosisCode == null)
                                        Claim.PrimaryDiagnosisCode = '';
                                    else{
                                        for(ACETFindMedicalClaimJSON2Apex.DiagnosisCode diagnosisCode : SRClaim.ClaimTransactionDetail.diagnosisCode){
                                            if(diagnosisCode.levelTypeCode != null && diagnosisCode.levelTypeCode.code == 'primary'){
                                                Claim.PrimaryDiagnosisCode = diagnosisCode.DiagnosisCodeOidId.codeValueId;
                                            }                                                
                                            else
                                                Claim.PrimaryDiagnosisCode = '';
                                        }
                                    }
                                    system.debug('@@@PrimaryDiagnosisCode' + Claim.PrimaryDiagnosisCode);
                                    /*
                                    if(SRClaim.ClaimTransactionDetail.diagnosisCode[0] !=null){
                                        Claim.PrimaryDiagnosisCode = SRClaim.ClaimTransactionDetail.diagnosisCode[0].DiagnosisCodeOidId.codeValueId;
                                    }
                                    */
                                    Claims.add(Claim);
                                }
                            }
                        }        
                    }
                    else
                    {
                        oACETWSCalloutResult.Success = false;
                        oACETWSCalloutResult.Message = SystemLabels[4];
                        oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
                    }
                    
                }
                
            }
            else
            {
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
            }
            
            if (Claims.size() > 0)
            {
                ACETClaimSearchResult.SortBy = SortBy;
                ACETClaimSearchResult.SortOrder = SortOrder;
                Claims.Sort();
                
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = Claims;
            }
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in FindClaims. Details: ' + ex); 
            System.debug('getStackTraceString ' + ex.getStackTraceString());
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
        }
        
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);         
        return oACETWSCalloutResult;
    }
}