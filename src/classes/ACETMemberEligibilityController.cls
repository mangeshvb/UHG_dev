public with sharing class ACETMemberEligibilityController {
    public String AutoDoc {get;set;}
    public Interaction__c Interaction {get;set;}
    public Contact Subject {get;set;}
    public String response{get;set;}
    public String SourceOriginator {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public Boolean isClaim {get;set;}
    public String memberdetailresponse{get;set;}
    public String memberFullname{get;set;}
    public String PrimaryAddress{get;set;}
    public String MailingAddress{get;set;}
    public String ClaimAddress{get;set;}
    public String ClaimAddress1{get;set;}    
    public Boolean IsShowActiveCoveragesOnly {get;set;}
    public List<ACETMemberDetail.CoverageLine> Coverages {get;set;}   
    public ACETMemberDetail.CoverageLine PreferredCoverage {get;set;}
    public String ProferredCoverageGUID {get;set;}    
    public ACETMemberDetail MemberDetail{get;set;}
    public boolean isCancelCaseCreation{get;set;}
    public boolean isResolved{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public String surrogateKey {get; set;}
    public static Map<String,String> serviceRequestLabels;
    ACETGetIndividualWebService ACETGetIndWebservice;
    ACETFindMembershipWebservice ACETFindMemWebservice;
    ACETGetMembershipWebService ACETGetMemWebservice;
  //  public ACETCaseItemWrapper caseItem{get;set;}
    
    
      public void init(){
        wrapper = new ACETCallTopicsDataWrapper(); 
        system.debug(ApexPages.currentPage().getParameters().get('interactionId')); 
             
        wrapper.CallTopic ='View Member Eligibility';
        wrapper.init(); 
        wrapper.CaseObj.Topic__c = 'View Member Eligibility';
        String strSurrogateKey = apexpages.currentpage().getparameters().get('SRK');
        wrapper.SurrogateKey = strSurrogateKey;
        
        initHighlightPanelAdditionalInfo();
      //  toggleShowCoverages();  
      }
    private void initHighlightPanelAdditionalInfo(){
        String additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        system.debug(additionalInfoStr );
        if(!String.isEmpty(additionalInfoStr )){ 
        wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(additionalInfoStr,ACETHighlightsPanelAdditionalInfo.class); 
        }           
    }
     public void childconsolefunction(){
       /* 
       if(memberdetailresponse!= null && memberdetailresponse!= ''){
       MemberDetail=(ACETMemberDetail)json.deserialize(memberdetailresponse,ACETMemberDetail.class); 
       memberFullname = MemberDetail.FirstName + ' ' + MemberDetail.MiddleName + ' ' + MemberDetail.LastName;
       PrimaryAddress = MemberDetail.Addresses[0].AddressLine1 + ' ' +
                        MemberDetail.Addresses[0].AddressLine2 + ' ' + 
                        MemberDetail.Addresses[0].City + ' ' +
                        MemberDetail.Addresses[0].State + ' ' + 
                        MemberDetail.Addresses[0].Zip ;
                        
       MailingAddress = MemberDetail.Addresses[0].AddressLine1 + ' ' +
                        MemberDetail.Addresses[0].AddressLine2 + ' ' + 
                        MemberDetail.Addresses[0].City + ' ' +
                        MemberDetail.Addresses[0].State + ' ' + 
                        MemberDetail.Addresses[0].Zip ;
                        
                       
       ClaimAddress  =   MemberDetail.ClaimAddressline1  + ' ' +
                         MemberDetail.ClaimAddressline2  + ' ' +
                         MemberDetail.ClaimAddresscity  + ' ' +
                         MemberDetail.ClaimAddressstate  + ' ' +
                         MemberDetail.ClaimAddresspostalCode  + ' ' +               
                         MemberDetail.ClaimAddresscountyCode ;
                        
        
        ClaimAddress=    MemberDetail.ClaimAddressline1  + ' ' +
                         MemberDetail.ClaimAddressline2;
                         
        ClaimAddress1=   MemberDetail.ClaimAddresscity  + ' ' +
                         MemberDetail.ClaimAddressstate  + ' ' +
                         MemberDetail.ClaimAddresspostalCode  + ' ' +               
                         MemberDetail.ClaimAddresscountyCode ;
        
       }*/toggleShowCoverages();
     }
      
    public void renderCancelCaseSection(){
        isCancelCaseCreation=true;  
    }
    public ACETMemberEligibilityController(){
         init();
         AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();        
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
        String addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
     if(!String.isEmpty(addInfo)){  
         AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(ApexPages.currentPage().getParameters().get('additionalInfo'), ACETHighlightsPanelAdditionalInfo.class);
     }
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
         if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }  
   }

  public void toggleShowCoverages(){
      if(IsShowActiveCoveragesOnly == null){
        IsShowActiveCoveragesOnly = true;  
      }else{
        IsShowActiveCoveragesOnly = !IsShowActiveCoveragesOnly;
      }
      system.debug('IsShowActiveCoveragesOnly '+IsShowActiveCoveragesOnly);
      Coverages = new List<ACETMemberDetail.CoverageLine>();
      if(MemberDetail != null && MemberDetail.CoverageLines != null){      
        for(ACETMemberDetail.CoverageLine c : MemberDetail.CoverageLines){
          if(!IsShowActiveCoveragesOnly || c.getIsActive()){
            Coverages.add(c);  
          }
        }
      }
      system.debug('Coverages'+Coverages);
    }
    /**
    * @name         :   getMemberData
    * @description  :   This method/action function is responsible for getting the selected member information from getIndividual, FindMemberShip and getmembership service.
    * @param        :   void   
    * @return       :   void
    * @author       :   Bhanu Jain
    * @createddate  :   17/04/2016
    * @lastmodifiedby:  
    **/    
    public void getMemberData(){
        system.debug('Calling memberData');
        MemberDetail = ACETWebserviceHelper.queryIndividuals(MemberDetail);
        MemberDetail = ACETWebserviceHelper.queryMembership(MemberDetail);
        system.debug('MemberDetail in eligibility >> '+JSON.serialize(MemberDetail));
        memberFullname = MemberDetail.FirstName + ' ' + MemberDetail.MiddleName + ' ' + MemberDetail.LastName;
        //wrapper.createBlankCase();
        init();
    }
    
    public  Object callMemberServices(){
        system.debug('calling callMemberServices');
         serviceRequestLabels = new Map<String,String>();
        Continuation PageLoadContinuation;
            MemberDetail = new ACETMemberDetail(); 
            MemberDetail.SurrogateKey = surrogateKey;
            //GetIndividual webservice callout
            ACETGetIndWebservice = new ACETGetIndividualWebService();
            PageLoadContinuation = ACETGetIndWebservice.StartRequest(MemberDetail.SurrogateKey, MemberDetail,'memberServicesCallback',null);  
            
            //FindMembership webservice callout
            ACETFindMemWebservice = new ACETFindMembershipWebservice();
            PageLoadContinuation = ACETFindMemWebservice.StartRequest(MemberDetail.SurrogateKey, MemberDetail,'memberServicesCallback',PageLoadContinuation); 
            
         
          return PageLoadContinuation; 
    }
    public  PageReference memberServicesCallback(){
        system.debug('calling memberServicesCallback '+ACETGetIndWebservice);
        ACETWSCalloutResult getIndividualResponse, findMembershipResponse;
        //ACETMemberDetail MemberDetail;
        getIndividualResponse = ACETGetIndWebservice.ProcessResponse(ACETGetIndWebservice.RequestLabel, MemberDetail);
        
        if(getIndividualResponse.Success) {
          MemberDetail = (ACETMemberDetail)getIndividualResponse.Response;
          MemberDetail.OriginatorRelationship = MemberDetail.Relationship;
          system.debug('MemberDetail Continuation 1 >> '+Json.serialize(MemberDetail));
        }
        else{
                ApexPages.addMessage(new ApexPages.Message(getIndividualResponse.MessageSeverity,getIndividualResponse.Message));
            }        
        
        findMembershipResponse = ACETFindMemWebservice.ProcessResponse(ACETFindMemWebservice.RequestLabel, MemberDetail);
            if(findMembershipResponse.Success) {
              MemberDetail = (ACETMemberDetail)findMembershipResponse.Response;
               system.debug('MemberDetail Continuation 2 >> '+Json.serialize(MemberDetail));
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(findMembershipResponse.MessageSeverity,findMembershipResponse.Message));
            }
            
            system.debug('MemberDetail first callback '+MemberDetail);
            memberFullname = MemberDetail.FirstName + ' ' + MemberDetail.MiddleName + ' ' + MemberDetail.LastName;
        return null;
    } 
    
    public object CallGetMembership(){
        Continuation getMembershipContinuation; 
        ACETGetMemWebservice = new ACETGetMembershipWebService();
        system.debug('inside call membership :'+MemberDetail);
        if(MemberDetail.PreferredCoverage != null){
            if(!String.IsEmpty(MemberDetail.SurrogateKey)) {
                ACETGetMemWebservice = new ACETGetMembershipWebService();
                getMembershipContinuation = ACETGetMemWebservice.StartRequest(MemberDetail.SurrogateKey,MemberDetail.PreferredCoverage.groupNumber, MemberDetail,'GetMembershipCallback',null); 
            }else{
                system.debug('inside call get member id membership');
                ACETGetMemWebservice = new ACETGetMembershipWebService();
                getMembershipContinuation = ACETGetMemWebservice.StartRequest(MemberDetail.MemberId, PreferredCoverage.PolicyNumber, MemberDetail,'GetMembershipCallback',null);
            }
        }
        return  getMembershipContinuation;
    }
    public PageReference GetMembershipCallback() {
        system.debug('inside call bacl method'); 
        ACETWSCalloutResult getMembershipResponse;
        
        getMembershipResponse = ACETGetMemWebservice.ProcessResponse(ACETGetMemWebservice.RequestLabel, MemberDetail);
        system.debug('inside call bacl method' + getMembershipResponse); 
        if(getMembershipResponse.Success) {
          MemberDetail = (ACETMemberDetail)getMembershipResponse.Response;
        }
        else{
                system.debug('getMembershipResponse'+getMembershipResponse);
                ApexPages.addMessage(new ApexPages.Message(getMembershipResponse.MessageSeverity,getMembershipResponse.Message));
            }
        if(MemberDetail.OriginatorRelationship == null){
            MemberDetail.OriginatorRelationship = MemberDetail.Relationship;
        }
        
        //to code refactor
        if(PreferredCoverage != null){
            //memberDetail.MemberId='7293282';
            memberDetail.EffectiveDate = PreferredCoverage.EffectiveDate;
            memberDetail.EndDate = PreferredCoverage.EndDate;
            memberDetail.PolicyNumber =  PreferredCoverage.PolicyNumber;
            //memberDetail.GroupName =  
            memberDetail.Product =  PreferredCoverage.Product;
            memberDetail.ProductType =  PreferredCoverage.ProductType;              
        }
        init();
        system.debug('MemberDetail second callback '+JSON.serialize(MemberDetail));
        return null;
    }       
    
    //test autodoc
    public PageReference saveCase(){                
      /*  Case c = new Case();        
        c.Interaction__c = Interaction.Id;
        c.Topic__c = 'View Member Eligibility';
        c.Origin =  SourceOriginator ;
        c.Status = 'Open';
        c.AutoDoc__c = AutoDoc;
        insert c;
        
        return new PageReference('/' + c.Id);
        */
        
         wrapper.caseObj.Topic__c ='View Member Eligibility';
         wrapper.caseObj.AutoDoc__c = AutoDoc;
         wrapper.createCase();            
        PageReference caseDetailsReference = new PageReference('/' + wrapper.CaseObj.Id);
        return caseDetailsReference;        
                             
    }
 public PageReference routeCase(){
        wrapper.caseObj.Topic__c ='View Member Eligibility';
        wrapper.createCase();            
        PageReference caseDetailsReference = new PageReference('/' + wrapper.CaseObj.Id);
        return caseDetailsReference;
    }    
 public PageReference Save(){
        wrapper.caseObj.Topic__c ='View Member Eligibility';
        wrapper.caseObj.AutoDoc__c = AutoDoc;
        wrapper.createCase();            
        PageReference caseDetailsReference = new PageReference('/' + wrapper.CaseObj.Id);
        return caseDetailsReference;
    }
 public PageReference SaveAndClose(){
        wrapper.caseObj.Topic__c ='View Member Eligibility';
        wrapper.caseObj.Status='Closed';
        wrapper.caseObj.AutoDoc__c = AutoDoc;
        wrapper.createCase();            
        PageReference caseDetailsReference = new PageReference('/apex/ACETCallTopicSaveAndClose?caseId=' + wrapper.CaseObj.Id);
        system.debug('wrapper.CaseObj.Id  >>>  '+wrapper.CaseObj.Id);
        return caseDetailsReference;
    }        
}