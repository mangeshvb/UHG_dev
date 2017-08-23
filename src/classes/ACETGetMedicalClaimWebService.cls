/**
* @name         :   ACETGetMedicalClaimWebService
* @description  :   Custom Wrapper class for the claims deatil results from service
* @author       :   Khoushik Selvaraj
* @userstories  :
* @createddate  :   20-09-2016
* @lastmodifiedby:
*
**/
public class ACETGetMedicalClaimWebService extends ACETWebService
{
 /*   public override void getEndpoint()
    {
       // RelativeURL = '/api/bravo/eisl/claims/v1.0/search';    // Alex: made change for Bravo
        //RelativeURL = '/api/test/eisl/claims/v1.0/search';
       if(WSConfigurations.containsKey('GetMedicalClaimEndpoint')){
            RelativeURL = WSConfigurations.get('GetMedicalClaimEndpoint').Value__c;
        }     
    } */



 public override void GetEndpoint()
    {
        GetEndpointDetail('GetMedicalClaimEndpoint');
    }
    
    private void getRequestBody(String strClaimId){
        
        //Integer intClaimId = Integer.ValueOf(strClaimId);
    
    system.debug('2323 intClaimId'+ strClaimId);
    strClaimId = '5889556100';
    
        RequestBody = '{'+
    '"getClaim": {'+
        '"getClaimRequestMsg": {'+
            '"headerMsg": {},'+
            '"body": {'+
                '"claimTransaction": {'+
                    '"otherClaimId": [{'+
                        '"id": '+ strClaimId
                    +'}]    }}      }   }}';
       
        
        system.debug('*** my json' + RequestBody );
     
    }
   



     public ACETWSCalloutResult getMedicalClaims(String strClaimId)
    {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETClaimDetailResult> Claims = new List<ACETClaimDetailResult>();
        ACETClaimDetailResult Claim;
        List<ACETClaimDetailResult.ServiceLines> lstServiceLines;
        ACETClaimDetailResult.ServiceLines serviceline;
        List<ACETClaimDetailResult.ClaimDiagnosis> lstClaimDiagnosis;
        ACETClaimDetailResult.ClaimDiagnosis claimdiagnosis;
        system.debug('inside webservice calss' + strClaimId);
        List<ACETGetMedicalClaimsJSON2Apex.Claim> GMClaims;
        
        List<ACETClaimDetailResult.RemarkCodes> lstRemarkCodes;
        ACETClaimDetailResult.RemarkCodes RemarkCodes;
        
        try
        {
            GetEndpoint();
            GetRequestBody(strClaimId);
            HttpResponse Response = Send(OAuthConfig);
            system.debug('2323 reponse' + Response.getStatusCode());
            system.debug('2323 reponse' +Response);
            if (Response.getStatusCode() == 200)
         // if (1==1)
            {
            
                                     //// start the If here
                                     
                                 
                                  
                                     
                                     
                                                 
                                                string jsonfullstring = Response.getBody();
                                                system.debug('**fulljsonresponsebefore' + jsonfullstring );
                                                jsonfullstring = jsonfullstring .replace('"desc":','"desc_Z":');
                                                jsonfullstring = jsonfullstring .replace('"date"','"birthdate"');
                                                system.debug('**fulljsonresponse' + jsonfullstring );
                                                Type resultType = Type.forName('ACETGetMedicalClaimsJSON2Apex');
                                                ACETGetMedicalClaimsJSON2Apex claimdetailresults = (ACETGetMedicalClaimsJSON2Apex)JSON.deserialize(jsonfullstring , resultType);
                                             
                                             
                                                if(claimdetailresults.GetClaimResult.GetClaimResponseMsg != null)
                                                {
                                                        GMClaims = claimdetailresults.GetClaimResult.GetClaimResponseMsg.Body.claim;
                                                }
                                                
                                                
                                             system.debug('**2323**' + GMClaims);
                                                if (GMClaims != null && GMClaims.size() > 0)
                                                {
                                                    if (GMClaims.size() > 0)
                                                    {
                                                       
                                                        for (ACETGetMedicalClaimsJSON2Apex.Claim SRClaim: GMClaims)
                                                        {
                                                        
                                                            
                                                            
                                                            
                                                            Claim = new ACETClaimDetailResult();
                                                            
                                                            //Mapping for Claim Totals - Summary section - starts
                                                                    Claim.ClaimId = SRClaim.ClaimTransactionDetail.OtherClaimId[0].Id;
                                                                    Claim.PolicyNumber = SRClaim.ClaimTransactionDetail.SubscriberIndividual.membership[0].customerAccountId.id;
                                                                    Claim.AuthorizationNumber = SRClaim.ClaimTransactionDetail.ClaimAuthorization.externalOrganizationAuthortizationId.id;
                                                                    //convert string to date
                                                                    Date receiveddate = null;
                                                                     if(SRClaim.ClaimTransactionDetail.claimReceiptDate.birthdate != null)
                                                                    {
                                                                        if(SRClaim.ClaimTransactionDetail.claimReceiptDate.birthdate != '')
                                                                        {
                                                                            receiveddate  = Date.valueOf(SRClaim.ClaimTransactionDetail.claimReceiptDate.birthdate);
                                                                        }
                                                                    }
                                                                    
                                                                    Claim.ReceivedDate = receiveddate;
                                                                    Claim.PatientAccountNumber = SRClaim.ClaimTransactionDetail.patientAccountNumber;
                                                                    Claim.BillType = SRClaim.ClaimTransactionDetail.claimBillTypeCode.code;
                                                                    Claim.ReferralNumber = 'N/A'; // we are not able to map this field
                                                                  
                                                                    String NYSurchargePaid = '';
                                                                    
                                                           //Mapping Service Lines
                                                                    lstServiceLines = new List<ACETClaimDetailResult.ServiceLines>();
                                                                    
                                                                    if(SRClaim.ClaimTransactionDetail.serviceLine !=null)
                                                                    {
                                                                        if(SRClaim.ClaimTransactionDetail.serviceLine.size() > 0 )
                                                                        {
                                                                        
                                                                        
                                                                        for(ACETGetMedicalClaimsJSON2Apex.ServiceLine srline: SRClaim.ClaimTransactionDetail.serviceLine)
                                                                        {
                                                                                serviceline  = new ACETClaimDetailResult.ServiceLines();
                                                                               
                                                                                 serviceline.PlaceofService = srline.placeOfServiceCode.code;
                                                                                 serviceline.Procedure = srline.procedureCode.code.code;
                                                                                 serviceline.Modifier = srline.procedureModifierCodeOidId[0].codeValueId;
                                                                                 serviceline.RemarkCode = srline.serviceLineNote[0].noteTypeCode.code + ' - ' +srline.serviceLineNote[0].noteText.text;
                                                                                 serviceline.DxPointer = srline.professionalService.diagnosis1PointerNumber+' '+srline.professionalService.diagnosis2PointerNumber+' '+srline.professionalService.diagnosis3PointerNumber+' '+srline.professionalService.diagnosis4PointerNumber;
                                                                                 serviceline.Units = srline.datedServiceUnitMeasure.value;
                                                                                 Date StartDate = null;
                                                                     if(srline.serviceDateRange.startDate != null)
                                                                    {
                                                                        if(srline.serviceDateRange.startDate != '')
                                                                        {
                                                                            StartDate = Date.valueOf(srline.serviceDateRange.startDate);
                                                                        }
                                                                    }
                                                                    Date EndDate = null;
                                                                     if(srline.serviceDateRange.stopDate != null)
                                                                    {
                                                                        if(srline.serviceDateRange.stopDate != '')
                                                                        {
                                                                            EndDate = Date.valueOf(srline.serviceDateRange.stopDate);
                                                                        }
                                                                    }
                                                                                 serviceline.StartDate = StartDate ;
                                                                                 serviceline.EndDate = EndDate ;
                                                                                 
                                                                                 List<ACETGetMedicalClaimsJSON2Apex.ServiceLineAdjustment> SLAdj = new List<ACETGetMedicalClaimsJSON2Apex.ServiceLineAdjustment>();
                                                                                 
                                                                                 if(srline.serviceLineAdjustment != null)
                                                                                 {
                                                                                     if(srline.serviceLineAdjustment.size() > 0)
                                                                                     {
                                                                                        SLAdj = srline.serviceLineAdjustment;
                                                                                     }
                                                                                 }
                                                                                 for(ACETGetMedicalClaimsJSON2Apex.ServiceLineAdjustment sladj1 :SLAdj)
                                                                                 {
                                                                                    if(sladj1.reasonCode.desc_Z == 'Override')
                                                                                    {
                                                                                        serviceline.strOverride = sladj1.reasonCode.code;
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        serviceline.strOverride = '';
                                                                                    }
                                                                                 }
                                                                                 
                                                                                 
                                                                                 serviceline.Charged = Decimal.ValueOf(srline.billedChargeAmount.value);
                                                                                 serviceline.Allowed = Decimal.ValueOf(srline.allowedLineAmount.value);
                                                                                 
                                                                                  List<ACETGetMedicalClaimsJSON2Apex.OtherMonetaryAmountType> CSMA = new List<ACETGetMedicalClaimsJSON2Apex.OtherMonetaryAmountType>();
                                                                                 
                                                                                 if(srline.otherMonetaryAmountType!= null)
                                                                                 {
                                                                                     if(srline.otherMonetaryAmountType.size() > 0)
                                                                                     {
                                                                                        CSMA = srline.otherMonetaryAmountType;
                                                                                     }
                                                                                 }
                                                                                 for(ACETGetMedicalClaimsJSON2Apex.OtherMonetaryAmountType csma1 :CSMA)
                                                                                 {
                                                                                    if(csma1.otherMonetaryAmountTypeCode.code == 'NotCoveredAmount')
                                                                                    {
                                                                                           serviceline.NotCovered = Decimal.ValueOf(csma1.otherMonetaryAmount.value);
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                           serviceline.NotCovered = 0.00;
                                                                                    }
                                                                                 }
                                                                                 
                                                                                 
                                                                              
                                                                                 serviceline.Deductible = Decimal.ValueOf(srline.deductibleLineAmount.value);
                                                                                 serviceline.Paid = Decimal.ValueOf(srline.netPaidLineAmount.value);
                                                                                 serviceline.Percent = '99.99';
                                                                                 serviceline.Authorization = '999999';
                                                                                
                                                                                //Get NY Surcharge value
                                                                                
                                                                                If(srline.surchargeTaxCode.taxCode.desc_Z == 'NewYorkSurcharge')
                                                                                {
                                                                                        NYSurchargePaid = srline.surchargeTaxCode.lineAmount.value;
                                                                                }
                                                                                
                                                                                
                                                                                
                                                                                
                                                                                lstServiceLines.add(serviceline);
                                                                        }
                                                                        
                                                                        Claim.lstwrpServiceLines = lstServiceLines;
                                                                        }
                                                                    }
                                                                    
                                                            //Mapping Claim Diagnosis
                                                                    lstClaimDiagnosis = new List<ACETClaimDetailResult.ClaimDiagnosis >();
                                                                    
                                                                    if(SRClaim.ClaimTransactionDetail.diagnosisCode !=null)
                                                                    {
                                                                        if(SRClaim.ClaimTransactionDetail.diagnosisCode.size() > 0 )
                                                                        {
                                                                        
                                                                        
                                                                        for(ACETGetMedicalClaimsJSON2Apex.DiagnosisCode cldiagnosis: SRClaim.ClaimTransactionDetail.diagnosisCode)
                                                                        {
                                                                                claimdiagnosis  = new ACETClaimDetailResult.ClaimDiagnosis();
                                                                                
                                                                                 claimdiagnosis.DiagnosisCode = cldiagnosis.diagnosisCodeOidId.codeValueId;
                                                                                 claimdiagnosis.DiagnosisDescription = cldiagnosis.diagnosisCodeOidId.codeDescription;
                                                                                 claimdiagnosis.POA = 'N/A';
                                                                                
                                                                                lstClaimDiagnosis.add(claimdiagnosis);
                                                                        }
                                                                        
                                                                        Claim.lstwrpClaimDiagnosis = lstClaimDiagnosis;
                                                                        }
                                                                    }
                                                                    
                                                                     //Mapping Claim Remark Codes
                                                                    lstRemarkCodes = new List<ACETClaimDetailResult.RemarkCodes >();
                                                                    
                                                                    
                                                                    if(SRClaim.ClaimTransactionDetail.claimRemarkCode !=null)
                                                                    {
                                                                        if(SRClaim.ClaimTransactionDetail.claimRemarkCode.size() > 0 )
                                                                        {
                                                                        
                                                                        
                                                                        for(ACETGetMedicalClaimsJSON2Apex.CoverageTypeCode rmcode: SRClaim.ClaimTransactionDetail.claimRemarkCode)
                                                                        {
                                                                                RemarkCodes  = new ACETClaimDetailResult.RemarkCodes();
                                                                                
                                                                                 RemarkCodes.RemarkCode = rmcode.code;
                                                                                 RemarkCodes.RemarkCodeDesc = rmcode.desc_Z;
                                                                                 RemarkCodes.Procedure = 'N/A';
                                                                                
                                                                                lstRemarkCodes.add(RemarkCodes);
                                                                        }
                                                                        
                                                                        Claim.lstwrpRemarkCodes = lstRemarkCodes;
                                                                        }
                                                                    }
                                                                    
                                                          
                                                           
                                                           //Mapping for Claim Totals - UHC
                                                                    Claim.Status = SRClaim.ClaimTransactionDetail.statusCode.desc_Z;
                                                                    Claim.TotalCharged = Decimal.ValueOf(SRClaim.ClaimTransactionDetail.totalBilledChargeAmount.value);
                                                                    Claim.TotalNotCovered = Decimal.ValueOf(SRClaim.ClaimTransactionDetail.totalNotCoveredAmount.value);
                                                                    Claim.TotalAllowed = Decimal.ValueOf('9999.99') ;
                                                                    Claim.InterestPaid = Decimal.ValueOf(SRClaim.ClaimTransactionDetail.totalInterestAmount.value);
                                                                    Claim.NYSurchargePaid = Decimal.ValueOf(NYSurchargePaid);
                                                                    Claim.TotalHealthPlanPaid = Decimal.ValueOf(SRClaim.ClaimTransactionDetail.totalClaimPaidAmount.value);
                                                            
                                                           //Mapping for Claim Totals - UHC Member Responsibility
                                                           
                                                                    Claim.MRNotCovered = Decimal.ValueOf('9999.99') ;
                                                                    Claim.MRDeductible = Decimal.ValueOf('9999.99') ;
                                                                    Claim.MRCopay = Decimal.ValueOf(SRClaim.ClaimTransactionDetail.totalCoPayAmount.value);
                                                                    Claim.MRReimbursementReduction = Decimal.ValueOf('9999.99') ;
                                                                    Claim.MRCoinsurance = Decimal.ValueOf('9999.99') ;
                                                                    Claim.MRTotalPatientResponsibility = Decimal.ValueOf(SRClaim.ClaimTransactionDetail.totalPatientResponsibilityAmount.value);
                                                           
                                                            //Mapping for Claim Totals - UHC Provider Responsibility
                                                                    Claim.PRNotCovered = Decimal.ValueOf('9999.99');
                                                                    Claim.PROverpaymentWithheld = Decimal.ValueOf('9999.99');
                                                                    Claim.PRTotalProviderWriteOff = 'Not Available';
                                                                    Claim.PRReimbursementReduction = Decimal.ValueOf('9999.99');
                                                            
                                                            // Mapping for Claim Totals - Primary / Secondary
                                                            
                                                            // Claim Totals - Secondary / Tertiary
                                                            
                                                            //Mapping for In/Out Patient Information
                                                            
                                                                    Claim.SurgeryDate= Date.today() ;
                                                                    Claim.DischargeDate= Date.today() ;
                                                                    Claim.SemiPrivateRoom= Decimal.ValueOf('9999.99') ;
                                                                    Claim.DRGNumber= SRClaim.ClaimTransactionDetail.diagnosisRelatedGroup.code.code;
                                                                    Claim.DRGGrouper= SRClaim.ClaimTransactionDetail.diagnosisRelatedGroup.code.code;
                                                                    
                                                            //Mapping for Medical Payment Details  
                                                                    Claim.SeriesDesignator= SRClaim.ClaimTransactionDetail.payment[0].seriesDesignatorId.id;
                                                                    Claim.CheckEpayment= SRClaim.ClaimTransactionDetail.payment[0].paymentTrackingNumberId.id;
                                                                    Claim.CheckStatus= SRClaim.ClaimTransactionDetail.payment[0].payeeCheckInfo.currentCheckStatus.code;
                                                                    Claim.PaymentType= SRClaim.ClaimTransactionDetail.payment[0].paymentMethodCode.code;
                                                                    
                                                                    if(SRClaim.ClaimTransactionDetail.effectiveDateRange.code == 'AdjustedDate')
                                                                    {
                                                                       
                                                                         Date mpprocesseddate= null;
                                                                         if(SRClaim.ClaimTransactionDetail.effectiveDateRange.effectiveDateRange.startDate != null)
                                                                        {
                                                                            if(SRClaim.ClaimTransactionDetail.effectiveDateRange.effectiveDateRange.startDate != '')
                                                                            {
                                                                                mpprocesseddate = Date.valueOf(SRClaim.ClaimTransactionDetail.effectiveDateRange.effectiveDateRange.startDate);
                                                                            }
                                                                        }
                                                                         Claim.ProcessedDate= mpprocesseddate;
                                                                    }
                                                                    
                                                                    Claim.IssuedDate= Date.today() ;
                                                                    Claim.CashedDate= Date.today() ;
                                                                    Claim.VoidStopDate= Date.today() ;
                                                                    Claim.ReturnedDate= Date.today();
                                                                    Claim.RemailedDate= Date.today() ;
                                                                    Claim.TotalCheckAmount= Decimal.valueOf(SRClaim.ClaimTransactionDetail.payment[0].finalPaymentAmount.value);
                                                                    
                                                                    //Mapping for Claim Details - Payee Information
                                                                    
                                                                    Claim.PayeeName = SRClaim.ClaimTransactionDetail.payment[0].payeeName.firstName + ' ' + SRClaim.ClaimTransactionDetail.payment[0].payeeName.middleInitialName + ' ' + SRClaim.ClaimTransactionDetail.payment[0].payeeName.lastName;
                                                                    /*Claim.PayeeAddress = SRClaim.ClaimTransactionDetail.payment[0].payeeAddress.line1 + ' ' +
                                                                                         SRClaim.ClaimTransactionDetail.payment[0].payeeAddress.line2 + ' ' +
                                                                                        SRClaim.ClaimTransactionDetail.payment[0].payeeAddress.city + ' ' +
                                                                                        SRClaim.ClaimTransactionDetail.payment[0].payeeAddress.state.code + ' ' +
                                                                                        SRClaim.ClaimTransactionDetail.payment[0].payeeAddress.postalCode[0].part1 + ' - ' +
                                                                                        SRClaim.ClaimTransactionDetail.payment[0].payeeAddress.postalCode[0].part2;
                                                                    */                   
                                                                    Claim.PayeeAddress = SRClaim.ClaimTransactionDetail.payment[0].payeeAddress;
                                                                    Claim.PTIIndicator = 'O';
                                                                    
                                                                   //Mapping for Claim Details - Consumer Account Payment Details
                                                                   
                                                                   Date HRAProcessedDate= null;
                                                                         if(SRClaim.ClaimTransactionDetail.effectiveDateRange.effectiveDateRange.startDate != null)
                                                                        {
                                                                            if(SRClaim.ClaimTransactionDetail.effectiveDateRange.effectiveDateRange.startDate != '')
                                                                            {
                                                                                HRAProcessedDate= Date.valueOf(SRClaim.ClaimTransactionDetail.effectiveDateRange.effectiveDateRange.startDate);
                                                                            }
                                                                        }
                                                                        
                                                                   Date FSAProcessedDate= null;
                                                                         if(SRClaim.ClaimTransactionDetail.effectiveDateRange.effectiveDateRange.startDate != null)
                                                                        {
                                                                            if(SRClaim.ClaimTransactionDetail.effectiveDateRange.effectiveDateRange.startDate != '')
                                                                            {
                                                                                FSAProcessedDate= Date.valueOf(SRClaim.ClaimTransactionDetail.effectiveDateRange.effectiveDateRange.startDate);
                                                                            }
                                                                        }
                                                                        
                                                                   
                                                                    Claim.HRAProcessedDate= HRAProcessedDate;
                                                                    Claim.FSAProcessedDate= FSAProcessedDate;
                                                                    Claim.HRAPayment= Decimal.ValueOf('9999.99');
                                                                    Claim.FSAPayment= Decimal.ValueOf('9999.99');
       
                                                                                                                               
                                                            Claims.add(Claim);
                                                        }
                                                    }        
                                                }
                                                else
                                                {
                                                    oACETWSCalloutResult.Success = false;
                                                    oACETWSCalloutResult.Message = 'No Results found';
                                                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
                                                }
                                     
                                   
                                    
                                  
            }
            else
            {
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
            }
      
            if (Claims.size() > 0)
            {
               
                
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = Claims[0];
            }
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in Get Medical Claims. Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
        }
        
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);         
        return oACETWSCalloutResult;
    }
}