public with sharing class ACETPlanBenefitDetailController{
    public List<PolicyOverviewWrapper> policies{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public ACETBenefitsDetails benefitDetailwrapper{get;set;}
    public List<SelectOption> benefitCategories{get;set;}
    public string selectedbenefitCategy{get;set;}
    public String planId;
    public String PlanName;
    public String ProductId;
    public String PlanType;
    public String Accumulator;
    public String Gated;
    public String PCP;
    public string Network {get;set;}
    public list<string> networklist {get;set;}
    public String policyNumber {get;set;}
    public list<PayData> coPay{set;get;}
    public list<PayData> rxCoPay{set;get;}
    public list<OtherData> individualData{set;get;}
    public list<OtherData> familyData{set;get;}
    public List<Accumulator> IndividualAccs { get; set; }
    public List<Accumulator> FamilyAccs { get; set; }
    ACETGetBenefitAccWebservice ACETGBAWS;
    public String bundleOptionId {get;set;}                
    public String CoverageType {get;set;}
    public String EffectiveDate {get;set;}
    public String EndDate {get;set;}    
    public String SRKID {get;set;}  
    
    public ACETPlanBenefitDetailController(){
        
        planId = ApexPages.currentPage().getParameters().get('PI');
        PlanName = ApexPages.currentPage().getParameters().get('PName');  
        ProductId = ApexPages.currentPage().getParameters().get('PId');  
        policyNumber = ApexPages.currentPage().getParameters().get('PN');
        PlanType = ApexPages.currentPage().getParameters().get('PT');
        Accumulator = ApexPages.currentPage().getParameters().get('Accum');
        Gated = ApexPages.currentPage().getParameters().get('Gat');
        PCP = ApexPages.currentPage().getParameters().get('PCP');
        Network = ApexPages.currentPage().getParameters().get('Net');
        
        bundleOptionId = apexpages.currentpage().getparameters().get('bundleOptionId');        
        CoverageType = apexpages.currentpage().getparameters().get('CoverageType');
        EffectiveDate = apexpages.currentpage().getparameters().get('EffectiveDate');
        EndDate = apexpages.currentpage().getparameters().get('EndDate');
        SRKID = apexpages.currentpage().getparameters().get('SRK');
        
        system.debug('bundleOptionId:: '+bundleOptionId + ', SRKID: ' + SRKID + ',  ::CoverageType:: ' + CoverageType + '::EffectiveDate:: ' + EffectiveDate + '::EndDate:: ' + EndDate);        
        
        if(Network!=null){
            Network = Network.remove('[');
            Network = Network.remove(']');
            networklist = new list<string>(); 
            networklist.add(Network);
            //list<string> network = Network.split(',');
            //system.debug('networkl**'+networkl);
            //for(string s : Networkl){
            //    networklist.add(s);
           // }                       
        }
       
        system.debug(LoggingLevel.INFO,'PlanName:: ' + PlanName + ' ::PlanType:: ' + PlanType + ' ::Accumulator:: ' + Accumulator + ' ::Gated:: ' + Gated);
        system.debug(LoggingLevel.INFO,' ::PCP:: ' + PCP + ' ::Network:: ' + Network);
        policies = new List<PolicyOverviewWrapper>();                  
        PolicyOverviewWrapper polovr = new PolicyOverviewWrapper();
        polovr.PolicyNumber = policyNumber;
        polovr.PlanId = planId;
        polovr.PlanName = PlanName;
        polovr.ProductId = ProductId;
        polovr.PlanType = PlanType;
        polovr.FundingArrangement = Null ;
        polovr.Accumulator = Accumulator;
        polovr.Gated = Gated;
        polovr.PCP = PCP;
        polovr.GoverningStatePolicy = '';
       // polovr.Network = Network;
        polovr.Resolved = true;
        policies.add(polovr);  

        wrapper = new ACETCallTopicsDataWrapper();
        system.debug('wrapper >>> pbc '+JSON.serialize(wrapper));
        coPay = loadCoPay();
        rxCoPay = loadRxCoPay();   
        individualData = loadIndividualData();
        familyData = loadFamilyData();
        IndividualAccs = new List<Accumulator>();
        FamilyAccs = new List<Accumulator>();
    }
    public void makePlanBenefitLanguageCallout(){
        ACETGetBenefitsLanguageWebService service = new ACETGetBenefitsLanguageWebService();
        string webServKeyId='urn:uuid:6943dd15-fea6-4f4b-8c9c-82d97a7d3c30';
        if(wrapper!= null && wrapper.Subject!= null &&  wrapper.Subject.Name!= null){
            webServKeyId = wrapper.Subject.Name.equals('NIkki Reed') ? 'urn:uuid:d69a70fc-8a47-48fb-aed3-873279431f8b' : 'urn:uuid:6943dd15-fea6-4f4b-8c9c-82d97a7d3c30';

        }
        //ACETWSCalloutResult response = service.getBenefitLanguage('urn:uuid:6943dd15-fea6-4f4b-8c9c-82d97a7d3c30');
        ACETWSCalloutResult response = service.getBenefitLanguage(webServKeyId );
        if(response.Success!=null){
            benefitDetailwrapper = (ACETBenefitsDetails)response.response;

            //Preparing benefit Category in picklist
            benefitCategories = new List<SelectOption>();
            benefitCategories.add(new SelectOption('','--None--'));
            Integer BenefitIndex = 0;
            if(benefitDetailwrapper != null && benefitDetailwrapper.Benefits != null && benefitDetailwrapper.Benefits.size() > 0){
                for(String benefitKey : benefitDetailwrapper.Benefits.keySet()){
                    benefitCategories.add(new SelectOption(benefitKey, benefitDetailwrapper.Benefits.get(benefitKey).SectionName));
                }
                benefitCategories.sort();
            }
            
        }
    }
    
    public Object CallWSOnPageLoad()
    {
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoad.');
        Continuation PageLoadContinuation;
        ACETGBAWS = new ACETGetBenefitAccWebservice();
        
        /*  Added by Avish on 06092017, once mapping is done removed the whole commented section
            Use below variable to dynamically formed the request 
            bundleOptionId,'SRK',SRKID,EffectiveDate,EndDate, CoverageType,
            PageLoadContinuation = ACETGBAWS.StartRequest(bundleOptionId, 'SRK', SRKID, '2016-03-01', '9999-12-31', 'M', '', '', 'CallWSOnPageLoadCallback', null);
            "bundleOptionId,CoverageType,EffectiveDate,EndDate
            and make web service call
        */
                
        PageLoadContinuation = ACETGBAWS.StartRequest('35567894', 'SRK', '999521234367', '2016-03-01', '9999-12-31', 'M', 'A', '', 'CallWSOnPageLoadCallback', null);
        return PageLoadContinuation; 
    }
    
    public PageReference CallWSOnPageLoadCallback() {
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoadCallback.');
        ACETWSCalloutResult GBACalloutResult = ACETGBAWS.ProcessResponse('CPD125', 'M', ACETGBAWS.RequestLabel);
        if (GBACalloutResult.Success) {
            for (Accumulator oAccumulator :(List<Accumulator>)GBACalloutResult.Response) {
                if (oAccumulator.Section == 'Individual') {
                    IndividualAccs.add(oAccumulator);
                } else {
                    FamilyAccs.add(oAccumulator);
                }
            }
        }
        system.debug('IndividualAccs: ' + IndividualAccs);
        system.debug('FamilyAccs: ' + FamilyAccs);
        return null;
    }
        
    public class PolicyOverviewWrapper{
        public boolean isSelected{get;set;}
        public String PolicyNumber{get;set;}
        public String PlanId { get; set; }
        public String PlanName { get; set; }
        public String productName{get;set;}
        public String ProductId { get; set; }
        public String PlanType { get; set; }
        public String FundingArrangement { get; set; }
        public String Accumulator  { get; set; }
        public String Gated  { get; set; }
        public String PCP  { get; set; }
        public String GoverningStatePolicy  { get; set; }
        public String Network  { get; set; }
        public Boolean Resolved  { get; set; }
    }
    private list<PayData> loadCoPay()
    {
        list<PayData> tempList = new list<PayData>();
        tempList.add(new PayData('PCP','$20'));
        tempList.add(new PayData('Specialist','$30'));
        tempList.add(new PayData('ER Visit','$300'));
        return tempList;
    }
    private list<PayData> loadRxCoPay()
    {
        list<PayData> tempList = new list<PayData>();
        tempList.add(new PayData('Tier 1','$15'));
        tempList.add(new PayData('Tier 2','$45'));
        tempList.add(new PayData('Tier 3','$75'));
        tempList.add(new PayData('Tier 4','$150'));
        return tempList;
    }
    private list<OtherData> loadIndividualData()
    {
        list<OtherData> tempList = new list<OtherData>();
        tempList.add(new OtherData('INN','$2,500','$500','$2,000','$2,500','$500','$2,000'));
        tempList.add(new OtherData('OON','$6,000','$500','$5,500','$6,000','$500','$5,500'));        
        return tempList;
    }
    private list<OtherData> loadFamilyData()
    {
        list<OtherData> tempList = new list<OtherData>();
        tempList.add(new OtherData('INN','$2,500','$500','$2,000','$2,500','$500','$2,000'));
        tempList.add(new OtherData('OON','$6,000','$500','$5,500','$6,000','$500','$5,500')); 
        return tempList;
    }
    public class PayData
    {    
        public String label{set;get;}
        public String value{set;get;}
        public PayData(String label,String value)
        {
            this.label = label;
            this.value = value;
        }
    }
    public class OtherData
    {    
        public String rowLabel{set;get;}
        public String dedLimit{set;get;}
        public String dedSatisfied{set;get;}
        public String dedRemaining{set;get;}
        public String OOPLimit{set;get;}
        public String OOPSatisfied{set;get;}
        public String OOPRemaining{set;get;}
        public OtherData(String rowLabel,String dedLimit,String dedSatisfied,String dedRemaining,String OOPLimit,String OOPSatisfied,String OOPRemaining)
        {
            this.rowLabel = rowLabel;
            this.dedLimit = dedLimit;
            this.dedSatisfied = dedSatisfied;
            this.dedRemaining = dedRemaining;
            this.OOPLimit = OOPLimit;
            this.OOPSatisfied = OOPSatisfied;
            this.OOPRemaining = OOPRemaining;
        }
    }
    
    public class Accumulator {
        public String Section { get ; set; }            //Individual or Familty
        public String TypeCode { get ; set; }           //INN or OON
        public Decimal MaxDeductible { get ; set; }
        public Decimal YTDDeductible { get ; set; }
        public Decimal RemDeductible { get ; set; }
        public Decimal MaxOOP { get ; set; }
        public Decimal YTDOOP { get ; set; }
        public Decimal RemOOP { get ; set; }
    }
}