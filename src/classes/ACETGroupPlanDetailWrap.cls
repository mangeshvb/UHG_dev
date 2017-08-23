public with sharing class ACETGroupPlanDetailWrap {
    //Summary Info Section
    //public string csp {get; set;}
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
    //Copay Section
    public String PCPCopay {get; set;}
    public String emergencyRoom {get; set;}
    public String rxDed {get; set;}
    public string rxTier3 {get; set;}
    public String rxTier2 {get; set;}
    public String rxTier1 {get; set;}
    //Individual Coverage Section
    public String indivOONDeduc {get; set;}
    public String indivOONCoInsurance {get; set;}
    public String indivOONOOP {get; set;}
    public String indivInDeductible {get; set;}
    public String indivInCoInsurance {get; set;}
    public String indivINOOP {get; set;}
    //Family Coverage Section
    public String familyOONDeduc {get; set;}
    public String familyOONCoInsurance {get; set;}
    public String familyOONOOP {get; set;}
    public String familyInDeductible {get; set;}
    public String familyInCoInsurance {get; set;}
    public String familyINOOP {get; set;}
    
    //Rider Section
    public List<RiderWrapper> riderWrapperList {get; set;}
    //Premium Rates Section
    public List<ContractWrapper> contractWrapperList {get; set;}
    // Benefit Section
    public List<BenefitWrapper> benefitWrapperList {get; set;}
    //Group Plan Wrapper List
    public List<GroupPlanWrapper> GroupPlanWrapperList {get; set;}
   
    //Individual Coverage
    public List<indivCoverageWrapper> indivCoverageWrapperList {get; set;}
    //Family Coverage
    public List<familyCoverageWrapper> familyCoverageWrapperList {get; set;}
    
    public class indivCoverageWrapper {
        public String level {get; set;}
        public String DED {get; set;}
        public String COIN {get; set;}
        public String MAXOOP {get; set;}
            public indivCoverageWrapper(String levelGp,String DEDGp,String coinGp,String maxoopGp) {
                level = levelGp;
                DED = DEDGp;
                COIN = coinGp;
                MAXOOP = maxoopGp;
            }
    }
    
    public class familyCoverageWrapper {
        public String level {get; set;}
        public String DED {get; set;}
        public String COIN {get; set;}
        public String MAXOOP {get; set;}
            public familyCoverageWrapper(String levelGp,String DEDGp,String coinGp,String maxoopGp) {
                level = levelGp;
                DED = DEDGp;
                COIN = coinGp;
                MAXOOP = maxoopGp;
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
    
    public class contractWrapper {
        public String contractType {get; set;}
        public String Amount {get; set;}
        public contractWrapper(String contractTyprGp,String amountGp) {
            contractType = contractTyprGp;
            Amount = amountGp;
        }
    }
    
     public Class BenefitWrapper {
        public String Benefit {get; set;}
        public String BenefitCode {get; set;}
        public String BenefitType {get; set;}
        public String BenefitFrom {get; set;}
        public String BenefitThru {get; set;}
        
        public BenefitWrapper(String benefitGp,String BenefitCodeGp,String BenefitTypeGp,String BenefitFromGp,String BenefitThruGp) {
           Benefit =  benefitGp;
           BenefitCode = BenefitCodeGp;
           BenefitType = BenefitTypeGp;
           BenefitFrom = BenefitFromGp;
           BenefitThru = BenefitThruGp;
        }
    }
    
     public class GroupPlanWrapper {
        //public String CSP {get; set;}
        public String PlanClass {get; set;}
        public String Accumulator {get; set;}
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
        public String GUID {get; set;}
        public boolean isActive {get; set;}
        
        public GroupPlanWrapper(String policyNoGp,String planIDGp, String PlanClss, String ProductSa, String GatedGrp,String PCPReq,String accgp,String PlanMetall, String NetworkGrp, String TierGrp,String effecDategp,String endDategp) {
            policyNo = policyNoGp;
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
            endDate = endDategp;
            GUID = ACETGUIDUtil.newGuid();                     
        }
        public String getImage(){
            //if(String.isEmpty(effecDate) || String.isEmpty(EndDate)) return false; 
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
    
    public class AgeBandWrap {
        public String AgeBand {get; set;}
        public String premium {get; set;}
        public AgeBandWrap(String AgeBandGP,String premiumGP) {
            AgeBand = AgeBandGP;
            premium = premiumGP;
        }
    }
}