public class ACETGetSubscriptionBeneJSON2APEX {
    public getSubscriptionServiceBenefit getSubscriptionServiceBenefit;
    public class getSubscriptionServiceBenefit {
        public getSubscriptionServiceBenefitResponse getSubscriptionServiceBenefitResponse;
    }
    public class getSubscriptionServiceBenefitResponse {
        public serviceBenefit serviceBenefit;
    }
    public class serviceBenefit {
        public memberGroup memberGroup;
        public memberGroupContractPlanOption memberGroupContractPlanOption;
    }
    public class memberGroup {
    }
    public class memberGroupContractPlanOption {
        public String benefitBundleOptionId;    //35567894
        public String planMetallicLevel;    //25567894
        public benefitPlan[] benefitPlan;
    }
    public class benefitPlan {
        public List<membership> membership;
        public String benefitPlanId;    //CPD125
        public String coverageType; //M
        public String carrierId;    //16000_CIGNA
        public String legalEntityName;  //Oxford Health Insurance, Inc.
        public networkScheduleIds[] networkScheduleIds;
        public String gatedProductIndicator;    //MED
        public String pcpRequiredIndicator; //1
        public String productName;  //Gated INN/ONN
        public String productId;    //CPRD333
        public String planTypeCode; //02
        public String timelyFilingLimitDuration;    //300
        public String timelyFilingLimitType;    //555
        public String customerFacingPlanName;   //planname03
        public String administeredByName;   //3524
        public String riderOnlyFlag;    //0
        public planTier[] planTier;
        public benefitCode[] benefitCode;
    }
    public class membership {
        public String coverageStartDate {get;set;} 
        public String coverageEndDate {get;set;} 
        public String timePeriodQualifier {get;set;}
        public enrolleeIdentifier enrolleeIdentifier {get;set;}    
        public SubscriberIdentifier subscriberIdentifier {get;set;}   
    }
    public class SubscriberIdentifier{
        public String id;
        public String type;   
    }
    public class enrolleeIdentifier{
        public String id; 
        public String type;    
    }
    public class networkScheduleIds {
        public String networkScheduleId;    //Freedom
    }
    public class planTier {
        public String tierIdentifier;   //888999
        public String tierTypeCode; //1
        public String tierTypeDescription;  //In-Network Providers
        public String gatedPlanIndicator;   //N
        public String primaryIndividualDeductibleMaximum;   //2500
        public String primaryFamilyDeductibleMaximum;   //5000
        public String primaryIndividualOOPMaximum;  //2500
        public String primaryFamilyOOPMaximum;  //5000
        public planDelegation[] planDelegation;
    }
    public class planDelegation {
        public String delegationIndicator;  //q
        public String delegationIdentifier; //902313
        public String delegationName;   //pdname
    }
    public class benefitCode {
        public String benefitName;  //Office Dialysis
        public String benefitCode;  //DIALYSIS_OFFICE
        public String benefitTier;  //11
        public String benefitLevel; //101
        public String benefitVersion;   //102
        public String benefitCodeEffectiveDate; //2006-05-04
        public String benefitCodeExpirationDate;    //2020-05-04
        public String categoryCodeDescription;  //text101
        public String serviceTypeCode;  //stcid101
        public String serviceTypeDescription;   //908id101
        public String placeOfService;   //stdescid101
        public String deductibleAppliesIndicator;   //Y
        public String referralRequired; //Y
        public String authorizationRequired;    //Y
        public String coveredIndicator; //Y
        public String providerDesignation;  //text101
        public String ageLimitBeginningRangeValue;  //0
        public String ageLimitBeginningRangeUnit;   //D
        public String ageLimitEndingRangeValue; //999
        public String ageLimitEndingRangeUnit;  //Y
        public String genderLimit;  //A
        public relationshipLimits[] relationshipLimits;
        public stateLimits[] stateLimits;
        public String occurrenceLimitBeginningRangeValue;   //0
        public String occurrenceLimitEndingRangeValue;  //0
        public String occurrenceLimitForEveryValue; //0
        public String occurrenceLimitForEveryUnit;  //1
        public String consecutiveDaysLimitBeginningRangeValue;  //0
        public String consecutiveDaysLimitEndingRangeValue; //0
        public String dollarLimitBeginningRangeValue;   //0
        public String dollarLimitEndingRangeValue;  //0
        public String dollarLimitPerEveryValue; //0
        public String dollarLimitPerEveryUnit;  //0
        public String maxConsecutiveDays;   //10
        public String maxCoPayments;    //0
        public String maxCoPaymentForEveryValue;    //101
        public String maxCoPaymentForEveryUnit; //code101
        public waiveBenefitCoPayCodes[] waiveBenefitCoPayCodes;
        public String benefitCodeCoPaymentDuration; //D
        public eventBasedLimitType[] eventBasedLimitType;
        public medicalProcedureBasedLimitTypes[] medicalProcedureBasedLimitTypes;
        public benefitOverrides[] benefitOverrides;
        public coverageConditions[] coverageConditions;
        public benefitCostShare[] benefitCostShare;
    }
    public class relationshipLimits {
        public String relationshipLimit;    //Child
    }
    public class stateLimits {
        public String stateLimit;   //CA
    }
    public class waiveBenefitCoPayCodes {
        public String waiveBenefitCoPayCode;    //76id101
    }
    public class eventBasedLimitType {
        public String eventBasedBenefitLimitIdentifier; //Y
        public String eventBasedBenefitLimitType;   //23
        public String serviceMustStartWithin;   //929
        public String serviceCoveredThru;   //435
        public String serviceCoveredDuration;   //22
    }
    public class medicalProcedureBasedLimitTypes {
        public String medicalProcedureBasedBenefitLimitValue;   //1
    }
    public class benefitOverrides {
        public String benefitOverrideCode;  //33id101
        public String benefitOverrideIndicator; //Y
    }
    public class coverageConditions {
        public String diagnosisCategoryCode;    //3655id101
        public String diagnosisCategoryCodeDescription; //diagcdescid101
        public String procedureCategoryCode;    //567id101
        public String procedureCategoryCodeDescription; //pdid101
        public String conditionTimeFrame;   //11
        public String conditionTimeFrameDMY;    //M
    }
    public class benefitCostShare {
        public String coverageLevel;    //Indivdiual
        public String costShareType;    //Copayment
        public String benefitMaximumUnit;   //COPMT
        public String benefitMaximumValue;  //901
    }
    public static ACETGetSubscriptionBeneJSON2APEX parse(String json){
        return (ACETGetSubscriptionBeneJSON2APEX) System.JSON.deserialize(json, ACETGetSubscriptionBeneJSON2APEX.class);
    }
}