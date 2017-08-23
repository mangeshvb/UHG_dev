/* This class related to "ACETClaimSearch Visual Force Page"
Developed By: Prakash Swain
Date created:08/11/2016
Rally User Stories ID: US335825
Task ID: TA1016961
*/
public class ACETClaimSearchController {
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    //public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String searchBy{get;set;}
    public String dateOfService{get;set;}
    public String status{get;set;}
    public Boolean deductible{get;set;}
    public String inNetwork{get;set;}
    public String claimnumber{get;set;}
    
    public String claimtype{get;set;}
    public Boolean startdatedisabled{get;set;}
    public Boolean enddatedisabled{get;set;}
    public Boolean  dateofservicedisabled {get;set;}
   
    public String taxid{get;set;}
    public String AuthorizationNumber{get;set;}
    public String ReferralNumber{get;set;}
    // Hide or UnHide Fields
    public Boolean authnumberhide{get;set;}
    public Boolean referralhide{get;set;}
    public Boolean casenumberhide{get;set;}
    public Boolean networkstatushide{get;set;}
    public Boolean deductiblehide{get;set;}
    public Boolean claimtypehide{get;set;}
    public Boolean taxidhide{get;set;}
    public Boolean claimnumberhide{get;set;}
    public Case startdate {get;set;}
    public Case enddate {get;set;}
    // Make Field Required
    public String claimNoReqd{get;set;}
    public String startDateReqd{get;set;}
    public String endDateReqd{get;set;}
    public String authorizationNoReqd{get;set;}
    public String taxIdReqd{get;set;}
    public String referralNoReqd{get;set;}
    public Boolean claimmandatory{get;set;}
    public String providers{get;set;}
    public boolean notResearchUser {get;set;}
    public boolean disableDates {get;set;}
     
     //added by khoushik for sorting
      public String SortBy {get;set;}
    public String SortOrder {get;set;}
    public String LastSortBy{get;set;}
   public String strSelectedClaims{get;set;}
   public string surrogateKey {get; set;}
   
    public List<ACETClaimSearchResult>  Claims{ set; get; }
    public String ClaimsResultJson{get;set;}
    public Interaction__c Interaction { get; set; }
    public String SourceOriginator {get;set;}
    public Contact Provider {get;set;}  
    public Contact Subject {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public Boolean isClaim {get;set;}
    public String hpAdditionInfoStr {get;set;}
    public boolean isCancelCaseCreation{get;set;}
    //Added By Prakash: This Method is used to call the components of HighlightsPanel
    
    public void init(){
        //isClaim = true;
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'View Claims';
        //wrapper.createBlankCase();
        String additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(additionalInfoStr,ACETHighlightsPanelAdditionalInfo.class);  
         
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        String providerId = ApexPages.currentPage().getParameters().get('id');
        if(!String.isEmpty(providerId)){
            Provider = [select FirstName, LastName, Tax_ID__c, NPI__c from Contact where Id = :providerId];
        }
        
        //system.debug('*********ProviderInteraction********'+Provider.Tax_ID__c);
        
        //Get Provider Interaction SFDC Id
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');    
        //Check if User is redirected to Member Search page from Provider detail page   
        system.debug('-----------taxid---'+interactionId );      
        if (!String.isEmpty(interactionId)){                        
            system.debug('InteractionId: ' + InteractionId);
            
            //Query Provider Interaction details
            Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            SourceOriginator = Interaction.Interaction_Type__c;
            system.debug('Interaction: ' + Interaction + ', SourceOriginator: ' + SourceOriginator);
        }
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        if (!String.isEmpty(contactId)){ 
            subject = ACETProviderUtility.GetContactByID(contactId);
        }
        
         // if(Interaction.Third_Party__r.Tax_ID__!=null && Interaction!=null){
            TaxId = Interaction!=null && Interaction.Third_Party__r!=null && Interaction.Third_Party__r.Tax_ID__c!=null? Interaction.Third_Party__r.Tax_ID__c:Interaction.Originator__r.Tax_ID__c;
            //taxid ='123456';
       //}
       system.debug('*********Interaction********'+Interaction.Third_Party__r.Tax_ID__c);
        //AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)Json.deserializeUntyped(ApexPages.currentPage().getParameters().get('additionalInfo'));
        AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(ApexPages.currentPage().getParameters().get('additionalInfo'), ACETHighlightsPanelAdditionalInfo.class);
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
        /*AdditionalInfo.DOB = ApexPages.currentPage().getParameters().get('DOB');
        AdditionalInfo.SitusState = ApexPages.currentPage().getParameters().get('SitusState');
        AdditionalInfo.Relationship = ApexPages.currentPage().getParameters().get('relationship');
        AdditionalInfo.PolicyNumber= ApexPages.currentPage().getParameters().get('policynumber');
        AdditionalInfo.ProductType= ApexPages.currentPage().getParameters().get('producttype');
        AdditionalInfo.EndDate= ApexPages.currentPage().getParameters().get('enddate');
        AdditionalInfo.Product= ApexPages.currentPage().getParameters().get('product');
        AdditionalInfo.EffectiveDate= ApexPages.currentPage().getParameters().get('effectivedate');
        */
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }        
        
    }
    
    //Constructor Class
    public ACETClaimSearchController()
    {
        //added by khoushik
        disableDates = false;
        
        //Claims = new list<ACETClaimSearchResult>();        
        //making sure default value is blank for input paramters
        
        inNetwork='';
        claimtype='MD';

        deductible=false;
        ClaimNumber ='';
        AuthorizationNumber='';
        ReferralNumber='';        
        
        claimnumberhide = false;
        networkstatushide=true;
        startdatedisabled=true;
        enddatedisabled=true;
        dateofservicedisabled =true;
        deductiblehide=true;
        taxidhide=true;
        inNetwork='All';
        claimtype='MD';
        providers='All';
        claimtypehide=true;
        startdate = new Case();
        enddate= new Case();
        //searchBy='Subject';
        taxid='';
        authnumberhide = false;
        referralhide=false;
        ClaimNoReqd = '';
        startDateReqd = '';
        endDateReqd = '';
        authorizationNoReqd = '';
        taxIdReqd = '';
        referralNoReqd = '';
        //Added by Raj (Motorhead). This is required to check the logged-in User profile on the page load for Research User
        getloggedinProfileName();
        init(); 
        dateOfService = 'Day';    
        if(dateOfService == 'Day'){
            startdate.tst_Date_Field__c = null;
           // enddate.tst_Date_Field__c = Date.Today();
            enddatedisabled=false;            
            
        }  
        //dateServiceChange();
        
        
    }
    
    public PageReference clear()
    {
        startdate.tst_Date_Field__c = null;
        enddate.tst_Date_Field__c = null;
        deductible =false;
        inNetwork = 'All';
        taxidhide= null;
        dateOfService = 'Date Range';
        searchBy = 'Subject';
        claimtype='MD';
        searchbyaction();
        taxid='';
        authnumberhide = false;
        referralhide=false;
        ClaimNoReqd = '';
        startDateReqd = '';
        endDateReqd = '';
        authorizationNoReqd = '';
        taxIdReqd = '';
        referralNoReqd = '';
        claimmandatory=false;
       
        providers='All';
        ReferralNumber='';
        AuthorizationNumber='';
        //Claims.clear();
        Claims = null;
        return null;
    }

    public PageReference search()
    {
        string vccdParam = ApexPages.currentPage().getParameters().get('vccdParams');
        system.debug('------vccdParam------'+vccdParam );
        if(vccdParam != '' && vccdParam != null){
            ApexPages.currentPage().getParameters().put('noAutoSearch','true');
        }

        Claims = null; 
         //Claims = new list<ACETClaimSearchResult>();
        //Claims.clear();
        ClaimNoReqd = ''; 
        startDateReqd = '';
        endDateReqd = '';
        authorizationNoReqd = '';
        taxIdReqd = '';
        referralNoReqd = '';
        claimtype= 'MD';
        Date dt= Date.today();
        
        //@rama - adding the code for defalting values during the search
          if(searchBy == 'Subject' || searchBy == 'AuthorizationNumber' || searchBy == 'ReferralNumber'){
         //date of service is 'Day', then end date wsould be equal to start day
            if(dateOfService == 'Day'){
                enddate.tst_Date_Field__c = startdate.tst_Date_Field__c;
            }else if(dateOfService == 'DateRange'){
                if(startdate.tst_Date_Field__c == null && enddate.tst_Date_Field__c == null){
                    enddate.tst_Date_Field__c = System.today();
                    startdate.tst_Date_Field__c =  enddate.tst_Date_Field__c.addYears(-2);
                }
            }
        }
                
        
        /*
        if(dateofservicedisabled && (dateOfService == 'DateRange' || dateOfService == 'Day') && startdate != null &&
           ((startdate.tst_Date_Field__c != null 
             && startdate.tst_Date_Field__c.daysBetween(System.today()) < 0)))
        {
            startDateReqd = 'Required';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Invalid Search'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Start Date must be less than or equal to today\'s Date'));
        }
        
       /* if(dateofservicedisabled && (dateOfService == 'DateRange' || dateOfService == 'Day') && enddate != null &&
           ((enddate.tst_Date_Field__c != null 
             && enddate.tst_Date_Field__c.daysBetween(System.today()) < 0)))
        {
            endDateReqd = 'Required';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Invalid Search'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'End Date must be less than or equal to today\'s Date'));
        }
       /*
        if(dateofservicedisabled && dateOfService == 'DateRange' && startdate != null && enddate != null && 
           ((startdate.tst_Date_Field__c != null && enddate.tst_Date_Field__c != null 
             && startdate.tst_Date_Field__c.daysBetween(enddate.tst_Date_Field__c) < 0)                                                                                                 
            //|| (startdate.tst_Date_Field__c != null && enddate.tst_Date_Field__c == null) 
            //|| (startdate.tst_Date_Field__c == null && enddate.tst_Date_Field__c != null) 
            ))
        {   system.debug('dateofservicedisabled+------');
            startDateReqd = 'Required';
            endDateReqd = 'Required';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Invalid Search'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'End Date must be greater than Start Date'));
        }
        
        if(searchBy == 'AuthorizationNumber' && (AuthorizationNumber == null || AuthorizationNumber == ''))
        {
            authorizationNoReqd = 'Required';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Invalid Search'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must enter a value'));
        }
        if(searchBy == 'ReferralNumber' && (ReferralNumber == null || ReferralNumber == ''))
        {
            referralNoReqd = 'Required';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Invalid Search'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must enter a value'));
        }
        if(searchBy == 'ClaimNumber' && (claimnumber == null || claimnumber == ''))
        {
            ClaimNoReqd = 'Required';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Invalid Search'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must enter a value'));
        }
        */
  // Code added by khoushik to call the webservice and get claims search results
  
        //if(ClaimNoReqd != 'required' && referralNoReqd != 'required' && authorizationNoReqd != 'required' && endDateReqd != 'required' && startDateReqd != 'required')
        //{
             SortBy = 'ClaimId';
            SortOrder = 'Asc';
        List<String> SystemLabels = new String[] { Label.ACETProviderSearchResultMaxRecordCount, Label.ACETProviderSearchMoreRecordsErrorMessage, Label.ACETProviderFacility_Group, 
                                                    Label.ACETProviderPhysician, Label.ACETProviderSearchNoRecordErrorMessage };
       // if(!Test.isRunningTest())
        //{        
        ACETWSCalloutResult CalloutResult =  ACETClaimSearchUtility.GetClaims(TaxId, inNetwork, claimtype, string.valueof(startdate.tst_Date_Field__c), string.valueof(enddate.tst_Date_Field__c), string.valueof(deductible), ClaimNumber, AuthorizationNumber, ReferralNumber, '', SortBy, SortOrder, SystemLabels);
        
        system.debug('Problem 0' );
        system.debug('Problem 0' + CalloutResult.Success);
        
        if (CalloutResult.Success)
        {
            system.debug('Problem 1');
            
            Claims = (list<ACETClaimSearchResult>)CalloutResult.Response;
            system.debug('Problem 2');
           if(Claims != null)
           {
                
               ClaimsResultJson = json.serialize(Claims);
               system.debug('**ClaimsResultJson**' + ClaimsResultJson );
           }
        }
        else
        {
            if(String.isNotBlank(CalloutResult.Message)){                
                ACETClaimMessageWrapper claimMessage = (ACETClaimMessageWrapper)JSON.deserialize(CalloutResult.Message, ACETClaimMessageWrapper.class);
                if(claimMessage.findClaimsResult != null && claimMessage.findClaimsResult.errors != null && claimMessage.findClaimsResult.errors.size() > 0){
                    if(claimMessage.findClaimsResult.errors[0].code == '400' && claimMessage.findClaimsResult.errors[0].name == 'NoDataFound'){
                        Claims = new list<ACETClaimSearchResult>();
                    } 
                }
            }
            if(Claims == null)
                ApexPages.addMessage(new ApexPages.Message(CalloutResult.MessageSeverity, CalloutResult.Message));
        }
       // }
        //}
        return null;
        
    }
    public void sortTable(){   
        if(LastSortBy != null){             
            if(LastSortBy != SortBy){
                SortOrder = 'Asc';                      
            }else{
                SortOrder = (SortOrder == 'Asc'? 'Desc' : 'Asc');
            }
        }
        
        ACETClaimSearchResult.SortBy = SortBy;
        ACETClaimSearchResult.SortOrder = SortOrder;
        Claims.sort();
        LastSortBy = SortBy;                                
    }
    public void renderCancelCaseSection(){
        isCancelCaseCreation=true;  
    }
    
   
    public PageReference searchbyaction() {
    
    ApexPages.currentPage().getParameters().put('noAutoSearch','true');
       
        ClaimNoReqd = '';
        startDateReqd = '';
        endDateReqd = '';
        authorizationNoReqd = '';
        taxIdReqd = '';
        referralNoReqd = '';       
        claimnumber = '';
        ReferralNumber='';
        //@Rama: Clear Taxid on searchBy Change
        TaxId = '';
        AuthorizationNumber='';
        
        //claimnumber = '';
        //disableDates = false;
        //startdatedisabled = true;
        //enddatedisabled = true;
        
        //@Rama : Commenting the hard code of searchBy
        //searchBy = 'ClaimNumber';
                        
        authnumberhide = true;        
        dateOfService = 'DateRange';
        startdate.tst_Date_Field__c = null;
        enddate.tst_Date_Field__c = null;
        
        if(dateOfService =='DateRange'){
            if(searchBy == 'ClaimNumber'){
                disableDates = true;
                startdatedisabled  =false;
                enddatedisabled  =false;
            }else{
                disableDates = false;
                startdatedisabled  =true;
                enddatedisabled  =true;
            }
        }
        
        if(searchBy == 'ClaimNumber'){
            claimnumberhide = true;
            //startdatedisabled = false;
            //enddatedisabled = false;
            dateofservicedisabled = false;
            authnumberhide=false;
            networkstatushide=false;
            taxidhide=false;
            deductiblehide=false;
            claimtypehide=false;
            referralhide=false;
            claimmandatory = true;
        }
       
        
        else if(searchby=='AuthorizationNumber'){
            claimnumberhide = false;
            startdatedisabled = true;
            enddatedisabled = true;
            dateofservicedisabled = true;
            networkstatushide=true;
            taxidhide=false;
            deductiblehide=true;
            claimtypehide=false;
            authnumberhide =true;
            referralhide=false;
         }
         else if(searchby=='referralnumber'){
            claimnumberhide = false;
            startdatedisabled = true;
            enddatedisabled = true;
            dateofservicedisabled = true;
            networkstatushide=true;
            taxidhide=false;
            deductiblehide=true;
            claimtypehide=false;
            authnumberhide = false;
            referralhide=true;
         }
         
       
         else {
            claimnumberhide = false;
            startdatedisabled = true;
            enddatedisabled = true;
            dateofservicedisabled = true;
            networkstatushide=true;
            taxidhide=true;
            deductiblehide=true;
            claimtypehide=false;
            authnumberhide=false;
            referralhide=false;
         }
        return null;
    }
    
    
   private void getloggedinProfileName(){ 
        notResearchUser = true;
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String loggedinProfileName = PROFILE[0].Name;
    
        //Check if the logged-in User has profile 'Research' type
           if(loggedinProfileName.contains('Research'))
            { notResearchUser = false;}
    }
    
    public PageReference dateServiceChange()
    {   
        disableDates  = false;
        startDateReqd = '';
        endDateReqd = '';
        startdatedisabled = true;
        enddatedisabled = true;
        referralNoReqd = '';
        authorizationNoReqd = '';
        if(dateOfService == 'Day'){
           // startdate.tst_Date_Field__c = Date.today();
           // enddate.tst_Date_Field__c = Date.Today();
            enddatedisabled=false;            
            
        }
        else if(dateOfService == 'ThisYear'){
            disableDates = true;    
            Date dt = Date.today();
            startdate.tst_Date_Field__c  = Date.newInstance(dt.year(), 1, 1);
            enddate.tst_Date_Field__c = Date.newInstance(dt.year(), 12, 31);
        }
        else if(dateOfService == 'LastYear'){
            disableDates = true;
            Date dt = Date.today();
            startdate.tst_Date_Field__c = Date.newInstance(dt.year()-1, 1, 1);
            enddate.tst_Date_Field__c = Date.newInstance(dt.year()-1, 12, 31);
        }
        else
        {
            startdate.tst_Date_Field__c = null;
            enddate.tst_Date_Field__c = null;
        }
        return null;
    }
    
    //public PageReference Save(){
        //wrapper.caseObj.Topic__c ='View Claims';
        //wrapper.createCase();            
        //PageReference caseDetailsReference = new PageReference('/' + wrapper.CaseObj.Id);
        //return caseDetailsReference;
    //} 
 public PageReference SaveAndClose(){
        wrapper.caseObj.Topic__c ='View Claims';
        wrapper.caseObj.Status='Closed';
       // wrapper.caseObj.AutoDoc__c = AutoDoc;
        wrapper.createCase();            
        PageReference caseDetailsReference = new PageReference('/apex/ACETCallTopicSaveAndClose?caseId=' + wrapper.CaseObj.Id);
        system.debug('wrapper.CaseObj.Id  >>>  '+wrapper.CaseObj.Id);
        return caseDetailsReference;
    }      
  /*  public void processselected()
    {
    strSelectedClaims = '' ;
       List<ACETClaimSearchResult> SelectClaims = new List<ACETClaimSearchResult>();
        
        for(ACETClaimSearchResult ars : Claims)
        {
               if(ars.selected == true)
               {
                   SelectClaims.add(ars);
                   strSelectedClaims = strSelectedClaims  + ' ClaimId:' +  ars.ClaimID;
               } 
        }        
        
    }*/
    
    public class ACETClaimMessageWrapper{
        public FindClaimResult findClaimsResult;
    }
    
    public class FindClaimResult{
        public List<FC_Error> errors;
    }
    
    public class FC_Error{
        public String code;
        public String name;
        public String severity;
        public String origin;
        public String description;
    }
}