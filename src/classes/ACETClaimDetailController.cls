/* 
Apex Class Name: ACETClaimDetailController
Purpose: This class is created to support the functionalities of ACETClaimDetail Visualforce Page.
Developed By: Khoushik Selvaraj
Date created:08/23/2016
Rally User Stories ID: US335878
Task ID: 
*/

public with sharing class ACETClaimDetailController {
    
    public String body = '';
    public String ClaimId; 
    public List<ACETClaimJsonSerialization.Claim> lstclaims{get;set;}
    public List<wrapperRemarkCodes> lstwrpRemarkCodes{get;set;}
    public List<wrapperServiceLines> lstwrpServiceLines{get;set;}
    public List<wrapperReimbReduction> lstwrpReimbReduction{get;set;}
    public List<wrapperICESLogic> lstwrpICESLogic{get;set;}
    public List<wrapperSurgicalProc> lstwrpSurgicalProc{get;set;}
    public List<wrapperCause> lstwrpCause{get;set;}
    public List<wrapperClaimDiagnosis> lstwrpClaimDiagnosis{get;set;}
    public List<wrapperClaimsTotalCOB> lstwrpClaimTotalCOB{get;set;}//Added for Temporary, remove it once Webservice is build.(Prakash)
    public ACETClaimDetailResult ClaimsDetail{get;set;}
    public Boolean noresult{get;set;}
    public Interaction__c Interaction {get;set;}
    public List<SelectOption> Originators {get;set;}
    public Boolean IsProviderFlow {get;set;}
     public List<ACETClaimSearchResult> claimList{get;set;}
    public Contact Subject {get;set;}
   public String response{get;set;}
    public String SourceOriginator {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get;set;}
    public Boolean isClaim {get;set;}
    public boolean isCancelCaseCreation{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
     public ACETMemberDetail MemberDetail{get;set;}
   public void childconsolefunction(){
    response = ApexPages.currentPage().getParameters().get('ClaimsResultJson');
    System.debug('Prakash::::response::::'+response );
    claimList = new List<ACETClaimSearchResult>();
     if(response != null && response != '')
     {
       List<ACETClaimSearchResult> claimList1=(List<ACETClaimSearchResult>)json.deserialize(response,List<ACETClaimSearchResult>.class);
       System.debug('Prakash::::claimList1.size()::::'+claimList1.size()+'::::claimList1::::'+claimList1);
       for(ACETClaimSearchResult c: claimList1)
       {
           System.debug('Prakash::::ClaimId::::'+ClaimId+'::::c::::'+c);
           if(c.ClaimId == ClaimId)
           {
               claimList.add(c);
           }
       }
    }
       }
    public void renderCancelCaseSection(){
        isCancelCaseCreation=true;  
    }
    public ACETClaimDetailController()
    {
    
        ClaimId = ApexPages.currentPage().getParameters().get('id');
        childconsolefunction();
       // ClaimId = '';//temp change by Sourav
        system.debug('2323 ClimaId' + ClaimId);
        getClaimDetailsData(ClaimId);   
        getRemarkCodes();
        getServiceLines();
        getReimbReduction();
        getICESLogic();
        getSurgicalProc();
        getCause();
        getClaimDiagnosis();
        //Added for Temporary, remove it once Webservice is build.(Prakash)
        lstwrpClaimTotalCOB = new List<wrapperClaimsTotalCOB>();
        wrapperClaimsTotalCOB cob1= new wrapperClaimsTotalCOB();
        cob1.COBStatus='Primary';
        lstwrpClaimTotalCOB.add(cob1);
        
        wrapperClaimsTotalCOB cob2= new wrapperClaimsTotalCOB();
        cob2.COBStatus='Secondary';
        lstwrpClaimTotalCOB.add(cob2);
    }
     public void init(){
         isClaim = true;
         AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        /*String providerId = ApexPages.currentPage().getParameters().get('id');
        if(!String.isEmpty(providerId)){
            Provider = [select FirstName, LastName, Tax_ID__c, NPI__c from Contact where Id = :providerId];
        }
        */
        //Get Provider Interaction SFDC Id
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');    
        //Check if User is redirected to Member Search page from Provider detail page         
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
       
       
        String strAdditionalInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if (!String.isEmpty(strAdditionalInfo)){ 
             AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(strAdditionalInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);     
/*
        AdditionalInfo.DOB = ApexPages.currentPage().getParameters().get('DOB');
        AdditionalInfo.SitusState = ApexPages.currentPage().getParameters().get('SitusState');
        AdditionalInfo.Relationship = ApexPages.currentPage().getParameters().get('relationship');
        */
    }
     private PageReference getClaimDetailsData(String ClaimId)
    {
        /* List<String> SystemLabels = new String[] { Label.ACETProviderSearchResultMaxRecordCount, Label.ACETProviderSearchMoreRecordsErrorMessage, Label.ACETProviderFacility_Group, 
                                                    Label.ACETProviderPhysician, Label.ACETProviderSearchNoRecordErrorMessage };
           */  
            system.debug('2323 Claim Id' + ClaimId);   
        ACETWSCalloutResult CalloutResult = ACETClaimSearchUtility.getMedicalClaims(ClaimId);
        
         system.Debug('2323 Callout response' + CalloutResult.Response + CalloutResult.MessageSeverity);
        
        if (CalloutResult.Success)
        {
           system.Debug('2323 Callout response' + CalloutResult.Response);
           ClaimsDetail = (ACETClaimDetailResult)CalloutResult.Response;
           system.debug('final wrapper claims details' + ClaimsDetail);
           noresult = true;
        
        }
        else
        {
             system.Debug('2323 else condition' + CalloutResult.Response + CalloutResult.MessageSeverity+CalloutResult.Message);
            
            ApexPages.addMessage(new ApexPages.Message(CalloutResult.MessageSeverity,CalloutResult.Message));
            noresult = false;
        }

     return null;
    }
      private void getICESLogic()
    {
    
     
           lstwrpICESLogic = new List<wrapperICESLogic>();
           
           wrapperICESLogic wil = new wrapperICESLogic();
        
           wil.EditType='test';
           wil.EditAction='test';
           wil.EditDescription='test';
           wil.iCESFlag='test';
           wil.PolicyName='test';
           
           
         lstwrpICESLogic.add(wil);  
           
     }
      private void getSurgicalProc()
    {
      
        
            lstwrpSurgicalProc = new List<wrapperSurgicalProc>();
            wrapperSurgicalProc wsp = new wrapperSurgicalProc();
            wsp.SurgicalProcedure='--';
            wsp.Description='--';
            
            lstwrpSurgicalProc.add(wsp);
    
     }
      private void getCause()
    {
       
       
    lstwrpCause = new List<wrapperCause>();
    wrapperCause wc = new wrapperCause();
    wc.CauseCode='0';
    wc.CauseDescription='General Illness';
    
    lstwrpCause.add(wc);
    
     }
      private void getClaimDiagnosis()
    {
    
                  
        
        lstwrpClaimDiagnosis = new  List<wrapperClaimDiagnosis>();
        wrapperClaimDiagnosis wcd = new wrapperClaimDiagnosis();
        wcd.DiagnosisCode='R12';
        wcd.DiagnosisDescription='HeartBurn';
        wcd.POA='N/A';
        
        lstwrpClaimDiagnosis.add(wcd);
        
        wrapperClaimDiagnosis wcd1 = new wrapperClaimDiagnosis();
        wcd1.DiagnosisCode='R1013';
        wcd1.DiagnosisDescription='Epicatric Pain';
        wcd1.POA='N/A';
        lstwrpClaimDiagnosis.add(wcd1);
        
        wrapperClaimDiagnosis wcd2 = new wrapperClaimDiagnosis();
        wcd2.DiagnosisCode='I10';
        wcd2.DiagnosisDescription='Essential Primary Hypertension';
        wcd2.POA='N/A';
        lstwrpClaimDiagnosis.add(wcd2);
    
     }
   
    private void getRemarkCodes()
    {
       lstwrpRemarkCodes = new List<wrapperRemarkCodes>();
       
        wrapperRemarkCodes wrc = new wrapperRemarkCodes();
        wrc.Procedure = '007404';
        wrc.RemarkCode = '0';
        wrc.RemarkCodeDesc ='Anethsthesia for upper gastro…';
        
        lstwrpRemarkCodes.add(wrc);
        
         wrapperRemarkCodes wrc1 = new wrapperRemarkCodes();
        wrc1.Procedure = '4047F';
        wrc1.RemarkCode = '60';
        wrc1.RemarkCodeDesc ='Documentatin of order for…';
        
        lstwrpRemarkCodes.add(wrc1);
        
        system.debug(lstwrpRemarkCodes);
        
    }
    private void getServiceLines()
    {    
           lstwrpServiceLines = new  List<wrapperServiceLines>();
           wrapperServiceLines wsl = new wrapperServiceLines();
           
           wsl.PlaceofService='Ambulatory Surgical Center';
            wsl.BenefitLevel='N/A';
            wsl.Procedure='007404';
            wsl.Modifier='AA';
            wsl.RemarkCode='0';
            wsl.DxPointer='1,2';
            wsl.Units='045';
            wsl.StartDate='5/10/2016';
            wsl.EndDate='5/10/2016'; 
            wsl.strOverride='';
            wsl.Charged=1640.00;
            wsl.Allowed=1640.00;
            wsl.NotCovered=0.00;
            wsl.Deductible=0.00;
            wsl.Paid=1640.00;
            wsl.Percent='100%';
            wsl.Authorization='AB1234567890';
            
            lstwrpServiceLines.add(wsl);
              wrapperServiceLines wsl1 = new wrapperServiceLines();
           
           wsl1.PlaceofService='Ambulatory Surgical Center';
            wsl1.Procedure='4047F';
            wsl1.Modifier='8P';
            wsl1.RemarkCode='6D';
            wsl1.DxPointer='1,2';
            wsl1.Units='001';
            wsl1.StartDate='5/10/2016';
            wsl1.EndDate='5/10/2016'; 
            wsl1.strOverride='';
            wsl1.Charged=0.01;
            wsl1.Allowed=0.01;
            wsl1.NotCovered=0.00;
            wsl1.Deductible=0.00;
            wsl1.Paid=0.01;
            wsl1.Percent='100%';
            wsl1.Authorization='AB1234567890';
            
            lstwrpServiceLines.add(wsl1);
          
    }
    
   private void getReimbReduction()
   {
           lstwrpReimbReduction = new List<wrapperReimbReduction>();
           
           wrapperReimbReduction wrr = new wrapperReimbReduction();
           
           wrr.Type = 'AL';
           wrr.RemarkCode = 'G6';
           wrr.Amount=1000.00;
           
          lstwrpReimbReduction.add(wrr); 
          
            wrapperReimbReduction wrr1 = new wrapperReimbReduction();
           
           wrr1.Type = 'GL';
           wrr1.RemarkCode = 'G5';
           wrr1.Amount=3000.00;
           
          lstwrpReimbReduction.add(wrr); 
           
   }
    
    public class wrapperRemarkCodes
    {
            public String Procedure { set; get; }
            public String RemarkCode { set; get; }
            public String RemarkCodeDesc { set; get; }
    }
    public class wrapperServiceLines
    {
         public String BenefitLevel { set; get; }
        public String  PlaceofService{ set; get; }
        public String  Procedure{ set; get; }
        public String  Modifier{ set; get; }
        public String  RemarkCode{ set; get; }
        public String  DxPointer{ set; get; }
        public String  Units{ set; get; }
        public String  StartDate{ set; get; }
        public String  EndDate { set; get; }
        public String  strOverride { set; get; }
        public Decimal Charged{ set; get; }
        public Decimal Allowed{ set; get; }
        public Decimal NotCovered{ set; get; }
        public Decimal Deductible{ set; get; }
        public Decimal Paid{ set; get; }
        public String  Percent{ set; get; }
        public String  Authorization{ set; get; }

    }
    public class wrapperReimbReduction
    {
         public String  Type{ set; get; }
        public String  RemarkCode{ set; get; }
        public Decimal  Amount{ set; get; }
    }
     public class wrapperICESLogic
    {
         public String  EditType{ set; get; }
        public String  EditAction{ set; get; }
        public String  EditDescription{ set; get; }
        public String  iCESFlag{ set; get; }
        public String  PolicyName{ set; get; }
    }
     public class wrapperSurgicalProc
    {
         public String  SurgicalProcedure{ set; get; }
        public String  Description{ set; get; }
       
    }
      public class wrapperCause
    {
         public String  CauseCode{ set; get; }
        public String  CauseDescription{ set; get; }
       
    }
     public class wrapperClaimDiagnosis
    {
         public String  DiagnosisCode{ set; get; }
        public String  DiagnosisDescription{ set; get; }
        public String  POA{ set; get; }
       
    }
    
    private void initInteractionAndSubject(){
        String interactionId = ApexPages.currentPage().getParameters().get('InteractionId'); 
        system.debug('InteractionId: ' + InteractionId);    
          
        if (!String.isEmpty(interactionId)){                                                        
            //Query Provider Interaction details
            Interaction = ACETProviderUtility.GetInteractionByID(interactionId);    
            //IsProviderFlow = true;                   
        }else{
            //IsProviderFlow = false;
        } 
        
        //save member and member family to contact
        //createMemberAndFamilyMembers();
        
        //create a new interaction if not passed from provider page        
        If(Interaction == null){
            createInteraction();
        }  
        
        //setup originator options
        Originators = new List<SelectOption>();        
        //redirected from provider page, add provider as originator
        if(IsProviderFlow){ 
            if(Interaction.Originator_Type__c == 'Other')
             originators.add(new SelectOption(Interaction.Third_Party__c, Interaction.Third_Party__r.Name));
            else              
            originators.add(new SelectOption(Interaction.Originator__c, Interaction.Originator__r.Name));       
        }else{
            //member flow, add current member and member family
            //initMemberOriginators();    
        }                                                         
    }
    
    private void createInteraction(){
        Interaction = new Interaction__c();
        Interaction.Originator__c = Subject.Id;
        
        //for now, we only have the use case as member calls themselves
        Interaction.Interaction_Type__c = SourceOriginator;
        Interaction.Originator_Type__c = 'Member';
                   
        Insert Interaction; 
        
        //query referenced originator information
        Interaction = ACETProviderUtility.GetInteractionByID(Interaction.Id);            
        system.debug(Interaction);
    }
    //Added for Temporary, remove it once Webservice is build.(Prakash)
    public class wrapperClaimsTotalCOB{
      public string COBStatus{get;set;}
    }
    
}