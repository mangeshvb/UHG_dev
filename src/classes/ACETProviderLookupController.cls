public with sharing class ACETProviderLookupController {
    public Boolean isErrorMessageAdded {get; set;}
    public String groupNum {
        get;
        set;
    }    
    public map<string,Network_Values__mdt> networkSchedulemapId = new map<string,Network_Values__mdt>();
    
    public map<string,Language_Codes__mdt> languageSchedulemapId = new map<string,Language_Codes__mdt>();
    
    public map<string,string> SpecCodes = new  map<string,string>();
       
    public String benefitPlanId {
        get;
        set;
    }    
    public string networkval{
        get;
        set;
    }
    public string LanguageVal{
        get;
        set;
    }
    
    public String srkKey {
        get;
        set;
    }
    public String memId {
        get;
        set;
    }
    public String checkNumber {
        get;
        set;
    }
    public String seriesDesignator {
        get;
        set;
    }
    public String totalPayment {
        get;
        set;
    }
    public String lastName {
        get;
        set;
    }
    
    //Display the StateCodes.
    public ACETstateCodeContainer stateCode {
        get;
        set;
    }
    public Boolean showSearch {
        get;
        set;
    }
    public string providerId {
        get;
        set;
    }
    public string searchProviderId {
        get;
        set;
    }
    
    public string city {
        get;
        set;
    }
    //public String hpAdditionInfoStr {get;set;}
    public string state {
        get;
        set;
    }
    public string specialty {
        get;
        set;
    }
    public string radious {
        get;
        set;
    }
    public string providerType {
        get;
        set;
    }
    public string zipcode {
        get;
        set;
    }
    public string language {
        get;
        set;
    }
    
    public String firstName {
        get;
        set;
    }
    public String taxId {
        get;
        set;
    }
    public boolean existingpatientsInd{
        get;
        set;
    }
      public boolean NewpatientsInd{
        get;
        set;
    }
    public string networkSchedule{
        get;
        set;
    }
    public string npi {
        get;
        set;
    }
    public String eId {
        get;
        set;
    }
    public string phoneNumber {
        get;
        set;
    }
    public String policyNumber {
        get;
        set;
    }
    public string selectedSpeciality{
        get;
        set;
    }
    
    public Case startDate {
        get;
        set;
    }
    public Case endDate {
        get;
        set;
    }
    public Interaction__c interaction {
        get;
        set;
    }
    public string SelSpecialityCodes {
            get;
            set;
        }
    public Contact conObj {
        get;
        set;
    }
    public String sourceOriginator {
        get;
        set;
    }
    public ACETHighlightsPanelAdditionalInfo additionalInfo {
        get;
        set;
    }
    
    public String hpAdditionInfoStr {
        get;
        set;
    }
    
    
    public ACETCallTopicsDataWrapper acetCallTopicData {
        get;
        set;
    }
    
    
    public boolean isShowActiveCoveragesOnly {
        get;
        set;
        
    }
    
    public list < ProviderLookupResult > lstProviderLookupResults {
        get;
        set;
        
    }
    
    public boolean providerLookupControl {
        get;
        set;
    }
    public boolean isProviderControl {
        get;
        set;
    }
    
    public String netWork {
        get;
        set;
    }
    public string gender {
        get;
        set;
    }
    
    public set < SelectOption > networkOptions {
        get;
        set;
    }
    public String urlscrId {get;set;}
    public String urlssn {get;set;}
    public String urlrelationshipCode {get;set;}
    /* Added the variable as a part of US577497 by Avish    */
    public Boolean showNonParChckBox {get;set;}
    public String memberId {get;set;}
    
    public List < SelectOption > getnetworkOptions () {
        
        List < SelectOption > providerTypeOptions = new List < SelectOption > ();
         providerTypeOptions.add(new SelectOption('', ''));       
        providerTypeOptions.add(new SelectOption('Physician', 'Physician'));
        providerTypeOptions.add(new SelectOption('Facility', 'Facility'));
        return providerTypeOptions;
    }
    
    public string surrogateKey {get; set;}
	public ACETDatatableWrapper PLDTWrapper { get; set; }     //Used by pagination component
	    
    public ACETProviderLookupController() {        
       
    	urlscrId = ApexPages.currentPage().getParameters().get('scrId');
    	urlssn = ApexPages.currentPage().getParameters().get('ssnId');
    	urlrelationshipCode = ApexPages.currentPage().getParameters().get('rl');
        SpecCodes = new map<string,string>();
        for(Provider_Taxonomy__mdt prodTax :[select label,Classification__c,Provider_Type__c,Speciality__c,Speciality_Code__c from Provider_Taxonomy__mdt]){
            SpecCodes.put(prodTax.Classification__c+'#'+prodTax.Speciality__c, prodTax.Speciality_Code__c);
            
        }
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        isProviderControl = false;
        showNonParChckBox = false;
        isShowActiveCoveragesOnly = true;
        providerLookupControl = false;
        stateCode = new ACETstateCodeContainer('');
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');
        groupNum = ApexPages.currentPage().getParameters().get('grpnum');
        system.debug('2323groupNum'+groupNum);
        benefitPlanId  = ApexPages.currentPage().getParameters().get('benefitPlanId');       
        memId = ApexPages.currentPage().getParameters().get('Id');
        system.debug(LoggingLevel.Info,'benefitPlanId:: ' + benefitPlanId + ' memId*** ' + memId);
        srkKey = ApexPages.currentPage().getParameters().get('SRK');
        providerId = ApexPages.currentPage().getParameters().get('ProviderId');
        system.debug('providerId *** ' + providerId);
        acetCallTopicData = new ACETCallTopicsDataWrapper();
        acetCallTopicData.CallTopic = 'Provider Lookup'; 
        acetCallTopicData.init();
        acetCallTopicData.CaseObj.topic__c = 'Provider Lookup';
        
        //Get Provider Interaction SFDC Id
        //String interactionId = ApexPages.currentPage().getParameters().get('interactionId');    
        //Check if User is redirected to Member Search page from Provider detail page         
        if (!String.isEmpty(interactionId)) {
            system.debug('InteractionId: ' + InteractionId);
            
            //Query Provider Interaction details
            interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            sourceOriginator = interaction.Interaction_Type__c;
            system.debug(LoggingLevel.Info,'Interaction: ' + Interaction + ', sourceOriginator: ' + sourceOriginator);
        }
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        if (!String.isEmpty(contactId)) {
            conObj = ACETProviderUtility.GetContactByID(contactId);
        }
        
        if (!String.isEmpty(contactId)) {
            conObj = ACETProviderUtility.GetContactByID(contactId);
            eId = conObj.EID__c;
        }
        String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');
        memberId = ApexPages.currentPage().getParameters().get('memberId');
        if (!String.isEmpty(additionalInfostr)) {
            additionalInfo = (ACETHighlightsPanelAdditionalInfo) JSON.deserialize(additionalInfostr, ACETHighlightsPanelAdditionalInfo.class);
            policyNumber = additionalInfo.PolicyNumber;
            hpAdditionInfoStr = JSON.serialize(additionalInfo);
        }
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        if (!String.isEmpty(surrogateKey)){ 
            acetCallTopicData.surrogateKey = surrogateKey;
        }
    }
    
    public List < SelectOption > getProviderTypes() {
        isProviderControl = true;
        List < SelectOption > providerTypeOptions = new List < SelectOption > ();
        providerTypeOptions.add(new SelectOption('', '--None--'));
        providerTypeOptions.add(new SelectOption('Physician', 'Physician'));
        providerTypeOptions.add(new SelectOption('Facility', 'Facility'));
        return providerTypeOptions;
    }
    
    public void providertypechange(){
        if(providerType == null || providerType == '--None--'){
            SelSpecialityCodes = '--None--';
            selectedSpeciality = '--None--';
        }
    }
    
    public List < SelectOption > getSpecialities() {
        
        List < SelectOption > SpecialityOptions = new List < SelectOption > ();
        List < SelectOption > SpecialityOptionsAll = new List < SelectOption > ();
        List < SelectOption > SpecialityOptionsNotAll = new List < SelectOption > ();
          map<string,Set<string>> specialitymap = new map<string,Set<string>>();
          list<Provider_Taxonomy__mdt> providertaxmony = new list<Provider_Taxonomy__mdt>();
          Set<string> uniSpeciality = new Set<string>();
          
          if(providerType != null && providerType != ''){
           providertaxmony = [select label,Classification__c,Provider_Type__c,Speciality__c,Speciality_Code__c from Provider_Taxonomy__mdt where Provider_Type__c =: providerType order by Speciality__c asc];
           SpecialityOptions.add(new SelectOption('', '--None--'));
           for(Provider_Taxonomy__mdt prtx:providertaxmony){ 
            
            uniSpeciality.add(prtx.Speciality__c);
               Set<String> tempList = (specialityMap.get(prtx.classification__c)== null)? new Set<String>():specialityMap.get(prtx.classification__c);
               tempList.add(prtx.speciality__c);
               specialityMap.put(prtx.Classification__c,tempList);
           }          
             
            if(specialityMap.get(SelSpecialityCodes) != null)
              for(String s:specialityMap.get(SelSpecialityCodes))
            {
                if(s=='All'){
                    SpecialityOptionsAll.add(new SelectOption(s,s));
                }else{
                    SpecialityOptionsNotAll.add(new SelectOption(s,s));
                }
            }
                  SpecialityOptions.addAll(SpecialityOptionsAll);
              SpecialityOptions.addAll(SpecialityOptionsNotAll);
                  
          } else {
            SpecialityOptions.add(new SelectOption('', ''));
        }        
        return SpecialityOptions;
    }
    
    public void clearResults() {
        providerLookupControl = false;
        lstProviderLookupResults = null;
    }
    
     public List < SelectOption > getClassifications() {
        
        List < SelectOption > SpecialityCodeOptions = new List < SelectOption > ();
          list<Provider_Taxonomy__mdt> providertaxmony = new list<Provider_Taxonomy__mdt>();
          Set<string> unicClassification = new Set<string>();
          
          if(providerType != null && providerType != ''){
           providertaxmony = [select label,Classification__c,Provider_Type__c,Speciality__c,Speciality_Code__c from Provider_Taxonomy__mdt where Provider_Type__c =: providerType order by Classification__c asc];
           SpecialityCodeOptions.add(new SelectOption('', '--None--'));
           for(Provider_Taxonomy__mdt prtx:providertaxmony){
            unicClassification.add(prtx.Classification__c); 
           }
           for(String s:unicClassification){
            SpecialityCodeOptions.add(new SelectOption(s,s));
           }
          
          }
                    
        else {
            SpecialityCodeOptions.add(new SelectOption('', ''));
            }
        
        return SpecialityCodeOptions;
            
      }
    
    public List < SelectOption > getlanguagescmdt() {
        List<SelectOption> SpecialitylangOptions = new List<SelectOption> ();
        SpecialitylangOptions.add(new SelectOption('','--None--'));
        for(Language_Codes__mdt lancode:[select label,DeveloperName from Language_Codes__mdt order by label asc]) {
            SpecialitylangOptions.add(new SelectOption(lancode.label,lancode.label));
            languageSchedulemapId.put(lancode.label,lancode); 
       
            
      }
        return SpecialitylangOptions;
    }
    
    public list<SelectOption> getnetworkmdt(){
        List<SelectOption> SpecialityNetworkOptions = new List<SelectOption> ();
        SpecialityNetworkOptions.add(new SelectOption('','--None--'));         
        for(Network_Values__mdt NtwkVal:[select label,DeveloperName,Network_ID__c from Network_Values__mdt order by label asc]) {
            SpecialityNetworkOptions.add(new SelectOption(NtwkVal.label,NtwkVal.label));            
            networkSchedulemapId.put(NtwkVal.label,NtwkVal);
      }
        return SpecialityNetworkOptions;
    }   
   
    //Based on the Provider information search we can able to display Provider Lookup Results.
    public void searchResults() {
        providerLookupControl = true;
        string networksel = networkval;
        string languagesel = LanguageVal;        
        ProviderLookupResult objSearch = new ProviderLookupResult();
               
        ACETWSCalloutResult CalloutResult = new ACETWSCalloutResult();
        lstProviderLookupResults = null;
        String strNewpatientsInd,strExistingpatientsInd;
        if (NewpatientsInd) {
            strNewpatientsInd = 'Y';
        } else {
            strNewpatientsInd = '';
        }
        
        if (existingpatientsInd) {
            strExistingpatientsInd = 'Y';
        } else {
            strExistingpatientsInd = '';
        }
        
        if (string.isNotBlank(networkval)) {
			networkval = networkSchedulemapId.get(networkval).Network_ID__c;
		}
       
        if (string.isNotBlank(LanguageVal)) {
            LanguageVal = languageSchedulemapId.get(LanguageVal).DeveloperName;
        }
        string Speccod;
        if (string.isNotBlank(SelSpecialityCodes) && string.isNotBlank(selectedSpeciality)) {
            if (SpecCodes.containsKey(SelSpecialityCodes+'#'+selectedSpeciality)) {
                Speccod=SpecCodes.get(SelSpecialityCodes+'#'+selectedSpeciality);
            }
        }
        /*  Added by Avish as a part of US577497  */
        if (showNonParChckBox) {
            benefitPlanId = null;
        } else {
            benefitPlanId  = ApexPages.currentPage().getParameters().get('benefitPlanId');
        }
        /* End */        
        if (providerType == 'Physician') {
            ACETFindHCPWebservice ACTFHCPWS = new ACETFindHCPWebservice();
            ACTFHCPWS.Init(searchProviderId, NPI, TaxId, LastName, FirstName, gender, Speccod, ZipCode, radious, city, stateCode.value, 
            	PhoneNumber, networkval, benefitPlanId, strNewpatientsInd, strExistingpatientsInd, LanguageVal, providerType);
            ACTFHCPWS.GetEndpoint();	
            PLDTWrapper = new ACETDatatableWrapper('ACETFindHCPWebservice', ACTFHCPWS);
            PLDTWrapper.PageSize = ACTFHCPWS.PageSize;
        } else if(providerType == 'Facility') {
            ACETFindHCOWebservice ACTFPWS = new ACETFindHCOWebservice();
            ACTFPWS.Init(searchProviderId, NPI, TaxId, LastName, Speccod, ZipCode, radious, city, stateCode.value, PhoneNumber, networkval, benefitPlanId, providerType);
            ACTFPWS.GetEndpoint();
            PLDTWrapper = new ACETDatatableWrapper('ACETFindHCOWebservice', ACTFPWS);
            PLDTWrapper.PageSize = ACTFPWS.PageSize;  
        } else {
            ACETFindProviderLookupWebservice ACTFPWS = new ACETFindProviderLookupWebservice();
            ACTFPWS.Init(searchProviderId, NPI, TaxId, LastName, FirstName, gender, specialty, ZipCode, radious, city, stateCode.value, PhoneNumber,
            	networkval, benefitPlanId, strNewpatientsInd, strExistingpatientsInd, LanguageVal, providerType);
            ACTFPWS.GetEndpoint();	 
            PLDTWrapper = new ACETDatatableWrapper('ACETFindProviderLookupWebservice', ACTFPWS);   
            PLDTWrapper.PageSize = ACTFPWS.PageSize;
        }
        PLDTWrapper.PageStartNumber = 0;
        PLDTWrapper.PageNumber = 0;
        PLDTWrapper.StartRecord = 0;
        PLDTWrapper.initOnDocumentReady = false;        
        
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Provider ID', 'providerId'));
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Name', 'fullName'));
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Provider Type', 'providerType'));
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Tax ID', 'taxId'));
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Address', 'address'));
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Phone Number', 'phoneNumber'));
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Specialty', 'speciality'));
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('PCP Role', 'PCPRole'));
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Gender', 'gender'));
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('UHPD', 'uphd'));
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Platinum Provider', 'Platinum'));
        PLDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Radius', 'Radious'));
        isErrorMessageAdded = false;
        networkval = networksel;
        LanguageVal = languagesel;
    }
    
    public void getFacility(){
        
    }
    
    public class ProviderLookupResult {
        public string fullName {  get; set; }
        public string networkSchedule { get; set; }
        public string languageSchedule { get; set; }
        public string providerId { get; set; }
        public string providerType { get; set; }
        public string status { get; set; }
        public string taxId { get; set; }
        public string ssn { get; set; }
        public string address { get; set; }
        public string SelSpecialityCodes { get; set; }
        public string NPI { get; set; }  
        public string street { get; set; }
        public string city { get; set; }
        public string state { get; set; }
        public string zipCode { get; set; }
        public string providerTypeCode { get; set; }   
        public string phoneNumber { get; set; }
        public string speciality { get; set; }
        public string PCPRole { get; set; }
        public string gender { get; set; }
        public string network { get; set; }
        public string affiliation { get; set; }
        public string uphd { get; set; }
        public string radious { get; set; }
        public string acceptNewPatient { get; set; }
        public string Platinum { get; set; }
        public string radius { get; set; }
        public string ProviderName { get; set; }
        public string typeDescription { get; set; }
        public string phone { get; set; }
        public string Code { get; set; }
        public String providerTINTypeCode { get; set; }
        public String providerTINStatusCode { get; set; }  
        public String addressId { get; set; }
        public String addressTypeCode { get; set; } 
        public String benefitPlanId { get; set; }
        public String County { get; set; } 
        public String Fax { get; set; }
        public String Email { get; set; }
        public String OperationHours { get; set; }
        public String PatientAgeRange { get; set; }
        public String owner { get; set; }  
        public String hcoTypeCode { get; set; }
        public String addressLine1 { get; set; }
        public String addressLine2 { get; set; }
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String middleName { get; set; }
        public String suffix { get; set; }
        public ProviderLookupResult() {
        	providerId = '';
        	taxId = '';
        	NPI = '';
        	fullName = '';
        	providerType = '';	
        }
    }
}