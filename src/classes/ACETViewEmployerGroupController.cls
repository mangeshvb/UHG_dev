public with sharing class ACETViewEmployerGroupController
{
        
    public ACETCallTopicsDataWrapper wrapper{get;set;}
    public List<producerHistory> ProducerHistoryList{get;set;}    
    @TestVisible private String Subject; 
    public boolean memberEnrollment{get;set;} 
    public ACETGroupDetail groupDetails{get;set;}
    public string groupNumber{get;set;}
    public Integer caseListSize{get;set;}
    public Interaction__c Interaction {get;set;}
    public string OriginatorName{get;set;}
    public List<SelectOption> OriginatorNames{get;set;}
    public string ContactType{get;set;}
    public List<SelectOption> ContactTypes{get;set;}
    public string ContactName{get;set;}
    public boolean displayCName{get;set;} 
    public boolean isProdHistory{get;set;} 
    public boolean isContHistory{get;set;} 
    public String selectedValue;
    public string contName;
    public String SourceOriginator ;
    public contact subjectObj{get;set;}
    public list<Alert__c> lstGroupAlert{get;set;}
    public Integer resultSize{get;set;}
    public boolean isshowGroupALert{get;set;}
    public boolean isGroupALertModal{get;set;}
     
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}
    public list<case> caseHistoryList{get;set;}
    ACETGetEmployerDetailAdapterWebService ACETGetGDWebservice;
    Public List<ACETProducerSearchResult> ProducerSearchResults{get;set;} 
    Public List<ACETProducerSearchResult> producerTypeBRestuls{get;set;}
    Public List<ACETProducerSearchResult> producerTypeIRestuls{get;set;}
    
    public ACETViewEmployerGroupController(){
        caseListSize=0;
        resultSize = 0;
        displayCName = false;
        isProdHistory = false;
        isContHistory = false;
        isshowGroupALert = false;
        wrapper = new ACETCallTopicsDataWrapper();
        
        Subject = apexpages.currentpage().getparameters().get('Subject');
        groupNumber = apexpages.currentpage().getparameters().get('Id');
        contactType = apexpages.currentpage().getparameters().get('contactType');
        SourceOriginator = ApexPages.currentPage().getParameters().get('sourceOriginator');
        OriginatorNames = null;
        memberEnrollment = true;
        groupDetails = new ACETGroupDetail();
        ContactTypes = new list<SelectOption>();
        ContactTypes.add(new SelectOption('----None----','----None----'));  
        initInteraction();
    }
    
    public void producerHistoryWindow(){
    
        isProdHistory = true;
    }
    public void contactHistoryWindow(){
    
        isContHistory = true;
    }
     public void resetWindow(){
    
        isProdHistory = false;
        isContHistory = false;
    
    }
    
    public void updateTPContactName()
    {
        selectedValue =Apexpages.currentPage().getParameters().get('selectedVal');
        if(selectedValue != Null)
        {
           
            OriginatorNames.add(new SelectOption('currentTP',selectedValue));
            OriginatorName = 'currentTP';
            ContactTypes = new list<SelectOption>();
            ContactTypes.add(new SelectOption('----None----','----None----'));
            ContactName = '';
            displayCName = true;
            Interaction.Contact_Name__c = selectedValue;
            if(groupDetails != Null && groupDetails.genGroupInfo != Null)
            {
                string groupName = groupDetails.genGroupInfo.groupId +' - '+groupDetails.genGroupInfo.groupName;
                ACETGroupDetailsWrapper obj = new ACETGroupDetailsWrapper(groupDetails.genGroupInfo.UHCBSCOBRA,groupName,groupDetails.genGroupInfo.groupStatus,groupDetails.genGroupInfo.groupTeamSize,groupDetails.genGroupInfo.effectiveStartDate,groupDetails.genGroupInfo.riskManagement,'',groupDetails.genGroupInfo.groupRenewalDate,AdditionalInfo.RelationshipType,groupDetails.genGroupInfo.groupName);
                if(obj != null)
                {
                    String JSONBody = JSON.serialize(obj);
                    system.debug('JSONBody---->'+JSONBody);
                    Interaction.Highlight_Panel_GroupInfo__c = JSONBody;
                }
            }
            update Interaction;
            
            Interaction = ACETMemberQueryUtil.queryInteraction(Interaction.Id);
        }
    
    }
    
    public void createUpdateContact()
    {
         String contName;
         list<contact> contactRec = new list<Contact>();
         if(ContactName == Null && ContactName == '')
         {
             ContactName =Apexpages.currentPage().getParameters().get('contactName');        
         }        
         if(ContactName != Null && ContactName != '')
         {        
             contName = OriginatorName;
             if(groupDetails != Null && groupDetails.genGroupInfo != Null)
             {
                 contactRec = [select id from Contact where LastName =:contName AND EID__c =: groupDetails.genGroupInfo.groupId];
             }
             if(ContactType == 'Primary Benefits Administrator' )
             {
                 AdditionalInfo.RelationshipType = ContactType;
                 hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
             }
             else if(ContactType == 'Primary Billing Administrator' )
             {
                AdditionalInfo.RelationshipType = ContactType;
                hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
                
             }else if(groupDetails != Null && groupDetails.genGroupInfo != Null && OriginatorName == groupDetails.genGroupInfo.groupName && ContactType != 'Primary Billing Administrator' && ContactType != 'Primary Benefits Administrator' )
             {
                AdditionalInfo.RelationshipType = ContactType;
                hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
                
             }else{
                if(ContactType != '----None----')
                {
                    AdditionalInfo.RelationshipType = ContactType;
                    hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
                }else
                {
                    AdditionalInfo.RelationshipType = '';
                    hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
                } 
                               
             }
    
             if(contactRec.size() == 0 && contName != Null)
             { 
                 Account accountObj = new Account();
                 accountObj.Name = contName;
                    if(groupDetails != Null && groupDetails.genGroupInfo != Null)
                     {
                         accountObj.EID__c = groupDetails.genGroupInfo.groupId;
                     }
                     if(groupDetails != Null && groupDetails.genGroupInfo != Null)
                     {
                         accountObj.Tax_Id__c = groupDetails.genGroupInfo.groupTaxId;
                     }
                                
                 upsert accountObj;
                 
                 
                 Contact contactObj = new Contact();                 
                 contactObj.LastName = contName;
                 contactObj.AccountId = accountObj.id;
                 contactObj.Contact_Type__c = 'Group/Employer';
                    if(groupDetails != Null && groupDetails.genGroupInfo != Null)
                     {
                         contactObj.EID__c = groupDetails.genGroupInfo.groupId;
                     }
                     if(groupDetails != Null && groupDetails.genGroupInfo != Null)
                     {
                         contactObj.Tax_ID__c = groupDetails.genGroupInfo.groupTaxId;
                     }                             
                 
                 upsert contactObj;
                 
                 Interaction.Originator__c = contactObj.id;
                 Interaction.Contact_Name__c = ContactName;
                 interaction.Third_Party__c = Null;
                 string groupName = groupDetails.genGroupInfo.groupId +' - '+groupDetails.genGroupInfo.groupName;
                ACETGroupDetailsWrapper obj = new ACETGroupDetailsWrapper(groupDetails.genGroupInfo.UHCBSCOBRA,groupName,groupDetails.genGroupInfo.groupStatus,groupDetails.genGroupInfo.groupTeamSize,groupDetails.genGroupInfo.effectiveStartDate,groupDetails.genGroupInfo.riskManagement,'',groupDetails.genGroupInfo.groupRenewalDate,AdditionalInfo.RelationshipType,groupDetails.genGroupInfo.groupName);
                if(obj != null)
                {
                    String JSONBody = JSON.serialize(obj);
                    Interaction.Highlight_Panel_GroupInfo__c = JSONBody;
                }
                 update Interaction;
                 Interaction = ACETMemberQueryUtil.queryInteraction(Interaction.Id);
             }else
             {
                 Interaction.Contact_Name__c = ContactName;
                 Interaction.Originator__c = contactRec[0].id;
                 interaction.Third_Party__c = Null;
                 string groupName = groupDetails.genGroupInfo.groupId +' - '+groupDetails.genGroupInfo.groupName;
                  
                ACETGroupDetailsWrapper obj = new ACETGroupDetailsWrapper(groupDetails.genGroupInfo.UHCBSCOBRA,groupName,groupDetails.genGroupInfo.groupStatus,groupDetails.genGroupInfo.groupTeamSize,groupDetails.genGroupInfo.effectiveStartDate,groupDetails.genGroupInfo.riskManagement,'',groupDetails.genGroupInfo.groupRenewalDate,AdditionalInfo.RelationshipType,groupDetails.genGroupInfo.groupName);
                if(obj != null)
                {
                    String JSONBody = JSON.serialize(obj);
                    system.debug('JSONBody---->'+JSONBody);
                    Interaction.Highlight_Panel_GroupInfo__c = JSONBody;
                }
                 update Interaction;
                 Interaction = ACETMemberQueryUtil.queryInteraction(Interaction.Id);
             
             } 
             isshowGroupALert=true;                         
             }
    }
    
    public void createThirdPartySubject()
    {
        list<contact> contactRec = new list<Contact>();
        if(groupDetails != Null && groupDetails.genGroupInfo != Null)
        {
            contactRec = [select id from Contact where LastName =:groupDetails.genGroupInfo.groupName AND EID__c =: groupDetails.genGroupInfo.groupId];
            if(contactRec.size() == 0)
            {    
                Account accountObj = new Account();
                accountObj.Name = groupDetails.genGroupInfo.groupName;
                accountObj.EID__c = groupDetails.genGroupInfo.groupId;
                accountObj.Tax_Id__c = groupDetails.genGroupInfo.groupTaxId;
                upsert accountObj;
                
                subjectObj = new Contact();
                subjectObj.LastName = groupDetails.genGroupInfo.groupName;
                subjectObj.AccountId = accountObj.id;
                subjectObj.Contact_Type__c = 'Group/Employer';
                subjectObj.EID__c = groupDetails.genGroupInfo.groupId;
                subjectObj.Tax_ID__c = groupDetails.genGroupInfo.groupTaxId;
                upsert subjectObj;
                
            }else
            {
                subjectObj = contactRec[0];
                caseHistory();
            }
        }
    }
     
    public void updateProcucertab(){
        try{
                String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
                ContactName = '';
                OriginatorNames= null;
                if(Interaction.Originator_Type__c == 'Producer')
                {
                    OriginatorNames= new List<SelectOption>();
                    OriginatorNames.add(new SelectOption(Interaction.Originator__r.Name,Interaction.Originator__r.Name));
                    OriginatorName = Interaction.Originator__r.Name;
                    ContactTypes = new list<SelectOption>(); 
                    ContactTypes.add(new SelectOption(Interaction.Caller_Type__c,Interaction.Caller_Type__c));
                    displayCName = true;
                    ContactName = '';
                    ContactName = Interaction.Contact_Name__c;
                    displayCName = true;
                
                } 
            }catch(Exception ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETOILNotAvailable ));
            } 
            initInteraction();
        
     }   
    
     private void initHighlightPanelAdditionalInfo(){
        if(AdditionalInfo == null){
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        }
        string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        system.debug('addInfo ----->'+addInfo );
        
        if(addInfo != null && addInfo != '')
        {
            AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
        }else{
        
        }     
        if(groupDetails != Null && groupDetails.genGroupInfo != Null)
        {
        if(AdditionalInfo == null){
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        }
        system.debug('AdditionalInfo ----->'+AdditionalInfo );
        AdditionalInfo.UHCBS = groupDetails.genGroupInfo.UHCBSCOBRA;    
        AdditionalInfo.GroupN = groupDetails.genGroupInfo.groupId +' - '+groupDetails.genGroupInfo.groupName;
        AdditionalInfo.GroupStatus = groupDetails.genGroupInfo.groupStatus;
        AdditionalInfo.ServiceTeam = groupDetails.genGroupInfo.groupTeamSize;
        AdditionalInfo.EffectiveStartDate = groupDetails.genGroupInfo.effectiveStartDate;
        AdditionalInfo.RiskManagement = groupDetails.genGroupInfo.riskManagement;
        AdditionalInfo.RatingMethod = '';
        AdditionalInfo.RenewalDate= groupDetails.genGroupInfo.groupRenewalDate; 
        AdditionalInfo.producerSubject = groupDetails.genGroupInfo.groupName;
        AdditionalInfo.producerOriginator =  Interaction.Originator__r.Name;
        AdditionalInfo.producerId = Interaction.Originator__r.EID__c;    
        }          
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
        
    }
    
    private void initInteraction(){
        String Id = ApexPages.currentPage().getParameters().get('Id');
        String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
        createInteraction();                                    
    }
    
    public void createInteraction(){
        
        Interaction = new Interaction__c();
        
        String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
        if(interactionId != Null)
        {    
            Interaction = ACETMemberQueryUtil.queryInteraction(interactionId);   
        }else
        {
            String SourceOriginator = ApexPages.currentPage().getParameters().get('sourceOriginator');
            if(SourceOriginator != Null)
            {
                Interaction.Interaction_Type__c = SourceOriginator ;
            }else
            {
                Interaction.Interaction_Type__c = 'Phone Call';
            
            }
            Interaction.Originator_Type__c = 'Group/Employer';
        
            Interaction = ACETVCCDUtility.populateVCCDInfo(Interaction);//added by bhanu
            Interaction.Originator_Type__c = 'Group/Employer';          
            insert Interaction; 
            Interaction = ACETMemberQueryUtil.queryInteraction(Interaction.Id);
        }
        
    }
    
    public pageReference navigateToCallTopic()
    {
            return Null;
    }

    public void updateContactNameField()
    {
        if(ContactType == 'Primary Benefits Administrator' )
        {
            for(ACETGroupDetail.groupContactInfo contactInfo:groupDetails.groupExternalContactInfoList)
            {
                 if(contactInfo.primaryContactType == 'Benefit Administrator')
                 {
                     ContactName = contactInfo.firstName+' '+contactInfo.LastName;
                     displayCName = true;
                     Interaction.Originator_Type__c = 'Group/Employer';
                     Interaction.Caller_Type__c = ContactType;
                     createUpdateContact();                
                 }
            }
                       
        }
        else if(ContactType == 'Primary Billing Administrator' )
        {
             for(ACETGroupDetail.groupContactInfo contactInfo:groupDetails.groupExternalContactInfoList)
            {
                 if(contactInfo.primaryContactType == 'Billing Contact')
                 {
                     ContactName = contactInfo.firstName+' '+contactInfo.LastName; 
                     displayCName = true;
                     Interaction.Originator_Type__c = 'Group/Employer';
                     Interaction.Caller_Type__c = ContactType;
                     
                     createUpdateContact();                
                 }
            }
            
        }else if(groupDetails != Null && groupDetails.genGroupInfo != Null && OriginatorName == groupDetails.genGroupInfo.groupName && ContactType != 'Primary Billing Administrator' && ContactType != 'Primary Benefits Administrator' )
        {
            Interaction.Originator_Type__c = 'Group/Employer';
            Interaction.Caller_Type__c = ContactType;
            ContactName = '';
            displayCName = false;
            
        }else{
            ContactName = '';
            displayCName = false;
            
        }
    
    }
    
    public void updateContactType()
    {
        displayCName = false;
        ContactName = '';
        selectedValue =Apexpages.currentPage().getParameters().get('selectedVal');
        if(selectedValue != Null)
        {
            OriginatorName = selectedValue;
        
        }
        if(groupDetails != Null && groupDetails.genGroupInfo != Null && OriginatorName == groupDetails.genGroupInfo.groupName)
        {
            ContactTypes = new list<SelectOption>();
            ContactTypes.add(new SelectOption('----None----','----None----'));  
            ContactTypes.add(new SelectOption('Primary Benefits Administrator','Primary Benefits Administrator'));  
            ContactTypes.add(new SelectOption('Primary Billing Administrator','Primary Billing Administrator')); 
            ContactTypes.add(new SelectOption('President','President'));  
            ContactTypes.add(new SelectOption('Owner','Owner'));  
            ContactTypes.add(new SelectOption('Vice President','Vice President'));  
            ContactTypes.add(new SelectOption('Controller','Controller'));  
            ContactTypes.add(new SelectOption('Assistant Controller','Assistant Controller'));  
            ContactTypes.add(new SelectOption('Chief Executive Officer','Chief Executive Officer'));  
            ContactTypes.add(new SelectOption('Chief Operating Officer','Chief Operating Officer'));  
            ContactTypes.add(new SelectOption('Chief Financial Officer','Chief Financial Officer'));  
            ContactTypes.add(new SelectOption('Member of LLC','Member of LLC'));
            ContactTypes.add(new SelectOption('Unlisted Contact','Unlisted Contact'));
        }else if(OriginatorName == 'thirdPartId')
        {
            ContactTypes = new list<SelectOption>(); 
            ContactTypes.add(new SelectOption('Third Party','Third Party'));
            Interaction.Originator_Type__c = 'Third Party';
            Interaction.Caller_Type__c = '';  
                  
        }else if(OriginatorName == '----None----')
        {
            ContactTypes = new list<SelectOption>();
            ContactTypes.add(new SelectOption('----None----','----None----'));
            displayCName = false;        
        }else
        {
            
           
            ContactTypes = new list<SelectOption>();
            if(AdditionalInfo.RelationshipType == null){
            ContactTypes.add(new SelectOption('Third Party','Third Party'));  }
            else{
            ContactTypes.add(new SelectOption(AdditionalInfo.RelationshipType,AdditionalInfo.RelationshipType));}
            ContactName = OriginatorName;
            displayCName = true; 
            Interaction.Caller_Type__c = 'Third Party';
            Interaction.Originator__c = Null;
            if(groupDetails != Null && groupDetails.genGroupInfo != Null)
            {
                string groupName = groupDetails.genGroupInfo.groupId +' - '+groupDetails.genGroupInfo.groupName;
                ACETGroupDetailsWrapper obj = new ACETGroupDetailsWrapper(groupDetails.genGroupInfo.UHCBSCOBRA,groupName,groupDetails.genGroupInfo.groupStatus,groupDetails.genGroupInfo.groupTeamSize,groupDetails.genGroupInfo.effectiveStartDate,groupDetails.genGroupInfo.riskManagement,'',groupDetails.genGroupInfo.groupRenewalDate,AdditionalInfo.RelationshipType,groupDetails.genGroupInfo.groupName);
                if(obj != null)
                {
                    String JSONBody = JSON.serialize(obj);
                    Interaction.Highlight_Panel_GroupInfo__c = JSONBody;
                }
            }
            update Interaction;
            Interaction = ACETMemberQueryUtil.queryInteraction(Interaction.Id);
        }    
    }
    
     public list<SelectOption> getContactTypes(){
            List<SelectOption> options = new List<SelectOption>();
            return options;      
     } 
     
     public List<SelectOption> getCallTopicOptions(){
        return ACETCallTopicsPicklistUtility.getCallTopicOptions('Group Detail', Interaction.Originator_Type__c);
     }
     
    public List<SelectOption> getOriginatorNames(){
        List<SelectOption> options = new List<SelectOption>();
            if(Interaction.Originator_Type__c == 'Producer')
            {
                Options.add(new SelectOption(Interaction.Originator__r.Name,Interaction.Originator__r.Name));
                ContactTypes = new list<SelectOption>(); 
                ContactTypes.add(new SelectOption('Producer','Producer'));
                ContactName = Interaction.Originator__r.Name;
                system.debug('ContactName 5---->'+ContactName);
                displayCName = true;
            }else
            {
                Options.add(new SelectOption('----None----','----None----'));
                if(groupDetails != Null && groupDetails.genGroupInfo != Null)
                {
                Options.add(new SelectOption(groupDetails.genGroupInfo.groupName,groupDetails.genGroupInfo.groupName));
                }
                Options.add(new SelectOption('thirdPartId','Third Party'));  
            }          
            return options; 
    
    
    }
    
    public class producerHistory
    {
        public string fromDate{get;set;}
        public string through{get;set;}
        public string producerID{get;set;}
        public string producerName{get;set;}
        public string contactName{get;set;}    
        public string PhoneNumber{get;set;}
    }
    
    public void caseHistory(){
        
        String Id = ApexPages.currentPage().getParameters().get('Id');
        caseHistoryList = new List<case>();
        if(subjectObj != null)
        {
            caseHistoryList  = [select CaseNumber, Contact.Name, ContactId, CreatedBy.Name, CreatedDate, Topic__c, Status, Originator_Type__c, Interaction_Type__c, Interaction__c,(SELECT Id FROM Create_Letters__r) from Case where ContactId =: subjectObj.id order by CreatedDate desc limit 500];
            caseListSize = caseHistoryList.size();
        
        }
    }
    
    //Added by Krishna for User story US537355 
    public void getNoOfGroupAlert(){
       ACETInteractionHighlightsPanelController AlertNo = new ACETInteractionHighlightsPanelController();     
           if(groupDetails!=null && groupDetails.genGroupInfo!=null && groupDetails.genGroupInfo.groupId!=null){
             lstGroupAlert= AlertNo.getNoAlert(null,null,groupDetails.genGroupInfo.groupId);
           }
           system.debug('lstGroupAlert is '+lstGroupAlert);
           if(lstGroupAlert != null && lstGroupAlert.size()>0){
               list<Interaction_Alert__c> lstIntAlert = new list<Interaction_Alert__c>();
               for(Alert__c varalert : lstGroupAlert){
                   Interaction_Alert__c intAlert = new Interaction_Alert__c();
                   intAlert.Alert__c = varAlert.id;
                   intAlert.Interaction__c = Interaction.Id;
                   intAlert.Alert_Title_at_Display__c = varAlert.Alert_Title__c;
                   intAlert.Alert_Comments_at_Display__c= varAlert.Alert_Comments__c;
                   intAlert.Intercation_Alert_Unique_Id_del__c = String.valueof(varAlert.id)+String.valueof(Interaction.id)+groupDetails.genGroupInfo.groupId;
                   lstIntAlert.add(intAlert); 
               }
               try{
               upsert lstIntAlert Intercation_Alert_Unique_Id_del__c;
               }
               Catch(DMLException e){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Exception during insertion on Interaction Alert.'));
               }
           }      
    }
    
    public Object CallGroupDetailCWS()
    {
        Continuation PageLoadContinuation;
        ACETGetGDWebservice = new ACETGetEmployerDetailAdapterWebService();
        system.debug('Group number information======>'+groupNumber);
        PageLoadContinuation = ACETGetGDWebservice.StartRequest(groupNumber,'GDWebserviceCallBack',null);
        
        return PageLoadContinuation;
    }
    
    public PageReference GDWebserviceCallBack() {
        ACETWSCalloutResult getGDCalloutResults;
        
        
        getGDCalloutResults = ACETGetGDWebservice.ProcessResponse(ACETGetGDWebservice.RequestLabel);
        system.debug('Entery for getGDCalloutResults call-->'+getGDCalloutResults );
        
        if(getGDCalloutResults.Success) {
            groupDetails = (ACETGroupDetail)getGDCalloutResults.Response;
            
            ACETFindProducerWebservice ACTFPWS = new ACETFindProducerWebservice();
            ACETWSCalloutResult CalloutResult = ACTFPWS.FindProducers('','','', '',groupNumber, '', '', '', '', '',''); 
            system.debug('CalloutResult:: ' + CalloutResult);         
            if (CalloutResult.Success)
            {   
                ProducerSearchResults = new List<ACETProducerSearchResult>();
                ProducerSearchResults = (list<ACETProducerSearchResult>)CalloutResult.Response;
                system.debug('ProducerSearchResults:: ' + ProducerSearchResults);
                producerSerachResultsSplit(ProducerSearchResults);
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(calloutResult.MessageSeverity, calloutResult.Message));    
            }         
            updateOtherInfo();
        }
        
        return null; 
    } 
    
    public void producerSerachResultsSplit(List<ACETProducerSearchResult> producerSearchresults){
        if(producerSearchresults!=null){
         producerTypeBRestuls= new List<ACETProducerSearchResult>();
         producerTypeIRestuls= new List<ACETProducerSearchResult>();
          for(ACETProducerSearchResult rec: producerSearchresults){
              if(rec.producerType == 'B'){
                producerTypeBRestuls.add(rec);
              }
              else if(rec.producerType == 'I'){
                producerTypeIRestuls.add(rec);
              }
          }
        }
    }
    
    private void updateOtherInfo(){
    
        String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
        initInteraction();
        initHighlightPanelAdditionalInfo();
        createThirdPartySubject();
        getNoOfGroupAlert();
        OriginatorNames= new List<SelectOption>();
        if(Interaction.Originator_Type__c == 'Producer')
        {
            OriginatorNames= new List<SelectOption>();
            OriginatorNames.add(new SelectOption(Interaction.Originator__r.Name,Interaction.Originator__r.Name));
            OriginatorName = Interaction.Originator__r.Name;
            ContactTypes = new list<SelectOption>(); 
            ContactTypes.add(new SelectOption(Interaction.Caller_Type__c,Interaction.Caller_Type__c));
            displayCName = true;
            ContactName = '';
            
            string groupName = groupDetails.genGroupInfo.groupId +' - '+groupDetails.genGroupInfo.groupName;
            ACETGroupDetailsWrapper obj = new ACETGroupDetailsWrapper(groupDetails.genGroupInfo.UHCBSCOBRA,groupName,groupDetails.genGroupInfo.groupStatus,groupDetails.genGroupInfo.groupTeamSize,groupDetails.genGroupInfo.effectiveStartDate,groupDetails.genGroupInfo.riskManagement,'',groupDetails.genGroupInfo.groupRenewalDate,AdditionalInfo.RelationshipType,groupDetails.genGroupInfo.groupName);
            if(obj != null)
            {
                String JSONBody = JSON.serialize(obj);
                system.debug('JSONBody---->'+JSONBody);
                Interaction.Highlight_Panel_GroupInfo__c = JSONBody;
            }
            update Interaction;
            ContactName = Interaction.Contact_Name__c;
            
        }else
        { 
            if(groupDetails != Null && groupDetails.genGroupInfo != Null)
            {
                OriginatorNames= new List<SelectOption>();
                OriginatorNames.add(new SelectOption('----None----','----None----'));
            
                OriginatorNames.add(new SelectOption(groupDetails.genGroupInfo.groupName,groupDetails.genGroupInfo.groupName));
                OriginatorNames.add(new SelectOption('thirdPartId','Third Party')); 
                string groupName = groupDetails.genGroupInfo.groupId +' - '+groupDetails.genGroupInfo.groupName;
                ACETGroupDetailsWrapper obj = new ACETGroupDetailsWrapper(groupDetails.genGroupInfo.UHCBSCOBRA,groupName,groupDetails.genGroupInfo.groupStatus,groupDetails.genGroupInfo.groupTeamSize,groupDetails.genGroupInfo.effectiveStartDate,groupDetails.genGroupInfo.riskManagement,'',groupDetails.genGroupInfo.groupRenewalDate,AdditionalInfo.RelationshipType,groupDetails.genGroupInfo.groupName);
                if(obj != null)
                {
                    String JSONBody = JSON.serialize(obj);
                    system.debug('JSONBody---->'+JSONBody);
                    Interaction.Highlight_Panel_GroupInfo__c = JSONBody;
                }
                update Interaction;
            }
        }
        
    } 
     

}