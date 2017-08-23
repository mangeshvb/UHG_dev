public with sharing class ACETProducerDetailController
{
    public ACETProducerResult producerDetailresult { get; set;} 
    public id contactid{ get; set;}
    public String interactionId{ get; set;}
     public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}
    public String Id { get; set;}
    public Interaction__c Interaction { get; set;}
    public Contact Subject { get; set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo { get; set;}
    public list<Alert__c> lstMemAlert{ get; set;}
    public list<Alert__c> lstProducerAlert{ get; set;}//added by Harish for Alert
    public String SourceOriginator { get; set;}
    public ACETCallTopicsDataWrapper wrapper { get; set;}   
    public String producerId { get; set; }   
    public List<SelectOption> contactTypeOptions { get; set;}
    public String contactType { get; set;}
    public String originatorName { get; set;}
    public String contactName { get; set;}
    public boolean isShowALert{get;set;}
    //continuation web call
    ACETGetProducerAdapterWebservice ACETPDWS;
    
    public ACETProducerDetailController(){
        producerId = ApexPages.currentPage().getParameters().get('ProducerId');
        Id = ApexPages.currentPage().getParameters().get('Id');
        interactionId = ApexPages.currentPage().getParameters().get('InteractionId'); 
        system.debug('InteractionId: ' + InteractionId); 
        contactId  = null;
        system.debug('contactId: ' + contactId); 
        contactTypeOptions = new List<SelectOption>();
        contactTypeOptions.add(new SelectOption('Broker', 'Broker'));
        contactTypeOptions.add(new SelectOption('General Agent' , 'General Agent'));        
        List<Interaction__c> InteractionList = [SELECT id, name,Originator__c,Interaction_Type__c,Originator_Type__c,Contact_Name__c,
                                Originator__r.Name  from Interaction__c where id =: interactionId];
        if(InteractionList.size() > 0){
            Interaction = InteractionList[0];
        } 
        try{
            Interaction = ACETMemberQueryUtil.queryInteraction(Interaction.Id);
            Subject = ACETMemberQueryUtil.queryContact(Interaction.Originator__c);
        }catch(Exception e){} 
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.producerSubject = Interaction.Originator__r.Name;
        AdditionalInfo.producerOriginator =  Interaction.Originator__r.Name;
        AdditionalInfo.producerId = Interaction.Originator__r.EID__c;
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo); 
        lstProducerAlert = new list<Alert__c>();
        
    }
    public void updateContact()
    {
        isShowALert = true;
        if(Interaction.Contact_Name__c != contactName)
        {
            Interaction.Contact_Name__c = contactName;
            if(contactType == 'Broker')
            {
                Interaction.Caller_Type__c = 'Broker';
            }else
            {
                Interaction.Caller_Type__c = 'General Agent';
            }
            update Interaction;
            
            AdditionalInfo.producerName = contactName + ' - '+Interaction.Caller_Type__c;
            hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
        }
    
    }
        public void getNumberOfProducerAlert(){
            ACETInteractionHighlightsPanelController alertNumber = new ACETInteractionHighlightsPanelController();
             System.debug('list of interaction'+interaction);
            if(interaction != null){
                lstProducerAlert = alertNumber.getNoAlert('Producer',interaction.Originator__r.EID__c,interaction.Originator__r.Tax_ID__c);
                System.debug('list of producer Alert'+lstProducerAlert);
                if(!lstProducerAlert.IsEmpty()){
                    list<Interaction_Alert__c> lstIntAlert = new list<Interaction_Alert__c>();
                    for(Alert__c varalert : lstProducerAlert){
                        Interaction_Alert__c intAlert = new Interaction_Alert__c();
                        intAlert.Alert__c = varAlert.id;
                        intAlert.Interaction__c = interaction.id;
                        intAlert.ID_Number__c = interaction.Originator__r.EID__c;// added by vishakha 11/30 for US442332
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
  
    
    public void updateInteraction(){
        if(Interaction != null){
            Interaction.Contact_Name__c = contactName;
            Interaction.Caller_Type__c = contactType;            
            update Interaction;
        }
    }    
   
         
    public List<Case> getCaseHistory(){
        String Id = ApexPages.currentPage().getParameters().get('Id');
        List<Case> cases = [select CaseNumber, Contact.Name, ContactId, CreatedBy.Name, CreatedDate, Topic__c, Status, Originator_Type__c, Interaction_Type__c, Interaction__c,Rollup_Fulfillment__c,(SELECT Id, Name FROM Create_Letters__r) from Case where ContactId =: Subject.id order by CreatedDate desc limit 500];
        return cases;
    }
    
    public Object CallGetProducerWS1(){
    system.debug('Entery for callGetproducerWS call');
        Continuation PageLoadContinuation;                
        ACETPDWS = new ACETGetProducerAdapterWebservice();
        PageLoadContinuation = ACETPDWS.StartRequest(producerId,'PDWebserviceCallBack',null);
         System.debug('Entery PageLoadContinuation'+PageLoadContinuation);
        return PageLoadContinuation;
    }
    
    public PageReference PDWebserviceCallBack(){
        ACETWSCalloutResult GetProducerResponse;
        isShowALert = true;
        system.debug('Entery for PDWebserviceCallBack call');
        GetProducerResponse = ACETPDWS.ProcessResponse(ACETPDWS.RequestLabel);
         system.debug('Entery for GetProducerResponse call'+GetProducerResponse);
        if(GetProducerResponse.Success){
            try{
               producerDetailresult = (ACETProducerResult)GetProducerResponse.Response;
               getNumberOfProducerAlert();
            }catch(Exception ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.ACETUnexpectedErrorMessage));
            }
        }
        return null; 
    } 
    
    public List<SelectOption> getCallTopicOptions()
    {
        List<SelectOption> callTopics = new List<SelectOption>();
        callTopics = ACETCallTopicsPicklistUtility.getCallTopicOptions('Producer Detail', Interaction.Originator_Type__c);
        return callTopics;
    }

}