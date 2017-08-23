public with sharing class ACETViewCommissionController
{
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get; set;}
    public ACETCallTopicsDataWrapper wrapper {get; set;}    
    public String swivelBASICS_URL{get; set;}
    public Interaction__c Interaction { get; set; }    
     public ACETViewCommissionController(){  
        fetchBASICSsysURL(); 
        wrapper = new ACETCallTopicsDataWrapper(); 
        String InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        string callTopic = apexpages.currentpage().getparameters().get('callTopic');
        wrapper.caseObj.Topic__c = callTopic;
        if(InteractionId != null && InteractionId != ''){
           Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        }
        initHighlightPanelAdditionalInfo();              
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
    }     
     
    public void fetchBASICSsysURL()
    {
        string sandboxName = ACETUtility.GetOrgName();
        swivelBASICS_URL = ACETUtility.GetSwivelEndpointByOrgName(sandboxName, 'BASICS');
    }  
}