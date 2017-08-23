public with sharing class ACETGetSubscriptionBenefitWebservice extends ACETWebservice {
   
    public ACETGroupPlanBenefitWrapper groupPlanWrapper ;
    public Map<String,String> teirCodeMap {get; set;}
    public override void GetEndpoint()
    {
         GetEndpointDetail('getSubscriptionBenefitSearch');
    }
    
    private void GetRequestBody(String bundleID,String network) {
         RequestBody = '{"getSubscriptionServiceBenefit":{"getSubscriptionServiceBenefitRequest":{"benefitBundleOptionId":"'+bundleID+'","parStatusType":"'+network+'"}}}';          
     }
     
   
    private void GetRequestBody(String bundleId, String enrollerSRK, String startDate, String EndDate, String CoverageTypes, String groupNumber)
    {
        List<String> SearchParameters = new String[] {bundleId};
        
        //RequestBody = GetRequestBody('GetSubscriptionBenefitJSON',SearchParameters);
        RequestBody = GetRequestFormatByName('GetSubscriptionBenefitJSON');
        system.debug(LoggingLevel.INFO, 'RequestBodyFormat: ' + RequestBody);
    }     
    
    private ACETGroupPlanBenefitWrapper parseSuccessAdapterResponse(String ResponseBody)
    {
        groupPlanWrapper = new ACETGroupPlanBenefitWrapper();
        groupPlanWrapper.benefitWrapperList = new List<ACETGroupPlanBenefitWrapper.BenefitWrapper>();
        groupPlanWrapper.planInfoWrapperList = new List<ACETGroupPlanBenefitWrapper.PlanInformationWrapper>();
        groupPlanWrapper.individualBenefitWrapperList = new List<ACETGroupPlanBenefitWrapper.individualBenefitWrapper>();
        groupPlanWrapper.familyBenefitWrapperList = new List<ACETGroupPlanBenefitWrapper.familyBenefitWrapper>();
        ACETGetSubscriptionBeneJSON2APEX.memberGroupContractPlanOption benefitSubDetails;
        ACETGetSubscriptionBeneJSON2APEX ACETEGDJSON2Apex = (ACETGetSubscriptionBeneJSON2APEX)JSON.deserialize(ResponseBody, ACETGetSubscriptionBeneJSON2APEX.class);
        benefitSubDetails = ACETEGDJSON2Apex.getSubscriptionServiceBenefit.getSubscriptionServiceBenefitResponse.serviceBenefit.memberGroupContractPlanOption; 
        riderInfoMapping(benefitSubDetails);
        individualFamilyInfoMapping(benefitSubDetails);
        return groupPlanWrapper;
    }
    
    private void riderInfoMapping(ACETGetSubscriptionBeneJSON2APEX.memberGroupContractPlanOption benefitSubscriptionDetails) {
         List<ACETGroupPlanBenefitWrapper.BenefitWrapper> groupPlanBenefitRiderInfoList = new List<ACETGroupPlanBenefitWrapper.BenefitWrapper>();
         system.debug(LoggingLevel.INFO,'benefitSubDetails.benefitBundleOptionId::' + benefitSubscriptionDetails.benefitBundleOptionId);
         String strBenefitBundleOptionId = benefitSubscriptionDetails.benefitBundleOptionId;
         
         for(ACETGetSubscriptionBeneJSON2APEX.benefitPlan benefitSectionInfo: benefitSubscriptionDetails.benefitPlan) {
             if(benefitSectionInfo.riderOnlyFlag == '1') {
                 for(ACETGetSubscriptionBeneJSON2APEX.benefitCode riderInfo:benefitSectionInfo.benefitCode) {
                     ACETGroupPlanBenefitWrapper.BenefitWrapper groupPlanBenefitRiderInfo = new  ACETGroupPlanBenefitWrapper.BenefitWrapper();
                     groupPlanBenefitRiderInfo.BenefitCode = (riderInfo.benefitCode != Null)?riderInfo.benefitCode :''; 
                     groupPlanBenefitRiderInfo.BenefitType = (riderInfo.benefitName != Null)?riderInfo.benefitName :'';
                     groupPlanBenefitRiderInfo.BenefitFrom = (riderInfo.benefitCodeEffectiveDate != Null)?string.valueOf(Date.valueOf(riderInfo.benefitCodeEffectiveDate).format()):'';
                     groupPlanBenefitRiderInfo.BenefitThru = (riderInfo.benefitCodeExpirationDate != Null)?string.valueOf(Date.valueOf(riderInfo.benefitCodeExpirationDate).format()) :'';
                     groupPlanWrapper.benefitWrapperList.add(groupPlanBenefitRiderInfo);
                 }
             }else if(benefitSectionInfo.riderOnlyFlag == '0' && benefitSectionInfo.coverageType == 'M'){
             
                 //Code for Plan Information Section added by Avish on 06012017
                 ACETGroupPlanBenefitWrapper.PlanInformationWrapper getPlanInfo = new  ACETGroupPlanBenefitWrapper.PlanInformationWrapper();
                 
                 getPlanInfo.coverageType = (benefitSectionInfo.coverageType != null)?benefitSectionInfo.coverageType:'';
                 getPlanInfo.riderOnlyFlag = (benefitSectionInfo.riderOnlyFlag != null)?benefitSectionInfo.riderOnlyFlag:'';
                 getPlanInfo.PlanId = (benefitSectionInfo.benefitPlanId != null)?benefitSectionInfo.benefitPlanId:'';
                 getPlanInfo.administeredByName = (benefitSectionInfo.administeredByName != null)?benefitSectionInfo.administeredByName:'';
                 getPlanInfo.productId = (benefitSectionInfo.productId != null)?benefitSectionInfo.productId:'';
                 getPlanInfo.planTypeCode = (benefitSectionInfo.planTypeCode != null)?benefitSectionInfo.planTypeCode:'';                
                 getPlanInfo.benefitBundleOptionId = (strBenefitBundleOptionId !=null)?strBenefitBundleOptionId:'';
                 getPlanInfo.gatedProductIndicator = (benefitSectionInfo.gatedProductIndicator != null)?benefitSectionInfo.gatedProductIndicator:'';
                 getPlanInfo.pcpRequiredIndicator = (benefitSectionInfo.pcpRequiredIndicator != null)?benefitSectionInfo.pcpRequiredIndicator:'';
                 
                // groupPlanWrapper.planInfoWrapperList.add(getPlanInfo); 
                 
                 
                 //Start of membership snippet
                 List<ACETGetSubscriptionBeneJSON2APEX.membership> membershipLst = new List<ACETGetSubscriptionBeneJSON2APEX.membership>();  
                 membershipLst = benefitSectionInfo.membership;  
                 system.debug(LoggingLevel.INFO,'membershipLst::' + membershipLst.size() + ' ::membershipLst:: ' + benefitSectionInfo.membership[0]);
                 if(membershipLst != null){
                     for(Integer index =0; index < membershipLst.size(); index++){
                         getPlanInfo.EffectiveDate = (membershipLst[0].coverageStartDate != null)?ChangeDateFormat(membershipLst[0].coverageStartDate):'';
                         getPlanInfo.ExpirationDate = (membershipLst[0].coverageEndDate != null)?ChangeDateFormat(membershipLst[0].coverageEndDate):'';
                         getPlanInfo.enrolleeIdentifier = (membershipLst[0].enrolleeIdentifier.id != null)?membershipLst[0].enrolleeIdentifier.id:'';
                         getPlanInfo.enrolleeType =  (membershipLst[0].enrolleeIdentifier.type != null)?membershipLst[0].enrolleeIdentifier.type:'';
                         getPlanInfo.timePeriodQualifier = (membershipLst[0].timePeriodQualifier != null)?membershipLst[0].timePeriodQualifier:'';
                         groupPlanWrapper.planInfoWrapperList.add(getPlanInfo);   
                     }
                 }    
                 //End of membership
                 
                 //Start of NetworkSchdule
                 List<ACETGroupPlanBenefitWrapper.networkScheduleIds> networkSchduleToAdd = new List<ACETGroupPlanBenefitWrapper.networkScheduleIds>();  
                 List<ACETGetSubscriptionBeneJSON2APEX.networkScheduleIds> networkSchduleLst = new List<ACETGetSubscriptionBeneJSON2APEX.networkScheduleIds>();  
                 networkSchduleLst = benefitSectionInfo.networkScheduleIds;  
                 if(networkSchduleLst != null){
                     ACETGroupPlanBenefitWrapper.networkScheduleIds networkSchObj = new  ACETGroupPlanBenefitWrapper.networkScheduleIds();
                     for(ACETGetSubscriptionBeneJSON2APEX.networkScheduleIds networkObj: networkSchduleLst){
                         
                         networkSchObj.networkSchId = networkObj.networkScheduleId;
                         networkSchduleToAdd.add(networkSchObj);
                         getPlanInfo.networkSchedules.add(networkSchObj);
                     }    
                                
                 }  
                 
                 //End of Network schedule         
             system.debug('networkSchduleToAdd:: ' + networkSchduleToAdd);
            } 
          
         }
    }
    
    private void individualFamilyInfoMapping(ACETGetSubscriptionBeneJSON2APEX.memberGroupContractPlanOption benefitIndividualFamilyDetails) {
        //List<ACETGroupPlanBenefitWrapper.individualBenefitWrapper> benefitDetailsIndividualInfoList = new List<ACETGroupPlanBenefitWrapper.individualBenefitWrapper>();
        //List<ACETGroupPlanBenefitWrapper.familyBenefitWrapper> benefitDetailsFamilyInfoList = new List<ACETGroupPlanBenefitWrapper.familyBenefitWrapper>();
        getTierCode();
        if(benefitIndividualFamilyDetails != null) {
            System.debug('Allowing1::::::::::::'+benefitIndividualFamilyDetails);
            //ACETGetSubscriptionBeneJSON2APEX.benefitPlan benefitIndivFamilySectionInfo = benefitIndividualFamilyDetails.benefitPlan[0];
            for(ACETGetSubscriptionBeneJSON2APEX.benefitPlan benefitIndivFamilySectionInfo: benefitIndividualFamilyDetails.benefitPlan) {
             if(benefitIndivFamilySectionInfo != null && benefitIndivFamilySectionInfo.riderOnlyFlag == '0') {   
                 for(ACETGetSubscriptionBeneJSON2APEX.planTier IndivFamilyInfo:benefitIndivFamilySectionInfo.planTier) {
                     if(IndivFamilyInfo != null) {
                         ACETGroupPlanBenefitWrapper.individualBenefitWrapper individualWrapper = new ACETGroupPlanBenefitWrapper.individualBenefitWrapper();
                         individualWrapper.rowLabel = (teirCodeMap.get(IndivFamilyInfo.tierTypeCode) != null)?teirCodeMap.get(IndivFamilyInfo.tierTypeCode):'';
                         individualWrapper.dedLimit = (IndivFamilyInfo.primaryIndividualDeductibleMaximum != null)?'$'+IndivFamilyInfo.primaryIndividualDeductibleMaximum :'N/A';
                         individualWrapper.OOPLimit = (IndivFamilyInfo.primaryIndividualOOPMaximum != null)?'$'+IndivFamilyInfo.primaryIndividualOOPMaximum:'N/A';
                         groupPlanWrapper.individualBenefitWrapperList.add(individualWrapper);
                         ACETGroupPlanBenefitWrapper.familyBenefitWrapper familyWrapper = new ACETGroupPlanBenefitWrapper.familyBenefitWrapper();
                         familyWrapper.rowLabel = (teirCodeMap.get(IndivFamilyInfo.tierTypeCode) != null)?teirCodeMap.get(IndivFamilyInfo.tierTypeCode):'';
                         familyWrapper.dedLimit = (IndivFamilyInfo.primaryFamilyDeductibleMaximum != null)?'$'+IndivFamilyInfo.primaryFamilyDeductibleMaximum :'N/A';
                         familyWrapper.OOPLimit = (IndivFamilyInfo.primaryFamilyOOPMaximum != null)?'$'+IndivFamilyInfo.primaryFamilyOOPMaximum:'N/A';
                         groupPlanWrapper.familyBenefitWrapperList.add(familyWrapper);
                     }
                 }
             }
             }
         }
    }
    public ACETWSCalloutResult getSubscriptionBenefitSearch(string bundleID,String getPlanFlag){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETGroupPlanBenefitWrapper groupPlanWrapper;
        
        try
        {
            GetEndpoint();
            HttpResponse Response = null;
            if(getPlanFlag == '1' || getPlanFlag == '2'){
                GetRequestBody(bundleID,getPlanFlag);
                Response = Send(OAuthConfig);
            }else{
                //Code for Plan Information section Added
                //Rama: 6/4- Using hardcoded response while waiting for data from OIL
            system.debug(LoggingLevel.INFO,'Inside ACETGetSubscriptionBenefitWebservice');
                Response = new HttpResponse();
               // Response.setBody(ACETTestDataUtility.getSubscriptionBenefitJSON());
                Response.setStatusCode(200);  
                GetRequestBody(bundleID,null,null,null,null,null);
                Response = Send(OAuthConfig);
                system.debug('Response----->'+Response.getBody());              
            }
            
            
            if (Response.getStatusCode() == 200)
            {
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(Response.getBody()));
                
            }
            else
            {
                oACETWSCalloutResult = ParseFailureResponse(Response);        
            }
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in GetEmployer. Details: ' + ex + ex.getLineNumber() +ex.getMessage()); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);        
        return oACETWSCalloutResult;
    }
    
    public Map<String,String> getTierCode() {
        teirCodeMap = new Map<String,String>();
        teirCodeMap.put('1','INN');
        teirCodeMap.put('2','OON');
        return teirCodeMap;
    }
}