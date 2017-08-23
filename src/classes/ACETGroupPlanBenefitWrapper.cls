public with sharing class ACETGroupPlanBenefitWrapper {
   
    // Benefit Section
    public List<BenefitWrapper> benefitWrapperList {get; set;}
    public Class BenefitWrapper {
        public String Benefit {get; set;}
        public String BenefitCode {get; set;}
        public String BenefitType {get; set;}
        public String BenefitFrom {get; set;}
        public String BenefitThru {get; set;}
    } 
    
    public List<coPayWrapper> coPayWrapperList {get; set;}
    public class coPayWrapper {
        public string label {get; set;}
        public string value {get; set;}
    }
    
    public List<individualBenefitWrapper> individualBenefitWrapperList {get; set;}
    public class individualBenefitWrapper {
        public string rowLabel {get; set;}
        public string dedLimit {get; set;}
        public string OOPLimit {get; set;}
    }
    
    public List<familyBenefitWrapper> familyBenefitWrapperList {get; set;}
    public class familyBenefitWrapper {
        public string rowLabel {get; set;}
        public string dedLimit {get; set;}
        public string OOPLimit {get; set;}
    }
    /*** Added by Avish as a part of Plan Information section display on 06012017 ***/
    //Plan Information
    public List<PlanInformationWrapper> planInfoWrapperList {get; set;}
    
    
    public Class PlanInformationWrapper {
        public String coverageType {get;set;}
        public String riderOnlyFlag {get;set;}
        public String PlanId {get;set;}
        public String PolicyNumber {get;set;}
        public String administeredByName {get;set;}
        public String PlanName {get;set;}
        public string PlanType {get;set;}
        public String Accumulator {get;set;}
        public String Gated {get;set;}
        public String PCP {get;set;}
        public String Network {get;set;}
        public String productId {get;set;}
        public String planTypeCode {get;set;}
        public String timePeriodQualifier {get;set;}
        public String gatedProductIndicator {get;set;}
        public String pcpRequiredIndicator {get;set;}
        public List<networkScheduleIds> networkSchedules {get;set;}
        
        public String EffectiveDate {get;set;}
        public String EndDate {get;set;}
        public String ExpirationDate{get;set;}
        public String RevisionDate {get;set;}
        public String GroupName {get;set;}  
        
        public String benefitBundleOptionId {get;set;}
        public String enrolleeType {get;set;}
        public String enrolleeIdentifier {get;set;}   
        
        public PlanInformationWrapper(){
            networkSchedules = new List<networkScheduleIds>();
        }           
    }     
    
    public class networkScheduleIds {
        public String networkSchId {get;set;}
    }
}