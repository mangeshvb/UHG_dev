public with sharing class ACETGroupDetail{
    public string groupName{get;set;}
    public string groupId{get;set;}
    public string groupTaxId{get;set;}
    public string groupRenewalDate{get;set;}
    public string groupAddress{get;set;}
    public string groupCity{get;set;}
    public string groupState{get;set;}
    public string groupZip{get;set;}
    public string groupStatus{get;set;}
    public list<purchasedBenefits> purchasedBenefitsList{get;set;}
    public list<CurveOut> curveOutList{get;set;}
    
    public groupGeneralInfo genGroupInfo{get; set;}
    public AddressInfo addrGroupInfo {get;set;}
    public groupEligibilityInfoEnrollWaiting groupEEnrollWaiting {get;set;}
    public list<employeeCountInfo> groupEmployeeCountInfoList{get;set;}
    public list<groupContactInfo> groupExternalContactInfoList{get;set;}
    public list<groupContactInfo> groupExternalContactInfoHistoryList{get;set;}
    public list<groupContactInfo> groupInternalContactInfoList{get;set;}
    public list<AddressInfo> groupAddressInfoList {get;set;}
    //Eligibility TBD
    
    public list<groupEligibilityInfoOpenEnroll> groupEligibilityInfoOpenEnrollList{get;set;}
    public list<groupEligibilityInfoEnrollWaiting> groupEligibilityInfoEnrollWaitingList{get;set;}
    public list<groupEligibilityInfoTermLag> groupEligibilityInfoTermLagList{get;set;}
    public list<groupEligibilityInfoOpenEnroll> groupEligibilityEnrollmentWaitingPeriod {get;set;}
    public list<terminationLag> groupEligibilityTerminationLag  {get;set;}
    public list<DependentCutOff> groupEligibilityDependentCutOff {get;set;}
    public list<openEnrollmentPeriod> groupEligibilityEnrollmentPeriod {get;set;}
    public list<rehireLag> groupEligibilityRehireLag {get;set;}
    public list<retireepolicy> groupEligibilityRetirePolicy {get; set;}
    
    public list<retireePolicyWrapper> groupEligibilityRetirePolicyTest {get; set;}
    //Benefit
    public list<GroupPlanWrapper> GroupPlanBenefitList {get;set;}
    
    public ACETGroupDetail(){}
    
    public class groupGeneralInfo{
        public string groupName{get;set;}
        public string groupId{get;set;}
        public string groupTaxId{get;set;}
        public string groupStatus{get;set;}
        public string groupRenewalDate{get;set;}
        public String groupTeamSize { get; set; }
        public string serviceTeam{get;set;}
        public String effectiveStartDate { get; set; }
        public String effectiveEndDate { get; set; }
        public String UHCBSCOBRA{ get; set;}
        public String riskManagement{ get; set;}
        public String asianInitIndicator{ get; set;}
        public String insured{ get; set;}
        public string onshoreRestriction{get;set;}
        public string terminationDate{get;set;}
        public string terminationReason{get;set;}
        public String classesIncluded {get; set;}
    }
    
    public class AddressInfo{
        public string addrType {get;set;}
        public String addrLine1 { get; set;}
        public String addrLine2 { get; set;}
        public String addrLine3 { get; set;}
        public String city { get; set;}
        public String state{ get; set;}
        public String zip { get; set;}
        public string address{get;set;} //Added by Krishna for US598757
        public string concatAddrLines{get;set;} //Added by Krishna for US665995 
    }
    
    public class groupEligibilityInfoOpenEnroll{
        public string eType{get;set;}
        public string startDate{get;set;}
        public string endDate{get;set;}
          public String GUID {get; set;}
        public boolean isActive {get; set;} 
        public  groupEligibilityInfoOpenEnroll() {
             GUID = ACETGUIDUtil.newGuid(); 
         }
         public String getImage(){ 
           // System.debug('Get IMage...........'+fromRP+throughtRP);
            String benefitStatus = '';
            Date objThroughDate;
            Date objFromDate;
            if(startDate!= null) {
               objFromDate = Date.newInstance(Integer.valueOf(startDate.split('/')[2]), Integer.valueOf(startDate.split('/')[0]), Integer.valueOf(startDate.split('/')[1]));
            }
            if(endDate != null) {
               objThroughDate = Date.newInstance(Integer.valueOf(endDate.split('/')[2]), Integer.valueOf(endDate.split('/')[0]), Integer.valueOf(endDate.split('/')[1]));
            }
            //System.debug('Get IMage1...........'+objFromDate+objThroughDate);
            if(Date.today() < objFromDate) {
                benefitStatus = 'Blue';
            }
            else if(Date.today() >= objFromDate && (Date.today() <= objThroughDate || endDate == null)) {
                benefitStatus = 'active';
            }
            else if(Date.today() > objFromDate && Date.today() > objThroughDate) {
                benefitStatus = 'inactive';
            }
            System.debug('Get IMage Status...........'+benefitStatus);
            return benefitStatus;
        }             
    }
    
    public class groupEligibilityInfoEnrollWaiting{
        public string eType{get;set;}
        public string startDate{get;set;}
        public string endDate{get;set;}  
          public String GUID {get; set;}
        public boolean isActive {get; set;} 
        public  groupEligibilityInfoEnrollWaiting() {
             GUID = ACETGUIDUtil.newGuid(); 
         }
         public String getImage(){ 
           // System.debug('Get IMage...........'+fromRP+throughtRP);
            String benefitStatus = '';
            Date objThroughDate;
            Date objFromDate;
            system.debug('enrollwaiting startdate date ====>'+startDate);
            if(startDate != null && startDate != '') {
               objFromDate = Date.newInstance(Integer.valueOf(startDate.split('/')[2]), Integer.valueOf(startDate.split('/')[0]), Integer.valueOf(startDate.split('/')[1]));
            }
            system.debug('enrollwaiting end date ====>'+endDate);
            if(endDate != null && endDate !='') {
               objThroughDate = Date.newInstance(Integer.valueOf(endDate.split('/')[2]), Integer.valueOf(endDate.split('/')[0]), Integer.valueOf(endDate.split('/')[1]));
            }
            //System.debug('Get IMage1...........'+objFromDate+objThroughDate);
            if( startDate != null && Date.today() < objFromDate) {
                benefitStatus = 'Blue';
            }
            else if((startDate !=null && Date.today() >= objFromDate) && (Date.today() <= objThroughDate || endDate == null)) {
                benefitStatus = 'active';
            }
            else if(startDate != null && endDate !=null && Date.today() > objFromDate && Date.today() > objThroughDate) {
                benefitStatus = 'inactive';
            }
            System.debug('Get IMage Status...........'+benefitStatus);
            return benefitStatus;
        }           
    }
    
    public class groupEligibilityInfoTermLag{
        public String statustermnation {get;set;}
        public string eType{get;set;}
        public string descr{get;set;}
        public string startDate{get;set;}
        public string endDate{get;set;} 
        public String GUID {get; set;}
        public boolean isActive {get; set;} 
        public  groupEligibilityInfoTermLag() {
             GUID = ACETGUIDUtil.newGuid(); 
         }
         public String getImage(){ 
           // System.debug('Get IMage...........'+fromRP+throughtRP);
            String benefitStatus = '';
            Date objThroughDate;
            Date objFromDate;
            if(startDate!= null) {
               objFromDate = Date.newInstance(Integer.valueOf(startDate.split('/')[2]), Integer.valueOf(startDate.split('/')[0]), Integer.valueOf(startDate.split('/')[1]));
            }
            if(endDate != null) {
               objThroughDate = Date.newInstance(Integer.valueOf(endDate.split('/')[2]), Integer.valueOf(endDate.split('/')[0]), Integer.valueOf(endDate.split('/')[1]));
            }
            //System.debug('Get IMage1...........'+objFromDate+objThroughDate);
            if(Date.today() < objFromDate) {
                benefitStatus = 'Blue';
            }
            else if(Date.today() >= objFromDate && (Date.today() <= objThroughDate || endDate == null)) {
                benefitStatus = 'active';
            }
            else if(Date.today() > objFromDate && Date.today() > objThroughDate) {
                benefitStatus = 'inactive';
            }
            System.debug('Get IMage Status...........'+benefitStatus);
            return benefitStatus;
        }     
    }
    
    public class employeeCountInfo{
        public String employeeAtne{get;set;}
        public String efectiveFrom{get;set;}
        public String effectiveThrough{get;set;}
        public String fullTime{get;set;}
        public String partTime{get;set;}
        public String unionEligible{get;set;}
        public String totalEligible{get;set;}             
    }
    
    public class groupContactInfo{
        public String primaryContactType{get;set;}
        public String firstName{get;set;}
        public String LastName{get;set;}
        public String middleName{get;set;}
        public String startDate{get;set;}
        public String endDate{get;set;}
        public String effeDate{get;set;}
        public String AddrLine1 { get; set;}
        public String AddrLine2 { get; set;}
        public String City { get; set;}
        public String State{ get; set;}
        public String Zip { get; set;}
        public String country { get; set;}
        public String Phone{get;set;}
        public String extension{get;set;}
        public String fax{get;set;}
        public String EmailAddress{get;set;}
        public string address{get;set;}
        public list<addressInfo> contactAddress{get;set;}
        public list<contactPhoneInfo> contactPhones{get;set;}
        public list<string> contactEmails{get;set;}
        public string contactType{get;set;}
        public string addressType{get; set;}
        public string activeStatus{get;set;}
    }
    
    public class contactPhoneInfo{
        public string phoneType{get;set;}
        public string phoneNumber{get;set;}
        public string phoneExt{get;set;}
        public string internationalIndicator{get;set;} 
    }
    
    public class purchasedBenefits{
        public string product{get;set;}
        public string benefit{get;set;}
        public string planMetalicLevel{get;set;}
        public string network{get;set;}
        public string tier{get;set;}
        public CurveOut CarveOutDetails{get; set;}
        public list<Riders> ridersList{get;set;}
        public list<contactType> contactTypeList{get;set;}
        public list<CSPDetails> CSPDetailsList{get;set;}
        public list<ageBand> ageBandList{get; set;}        
    }
    
    public class Riders{
        public string riderCode{get;set;}
        public string description{get;set;}
        public string fromDate{get;set;}
        public string thruDate{get;set;}
    }
    
    public class CurveOut{
        public string high{get;set;}
        public string low{get;set;}
    }
    public class contactType{
        public string contactType{get;set;}
        public string amount{get;set;}
    }
    
    public class CSPDetails{
        public string cspDetail{get;set;}
        public string conType{get;set;}
        public string fdType{get;set;}
        public string amount{get;set;}
        public string fromDate{get;set;}
        public string thruDate{get;set;}
        public string reason{get;set;}
        public string deactivated{get;set;}        
    }
    
    public class ageBand{
        public string ageBand{get;set;}
        public single singleDetails{get;set;}
        public parentwoChildren parentDetails{get;set;}
        public couple coupleDetails{get;set;}
        public family familyDetails{get;set;}
        public medicare medicareDetails{get;set;}
    }
    
    public class single{
        public string male{get;set;}
        public string female{get;set;}
    }
    
    public class parentwoChildren{
        public string male{get;set;}
        public string female{get;set;}
    }
    
    public class couple{
        public string male{get;set;}
        public string female{get;set;}
    } 
    
    public class family{
        public string male{get;set;}
        public string female{get;set;}
    } 
    
    public class medicare{
        public string status{get;set;}        
    } 
    
    //added by harish for the US580447 on 4/11/2017
    public class enrollmentWaitingPeriod {
        public String rule {get; set;}
        public String fromGE {get; set;}
        public String through {get; set;}
         public String GUID {get; set;}
        public boolean isActive {get; set;} 
        public  enrollmentWaitingPeriod() {
             GUID = ACETGUIDUtil.newGuid(); 
         }
         public String getImage(){ 
           // System.debug('Get IMage...........'+fromRP+throughtRP);
            String benefitStatus = '';
            Date objThroughDate;
            Date objFromDate;
            if(fromGE != null) {
               objFromDate = Date.newInstance(Integer.valueOf(fromGE.split('/')[2]), Integer.valueOf(fromGE.split('/')[0]), Integer.valueOf(fromGE.split('/')[1]));
            }
            if(through != null) {
               objThroughDate = Date.newInstance(Integer.valueOf(through.split('/')[2]), Integer.valueOf(through.split('/')[0]), Integer.valueOf(through.split('/')[1]));
            }
            //System.debug('Get IMage1...........'+objFromDate+objThroughDate);
            if(Date.today() < objFromDate) {
                benefitStatus = 'Blue';
            }
            else if(Date.today() >= objFromDate && (Date.today() <= objThroughDate || through == null)) {
                benefitStatus = 'active';
            }
            else if(Date.today() > objFromDate && Date.today() > objThroughDate) {
                benefitStatus = 'inactive';
            }
            System.debug('Get IMage Status...........'+benefitStatus);
            return benefitStatus;
        } 
    }
    
    public class terminationLag {
        public String rule {get; set;}
        public Date fromGE {get; set;}
        public Date through {get; set;}
    }
    
    public class DependentCutOff {
        public String cutofAge {get; set;}
        public String rule {get; set;}
        public String fromGE {get; set;}
        public String through {get; set;}
        public String GUID {get; set;}
        public boolean isActive {get; set;} 
        public  DependentCutOff() {
             GUID = ACETGUIDUtil.newGuid(); 
         }
         public String getImage(){ 
           // System.debug('Get IMage...........'+fromRP+throughtRP);
            String benefitStatus = '';
            Date objThroughDate;
            Date objFromDate;
            if(fromGE != null) {
               objFromDate = Date.newInstance(Integer.valueOf(fromGE.split('/')[2]), Integer.valueOf(fromGE.split('/')[0]), Integer.valueOf(fromGE.split('/')[1]));
            }
            if(through != null) {
               objThroughDate = Date.newInstance(Integer.valueOf(through.split('/')[2]), Integer.valueOf(through.split('/')[0]), Integer.valueOf(through.split('/')[1]));
            }
            //System.debug('Get IMage1...........'+objFromDate+objThroughDate);
            if(Date.today() < objFromDate) {
                benefitStatus = 'Blue';
            }
            else if(Date.today() >= objFromDate && (Date.today() <= objThroughDate || through == null)) {
                benefitStatus = 'active';
            }
            else if(Date.today() > objFromDate && Date.today() > objThroughDate) {
                benefitStatus = 'inactive';
            }
            System.debug('Get IMage Status...........'+benefitStatus);
            return benefitStatus;
        } 
    }
  
    public class openEnrollmentPeriod {
        public String rule {get; set;}
        public Date fromGE {get; set;}
        public Date through {get; set;}
    }
    
    public class retireepolicy {
     public String population {get; set;}
     public String earlyretirement {get; set;}
     public String minimumageearly {get; set;}
     public String workingretirement {get; set;}
     public String mininumageworking {get; set;}
     public String fromRP {get; set;}
     public String throughtRP{get; set;}    
    }
  
    public class rehireLag {
       // public String population {get; set;}
        public String rule {get; set;}
        public String count {get; set;}
        public String unit {get; set;}
        public String fromGE {get; set;}
        public String through {get; set;}
         public String GUID {get; set;}
         public boolean isActive {get; set;} 
         public  rehireLag() {
             GUID = ACETGUIDUtil.newGuid(); 
         }
         public String getImage(){ 
           // System.debug('Get IMage...........'+fromRP+throughtRP);
            String benefitStatus = '';
            Date objThroughDate;
            Date objFromDate;
            if(fromGE != null && fromGE !='') {
               objFromDate = Date.newInstance(Integer.valueOf(fromGE.split('/')[2]), Integer.valueOf(fromGE.split('/')[0]), Integer.valueOf(fromGE.split('/')[1]));
            }
            if(through != null && through != '') {
               objThroughDate = Date.newInstance(Integer.valueOf(through.split('/')[2]), Integer.valueOf(through.split('/')[0]), Integer.valueOf(through.split('/')[1]));
            }
            //System.debug('Get IMage1...........'+objFromDate+objThroughDate);
            if(objFromDate != null && Date.today() < objFromDate) {
                benefitStatus = 'Blue';
            }
            else if((Date.today() >= objFromDate && objFromDate != null) && (Date.today() <= objThroughDate || through == null)) {
                benefitStatus = 'active';
            }
            else if(objFromDate != null && objThroughDate != null && Date.today() > objFromDate && Date.today() > objThroughDate) {
                benefitStatus = 'inactive';
            }
            System.debug('Get IMage Status...........'+benefitStatus);
            return benefitStatus;
        } 
    } 
  
    //Plan Summary Section
    public string accumulator {get; set;}
    public string PlanClass {get; set;}
    public String Product {get; set;}
    public String Gated {get; set;}
    public String PCPRequired {get; set;}
    public String PlanMettalicLevel {get; set;}
    public String Network {get; set;}
    public String Tier {get; set;}
    public String policyNo {get; set;}
    public String planID {get; set;}
    public String effecDate {get; set;}
    public String endDate {get; set;}
  
    //Group Plan benefit Section 
    public class GroupPlanWrapper {
        public String PlanClass {get; set;}
        public String Accumulator {get; set;}
        public String Product {get; set;}
        public String Gated {get; set;}
        public String PCPRequired {get; set;}
        public String PlanMettalicLevel {get; set;}
        public String Network {get; set;}
        public String Tier {get; set;}
        public String bundleID {get; set;}
        public String planID {get; set;}
        public String effecDate {get; set;}
        public String endDate {get; set;}
        public String GUID {get; set;}
        public boolean isActive {get; set;}
        public String groupId {get; set;}
        public List<AgeBandWrap> ageBandGroupPlanList {get; set;} 
        //public GroupPlanWrapper(String policyNoGp,String planIDGp, String PlanClss, String ProductSa, String GatedGrp,String PCPReq,String accgp,String PlanMetall, String NetworkGrp, String TierGrp,String effecDategp,String endDategp) {
        public GroupPlanWrapper() {   
            /*policyNo = policyNoGp;
            planID = planIDGp;
            //CSP = CspCpunt;
            PlanClass = PlanClss;
            Accumulator = accgp;
            Product = ProductSa;
            Gated = GatedGrp;
            PCPRequired = PCPReq;
            PlanMettalicLevel = PlanMetall;
            Network = NetworkGrp;
            Tier = TierGrp;
            effecDate = effecDategp;
            endDate = endDategp;*/
            GUID = ACETGUIDUtil.newGuid();                
        }
        
        public String getImage(){ 
            String benefitStatus = '';
            Date objEffectiveDate = Date.newInstance(Integer.valueOf(effecDate.split('/')[2]), Integer.valueOf(effecDate.split('/')[0]), Integer.valueOf(effecDate.split('/')[1]));
            Date objEndDate = Date.newInstance(Integer.valueOf(EndDate.split('/')[2]), Integer.valueOf(EndDate.split('/')[0]), Integer.valueOf(EndDate.split('/')[1]));
            
            if(Date.today() < objEffectiveDate) {
                benefitStatus = 'Blue';
            }
            else if(Date.today() >= objEffectiveDate && Date.today() <= objEndDate) {
                benefitStatus = 'active';
            }
            else if(Date.today() > objEffectiveDate && Date.today() > objEndDate) {
                benefitStatus = 'inactive';
            }
            return benefitStatus;
        }    
    } 
    
    public class AgeBandWrap implements Comparable {
        public String AgeBand {get; set;}
        public String premium {get; set;}
        /*public AgeBandWrap(String AgeBandGP,String premiumGP) {
            AgeBand = AgeBandGP;
            premium = premiumGP;
        }*/
        public Integer compareTo(Object o) {
            AgeBandWrap that = (AgeBandWrap) o;
            if (this.AgeBand < that.AgeBand) return -1;
            else if (this.AgeBand > that.AgeBand) return 1;
            else return 0;
        }
        
    } 
    
    public class riderWrapper {
        public String riderCode {get; set;}
        public String description {get; set;}
        public String FromGp {get; set;}
        public String thru {get; set;}
         public riderWrapper (String riderCodegp,String descriptionGp,String fromGpp, String thruGp) {
            riderCode = riderCodegp;
            description = descriptionGp;
            FromGp = fromGpp;
            thru = thruGp;
        }
    }
    
    public class retireePolicyWrapper {
         public String population {get; set;}
         public String earlyretirement {get; set;}
         public String minimumageearly {get; set;}
         public String workingretirement {get; set;}
         public String mininumageworking {get; set;}
         public String fromRP {get; set;}
         public String throughtRP{get; set;}
         public String GUID {get; set;}
         public boolean isActive {get; set;} 
         public  retireePolicyWrapper() {
             GUID = ACETGUIDUtil.newGuid(); 
         }
         public String getImage(){ 
            System.debug('Get IMage...........'+fromRP+throughtRP);
            String benefitStatus = '';
            Date objThroughDate;
            Date objFromDate;
            if(fromRP != null) {
               objFromDate = Date.newInstance(Integer.valueOf(fromRP.split('/')[2]), Integer.valueOf(fromRP.split('/')[0]), Integer.valueOf(fromRP.split('/')[1]));
            }
            if(throughtRP != null) {
               objThroughDate = Date.newInstance(Integer.valueOf(throughtRP.split('/')[2]), Integer.valueOf(throughtRP.split('/')[0]), Integer.valueOf(throughtRP.split('/')[1]));
            }
            //System.debug('Get IMage1...........'+objFromDate+objThroughDate);
            if(objFromDate != null && Date.today() < objFromDate) {
                benefitStatus = 'Blue';
            }
            else if((Date.today() >= objFromDate && objFromDate != null) && (Date.today() <= objThroughDate || throughtRP == null)) {
                benefitStatus = 'active';
            }
            else if(objFromDate != null && objThroughDate != null && Date.today() > objFromDate && Date.today() > objThroughDate) {
                benefitStatus = 'inactive';
            }
            System.debug('Get IMage Status...........'+benefitStatus);
            return benefitStatus;
        } 
    }  
    
}