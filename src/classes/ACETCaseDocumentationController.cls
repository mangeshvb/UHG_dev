public with sharing class ACETCaseDocumentationController{
    
    public ACETCallTopicsDataWrapper wrapper {get;set;} 
    public String comments{get;set;} 
    public string redirectUrl {get; set;} 
    public Interaction__c  Interaction { get; set; }    
    public Contact Subject { get; set; }  
    public boolean panelType{get; set;}
    public string surrogateKey {get; set;}
    //Added by Divya to display Subject Name -- US586563 -- 04/11/17
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
     public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}
    
    public ACETCaseDocumentationController(ApexPages.StandardController controller) {
       
        String InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        String memberId = apexpages.currentpage().getparameters().get('memberId');
                
        String callTopic = apexpages.currentpage().getparameters().get('callTopic');
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId); 
        
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = callTopic;
        wrapper.AutodocComment = comments;
        initHighlightPanelAdditionalInfo(); //Added by Divya to display Subject Name -- US586563 -- 04/11/17
        redirectUrl = '/apex/ACETViewEmployerGroup?Originator='+Interaction.Originator__r.Name+'&OriginatorType='+Interaction.Originator_Type__c+'&InteractionId='+InteractionId+'&contactid='+Interaction.Originator__c; 
        panelType = false;
        if(memberId != null)
        {
            panelType = true;
        }
        
        if(panelType == true)
        {
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
            if (!String.isEmpty(surrogateKey))
            { 
                 wrapper.surrogateKey = surrogateKey;
            }
        }  
        
        
    }
    //Added by Divya to display Subject Name on highlight panel -- US586563 -- 04/11/17
    private void initHighlightPanelAdditionalInfo(){
        if(wrapper.AdditionalInfo == null){
            wrapper.AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        }        
        string additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        if(additionalInfoStr != Null && additionalInfoStr != '')
        {
            wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(additionalInfoStr, ACETHighlightsPanelAdditionalInfo.class); 
        }
        if(Interaction != Null && Interaction.Highlight_Panel_GroupInfo__c != null)
        {
            ACETGroupDetailsWrapper deserializedExceptionData = (ACETGroupDetailsWrapper)JSON.deserialize(Interaction.Highlight_Panel_GroupInfo__c, ACETGroupDetailsWrapper.class);
            wrapper.AdditionalInfo.UHCBS = deserializedExceptionData.UHCBS;    
            wrapper.AdditionalInfo.GroupN = deserializedExceptionData.GroupName ;
            wrapper.AdditionalInfo.GroupStatus = deserializedExceptionData.GroupStatus;
            wrapper.AdditionalInfo.ServiceTeam = deserializedExceptionData.ServiceTeam;
            wrapper.AdditionalInfo.EffectiveStartDate = deserializedExceptionData.EffectiveStartDate;
            wrapper.AdditionalInfo.RiskManagement = deserializedExceptionData.RiskManagement;
            wrapper.AdditionalInfo.RatingMethod = '';
            wrapper.AdditionalInfo.RenewalDate= deserializedExceptionData.RenewalDate; 
            wrapper.AdditionalInfo.RelationshipType = deserializedExceptionData.RelationshipType ;
            wrapper.AdditionalInfo.groupSName = deserializedExceptionData.groupSName;
        }
         
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
    }
    public pagereference savecase(){return null;}
}