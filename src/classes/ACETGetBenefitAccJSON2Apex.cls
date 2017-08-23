public class ACETGetBenefitAccJSON2Apex {
    public BenefitAccumulatorRSResult benefitAccumulatorRSResult {get;set;} 
    
/*    public class BenefitOverride {
        public String benefitOverrideCode {get;set;} 
        public String benefitOverrideIndicator {get;set;} 
    }
    
    public class EnrolleeIdentifier {
        public String etype {get;set;} // in json: type
        public String id {get;set;} 
    }
    
    public class WaiveBenefitCopayCodes {
        public String waiveBenefitCopayCode {get;set;} 
    }
    
    public class EventBasedLimit {
        public String eventBasedBenefitLimitIdentifier {get;set;} 
        public String eventBasedBenefitLimitType {get;set;} 
        public String serviceMustStartWithin {get;set;} 
        public String serviceCoveredThru {get;set;} 
        public String serviceCoveredDuration {get;set;} 
    }
    
    public class MedicalProcedureBasedLimit {
        public String medicalProcedureBasedBenefitLimitValue {get;set;} 
    }    
    
    public class StateLimits {
        public String stateLimit {get;set;} 
    }
    
    public class RelationshipLimits {
        public String relationshipLimit {get;set;} 
    }   */
    
    public class PlanTier {
      //  public String tierIdentifier {get;set;} 
        public String tierTypeCode {get;set;} 
      //  public String tierTypeDescription {get;set;} 
        public String primaryIndividualDeductibleMaximum {get;set;} 
        public String primaryFamilyDeductibleMaximum {get;set;} 
        public String primaryIndividualOOPMaximum {get;set;} 
        public String primaryFamilyOOPMaximum {get;set;} 
        public String primaryIndividualDeductibleYTD {get;set;} 
        public String primaryFamilyDeductibleYTD {get;set;} 
        public String primaryIndividualOOPYTD {get;set;} 
        public String primaryFamilyOOPYTD {get;set;} 
    }
    
    public class BenefitAccumulatorRSResult {
        public GetBenefitsAccumulatorResponse getBenefitsAccumulatorResponse {get;set;} 
    }
    
/*    public class CoverageConditions {
        public String memberIndicator {get;set;} 
        public String diagnosisCategoryCode {get;set;} 
        public String diagnosisCategoryCodeDescription {get;set;} 
        public String procedureCategoryCode {get;set;} 
        public String procedureCategoryCodeDescription {get;set;} 
        public String conditionTimeFrame {get;set;} 
        public String conditionTimeFrameDMY {get;set;} 
    }   */
    
    public class BenefitsAccumulator {
        public List<Membership> membership {get;set;} 
    }
    
    public class Membership {
      //  public EnrolleeIdentifier enrolleeIdentifier {get;set;} 
     //   public String coverageStartDate {get;set;} 
    //    public String coverageEndDate {get;set;} 
      //  public String timePeriodQualifier {get;set;} 
        public List<BenefitPlan> benefitPlan {get;set;} 
    }
    
    public class GetBenefitsAccumulatorResponse {
        public BenefitsAccumulator benefitsAccumulator {get;set;}
        public ACETOILError[] errors { get; set; }  
    }
    
    public class BenefitCode {
        public String benefitName {get;set;} 
        public String benefitCode {get;set;} 
        public String benefitTier {get;set;} 
        public String benefitLevel {get;set;} 
        public String benefitVersion {get;set;} 
        public String benefitCodeEffectiveDate {get;set;} 
        public String benefitCodeExpirationDate {get;set;} 
        public String categoryCode {get;set;} 
        public String categoryCodeDescription {get;set;} 
        public String serviceTypeCode {get;set;} 
        public String serviceTypeDescription {get;set;} 
        public String providerDesignation {get;set;} 
        public String ageLimitBeginningRangeValue {get;set;} 
        public String ageLimitBeginningRangeUnit {get;set;} 
        public String ageLimitEndingRangeValue {get;set;} 
        public String ageLimitEndingRangeUnit {get;set;} 
        public String genderLimit {get;set;} 
    //    public List<RelationshipLimits> relationshipLimits {get;set;} 
     //   public List<StateLimits> stateLimits {get;set;} 
        public String occurrenceLimitBeginningRangeValue {get;set;} 
        public String occurrenceLimitEndingRangeValue {get;set;} 
        public String occurrenceLimitForEveryValue {get;set;} 
        public String occurrenceLimitForEveryUnit {get;set;} 
        public String consecutiveDaysLimitBeginningRangeValue {get;set;} 
        public String consecutiveDaysLimitEndingRangeValue {get;set;} 
        public String dollarLimitBeginningRangeValue {get;set;} 
        public String dollarLimitEndingRangeValue {get;set;} 
        public String dollarLimitPerEveryValue {get;set;} 
        public String dollarLimitPerEveryUnit {get;set;} 
        public String maxConsecutiveDays {get;set;} 
        public String maxCopayments {get;set;} 
        public String maxCopaymentForEveryValue {get;set;} 
        public String maxCopaymentForEveryUnit {get;set;} 
      //  public List<WaiveBenefitCopayCodes> waiveBenefitCopayCodes {get;set;} 
     //   public String benefitCodeCopaymentDuration {get;set;} 
      //  public List<EventBasedLimit> eventBasedLimit {get;set;} 
      //  public List<MedicalProcedureBasedLimit> medicalProcedureBasedLimit {get;set;} 
      //  public List<BenefitOverride> benefitOverride {get;set;} 
      //  public List<CoverageConditions> coverageConditions {get;set;} 
        public List<BenefitCostShare> benefitCostShare {get;set;} 
    }   
    
    public class BenefitCostShare {
        public String coverageLevel {get;set;} 
        public String costShareType {get;set;} 
        public String benefitMaximumUnit {get;set;} 
        public String benefitMaximumValue {get;set;} 
        public String costShareId {get;set;} 
        public String primaryCostShareIndicator {get;set;} 
        public String benefitYTDValue {get;set;} 
        public String benefitRemainingValue {get;set;} 
        public String shareBasedPlanAccumulatorIndicator {get;set;} 
        public String familyAccumulationType {get;set;} 
        public String familyAccumulationTypeDescription {get;set;} 
    }    
    
    public class BenefitPlan {
        public String benefitPlanId {get;set;} 
        public String coverageType {get;set;} 
        public List<PlanTier> planTier {get;set;} 
        public List<BenefitCode> benefitCode {get;set;} 
    }
}