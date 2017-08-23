/**
* @name         :   ACETClaimPaymentWebService
* @description  :   Custom Class to perform the Claim Payment Summary Weservice Callout
* @author       :   Khoushik Selvaraj
* @userstories  :
* @createddate  :   04-11-2016
* @lastmodifiedby:
*
**/
public class ACETClaimPaymentWebService extends ACETWebService{ 
    
    public override void GetEndpoint()
    {
        GetEndpointDetail('SearchClaimPaymentsSummaryEndpoint');
    }
    
    private void getRequestBody(String strProviderId, String strTaxId, String strNPI, String strCallCode,String strCheckNumber, String strSeriesDesignator,String strTotalPayment,String strLastName,String strFirstName,String strMemberId,String strPolicyNumber){
        system.debug('inside getrequestbody');
        String strstaticfilename = 'findClaimPaymentsSummary';        
        StaticResource sr = [SELECT Id,NamespacePrefix,SystemModstamp FROM StaticResource WHERE Name = :strstaticfilename LIMIT 1];
        system.debug('StaticResource' + sr);
        String prefix = sr.NamespacePrefix;
        if( String.isEmpty(prefix) ) {
            prefix = '';
        } else {
            //If has NamespacePrefix
            prefix += '__';
        }
        String srPath = '/resource/' + sr.SystemModstamp.getTime() + '/' + prefix + strstaticfilename; 
        PageReference pg = new PageReference(srPath); 
        system.debug('srPath' + srPath);
        if(!Test.isRunningTest()){  
            system.debug('inside !unit test');      
            RequestBody = pg.getContent().toString();
        }else{
            system.debug('unit test');
            RequestBody = 'UNIT.TEST';
        }
        system.debug('*** my json' + RequestBody + 'total payment' + strTotalPayment + strProviderId + strTaxId + strNPI + strCallCode + strCheckNumber + strSeriesDesignator + strLastName + strFirstName + strMemberId);
        RequestBody = strProviderId != '' ? RequestBody.replace('@@ProviderID@@',strProviderId) : RequestBody.replace('@@ProviderID@@', ''); 
        RequestBody = strTaxId != '' ? RequestBody.replace('@@TaxID@@',strTaxId) : RequestBody.replace('@@TaxID@@', ''); 
        RequestBody = strNPI != '' ? RequestBody.replace('@@NPI@@',strNPI) : RequestBody.replace('@@NPI@@', '');  
        RequestBody = strCallCode != '' ? RequestBody.replace('@@callcode@@',strCallCode) : RequestBody.replace('@@callcode@@', ''); 
        RequestBody = strCheckNumber != '' ? RequestBody.replace('@@checkNumberId@@',strCheckNumber) : RequestBody.replace('@@checkNumberId@@', '');
        RequestBody = strSeriesDesignator != '' ? RequestBody.replace('@@checkSeriesDesignatorId@@',strSeriesDesignator) : RequestBody.replace('@@checkSeriesDesignatorId@@', '');
        /*if(!String.IsEmpty(strTotalPayment)){
        RequestBody = strTotalPayment != '' ? RequestBody.replace('@@checkNumberId@@',strTotalPayment) : RequestBody.replace('@@checkNumberId@@', '');  
        }*/
        RequestBody = strLastName != '' ? RequestBody.replace('@@PatientLastName@@',strLastName) : RequestBody.replace('@@PatientLastName@@', '');
        RequestBody = strFirstName != '' ? RequestBody.replace('@@PatientFirstName@@',strFirstName) : RequestBody.replace('@@PatientFirstName@@', '');
        RequestBody = strMemberId != '' ? RequestBody.replace('@@MemberID@@',strMemberId) : RequestBody.replace('@@MemberID@@', '');
        RequestBody = strPolicyNumber != '' ? RequestBody.replace('@@checkNumberId@@',strCheckNumber) : RequestBody.replace('@@checkNumberId@@', '');
    }
    public ACETWSCalloutResult findClaimPayments(String strProviderId, String strTaxId, String strNPI, String strCallCode, String strCheckNumber, String strSeriesDesignator,String strTotalPayment,String strLastName,String strFirstName,String strMemberId,String strPolicyNumber){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETClaimPaymentResult> Payments = new List<ACETClaimPaymentResult>();
        ACETClaimPaymentResult Payment;     
        List<ACETClaimPaymentJSON2Apex.Payment> SRPayments;        
        try
        {
            GetEndpoint();
            GetRequestBody(strProviderId,strTaxId, strNPI,strCallCode, strCheckNumber, strSeriesDesignator,strTotalPayment,strLastName,strFirstName,strMemberId,strPolicyNumber);
            
            system.debug('***OAuthConfig' + OAuthConfig);
            HttpResponse Response = Send(OAuthConfig);
            system.debug('***' + Response.getStatusCode());
            if (Response.getStatusCode() == 200)
            {            
                string jsonfullstring = Response.getBody();
                system.debug('jsonfullstring'+jsonfullstring);
                Type resultType = Type.forName('ACETClaimPaymentJSON2Apex');
                ACETClaimPaymentJSON2Apex searchresults = (ACETClaimPaymentJSON2Apex)JSON.deserialize(jsonfullstring , resultType);
                SRPayments = searchresults.FindClaimPaymentsSummaryResult.FindClaimPaymentSummaryResponseMsg.Body.Payments.payment;
                system.debug('**SRPayments**'+ SRPayments);
                if (SRPayments != null && SRPayments.size() > 0){                                       
                    for (ACETClaimPaymentJSON2Apex.Payment SRPayment: SRPayments)
                    {
                        if(SRPayment != null){
                            Payment = new ACETClaimPaymentResult();                                                                       
                            Payment.SeriesDesignator = SRPayment.seriesDesignatorId.id;
                            Payment.PaymentTotal = Integer.valueOf(SRPayment.finalPaymentAmount.value);
                            Date checkDate = null;
                            if(SRPayment.paymentFundDate!=null && SRPayment.paymentFundDate.dateTime_z != null){
                                if(SRPayment.paymentFundDate.dateTime_z != ''){
                                    checkDate  = Date.valueOf(SRPayment.paymentFundDate.dateTime_z);
                                }
                            } 
                            Payment.checkDate = checkDate;
                            Payment.PayeeName = SRPayment.payeeName;
                            Payment.PayeeAddress = SRPayment.address[0].line1 + ' ' +SRPayment.address[0].line2;
                            Payment.City = SRPayment.address[0].city;
                            Payment.State = String.ValueOf(SRPayment.address[0].state.code);
                            Payment.Zip = String.ValueOf(SRPayment.address[0].postalCode[0].code.code);
                            //payment details
                            Payment.PaymentType = SRPayment.paymentMethodCode.code;
                            
                            if(SRPayment.claimTransaction!=null && SRPayment.claimTransaction.size()>0 && SRPayment.paymentTrackingNumberId!=null  && SRPayment.paymentTrackingNumberId.Id!=null){
                                
                                //Payment.CheckEFTNumber = SRPayment.claimTransaction[0].paidClaim.checkNumber;
                                Payment.CheckEFTNumber = SRPayment.paymentTrackingNumberId.Id;
                            }   
                            Payment.BulkCheck = '';
                            
                            //if(SRPayment.claimTransaction!=null && SRPayment.claimTransaction.size()>0 && SRPayment.claimTransaction[0].statusCode!= null && SRPayment.claimTransaction[0].statusCode.code!= null){                                    
                                //Payment.CheckStatus = SRPayment.claimTransaction[0].statusCode.code;
                                
                            //}
                            Payment.IssuedDate  = checkDate;
                            //payee information
                            Payment.PayeeType = SRPayment.payeeTypeCode.code;
                            Payment.PayeeID  = '';
                            Payment.PayeeAddressLine1 = SRPayment.address[0].line1;
                            Payment.PayeeAddressLine2 = SRPayment.address[0].line2;
                            Payment.PayeeAddressCity = SRPayment.address[0].city;
                            Payment.PayeeAddressState = String.ValueOf(SRPayment.address[0].state.code);
                            Payment.PayeeAddressZip = String.ValueOf(SRPayment.address[0].postalCode[0].code.code);
                            //Claims
                            List<ACETClaimPaymentResult.Claims> lstClaims = new List<ACETClaimPaymentResult.Claims>(); 
                            system.debug('**Claims List**'+ lstclaims);
                            if(SRPayment.claimTransaction !=null)
                            {
                                if(SRPayment.claimTransaction.size() > 0 ){ 
                                    for(ACETClaimPaymentJSON2Apex.ClaimTransaction ct: SRPayment.claimTransaction)
                                    {
                                        system.debug('***CT***' + ct);
                                        ACETClaimPaymentResult.Claims claims  = new ACETClaimPaymentResult.Claims();
                                        if(ct.otherClaimId!=null && ct.otherClaimId[0].Id!=null){
                                            claims.ClaimNumber =  ct.otherClaimId[0].Id;
                                            system.debug('****claim number ****'+ claims.ClaimNumber);
                                        }
                                        claims.MemberID = strMemberId;
                                        //if(ct.subscriberIndividualId!=null && ct.subscriberIndividualId.id!=null){
                                          //  claims.PolicyNumber = ct.subscriberIndividualId.id;
                                        //}
                                        claims.PatientAccountNumber= claims.PatientAccountNumber= ct.claimServiceLine[0].customerAccountId.Id;
                                        claims.PolicyNumber = strPolicyNumber;
                                        claims.FirstName= strFirstName;
                                        claims.LastName= strLastName;
                                        //claims.Relationship = '';
                                        claims.PaidAmount = strTotalPayment;
                                        Date startDate = null;
                                        if(ct.ClaimServiceDateRange.startDate != null){
                                            if(ct.ClaimServiceDateRange.startDate != ''){
                                                startDate  = Date.valueOf(ct.ClaimServiceDateRange.startDate);
                                            }
                                        } 
                                        claims.StartDate = startDate;
                                        Date stopDate = null;
                                        if(ct.ClaimServiceDateRange.stopDate != null){
                                            if(ct.ClaimServiceDateRange.stopDate != ''){
                                                stopDate  = Date.valueOf(ct.ClaimServiceDateRange.stopDate);
                                            }
                                        } 
                                        claims.EndDate = stopDate;
                                        lstClaims.add(claims);
                                    }
                                    
                                    Payment.lstClaims = lstClaims;
                                }
                            }
                            Payments.add(Payment);
                        }
                    }                                                
                }else{
                    oACETWSCalloutResult.Success = false;
                    oACETWSCalloutResult.Message = 'No Payments Found';
                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
                }
            }else{
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
            }
            if (Payments.size() > 0){
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = Payments;
            }
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in Claim Payment Summary. Details: ' + ex + ex.getStackTraceString());
            
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
        }
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);         
        return oACETWSCalloutResult;
    }
}