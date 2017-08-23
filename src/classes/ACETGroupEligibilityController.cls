public with sharing class ACETGroupEligibilityController {

    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public String swivelcirrusBtn_URL {get; set;}
    public Contact Subject { get; set; } 
    public string groupNumber{get;set;}
    public list<ACETGroupDetail.groupEligibilityInfoTermLag> terminationlist {get; set;}
    public string statuspopup{get;set;}
    public string retirepolicystatus {get; set;}
    public boolean isrerenderd {get; set;}    
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}  
    public Interaction__c Interaction { get; set; }  
    public ACETGroupDetail groupDetails{get;set;} 
    public List<ACETGroupDetail.retireePolicyWrapper> groupEligibilityRetirePolicyResults {get; set;} 
    public List<ACETGroupDetail.DependentCutOff> groupEligibilitydependentResults {get; set;} 
    public List<ACETGroupDetail.groupEligibilityInfoEnrollWaiting> groupEligibilityenrolwaitingResults {get; set;} 
    public List<ACETGroupDetail.groupEligibilityInfoOpenEnroll> groupEligibilityopenenrollmentResults {get; set;} 
    public List<ACETGroupDetail.rehireLag> groupEligibilityrehirelagResults {get; set;}   
    public boolean IsShowRetireePolicyOnly {get; set;}
    public boolean IsShowterminationOnly  {get; set;}  
    public boolean IsshownewwaitgperiodOnly {get; set;}
    public boolean IsshowdependentoffOnly {get; set;}
    public boolean IsshowopenenrollmentOnly {get; set;}
    public boolean IsshowrehirelagOnly {get; set;}
    
    public ACETGroupEligibilityController()
    {
       fetchCIRRUSURL();
       groupNumber = apexpages.currentpage().getparameters().get('groupId');
       system.debug('Group info in eligibility=======>'+groupNumber);
      // groupNumber = '3797692017185927';
       String InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
       //callwebservice();
       if(InteractionId != null && InteractionId != '')
       {
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
       }
        initHighlightPanelAdditionalInfo();
         init();
        
    }
    public void init(){
        //isClaim = true;
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'Group Eligibility';
       // toggleShowPlanBenefits();
    }
    public void callwebservice() {
        toggleShowPlanBenefits();
    }
    public void toggleShowPlanBenefits()
    {
       
                if(IsShowRetireePolicyOnly == null) {
                    IsShowRetireePolicyOnly = true;   
                }
                else{
                    IsShowRetireePolicyOnly = !IsShowRetireePolicyOnly;
                }
       
             if(IsShowterminationOnly == null) {
                    IsShowterminationOnly = true;   
                }
                else{
                    IsShowterminationOnly = !IsShowterminationOnly;
                }
              
              if(IsshowdependentoffOnly == null) {
                    IsshowdependentoffOnly = true;   
                }
                else{
                    IsshowdependentoffOnly = !IsshowdependentoffOnly;
                }
               
               if(IsshownewwaitgperiodOnly == null) {
                    IsshownewwaitgperiodOnly = true;   
                }
                else{
                    IsshownewwaitgperiodOnly = !IsshownewwaitgperiodOnly;
                }
                  
                 if(IsshowopenenrollmentOnly == null) {
                    IsshowopenenrollmentOnly = true;   
                }
                else{
                    IsshowopenenrollmentOnly = !IsshowopenenrollmentOnly;
                }
                 if(IsshowrehirelagOnly == null) {
                    IsshowrehirelagOnly = true;   
                }
                else{
                    IsshowrehirelagOnly = !IsshowrehirelagOnly;
                }
              
        
        try{
            groupDetails = new ACETGroupDetail(); 
            groupEligibilityRetirePolicyResults = new List<ACETGroupDetail.retireePolicyWrapper>();
            terminationlist = new list<ACETGroupDetail.groupEligibilityInfoTermLag>(); 
            groupEligibilitydependentResults = new List<ACETGroupDetail.DependentCutOff>();
            groupEligibilityenrolwaitingResults = new List<ACETGroupDetail.groupEligibilityInfoEnrollWaiting>();
            groupEligibilityopenenrollmentResults = new List<ACETGroupDetail.groupEligibilityInfoOpenEnroll>();
            groupEligibilityrehirelagResults  = new List<ACETGroupDetail.rehireLag>();
            System.debug('Calling the service');
            // ACETGetEmployerGroupDetailWebService stubData = new ACETGetEmployerGroupDetailWebService();
            ACETGetEmployerDetailAdapterWebService stubData = new ACETGetEmployerDetailAdapterWebService();
            ACETWSCalloutResult responseData = stubData.GetEmployerGroupDetail(groupNumber);
            System.debug('ACETCallOutResult responseData ='+responseData);
            if(responseData.Success){    
                groupDetails = (ACETGroupDetail)responseData.response; 
                statuspopup = (groupDetails.genGroupInfo.groupStatus == 'Terminate')?groupDetails.genGroupInfo.terminationDate+' and '+groupDetails.genGroupInfo.terminationReason:(groupDetails.genGroupInfo.groupStatus == 'Hold')?'Go to BRMS for Hold Reason':'';
                retirepolicystatus = ((groupDetails.groupEligibilityRetirePolicy).size() != null)?'Y':'N';
              //  List<ACETGroupDetail.retireePolicyWrapper> retirePolicyWrapList = getretireepolicydata();
               // List<ACETGroupDetail.terminationLag> terminationlaglist = groupDetails.groupEligibilityInfoTermLagList;
                for(ACETGroupDetail.retireePolicyWrapper retireePolicy:groupDetails.groupEligibilityRetirePolicyTest) {
                //for(ACETGroupDetail.retireePolicyWrapper retireePolicy:retirePolicyWrapList ) {
                    if(!IsShowRetireePolicyOnly || retireePolicy.getImage() == 'active') {
                        System.debug('All1******'+retireePolicy);
                        groupEligibilityRetirePolicyResults.add(retireePolicy);
                    }    
                } 
                  system.debug('Terminationlaglist'+groupDetails.groupEligibilityInfoTermLagList);
                  for(ACETGroupDetail.groupEligibilityInfoTermLag terminationlag:groupDetails.groupEligibilityInfoTermLagList) {
                    if(!IsShowterminationOnly || terminationlag.getImage() == 'active') {
                        terminationlist.add(terminationlag);
                    }    
                } 
                 for(ACETGroupDetail.DependentCutOff dependentcutoff:groupDetails.groupEligibilityDependentCutOff) {
                    if(!IsshowdependentoffOnly || dependentcutoff.getImage() == 'active') {
                        groupEligibilitydependentResults.add(dependentcutoff);
                    }    
                } 
                for(ACETGroupDetail.groupEligibilityInfoEnrollWaiting newwaitingperiod:groupDetails.groupEligibilityInfoEnrollWaitingList) {
                    if(!IsshownewwaitgperiodOnly || newwaitingperiod.getImage() == 'active') {
                        groupEligibilityenrolwaitingResults.add(newwaitingperiod);
                    }    
                } 
                
                for(ACETGroupDetail.groupEligibilityInfoOpenEnroll openenrollment:groupDetails.groupEligibilityInfoOpenEnrollList) {
                    if(!IsshowopenenrollmentOnly || openenrollment.getImage() == 'active') {
                        groupEligibilityopenenrollmentResults.add(openenrollment);
                        system.debug('status enrollment==>'+IsshowopenenrollmentOnly+'list size==>'+groupEligibilityopenenrollmentResults);
                    }    
                } 
                
                 for(ACETGroupDetail.rehireLag rehirelag:groupDetails.groupEligibilityRehireLag) {
                    if(!IsshowrehirelagOnly || rehirelag.getImage() == 'active') {
                        groupEligibilityrehirelagResults.add(rehirelag);                       
                    }    
                } 
                   
            }
            else{ 
                ApexPages.addMessage(new ApexPages.Message(responseData.MessageSeverity, responseData.Message));  
            } 
        }   
        catch(Exception ex)
        { 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETOILNotAvailable )); 
             System.debug(ex.getStackTraceString());
        }
    }
    /*public void toggleShowPlanBenefits() 
    {
      terminationlist = new list<ACETGroupDetail.groupEligibilityInfoTermLag>(); 
       if(IsShowterminationOnly == null) {
            IsShowterminationOnly = true;
           // terminationlist = (groupDetails.groupEligibilityInfoTermLagList).clone();
            system.debug('termination list'+terminationlist); 
            for(ACETGroupDetail.groupEligibilityInfoTermLag term : groupDetails.groupEligibilityInfoTermLagList)
            { 
               if(date.valueOf(term.startDate) >= date.today() && date.valueOf(term.endDate) == null){
                   terminationlist.add(term);
               }
            }
        } 
        else{
           for(ACETGroupDetail.groupEligibilityInfoTermLag term : groupDetails.groupEligibilityInfoTermLagList)
            {             
               terminationlist.add(term);             
            }
        }
    }
    
    public void callwebservice()
    {
         if(IsShowRetireePolicyOnly == null) {
            IsShowRetireePolicyOnly = true;   
        }
        else{
            IsShowRetireePolicyOnly = !IsShowRetireePolicyOnly;
        }
        try{
        groupDetails = new ACETGroupDetail(); 
        groupEligibilityRetirePolicyResults = new List<ACETGroupDetail.retireePolicyWrapper>(); 
        System.debug('Calling the service');
       // ACETGetEmployerGroupDetailWebService stubData = new ACETGetEmployerGroupDetailWebService();
       ACETGetEmployerDetailAdapterWebService stubData = new ACETGetEmployerDetailAdapterWebService();
        ACETWSCalloutResult responseData = stubData.GetEmployerGroupDetail(groupNumber);
        System.debug('ACETCallOutResult responseData ='+responseData);
         if(responseData.Success){    
            groupDetails = (ACETGroupDetail)responseData.response; 
            statuspopup = (groupDetails.genGroupInfo.groupStatus == 'Active')?groupDetails.genGroupInfo.terminationDate+' and '+groupDetails.genGroupInfo.terminationReason:(groupDetails.genGroupInfo.groupStatus == 'Hold')?'Go to BRMS for Hold reason':'';
            retirepolicystatus = ((groupDetails.groupEligibilityRetirePolicy).size() != null)?'Y':'N';
            for(ACETGroupDetail.retireePolicyWrapper retireePolicy:groupDetails.groupEligibilityRetirePolicyTest) {
                if(!IsShowRetireePolicyOnly || retireePolicy.getImage() == 'active') {
                    System.debug('All1******'+retireePolicy);
                    groupEligibilityRetirePolicyResults.add(retireePolicy);
                }    
            }
           // toggleShowPlanBenefits();
            //start
              
            
              
            //end
            
         
          //  System.debug('callout result for Groupdetails'+groupDetails.groupEligInfo);            
            }
            else{ 
                ApexPages.addMessage(new ApexPages.Message(responseData.MessageSeverity, responseData.Message));  
            } 
         }   
         catch(Exception ex)
         { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETOILNotAvailable )); }
    }*/
    
     private void initHighlightPanelAdditionalInfo(){
        if(AdditionalInfo == null){
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        } 
        string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if(addInfo != null)
        {
            AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
        if(Interaction != Null && Interaction.Highlight_Panel_GroupInfo__c != null)
        {
            ACETGroupDetailsWrapper deserializedExceptionData = (ACETGroupDetailsWrapper)JSON.deserialize(Interaction.Highlight_Panel_GroupInfo__c, ACETGroupDetailsWrapper.class);
            AdditionalInfo.UHCBS = deserializedExceptionData.UHCBS;    
            AdditionalInfo.GroupN = deserializedExceptionData.GroupName ;
            AdditionalInfo.GroupStatus = deserializedExceptionData.GroupStatus;
            AdditionalInfo.ServiceTeam = deserializedExceptionData.ServiceTeam;
            AdditionalInfo.EffectiveStartDate = deserializedExceptionData.EffectiveStartDate;
            AdditionalInfo.RiskManagement = deserializedExceptionData.RiskManagement;
            AdditionalInfo.RatingMethod = '';
            AdditionalInfo.RenewalDate= deserializedExceptionData.RenewalDate; 
            AdditionalInfo.RelationshipType = deserializedExceptionData.RelationshipType ;
            AdditionalInfo.groupSName = deserializedExceptionData.groupSName;
        }
           
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
    }
      
    public void fetchCIRRUSURL()
    {
         string sandboxName = ACETUtility.GetOrgName();
         swivelcirrusBtn_URL = ACETUtility.GetSwivelEndpointByOrgName(sandboxName,'CIRRUS');
    }  
}