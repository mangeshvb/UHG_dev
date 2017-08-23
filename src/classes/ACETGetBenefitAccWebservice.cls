public class ACETGetBenefitAccWebservice extends ACETWebservice
{
    public override void GetEndpoint()
    {
         GetEndpointDetail('GetBenefitAccEndpoint');
    }
    
    private void GetRequestBody() {
        RequestBody = GetRequestBody('ACETGetBenefitAccRequestJSON', RequestParameters);        
    }
    
    public Continuation StartRequest(String BenefitBundleOptId, String EnrolleeIdentifierType, String EnrolleeIdentifierId, String EffectiveStartDate, 
            String EffectiveEndDate, String CoverageType, String BenefitVerIndicator, String BenefitCode, String CallbackMethodName, Continuation oContinuation)
    {
        system.debug(LoggingLevel.INFO, 'BenefitBundleOptionId: ' + BenefitBundleOptId + ', EnrolleeIdentifierType: ' + EnrolleeIdentifierType);
        system.debug(LoggingLevel.INFO, 'EnrolleeIdentifierId: ' + EnrolleeIdentifierId + ', EffectiveStartDate: ' + EffectiveStartDate);
        system.debug(LoggingLevel.INFO, 'EffectiveEndDate: ' + EffectiveEndDate + ', CoverageType: ' + CoverageType + ', BenefitVerIndicator: ' + BenefitVerIndicator);
        system.debug(LoggingLevel.INFO, 'BenefitCode: ' + BenefitCode + ', CallbackMethodName: ' + CallbackMethodName + ', oContinuation: ' + oContinuation);
        
        GetEndpoint();
        RequestParameters = new List<String>{BenefitBundleOptId, EnrolleeIdentifierType, EnrolleeIdentifierId, EffectiveStartDate, 
            EffectiveEndDate, CoverageType, BenefitVerIndicator, BenefitCode};
        GetRequestBody();
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        return oContinuation;         
    }
    
    public ACETWSCalloutResult ProcessResponse(String BenefitPlanId, String CoverageType, String HttpRequestLabel) {
        
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETPlanBenefitDetailController.Accumulator> Accumulators = new List<ACETPlanBenefitDetailController.Accumulator>();
        ACETPlanBenefitDetailController.Accumulator Accumulator;
        try
        {
            HttpResponse Response = GetHttpResponse(HttpRequestLabel);
            String ResponseBody = Response.getBody();
            if (Response.getStatusCode() == 200 || Response.getStatusCode() == 400)
            {
                ACETGetBenefitAccJSON2Apex ACETJSON2Apex = (ACETGetBenefitAccJSON2Apex)JSON.deserialize(Response.getBody(), ACETGetBenefitAccJSON2Apex.class);
                system.debug('ACETJSON2Apex : ' + ACETJSON2Apex);
                if (ACETJSON2Apex.benefitAccumulatorRSResult.getBenefitsAccumulatorResponse.errors == null) {
                    ACETGetBenefitAccJSON2Apex.BenefitsAccumulator benefitsAccumulator = ACETJSON2Apex.benefitAccumulatorRSResult.getBenefitsAccumulatorResponse.benefitsAccumulator;
                    if (benefitsAccumulator != null && benefitsAccumulator.membership != null) {
                        for (ACETGetBenefitAccJSON2Apex.Membership Membership :benefitsAccumulator.membership) {
                            if (Membership.benefitPlan != null) {
                                for (ACETGetBenefitAccJSON2Apex.BenefitPlan BenefitPlan :Membership.benefitPlan) {
                                    if (BenefitPlan.benefitPlanId == BenefitPlanId 
                                        && BenefitPlan.coverageType == CoverageType 
                                        && BenefitPlan.planTier != null) {
                                        for (ACETGetBenefitAccJSON2Apex.PlanTier planTier :BenefitPlan.planTier) {
                                            Accumulator = new ACETPlanBenefitDetailController.Accumulator();
                                            Accumulator.Section = 'Individual';
                                            Accumulator.TypeCode = planTier.tierTypeCode == '1' ? 'INN' : 'ONN';
                                            Accumulator.MaxDeductible = String.isNotBlank(planTier.primaryIndividualDeductibleMaximum) ? Decimal.valueOf(planTier.primaryIndividualDeductibleMaximum) : 0;
                                            Accumulator.YTDDeductible = String.isNotBlank(planTier.primaryIndividualDeductibleYTD) ? Decimal.valueOf(planTier.primaryIndividualDeductibleYTD) : 0;
                                            Accumulator.RemDeductible = Accumulator.MaxDeductible - Accumulator.YTDDeductible;
                                            Accumulator.MaxOOP = String.isNotBlank(planTier.primaryIndividualOOPMaximum) ? Decimal.valueOf(planTier.primaryIndividualOOPMaximum) : 0;
                                            Accumulator.YTDOOP = String.isNotBlank(planTier.primaryIndividualOOPYTD) ? Decimal.valueOf(planTier.primaryIndividualOOPYTD) : 0;
                                            Accumulator.RemOOP = Accumulator.MaxOOP - Accumulator.YTDOOP;
                                            Accumulators.add(Accumulator);
                                            Accumulator = new ACETPlanBenefitDetailController.Accumulator();
                                            Accumulator.Section = 'Family';
                                            Accumulator.TypeCode = planTier.tierTypeCode == '1' ? 'INN' : 'ONN';
                                            Accumulator.MaxDeductible = String.isNotBlank(planTier.primaryFamilyDeductibleMaximum) ? Decimal.valueOf(planTier.primaryFamilyDeductibleMaximum) : 0;
                                            Accumulator.YTDDeductible = String.isNotBlank(planTier.primaryFamilyDeductibleYTD) ? Decimal.valueOf(planTier.primaryFamilyDeductibleYTD) : 0;
                                            Accumulator.RemDeductible = Accumulator.MaxDeductible - Accumulator.YTDDeductible;
                                            Accumulator.MaxOOP = String.isNotBlank(planTier.primaryFamilyOOPMaximum) ? Decimal.valueOf(planTier.primaryFamilyOOPMaximum) : 0;
                                            Accumulator.YTDOOP = String.isNotBlank(planTier.primaryFamilyOOPYTD) ? Decimal.valueOf(planTier.primaryFamilyOOPYTD) : 0;
                                            Accumulator.RemOOP = Accumulator.MaxOOP - Accumulator.YTDOOP;
                                            Accumulators.add(Accumulator);
                                        }
                                    }
                                }   
                            }
                        }
                    }
                    oACETWSCalloutResult.Success = true;
                    oACETWSCalloutResult.Message = '';
                    oACETWSCalloutResult.Response = Accumulators;
                } else {
                    oACETWSCalloutResult.Success = false;
                    oACETWSCalloutResult.Message = GetOILErrorMessage(ACETJSON2Apex.benefitAccumulatorRSResult.getBenefitsAccumulatorResponse.errors);
                    oACETWSCalloutResult.Response = null;
                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
                }
            }
            else
            {
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
            }
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in Get Benefit Accumulator. Details: ' + ex); 
            System.debug('getStackTraceString ' + ex.getStackTraceString());
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
}