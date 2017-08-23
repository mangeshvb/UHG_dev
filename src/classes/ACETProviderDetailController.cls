public with sharing class ACETProviderDetailController {
    public Interaction__c Interaction { set; get; }
    public ACETProviderDetail providerDetail { set; get; }
    public String sourceOriginator { get; set; }        //Added 
    public Contact subject {set; get; }   
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public list<ACETProviderLookupController.ProviderLookupResult> AdditionalAddresses { get; set;  }
    public List<ACETProviderAffiliation> Affiliations { get; set; }   
    public list<ACETProviderContractResult> lstACETProvider{get;set;}
    public list<ACETProviderContractResult> Agreements {get;set;}
    public String ProviderTypeCode { get;set; } //added by Avish 03/14/2017 - US537411
    public String providerTINStatusCode { get;set; } //added by Avish 03/14/2017 - US537411
    public String ProvideraddressTypeCode { get;set; } //added by Avish 03/14/2017 - US537411
    public String providerTINOwner { get;set; } //added by Avish 03/14/2017 - US537411
    public String hcoTypeCode {get;set;} //added by vinay 04/12/2017
    public String providerStatusCode {get;set;} //Added by vinay 04/11/2017
    public String providerTINTypeCode {get;set;} //Added by vinay 04/11/2017
    public String addressId {get;set;}  //Added by vinay 04/11/2017
    public String addressTypeCode {get;set;} //Added by vinay 04/11/2017
    public list<Alert__c> lstProviderAlert{get;set;}//added by Vishkaha 11/17/2016
    
    public List<ACETContactHistoryCase> historyCases { get; set; }
    public Integer caseListSize{get; set;}
    public string strType {get;set;}
    public Double offset { get; set; }        
    
    //Added for Async callouts
    ACETGetHCOWebservice ACETGetHCOWS;
    ACETGetHCPWebservice ACETGetHCPWS;
    ACETFindAgreementsWebservice ACETFindAgreementsWS;
    ACETFindHCOWebservice ACTFHCOWS;
    ACETFindHCPWebservice ACTFHCPWS;
    ACETFindHCPAffiliationsWebservice ACETHCPAffWS;
    ACETFindHCOAffiliationsWebservice ACETHCOAffWS;
    
    public ACETProviderDetailController()
    {
        String InteractionId = apexpages.currentpage().getparameters().get('Id');
        strType  = apexpages.currentpage().getparameters().get('Type');
        ProviderTypeCode = apexpages.currentpage().getparameters().get('ProviderTypeCode');
        providerTINStatusCode = apexpages.currentpage().getparameters().get('providerTINStatusCode');
        ProvideraddressTypeCode = apexpages.currentpage().getparameters().get('ProvideraddressTypeCode');
        providerTINOwner = apexpages.currentpage().getparameters().get('providerTINOwner');
        hcoTypeCode = apexpages.currentpage().getparameters().get('hcoTypeCode');
        providerStatusCode = apexpages.currentpage().getparameters().get('providerStatusCode');
        providerTINTypeCode = apexpages.currentpage().getparameters().get('providerTINTypeCode');
        addressId = apexpages.currentpage().getparameters().get('addressId');
        addressTypeCode = apexpages.currentpage().getparameters().get('addressTypeCode');
        
        system.debug(LoggingLevel.INFO, 'Interaction Id: ' + InteractionId + ', Type: ' + strType + ', ProviderTypeCode: ' + ProviderTypeCode);
        system.debug(LoggingLevel.INFO, 'providerTINStatusCode: ' + providerTINStatusCode + ', ProvideraddressTypeCode: ' + ProvideraddressTypeCode + ', providerTINOwner: ' + providerTINOwner);
        system.debug(LoggingLevel.INFO, 'hcoTypeCode: ' + hcoTypeCode + ', providerStatusCode: ' + providerStatusCode + ', providerTINTypeCode: ' + providerTINTypeCode);
        system.debug(LoggingLevel.INFO, 'addressId: ' + addressId + ', addressTypeCode: ' + addressTypeCode);
        
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        system.debug(LoggingLevel.INFO, 'Interaction: ' + Interaction );
        
        timeZone tz = UserInfo.getTimeZone();
        offset = tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
        lstACETProvider = new list<ACETProviderContractResult>();
        providerDetail  =  new ACETProviderDetail();     
            
        HistoryCases = new List<ACETContactHistoryCase>();
    }
    
    public void Init()
    {
        system.debug(LoggingLevel.INFO, 'Interaction.Originator__r.EID__c: ' + Interaction.Originator__r.EID__c);
        system.debug(LoggingLevel.INFO, 'Interaction.Originator__r.Tax_ID__c: ' + Interaction.Originator__r.Tax_ID__c);
        try
        {
            if (Interaction.Originator__r != NULL && String.isNotBlank(Interaction.Originator__r.EID__c))
            {
                HistoryCases = ACETProviderUtility.GetACETContactCaseHistory(Interaction.Originator__r.Tax_ID__c);
                caseListSize = HistoryCases.size();
            }
            else
            {
                providerDetail.generalInfo.lastName = Interaction.Third_Party__r.Name;
                providerDetail.generalInfo.firstName = Interaction.Third_Party__r.First_Name__c;
                providerDetail.generalInfo.taxId = Interaction.Third_Party__r.Tax_ID__c;
                providerDetail.generalInfo.nPI = Interaction.Third_Party__r.NPI__c;
                providerDetail.generalInfo.phone = Interaction.Third_Party__r.Phone_Number__c;   
            }
            getNumberOfProviderAlert();
            updateInterfromVccdParms();
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in Init: ' + ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.ACETUnexpectedErrorMessage));
        }
    }
    
    public Object CallWSOnPageLoad()
    {
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoad. ProviderTypeCode: ' + ProviderTypeCode + ', Interaction.Originator_Type__c @@@ ' + Interaction.Originator_Type__c);
        Continuation PageLoadContinuation;
        if (ProviderTypeCode == 'HCO') {
            ACETGetHCOWS = new ACETGetHCOWebservice();
            PageLoadContinuation = ACETGetHCOWS.StartRequest(Interaction.Originator__r.EID__c, Interaction.Originator__r.Tax_ID__c, providerStatusCode, providerTINStatusCode, providerTINTypeCode, addressId, ProvideraddressTypeCode, 'providerSearch', 'CallWSOnPageLoadCallback', null);
        } else {
            ACETGetHCPWS = new ACETGetHCPWebservice();
            PageLoadContinuation = ACETGetHCPWS.StartRequest(Interaction.Originator__r.EID__c, Interaction.Originator__r.Tax_ID__c, providerTINTypeCode, addressId, ProvideraddressTypeCode, 'providerSearch', 'CallWSOnPageLoadCallback', null);
        }
        ACETFindAgreementsWS = new ACETFindAgreementsWebservice();
        ACETFindAgreementsWS.StartRequest(Interaction.Originator__r.EID__c, Interaction.Originator__r.Tax_ID__c, providerTINTypeCode, addressId, ProvideraddressTypeCode,null, 'CallWSOnPageLoadCallback', PageLoadContinuation);
        
        return PageLoadContinuation; 
    }
    
    public PageReference CallWSOnPageLoadCallback() {
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoadCallback. ProviderTypeCode: ' + ProviderTypeCode);
        ACETWSCalloutResult GetProviderCalloutResult, FindAgreementsCalloutResult;
       // system.debug('>>>>>>'+ACETGetHCOWS.RequestLabel);
        if(Interaction.Originator_Type__c != 'Other'){
            if (ProviderTypeCode == 'HCO') {
                
                GetProviderCalloutResult = ACETGetHCOWS.ProcessResponse(providerTINOwner, ACETGetHCOWS.RequestLabel);
            } else if(ProviderTypeCode == 'HCP') {
                GetProviderCalloutResult = ACETGetHCPWS.ProcessResponse('providerSearch', ACETGetHCPWS.RequestLabel);
            }
            providerDetail = (ACETProviderDetail)GetProviderCalloutResult.Response;          
           // system.debug(LoggingLevel.INFO, 'ProviderDetail.GeneralInfo.NPI *** ' + ProviderDetail.GeneralInfo.NPI);        
            FindAgreementsCalloutResult = ACETFindAgreementsWS.ProcessResponse(ACETFindAgreementsWS.RequestLabel);
            if (FindAgreementsCalloutResult.Success) {
                Agreements = (list<ACETProviderContractResult>)FindAgreementsCalloutResult.Response;
            }
        }
        return null;
    }    
    
    public Object CallFindMedicalProvider() {
        Continuation oContinuation; 
        system.debug(LoggingLevel.INFO, 'Interaction.Originator__r.EID__c: ' + Interaction.Originator__r.EID__c + ' ProviderTypeCode :: ' + ProviderTypeCode);
        system.debug(LoggingLevel.INFO, 'Interaction.Originator__r.Tax_ID__c: ' + Interaction.Originator__r.Tax_ID__c);        
        if (ProviderTypeCode == 'HCO'){
            ACTFHCOWS = new ACETFindHCOWebservice();
            oContinuation = ACTFHCOWS.StartRequest(Interaction.Originator__r.Tax_ID__c, null, Interaction.Originator__r.EID__c, null, '', null, null, '', '', null, 
                                              null, null, null, null, null, null, null,null, 'FindMedicalProviderCallback', null);   
        } else {
            ACTFHCPWS = new ACETFindHCPWebservice();
            oContinuation = ACTFHCPWS.StartRequest(Interaction.Originator__r.Tax_ID__c, null, Interaction.Originator__r.EID__c, null, '', null, null, '', '', null, 
                                              null, null, null, null, null, null, null, null, 'FindMedicalProviderCallback', null);   
        }  
        return oContinuation;
    }
    
    public PageReference FindMedicalProviderCallback() {
        ACETWSCalloutResult CalloutResult;
        if (ProviderTypeCode == 'HCO') {
            CalloutResult = ACTFHCOWS.ProcessResponse(ACTFHCOWS.RequestLabel);   
        } else {
            CalloutResult = ACTFHCPWS.ProcessResponse(ACTFHCPWS.RequestLabel);
        }
        if (CalloutResult.Success) {
            AdditionalAddresses = (List<ACETProviderLookupController.ProviderLookupResult>)CalloutResult.Response;
        }
        return null;    
    }
    
    public Object CallFindAffiliations() {
        Continuation oContinuation; 
        system.debug(LoggingLevel.INFO, 'Interaction.Originator__r.EID__c: ' + Interaction.Originator__r.EID__c + ' ProviderTypeCode :: ' + ProviderTypeCode);
        system.debug(LoggingLevel.INFO, 'Interaction.Originator__r.Tax_ID__c: ' + Interaction.Originator__r.Tax_ID__c);        
        if (ProviderTypeCode == 'HCO'){
            ACETHCOAffWS = new ACETFindHCOAffiliationsWebservice();
            oContinuation = ACETHCOAffWS.StartRequest(Interaction.Originator__r.EID__c, null, null, null, 
                        '0', '50', '0', 'FindAffiliationsCallback', null);
              /*oContinuation = ACETHCOAffWS.StartRequest('521846173197840383', null, null, null, 
                        '0', '50', '0', 'FindAffiliationsCallback', null);*/             
        } else {
            ACETHCPAffWS = new ACETFindHCPAffiliationsWebservice();
            oContinuation = ACETHCPAffWS.StartRequest(Interaction.Originator__r.EID__c, providerStatusCode, 
                            '0', '50', '0', 'FindAffiliationsCallback', null);   
        }  
        return oContinuation;
    }
    
    public PageReference FindAffiliationsCallback() {
        ACETWSCalloutResult CalloutResult;
        if (ProviderTypeCode == 'HCO') {
            CalloutResult = ACETHCOAffWS.ProcessResponse(ACETHCOAffWS.RequestLabel);   
        } else {
            CalloutResult = ACETHCPAffWS.ProcessResponse(ACETHCPAffWS.RequestLabel);
        }
        if (CalloutResult.Success) {
            Affiliations = (List<ACETProviderAffiliation>)CalloutResult.Response;
        }
        return null;    
    }
    
    //added by Vishakha 11/17/2016
    public void getNumberOfProviderAlert() {
        ACETInteractionHighlightsPanelController alertNumber = new ACETInteractionHighlightsPanelController();
        if(Interaction != null){
            lstProviderAlert = alertNumber.getNoAlert('Provider',Interaction.Originator__r.EID__c,Interaction.Originator__r.Tax_ID__c);
            if(!lstProviderAlert.IsEmpty()){
                list<Interaction_Alert__c> lstIntAlert = new list<Interaction_Alert__c>();
                for(Alert__c varalert : lstProviderAlert){
                    Interaction_Alert__c intAlert = new Interaction_Alert__c();
                    intAlert.Alert__c = varAlert.id;
                    intAlert.Interaction__c = Interaction.id;
                    intAlert.ID_Number__c = Interaction.Originator__r.EID__c;// added by vishakha 11/30 for US442332
                    intAlert.Intercation_Alert_Unique_Id_del__c = String.valueof(varAlert.id)+String.valueof(Interaction.id)+ Interaction.Originator__r.EID__c;
                    lstIntAlert.add(intAlert); 
                }
                try{
                    Upsert lstIntAlert Intercation_Alert_Unique_Id_del__c ;//added by vishakha 12/09
                }
                Catch(DMLException ex){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Exception during Insertion Interaction Alert.'));
                }
            }
        }
    }
    
    
    public void updateInterfromVccdParms() { 
        Interaction = ACETVCCDUtility.populateVCCDInfo(Interaction);
        update Interaction;
    }
    
    public class ProviderContractDetail{
        public boolean isActive {get;set;}
        public string strProduct{get;set;}
        public string strNetworkId{get;set;}
        public string strNetworkName{get;set;}
        public string strNetworkStatus{get;set;}
        public string strEffective{get;set;}
        public string strCancel{get;set;}
        public string strIPA{get;set;}
        public string strCapitation{get;set;}
        public string strAcceptingNewPatient{get;set;}
    }
    
    public class ACETProviderDetail 
    {
        public ACETProviderGeneralInfo generalInfo {set; get;}
        public List<ACETProviderDemography> demographics {set; get;}
        public List<ACETProviderSpeciality> specialities {set; get;}
        public List<ACETProviderUnitedPremium> unitedPremiums {set; get;}
        public List<ACETProviderAffiliation> affiliations {set; get;}
        public List<Degree> degrees {get;set;}
        public List<HoursOfOperation> hoursOfOperations {set; get;}
        public List<Language> languages {set; get;}
        public List<NPI> npis {get;set;}
        public ACETProviderDetail()
        {
            generalInfo  =  new ACETProviderGeneralInfo();
            demographics  =  new List<ACETProviderDemography>();
            specialities  =  new List<ACETProviderSpeciality>();
            unitedPremiums  =  new List<ACETProviderUnitedPremium>();
            affiliations  =  new List<ACETProviderAffiliation>();    
            degrees = new List<Degree>();
            hoursOfOperations = new List<HoursOfOperation>();
            languages = new List<Language>();
            npis = new List<NPI>();
        }
    }
    
    public class ACETProviderGeneralInfo
    {
        public String lastName {get;set;}
        public String firstName {get;set;}
        public String taxId {get;set;}
        public String npi {get;set;}
        public String phone {set; get;}
        public String providerID {get;set;}
        public String primaryPhysician {get;set;}
        public String newPatients {get;set;}
        public String paytoIndividual {get;set;}
        public String platinumProvider {get;set;}
        public String medicareId {get;set;}
        public String medicaidId {get;set;}
        public String providerType {get;set;}
        public String providerTINOwner {get;set;}
        public String hcoTypeCode {get;set;}
        public String providerTINTypeCode {get;set;}
        public String providerGenderCode {get;set;}
        public String providerBirthDate {get;set;}
        public String patientAgeRange {get;set;}
        
    }
    public class NPI
    {
        public String npiName {get;set;}
    }
    public class ACETProviderDemography
    {
        public String primaryAddress { get; set; }
        public String addressType {set; get;}
        public String streetAddress {set; get;}
        public String city {set; get;}
        public String zip {set; get;}
        public String state {set; get;}
        public String county { get; set; }
        public String phone {set; get;}
        public String fax {set; get;}
    } 
    public class ACETProviderSpeciality
    {
        public String primarySpeciality {set; get;}
        public String speciality {set; get;}
        public String boardCert {set; get;}
        public String cancelDate {set; get;}
        
    }
    public class Degree 
    {
        public String code {get;set;}
        public String schoolName {get;set;}
    }
    
    public class HoursOfOperation
    {
        public String weekCode {get;set;}
        public String startTime1 {get;set;}
        public String endTime1 {get;set;}
    }
    
    public class Language 
    {
        public String languageStatusCode {get;set;}
        public String languageCode {get;set;}
        public String language {get;set;}
        public String languageSpokenByCode {get;set;}
        public String languageSpokenByDesc {get;set;}
        public String languageWrittenByCode {get;set;}
        public String languageWrittenByDesc{get;set;}
    }
    public class ACETProviderUnitedPremium
    {
        public String premiumDesignation {set; get;}
        public String premiumSpeciality {set; get;}
        public String effectiveDate {set; get;}
        public String premiumCancelDate {set; get;}
    }
    public class ACETProviderAffiliation
    {
        public string affiliation {set; get;}
        public string providerId {set; get;}
        public string effective {set; get;}
        public String PrimarySpeciality { get; set; }                
    }
    
    public class ACETProviderContract{
        public string strProduct {get;set;}
        public string strNetworkId {get;set;}
        public string strNetworkStatus {get;set;}
        public string strNetworkScheduleID {get;set;}
        public string strBenefitPlanId {get;set;}
        public string strEffective {get;set;}
        public string strCancel{get;set;}
        public string strIPA{get;set;}
        public string strCapitation{get;set;}
        public string strAcceptingNewPayment {get;set;}
    }
    
    public class ProviderLookupClass{
        public string TaxId {get;set;}
        public string ProviderName{get;set;}
        public string ProviderId{get;set;}         
        public string NPI{get;set;}
        public string hcoTypeCode{get;set;}
        public string hcoOwner{get;set;}
    }
    
    public List<SelectOption> getCallTopicOptions(){
        return ACETCallTopicsPicklistUtility.getCallTopicOptions('Provider Detail', Interaction.Originator_Type__c);
    }   
}