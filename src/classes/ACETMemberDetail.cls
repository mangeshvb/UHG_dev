public with sharing class ACETMemberDetail {
    //override
    public String FirstName {get;set;}
    public String LastName {get;set;}
    public String MemberId {get;set;}
    public String SCRId {get;set;}
    public String DOB {get;set;}
    public String RelationShip {get;set;}
    public String RelationShipCode {get;set;}
    public String OriginatorRelationship {get;set;}
    public String MiddleInitial {get;set;}
    public String Gender {get;set;}
    public String Age {get;set;}
    public String SSN {get;set;}
    public String FullSSN {get;set;}
    public String SpokenLanguage {get;set;}
    public String Email {get;set;}
    public String AsianInitiativeIndicator {get;set;}
    public String MigrationDate {get;set;}
    public String OriginalEffectiveDate {get;set;}
    public String DeceasedDate {get;set;}
    public String PCPRequired {get;set;}
    public String PCPAssignment {get;set;}
    public String SitusState {get;set;}
    public String PolicyNumber {get;set;}
    public String FundingArragement {get;set;}
    public String BenefitPlanId {get;set;}
    public String FundingArragementCode {get;set;}
    public String Network {get;set;}        
    public String EffectiveDate {get;set;}
    public String EndDate {get;set;}
    public String Product {get;set;}
    public String ProductType {get;set;}
    public String Suffix {get;set;}
    public String BundleOptionID {get;set;}
    public CoverageLine PreferredCoverage {get;set;}
    
    public List<Address> Addresses {get;set;}
    public List<Phone> Phones {get;set;}
    public List<PCPAssignment> PCPAssignments {get;set;}
    public List<FamilyMember> FamilyMembers {get;set;}
    public List<CoverageLine> CoverageLines {get;set;}
    //added by Ranjit for ROI Section in the member Detail Page
    public List<otherContact> ROIcontacts {get;set;}
    
     //added by Khoushik on 09/28/2016 for User Story - US378010
    public List<COB> lstCOB {get;set;}
    //added by Khoushik for Surrogate Id related Stories
    //added by Khoushik for Surrogate Id User Stories
    public String SurrogateKey {get;set;} 
   // public String MembershipSurrogateKey {get;set;} 
    public Set<String> SurrogateKeys {get;set;}
    public ACETMemberDetail() {
        SurrogateKeys = new Set<String>();  
    }
     
    public class Address {
        public String AddressLine1 {get;set;}
        public String AddressLine2 {get;set;}
        public String City {get;set;}
        public String State {get;set;}
        public String Zip {get;set;} 
        public String AddressType {get;set;}  
        public string countryCode {get;set;}      
    }
    
    public class Phone {
        public String PhoneNumber {get;set;}
        public String PhoneNumberType {get;set;}  
        public String primaryIndicator {get;set;}  
    }   
    
    public class PCPAssignment {
        public Boolean isChecked{get;set;}
        public Boolean isActive{get;set;}
        public String FirstName {get;set;}
        public String LastName {get;set;}   
        public String pcpAssignmentType {get;set;}
        public string endDate{get;set;}
        public string effectiveDate {get;set;} 
        public String id {get;set;} 
        public String identifiertype {get;set;}    
    }   
    public class otherContact{
        public boolean ContactStatus {get;set;}
        public String FirstName {get;set;}
        public String LastName {get;set;}   
        public String MiddleName {get;set;}
        public Date effectiveDate {get;set;}
        public Date terminationDate {get;set;}
        public string docLink {get;set;}          
    }
    public class FamilyMember {
        public String FirstName {get;set;}
        public String LastName {get;set;}
        public String MiddleInitial {get;set;}
        public String Relationship {get;set;}
        public String Gender {get;set;}     
        public String DOB {get;set;}   
        public String suffix {get;set;}     
        //added by Swetha//
        public String EID {get;set;}  
        public String Age {get;set;} //calculated from DOB 
        public String FamilyId {get;set;}
        public String subscriberIndividualId{get;set;}
        //Added by Rupsa to select table rows in Termination Enrollment, Reinstatement pages
        public Boolean selected {get; set;}
        public Date effectiveDate {get; set;}
        public Date termDate {get; set;}
        public Date reinstDate {get; set;}
        public String CoverageStatus{get;set;}
        public List<Address> Addresses {get;set;}
        public FamilyMember(){
            selected = false;
        }
        public string groupNumber{get;set;}
        public string benefitBundleOptionId {get;set;}   
    }
    
    public class CoverageLine {
        Public String GUID {get;set;} //manually generated
        public String CoverageType {get;set;}
        public String PolicyNumber {get;set;}
        public String GroupName {get;set;}
        public String GroupNumber {get;set;}
        public String Product {get;set;}
        public String ProductType {get;set;}
        public String Network {get;set;}
        public String EffectiveDate {get;set;}
        public String EndDate {get;set;}
        public String SourceCode {get;set;}
        public String CoverageLevel {get;set;}
        public String FundingArrangement {get;set;}
        public String BenefitPlanId {get;set;}
        public String PlanSitusState {get;set;}
        public String SurrogateKey {get;set;}
        public String OnshoreRestriction {get;set;}
        
        public CoverageLine(){
            GUID = ACETGUIDUtil.newGuid();  
        }  
                        
        public Boolean getIsActive(){
            if(String.isEmpty(EffectiveDate) || String.isEmpty(EndDate)) return false; 
            
            Date objEffectiveDate = Date.newInstance(Integer.valueOf(EffectiveDate.split('/')[2]), Integer.valueOf(EffectiveDate.split('/')[0]), Integer.valueOf(EffectiveDate.split('/')[1]));
            Date objEndDate = Date.newInstance(Integer.valueOf(EndDate.split('/')[2]), Integer.valueOf(EndDate.split('/')[0]), Integer.valueOf(EndDate.split('/')[1]));
            
            return (Date.today() >= objEffectiveDate) && (Date.today() < objEndDate);
        }                         
        
    }
     //added by Khoushik on 09/28/2016 for User Story - US378010
      public class COB {
        public String Name {get;set;}
        public String Relationship {get;set;}
        public String DateOfBirth {get;set;}
        public String InsuranceType {get;set;}
        public String COBTypeDesc {get;set;}// will map to coverage type desc
        public String IsOtherInsurancePrimary {get;set;}
        public Date Startdt {get;set;}
        public Date Enddt {get;set;}
        public Date LastUpdate {get;set;}
        public String MedicareType {get;set;} 
        public String IsMedicarePrimary {get;set;}     
        public String EntitlementReason {get;set;}
        public Date PartAStart {get;set;}
        public Date PartBStart {get;set;}
        public Date PartDStart {get;set;}
        public Date PartAEnd {get;set;}
        public Date PartBEnd {get;set;}
        public Date PartDEnd {get;set;}
        public String Age {get;set;} 
        public String CoverageTypeCode {get;set;} 
        public String OrderOfBenefit {get;set;}
        public String BenefitType {get;set;}              
      }
      public String MiddleName {get;set;} 
      public String EligibilityStatus{get;set;} 
      public Date TerminationDate{get;set;} 
      public Date DateOfEmployment{get;set;} 
      public String EmploymentStatus{get;set;} 
      public String CoverageLevel{get;set;} 
      public String GroupName{get;set;} 
      public String EmploymentStartDate{get;set;}
      
    public String ClaimAddressline1 {get;set;} 
    public String ClaimAddressline2 {get;set;} 
    public String ClaimAddresscity {get;set;} 
    public String ClaimAddressstate {get;set;} 
    public String ClaimAddresspostalCode {get;set;} 
    public String ClaimAddresscountyCode {get;set;} 
              
}