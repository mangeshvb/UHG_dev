public with sharing class ACETViewBillingController{

    public string swivelBRMS_URL{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public string tableau_URL {get;set;}
    public string comments{get;set;} 
    public Contact Subject { get; set; }
    public Interaction__c  Interaction { get; set; }    
    public string redirectUrl {get; set;} 
    public String[] selectedValue{get;set;}
    public boolean notResearchUser {get;set;}
    public id interactionId{get;set;}
    public id contactid{get;set;}
    public string groupId;
    public ACETGroupDetail groupDetails{get;set;}
    
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}          
    public ACETViewBillingController()
    {   
        string InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        string contactId = apexpages.currentpage().getparameters().get('contactId');
        string callTopic = apexpages.currentpage().getparameters().get('callTopic');
        groupId = apexpages.currentpage().getparameters().get('groupId');
        fetchATNESysURL();
        getloggedinProfileName();
        /*if(InteractionId == '') {
           InteractionId = 'a00210000051gAn'; 
        }*/
        System.debug('Invalid Id:::::'+InteractionId+'ID::::'+apexpages.currentpage().getparameters().get('Id'));
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = callTopic;
        wrapper.AutodocComment = comments;
        if(groupId != Null)
        {
        	wrapper.caseObj.Group_ID__c =groupId;
        }
        initHighlightPanelAdditionalInfo();
        selectedValue = new String[]{};
        fetchBRMSSysURL();
        redirectUrl = '/apex/ACETViewEmployerGroup?Originator='+Interaction.Originator__r.Name+'&OriginatorType='+Interaction.Originator_Type__c+'&InteractionId='+InteractionId+'&contactid='+Interaction.Originator__c; 
     }
    
     private void getloggedinProfileName(){ 
       try{
            notResearchUser = true;
            List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            String loggedinProfileName = PROFILE[0].Name;
        
            //Check if the logged-in User has profile 'Research' type
               if(loggedinProfileName.contains('Research'))
                { 
                    notResearchUser = false;
                }
        }catch(exception ex){
            System.debug('The exception is'+ ex.getmessage());
        }
       
    }  
    /*public List<SelectOption> getBillingCategories()
    {   
        List<SelectOption> options = new List<SelectOption>();
        options.add(new selectOption('Balance / Adjustments', 'Balance / Adjustments'));
        options.add(new selectOption('Direct Debit / ACH', 'Direct Debit / ACH'));
        options.add(new selectOption('Invoice Copy Request', 'Invoice Copy Request'));
        options.add(new selectOption('Pay by Phone', 'Pay by Phone'));
        options.add(new selectOption('Payment Inquiry', 'Payment Inquiry'));
        options.add(new selectOption('Rate Research', 'Rate Research'));
        options.add(new selectOption('Refund Request', 'Refund Request'));
        options.add(new selectOption('Reinstatement Quote', 'Reinstatement Quote'));
        options.add(new selectOption('Soft Calls', 'Soft Calls'));
        options.add(new selectOption('Other', 'Other'));
        return options;
    }*/
    
    //function to fetch BRMS url 
    public void fetchBRMSSysURL(){    
         Map<String, ACETOrgNameToSwivelEndpointMap__c> mapEndpointDetails = ACETOrgNameToSwivelEndpointMap__c.getAll();
         string sandboxName = ACETUtility.GetOrgName();
         swivelBRMS_URL= ACETUtility.GetSwivelEndpointByOrgName(sandboxName,'BRMS',mapEndpointDetails);
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
            System.debug('Group Additional information'+deserializedExceptionData);
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
    
    public void fetchATNESysURL()
    {
         string sandboxName = ACETUtility.GetOrgName();
         tableau_URL = ACETUtility.GetSwivelEndpointByOrgName(sandboxName,'Tableau');
    }
}