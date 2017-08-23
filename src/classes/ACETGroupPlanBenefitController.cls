public with sharing class ACETGroupPlanBenefitController {
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public string comments{get;set;} 
    public string InteractionId {get;set;}
    public boolean IsShowActiveCoveragesOnly {get;set;}
    public String callTopic {get; set;}
    public Contact Subject { get; set; }
    public boolean notResearchUser {get;set;}
    public Interaction__c  Interaction { get; set; }
    public Boolean IsShowActiveBenefitsOnly {get;set;}
    public string groupNumber{get;set;}  
    public ACETGroupDetail groupDetails{get;set;}  
    public static ACETGroupDetail groupPlanDetails{get;set;}
    public static List<ACETGroupDetail.GroupPlanWrapper> GroupPlanSearchResults {get; set;}
    //public List<ACETGroupDetail.GroupPlanWrapper> GroupPlanBenefitList {get; set;}
    public List<ACETGroupDetail.GroupPlanWrapper> GroupPlanBenefitResultsList {get; set;}
    
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;} 
    
    public ACETGroupPlanBenefitController() {
        groupNumber = apexpages.currentpage().getparameters().get('groupId');
        System.debug('Grou Pd'+groupNumber);
        InteractionId = apexpages.currentpage().getparameters().get('interactionId');
        callTopic = apexpages.currentpage().getparameters().get('callTopic');
        if(InteractionId != null && InteractionId != '')
            Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = callTopic;
        wrapper.AutodocComment = comments;
        initHighlightPanelAdditionalInfo();
        
    }
    
    public void init() {
        toggleShowPlanBenefits();
    }
    
    public static ACETWSCalloutResult callwebservice(string groupId)
    {
        ACETGetEmployerDetailAdapterWebService stubData = new ACETGetEmployerDetailAdapterWebService();
        ACETWSCalloutResult responseData = stubData.getEmployerGroupDetail(groupId);
        System.debug('Allowing.................'+responseData);
        return responseData;
    }
    
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
            System.debug('Entering NUll Check'+AdditionalInfo);
            if(AdditionalInfo != null) {
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
              
        }  
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
    }
    
    public void toggleShowPlanBenefits() {
        if(IsShowActiveBenefitsOnly == null) {
            IsShowActiveBenefitsOnly = true;   
        }
        else{
            IsShowActiveBenefitsOnly = !IsShowActiveBenefitsOnly;
        }
        System.debug('All******'+GroupPlanSearchResults);
        groupPlanDetails = new ACETGroupDetail(); 
        GroupPlanBenefitResultsList = new List<ACETGroupDetail.GroupPlanWrapper>();
        try {
            ACETWSCalloutResult responseGroupPlanData = callwebservice(groupNumber);
            System.debug('Response1...'+responseGroupPlanData);
            if(responseGroupPlanData.Success) {
                GroupPlanSearchResults = new List<ACETGroupDetail.GroupPlanWrapper>();
                groupPlanDetails = (ACETGroupDetail)responseGroupPlanData.response;
                System.debug('Response2...'+groupPlanDetails);
                GroupPlanSearchResults = groupPlanDetails.GroupPlanBenefitList;
                System.debug('callout result for Groupdetails'+GroupPlanSearchResults);  
                if(GroupPlanSearchResults != null) {
                    for(ACETGroupDetail.GroupPlanWrapper groupPlan:GroupPlanSearchResults) {
                        if(!IsShowActiveBenefitsOnly || groupPlan.getImage() == 'active') {
                            System.debug('All1******'+groupPlan);
                            GroupPlanBenefitResultsList.add(groupPlan);
                        }
                    }
                }          
            }
            else{ 
                ApexPages.addMessage(new ApexPages.Message(responseGroupPlanData.MessageSeverity, responseGroupPlanData.Message));  
            }
        }  
        catch(Exception ex)
        { 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETOILNotAvailable )); 
        }
        
    }
}