/* Developed by : Nayana Revanna
   Purpose      : Binds data with the ServiceRenewal VF page. 
                  Creates a new Case. Cancel the Service Renewal page.*/
                  
public with Sharing class ACETServiceRenewalController
{
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public Boolean bServiceRenewal{get;set;}
    public String comments{get;set;}
    public Interaction__c Interaction { get; set; } 
    public Contact Subject { get; set; }    
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}  
    public list<Alert__c> lstGroupAlert{get;set;}
    
    public ACETServiceRenewalController()
    {
        bServiceRenewal = ApexPages.currentPage().getParameters().get('callTopic') == 'Renewals' ? true : false;
        wrapper = new ACETCallTopicsDataWrapper();   
        //wrapper.CallTopic = bServiceRenewal==true ? 'Renewals' : 'New Business';
        wrapper.caseObj.Topic__c = bServiceRenewal==true ? 'Renewals' : 'New Business';
        String InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        if(InteractionId != null && InteractionId != '')
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        initHighlightPanelAdditionalInfo();
        ACETInteractionHighlightsPanelController AlertNo = new ACETInteractionHighlightsPanelController();   
        
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
        /******added by sourabh ****/
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
     public List<SelectOption> getServiceRenewalCallTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Assisted with IDEA portal navigation','Assisted with IDEA portal navigation'));
        options.add(new SelectOption('Discussed renewal plan options','Discussed renewal plan options'));
        options.add(new SelectOption('Generated new quotes','Generated new quotes'));
        options.add(new SelectOption('Not available for online renewal (NAFOR)','Not available for online renewal (NAFOR)'));   
        options.add(new SelectOption('Renewed as is','Renewed as is'));
        options.add(new SelectOption('Renewed with chagnes','Renewed with changes'));      
        options.add(new SelectOption('Sent quotes','Sent quotes'));        
        options.add(new SelectOption('Sent Summary of Benefits and Coverage (SBC)','Sent Summary of Benefits and Coverage (SBC)'));             
        options.add(new SelectOption('Other','Other'));
        return options;
    }
    
    public List<SelectOption> getCreateProposalCallTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Assisted with IDEA portal navigation','Assisted with IDEA portal navigation'));
        options.add(new SelectOption('Created new business proposals','Created new business proposals'));
        options.add(new SelectOption('Discussed new business proposals','Discussed new business proposals'));
        options.add(new SelectOption('Sent business lead to Sales','Sent business lead to Sales')); 
        options.add(new SelectOption('Sent new business proposals','Sent new business proposals'));               
        options.add(new SelectOption('Other','Other'));
        return options;
    }
    
  
}