public with sharing class ACETCallTopicsDataWrapper {
    public Interaction__c Interaction {get;set;}
    public Contact Subject {get;set;}
    public Contact Provider {get;set;}
    public Contact Originator {get;set;}
    public String SourceOriginator {get;set;} 
    public String SurrogateKey {get;set;}  
    public String Autodoc {get;set;}
    public String AutodocComment {get;set;}
    public String AutodocCaseItems {get;set;}    
    public String CallTopic {get;set;}
    public String CallTopicType {get;set;}
    public String CallTopicSubType {get;set;}
            
    public String EBcomments { get; set; }
    Public Boolean updategroupinfoSave{get; set;}//added by harish 02/13 US502373
    public string SubjectType{get;set;}
    public string topicType {get; set;}
    public String blockedCallTopic {get;set;}//added by Vishakha 12/02 US413581
    public String subjectId {get;set;}    
     
    public String CaseRecordTypeLabel { get; set; }    //Label for case record type
    public Boolean SkipCaseClosePage  { get; set; }
    public Case CaseObj {get;set;}
    public String Comments {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;} 
              
    public Boolean isSystemUnavailable {get;set;}   
    public String CancelReason{ get; set; } 
    public String MisdirectedReason {get;set;}
    public boolean saveActionFlag;
    
    //Added by Rupsa 12/02
    public string memberInfo {get;set;}
    public string routeTo{get;set;} 
    //public String EID__c{get;set;}
    
    public String[] Topic {get;set;}            
    public String[] AccountType{ get; set; } 
    
     //Added for the poc
    public List<String> selectedCallType {get; set;}
    public List<String> selectedAccountType {get; set;}
    //public List<CallTypeWrapper> callTypeWrapList {get; set;} 
    //public List<CallTypeWrapper> accountTypeWrapList {get; set;}
    public boolean isPOC;
    public List<String> passValuetoURL {get; set;}
    public String resultJsonMap {get; set;}
    public Set<passValuesWrapper> finalStr {get; set;}
    public List<Case> insertedCaseItemRecList {get; set;}
    public List<case> successCases {get; set;}
    public Map<String,String> caseItemListMap {get; set;}
    public List<Call_Topic__c> callsTopic {get; set;}
    public String callTopicSytr {get; set;}
    //public List<callSubTypeWrapper> callSubTypeWrapList {get; set;}
    //public Map<String,List<callSubTypeWrapper>> callSubTypeWrapperMap {get; set;}
    public Map<String,String> callSubRecordTypeMapping {get; set;}
   
  
   
    public ACETCallTopicsDataWrapper(){

        CaseObj = new Case();
        
        //Added for the poc
        insertedCaseItemRecList = new List<Case>(); 
        
        Comments = '';
        topicType = '';
        
        init();
    }
    
    public void init(){
        saveActionFlag = true;
        AccountType = new String[]{};
        Topic  = new String[]{};
        
        isSystemUnavailable = false;
        SkipCaseClosePage  = false;
        
        //Added for Poc
        selectedCallType = new List<String>();
        selectedAccountType = new List<String>();
     
        
        //CaseObj = new Case();
        //getCallSubType();
        system.debug(LoggingLevel.INFO, 'Init. CaseRecordTypeLabel: ' + CaseRecordTypeLabel);
        //init interaction
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId'); 
        system.debug('interactionId  >>> '+interactionId );
        if(!String.isEmpty(interactionId)){                        
            system.debug('InteractionId: ' + InteractionId);            
            //Query Provider Interaction details
            Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            //setup source originator
            SourceOriginator = Interaction.Interaction_Type__c;
            system.debug('Interaction: ' + Interaction + ', SourceOriginator: ' + SourceOriginator);
        }else{
            //interactionId = ApexPages.currentPage().getParameters().get('id'); 
            interactionId = ApexPages.currentPage().getParameters().get('interactionId');
            system.debug('InteractionId: ' + InteractionId);
            if(!String.isEmpty(interactionId)){
             system.debug('InteractionId: ' + InteractionId);
            Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            //setup source originator
            SourceOriginator = Interaction.Interaction_Type__c;             
                
            } else{
                Interaction = new Interaction__c();                
            }         
                                                                  
        }        
        //CaseObj.interaction__c = Interaction.Id;
        //init source originator
        SourceOriginator = ApexPages.currentPage().getParameters().get('sourceOriginator'); 
        if(!String.isEmpty(SourceOriginator)  && SourceOriginator != 'undefined') Interaction.Interaction_Type__c = SourceOriginator; 
        
        //init provider
        //todo: change id to providerId
        //String providerId = ApexPages.currentPage().getParameters().get('id');
        //if(!String.isEmpty(providerId)){
            //Provider = [select FirstName, LastName, Tax_ID__c, NPI__c from Contact where Id = :providerId];
        //}
        
        //init subject
        subjectId = Apexpages.currentPage().getParameters().get('contactId');
        if(!String.isEmpty(subjectId)){
            Subject = ACETProviderUtility.GetContactByID(subjectId); 
        }
        System.debug('Prakash::::Subject::::'+Subject);
        //init originator
        if(this.Interaction.Originator__c!=null)    
        this.Originator = ACETProviderUtility.GetContactByID(this.Interaction.Originator__c);
        
        //Autodoc = ApexPages.currentPage().getParameters().get('autodoc');
        CallTopic = ApexPages.currentPage().getParameters().get('callTopic');
        
        String strAdditionalInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if(!String.isEmpty(strAdditionalInfo)){
            AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(strAdditionalInfo,ACETHighlightsPanelAdditionalInfo.class);        
        }
        System.debug('AdditionalInfo^^^^^^^^^'+AdditionalInfo);
        System.debug('Misdirected Reason########'+MisdirectedReason); //added for Group Misdirect testing
        if(MisdirectedReason != ''){
            CaseObj.Misdirected_Reason__c = MisdirectedReason;
        }
        
        //Added for POC 
        //callSubTypeWrapperMap = getCallSubType();
        //callTypeList =  getCallTypesW();  
    }   
    
    public String getCallTopicDataWrapperStr(){
        return JSON.serialize(this);
    }
    
    //get limited type and subtype based on profile and role, so these values will be filtered out on modal window    
    public String getTTSFilterStr(){
        return ACETCallTopicsPicklistUtility.getTTSFilter(CaseObj.Topic__c);
    }
    
    
    //todo: to remove it, changed name to saveCase()
    public PageReference createCase(){
    system.debug('AdditionalInfo---->'+AdditionalInfo);
        if (String.isNotBlank(CaseRecordTypeLabel)) {
            CaseObj.RecordTypeId = ACETUtility.getRecordTypeID('Case', CaseRecordTypeLabel);
            system.debug(LoggingLevel.INFO, 'RecordTypeId: ' + CaseObj.RecordTypeId);
        }
        
        if(Interaction.Id == null) insert Interaction;
        CaseObj.Interaction__c = Interaction.Id;        
        if(SubjectType != Null && SubjectType != '')
        {
            CaseObj.Subject_Type__c = SubjectType;        
        }    
        if(Subject != null){
            CaseObj.ContactId = this.Subject.Id;            
        }        
        if(AdditionalInfo != null){
            CaseObj.Originator_Relationship__c = AdditionalInfo.OriginatorRelationship;           
        }
        if(!String.isEmpty(Interaction.Third_Party__c)){
            List<Third_Party_Originator__c> tpOriginatorList = [select id,name from Third_Party_Originator__c where third_party__c =:Interaction.Third_Party__c and Subject__c =:Interaction.Originator__c limit 1];
            CaseObj.Originator_Relationship__c = tpOriginatorList[0].name;
        }
        if(SourceOriginator != null){
            this.CaseObj.Origin = SourceOriginator;
        }        
        if(!String.isEmpty(Comments)){
            CaseObj.Comments__c = Comments;    
        }
        if(CaseObj.Topic__c == null && !String.isEmpty(callTopic)){
            //CaseObj.Topic__c = callTopic;
        }        
        
        system.debug('isSystemUnavailable'+isSystemUnavailable);
        if(isSystemUnavailable){
            this.CaseObj.Status = 'Closed';
            this.CaseObj.New_Closed_Reason__c = 'System Unavailable';
        }  
        
        if(!String.isEmpty(MisdirectedReason)){
            CaseObj.Status = 'Cancelled';
            CaseObj.Misdirected_Reason__c = MisdirectedReason;
        }
        
        if(!String.isEmpty(CancelReason)){
            CaseObj.Status = 'Cancelled';
            CaseObj.Cancel_Reason__c = CancelReason;
        }
                
        if(!String.isEmpty(Autodoc)){
            CaseObj.Autodoc__c = Autodoc;
        }
        if(saveActionFlag){
            CaseObj.isComplete__c = true;
        }            
         
        upsert CaseObj;        
        return new PageReference('/' + CaseObj.Id);
    }
    
  
    public PageReference saveCase() { 
        String strAdditionalInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        //if(callTopic != 'View Billing'){
            //system.debug('inside If Vlaues**********'+callTypeWrapList);
            string commentSting = '';
            system.debug('AdditionalInfo---->'+AdditionalInfo);
            if(Subject != null){
            contact contactObj = [Select id,contact_type__c from contact where id = :this.Subject.Id];
            system.debug('ocase ---->'+contactObj );
                if(contactObj != null && contactObj.contact_type__c!=null){
                 SubjectType = contactObj.contact_type__c;
                }  
            }
                                    
         //   system.debug('before save >>>>> ' + autodoc);
            system.debug(LoggingLevel.INFO, 'CaseRecordTypeLabel: ' + CaseRecordTypeLabel);
            if (String.isNotBlank(CaseRecordTypeLabel)) {
                //CaseObj.RecordTypeId = ACETUtility.getRecordTypeID('Case', CaseRecordTypeLabel);
                //system.debug(LoggingLevel.INFO, 'RecordTypeId: ' + CaseObj.RecordTypeId);
            }
            
            if(Interaction.Id == null) insert Interaction;        
            CaseObj.Interaction__c = Interaction.Id;        
            if(Subject != null){
                CaseObj.ContactId = this.Subject.Id;            
            }
            if(SubjectType != Null && SubjectType != '')
            {
            CaseObj.Subject_Type__c = SubjectType;
            
            }
            if(AdditionalInfo != null){
                // Dev @Ramadevi
                // @Purpose: Check the flow - If member search is from Provider or Provider Not Found
                //           the relationship field should be blank
                CaseObj.Originator_Relationship__c = (Interaction.Originator_Type__c == 'Provider' || Interaction.Originator_Type__c == 'Other') ? '' : AdditionalInfo.OriginatorRelationship;
               
            }
            if(!String.isEmpty(Interaction.Third_Party__c) && !String.isEmpty(Interaction.Originator__c)){
                List<Third_Party_Originator__c> tpOriginatorList = [select id,name from Third_Party_Originator__c where third_party__c =:Interaction.Third_Party__c and Subject__c =:Interaction.Originator__c limit 1];
                CaseObj.Originator_Relationship__c = tpOriginatorList[0].name;
            }        
            system.debug('SourceOriginator >>> '+SourceOriginator);       
            system.debug('Interaction >>> '+JSON.serialize(Interaction));
            if(SourceOriginator != null){
                this.CaseObj.Origin = SourceOriginator;
            }
            if(Interaction.Interaction_Type__c != null){
                this.CaseObj.Origin = Interaction.Interaction_Type__c;
            }
            //todo: remove the code, comment is saved under case comment        
            //if(!String.isEmpty(Comments)){
                //CaseObj.Comments__c = Comments;    
            //}
             system.debug('@@ callTopic '+callTopic);
              system.debug('CaseObj.Topic__c '+CaseObj.Topic__c);
            if(String.isEmpty(CaseObj.Topic__c) && !String.isEmpty(callTopic)){
                system.debug('@@ callTopic '+callTopic);
                CaseObj.Topic__c = callTopic;
            }
            
            
            system.debug(CallTopicType);
            //standard subtype input field has a strange option value starting with __ upon option [--none--] when there is no other options
            if(!String.isEmpty(CallTopicType) && !CallTopicType.startsWith('_')){
                CaseObj.Type__c = CallTopicType;                
                if(!String.isEmpty(CallTopicSubType) && !CallTopicSubType.startsWith('_')){
                    Caseobj.SubType__c = CallTopicSubType;
                }
            }                    
            
            //Added by Rupsa - Populate Member Info field on case when system is unavailable for Enrollment, Termination, Reinstatement
            if(String.isNotEmpty(memberInfo) && String.isNotBlank(memberInfo)) 
                CaseObj.Member_Info__c = memberInfo;
            /* //route_To__c - US615311
            if(String.isNotEmpty(memberInfo) && String.isNotBlank(memberInfo)) 
                CaseObj.route_To__c = routeTo;*/
            
            system.debug('isSystemUnavailable'+isSystemUnavailable);
            if(isSystemUnavailable){
                   if(updategroupinfoSave != null && updategroupinfoSave == true)// excutes only when Updategroupinformation calltopic is clicked on save if system unavailable is selected
                   {
                    this.CaseObj.Status = 'Open';
                   }
                   else{
                    this.CaseObj.Status = 'Closed';
                    this.CaseObj.New_Closed_Reason__c = label.ACETSystemUnavailable;
                    }
            }  
            
            if(!String.isEmpty(MisdirectedReason)){
                CaseObj.Status = 'Cancelled';
                CaseObj.Misdirected_Reason__c = MisdirectedReason;
            }
            
            if(!String.isEmpty(CancelReason)){
                CaseObj.Status = 'Cancelled';
                CaseObj.Cancel_Reason__c = CancelReason;
            }
                    
            if(!String.isEmpty(Autodoc)){
                CaseObj.Autodoc__c = Autodoc;
            }
            
            if(saveActionFlag){
                CaseObj.isComplete__c = true;
            }

            if(!String.isEmpty(SurrogateKey)){
                CaseObj.Surrogate_Key__c = SurrogateKey;
            } 
           
            system.debug(CaseObj.isComplete__c);
            //system.debug('Comments before upsert in savecase'+Comments); 
            //system.debug(LoggingLevel.INFO, 'CaseObj JSON: ' + JSON.serialize(CaseObj));
            
            //copy type and subtype to original_type and original_subtype, it will be used in report, type and subtype may be changed later.
            CaseObj.Original_Type__c = CaseObj.Type__c;
            CaseObj.Original_Subtype__c = CaseObj.Subtype__c;
            
            upsert CaseObj; 
            
            //add audodoc comment into case comment
            addCaseComment(caseObj.Id, AutodocComment);
            
            //add comment from call topic page
            addCaseComment(caseObj.Id, Comments);
            System.debug('Case Obj>>>>>>>>>>>'+AutodocCaseItems);
            //create case items with key id
            addCaseItems(caseObj.Id, AutodocCaseItems);
            
            //Set the flag to update to capture milestone iformation.
            updateInitalMilestonePerofmance(caseObj.Id);
            
            //display standard case page layout in a VF page to resolve cross domain issue  under IE in service console with multiple tabs   
            //standard page and VF page has different doamin in salesforce  
            //return new PageReference('/apex/ACETCaseDetail?id=' + CaseObj.Id);
            
          
            return new PageReference('/' + CaseObj.Id);  
         
         //}
        
        //----------------------Added for POC --------------------
         /* else{
            
            system.debug('inside else'+ callSubTypeWrapperMap +'Vlaues**********'+callTypeList);
        
            List<String> resolvedCallTypeList = new List<String>();
            List<String> selectedCallTypes = new List<String>();
            Map<String,String> selectedCallTypesMap = new Map<String,String>();
            insertedCaseItemRecList = new List<Case>();
            List<case> caseLists = new List<Case>();
            caseItemListMap = new Map<String,String>();
            finalStr = new Set<passValuesWrapper>();
            
            //finalStr = new Set<String>();
            passValuetoURL = new List<String>();
            String str = '';
            if(callTypeList!= null) {
                for(CallTypeWrapper chkCallType:callTypeList) {
                    //System.debug('Testing####Test%%%%'+chkCallType.callType+'@@@@'+chkCallType.optionSelected+'^^^^'+chkCallType.resolvedIds);
                    if(chkCallType.resolvedIds == 'Resolved') {
                        selectedCallTypes.add(chkCallType.callType);
                        selectedCallTypesMap.put(chkCallType.callType,chkCallType.resolvedIds);
                        resolvedCallTypeList.add(chkCallType.callType);
                    }
                    else if(chkCallType.resolvedIds == 'Unresolved') {
                        //str = insertCallTypeCases(chkCallType.callType);
                        selectedCallTypes.add(chkCallType.callType);
                        selectedCallTypesMap.put(chkCallType.callType,chkCallType.resolvedIds);
                    }
                    System.debug('Sub Types:::::::'+chkCallType.callSubTypeList);
                    if(chkCallType.callSubTypeList != null) {
                        for(callSubTypeWrapper callSubType:chkCallType.callSubTypeList) {
                            if(callSubType.resolvedValue == 'Resolved') {
                                selectedCallTypes.add(callSubType.CallTypeF+':'+callSubType.CallSubTypeF);
                                resolvedCallTypeList.add(callSubType.CallTypeF+':'+callSubType.CallSubTypeF);
                                selectedCallTypesMap.put(callSubType.CallTypeF+':'+callSubType.CallSubTypeF,callSubType.resolvedValue);
                            }
                            else if(callSubType.resolvedValue == 'Unresolved') {
                                selectedCallTypes.add(callSubType.CallTypeF+':'+callSubType.CallSubTypeF);
                                selectedCallTypesMap.put(callSubType.CallTypeF+':'+callSubType.CallSubTypeF,callSubType.resolvedValue);
                            }
                        }
                    }
                }
            }
            System.debug('Entering Loop::::'+selectedCallTypesMap+'&&&&&&&&&&&'+selectedCallTypes);
            if(selectedCallTypes.size() > 0 && selectedCallTypes != null) {
                insertedCaseItemRecList = insertCallTypeCases(selectedCallTypesMap,selectedCallTypes);
            }
            List<case> caseIdList = [select Id,CaseNumber from Case where Id =: insertedCaseItemRecList and status = 'Open'];
           
            if(caseIdList.size() > 0) {
               
                for(Case caseIds:caseIdList) {
                    finalStr.add(new passValuesWrapper(caseIds.Id,CaseIds.CaseNumber));
                    //finalStr.add(caseIds.Id);
                    //successCases.add(caseIds);
                    //caseItemListMap.put(caseIds.Id,caseIds.caseNumber);
                    //caseLists.add(caseIds.Case__r);
                    //passValuetoURL.addAll(finalStr);
                }
                resultJsonMap = JSON.Serialize(finalStr);
            } 
            
            return null;
            //return new PageReference('/' + passValuetoURL[0]);         
        }*/
    }
    
    //@Future
    public static void updateInitalMilestonePerofmance(Id caseId){
          system.debug('%%0508 caseid '+ caseid);
         Case cas = new case(Id = caseid,Trigger_Initial_MP_Record__c = true);
         update cas;
    }
    
    public void createBlankCase(){
        //CaseObj.Interaction__c = Interaction.Id;
        //if(Subject != null){
            //CaseObj.contactId = Subject.Id;
        //}        
        //system.debug('CaseObj >>>'+CaseObj);     
        //insert CaseObj;                                   
    }
    
    public PageReference saveAndClose(){
        system.debug('i am here >>>>>>>>>>>>>');
        string commentSting = '';
        saveActionFlag =false;
        CaseObj.Status='Closed'; 
        updategroupinfoSave = false;
         saveCase();
         if(!SkipCaseClosePage){
              system.debug(' isSystemUnavailable--->'+isSystemUnavailable); 
             /*****added by vishakha 12/02 for US413581 START*****/
             if((CaseObj.Topic__c == 'View Consumer Dashboard' || CaseObj.Topic__c == 'Create Authorization' || CaseObj.Topic__c == 'Create PCP Referral') && !isSystemUnavailable){
                  
                 return new PageReference('/apex/ACETCallTopicSaveAndClose?caseId=' + CaseObj.Id + '&blockedCallTopic ='+ blockedCallTopic); 
             }
             /*****added by vishakha 12/02 for US413581 END*****/
             else
             {
                 return new PageReference('/apex/ACETCallTopicSaveAndClose?caseId=' + CaseObj.Id);  
             }
         }
         else{
                 return new PageReference('/' + CaseObj.Id); 
         }
    }
    
    public void saveCaseAndReturn(){
        saveActionFlag =true;
        saveCase();
    }
    
    public PageReference cancelCase() {
        //saveActionFlag = false;
        CaseObj.Status='Canceled';
        updategroupinfoSave = false;
        saveCase();
        
        return new PageReference('/apex/ACETCancelCase?caseId=' + CaseObj.Id);                
    }
    
    public PageReference misdirect(){
        CaseObj.Status='Cancelled';
        updategroupinfoSave = false;
        saveCase();
        
        return new PageReference('/apex/ACETMisdirectedCall?currentCaseId=' + CaseObj.Id);    
    }
    
    //create case items based on external ids and other info from autodoc
    public static void addCaseItems(String caseId, String caseItemsInfo){
        System.debug('Entering.....'+caseItemsInfo+'>>>'+caseId); //debug added by divya for testing
        List<Case_Item__c> caseItems = new List<Case_Item__c>();
        
        if(!String.isEmpty(caseItemsInfo)){            
            List<String> keyIds = caseItemsInfo.split(',');
            Map<String, String> keyIdMap = new Map<String,String>();
            
            //merge case item with same keyid, case item from sub tab overrides same case item from search page
            for(String keyId : keyIds){
                List<String> keyIdParts = keyId.split(':');
                keyIdMap.put(keyIdParts[0], keyIdParts[1]);     
            }
                    
            for(String keyId : keyIdMap.keyset()){                
                Case_Item__c ci = new Case_Item__c();
                ci.Case__c = caseId;
                ci.ExternalID__c = keyId;
                ci.Resolved__c = Boolean.valueOf(keyIdMap.get(keyId));               
                caseItems.add(ci);
            }                        
        }else{
            //create a dummy case item
            Case_Item__c ci = new Case_Item__c();
            ci.Case__c = caseId; 
            ci.Resolved__c = true;
            caseItems.add(ci);
        } 
        insert caseItems;        
    }
    
    public static void addCaseComment(String caseId, String cc){
        if(!String.isEmpty(cc)){
            CaseComment objcc = new CaseComment();
            objcc.CommentBody = cc;
            objcc.ParentId = caseId;
            insert objcc;       
        }
    }
    
    public List<SelectOption> getMisdirectedReasons(){
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Cosmos','Cosmos'));
        options.add(new SelectOption('CSP Facets','CSP Facets'));
        options.add(new SelectOption('Dental Plan','Dental Plan'));
        options.add(new SelectOption('Member Service','Member Service'));
        options.add(new SelectOption('Other','Other'));
        options.add(new SelectOption('Global Restricted','Global Restricted'));
        options.add(new SelectOption('UHG Restricted','UHG Restricted'));
        options.add(new SelectOption('Pharmacy RX Other','Pharmacy RX Other'));
        options.add(new SelectOption('Prime','Prime'));
        options.add(new SelectOption('Provider Relations','Provider Relations'));
        options.add(new SelectOption('Pulse','Pulse'));
        options.add(new SelectOption('UNET','UNET'));
        options.add(new SelectOption('Vision Plan','Vision Plan'));
        options.add(new SelectOption('Wrong Carrier','Wrong Carrier'));
        return options;     
    }
    
    public List<SelectOption> getCancelReasons(){
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Caller Disconnected','Caller Disconnected'));
        options.add(new SelectOption('Created In Error','Created In Error'));        
        return options;     
    }
    
    public void passParameters() {
        //System.debug('Pass values.....'+callTypeWrapList );
    }
  
    // Added for POC - Divya
     public class passValuesWrapper {
         public String caseNumber;
         public String caseIDs;
         public passValuesWrapper(string caseId,string caseNo) {
             caseNumber = caseNo;
             caseIDs = caseId;
         }
     }
     
    /* Please don't remove the commented code - Added by Divya
    public List<Call_Topic__c> callTopics() {
         callsTopic = new List<Call_Topic__c>();
         callsTopic = [select Name_OOB__c,Call_Type__c, Active__c,Call_Subtype__c,Call_Sub_Type__c,Record_Type_Mapping__c from Call_Topic__c where Name_OOB__c =: CallTopic and Active__c = true];    
         return callsTopic;
     }
     public List<CallTypeWrapper> getCallTypesW() {
        System.debug('Call Topic%%%%%'+CallsTopic);
        callTopics();
        callTypeList = new List<CallTypeWrapper>();
        Set<String> callTypeSet = new Set<String>();
        for(Call_Topic__c calls:CallsTopic) {
            callTypeSet.add(calls.Call_Type__c);
        }
        //callTypeSet = callSubTypeWrapperMap.keySet();
        System.debug('Call Sub Topic::::::::'+callSubTypeWrapperMap);  
        for(String callType : callTypeSet) {
            if(callType != null) {
                 Integer i = 0;
                 if(callSubTypeWrapperMap.get(callType) != null) {
                    i  = callSubTypeWrapperMap.get(callType).size();
                 }
                 System.debug('Times::::'+callType);
                 callTypeList.add(new CallTypeWrapper(callType,callSubTypeWrapperMap.get(callType),i));
            } 
        }
       return callTypeList;
    }
   
    public Map<String,List<callSubTypeWrapper>> getCallSubType() {
        callTopics();
        callSubTypeWrapperMap = new Map<String,List<callSubTypeWrapper>>();
        callSubRecordTypeMapping = new Map<String,String>();
        Map<String,List<callSubTypeWrapper>> callSubTypeWrapperMapTemp = new Map<String,List<callSubTypeWrapper>>();
        for(Call_Topic__c callTop:callsTopic) {
            if(callTop.Call_Subtype__c != null) {
                //List<String> splitCallSubType = new List<String>();
                //if(callTop.Call_Sub_type__c.containsAny(';')) {
                    //splitCallSubType = callTop.Call_Sub_type__c.split(';');
                    //for(String str:splitCallSubType) {
                        if(callSubTypeWrapperMapTemp.containsKey(callTop.Call_Type__c) == false) {
                         callSubTypeWrapperMapTemp.put(callTop.Call_Type__c,new List<callSubTypeWrapper>());
                         callSubTypeWrapperMapTemp.get(callTop.Call_Type__c).add(new callSubTypeWrapper(callTop.Call_Subtype__c,callTop.Call_Type__c));  
                        } 
                        else {
                         callSubTypeWrapperMapTemp.get(callTop.Call_Type__c).add(new callSubTypeWrapper(callTop.Call_Subtype__c,callTop.Call_Type__c));
                        }
                    //}
                //}
            } 
            if(callTop.Record_Type_Mapping__c != null) {
                callSubRecordTypeMapping.put(callTop.Call_Subtype__c,callTop.Record_Type_Mapping__c);
            }  
         }
         System.debug('Mapping>>>>>'+callSubRecordTypeMapping);
         return callSubTypeWrapperMapTemp;    
     }
     
     public class CallTypeWrapper {
        public Boolean optionSelected {get; set;}
        public String callType {get; set;}
        public string resolvedIds {get; set;}
        public List<callSubTypeWrapper> callSubTypeList {get; set;}
        public Integer sizeCallSubTypes {get; set;}
        public CallTypeWrapper(String callTypeWrap,List<callSubTypeWrapper> callSubTypeListt,Integer subTypeSize) {
        //public CallTypeWrapper(String callTypeWrap,Integer subTypeSize) {
             callSubTypeList = new List<callSubTypeWrapper> ();
             callType =  callTypeWrap; 
             optionSelected = false; 
             resolvedIds ='';
             callSubTypeList = callSubTypeListt;
             sizeCallSubTypes = subTypeSize;
            
        }
    }
    public class callSubTypeWrapper {
        public string callSubTypeF {get; set;}
        public String callTypeF {get; set;}
        public Boolean checkBoxSelected {get; set;}
        public string resolvedValue {get; set;}
        public callSubTypeWrapper(String callSubTypes,String callType) {
            callSubTypeF = callSubTypes;
            callTypeF = callType;
            checkBoxSelected = false;
            resolvedValue = '';
        }
    }
    public List<Case> insertCallTypeCases(Map<String,String> selectedCallTypeMap,List<string> callTypeList) {
        List<recordType>  recordTypeList = new List<recordtype>();
        Map<String,String> recordTypeMap = new Map<String,String>();
        recordtypeList = [select Id, name from recordtype where SobjectType = 'Case_Item__c'];
        if(recordtypeList != null) {
            for(recordType recType:recordtypeList) {
                recordTypeMap.put(recType.Name,recType.Id);
            }
        }
        List<Case> caseList = new List<Case>();
        List<Case_Item__c> caseItmList = new List<Case_Item__c>();
        if(callTypeList != null) {
            for(String str:callTypeList) {
                Case CaseObj = new Case();
                string commentSting = '';
                if(Subject != null){
                    contact contactObj = [Select id,contact_type__c from contact where id = :this.Subject.Id];
                    if(contactObj != null && contactObj.contact_type__c!=null){
                        SubjectType = contactObj.contact_type__c;
                    }  
                }
                if (String.isNotBlank(CaseRecordTypeLabel)) {
                    CaseObj.RecordTypeId = ACETUtility.getRecordTypeID('Case', CaseRecordTypeLabel);
                }               
                if(Interaction.Id == null) insert Interaction;        
                    CaseObj.Interaction__c = Interaction.Id;        
                if(Subject != null){
                    CaseObj.ContactId = this.Subject.Id;            
                }
                if(SubjectType != Null && SubjectType != '')
                {
                    CaseObj.Subject_Type__c = SubjectType;                
                }     
                if(SourceOriginator != null){
                    this.CaseObj.Origin = SourceOriginator;
                }
                if(Interaction.Interaction_Type__c != null){
                    this.CaseObj.Origin = Interaction.Interaction_Type__c;
                }        
                if(selectedAccountType != null) {
                    String accountTypeString = string.join(selectedAccountType,';\n');
                    CaseObj.Account_Type__c = accountTypeString;
                }
                if(String.isEmpty(CaseObj.Topic__c) && !String.isEmpty(callTopic)){
                    CaseObj.Topic__c = callTopic;
                }
                if(isSystemUnavailable){
                    this.CaseObj.Status = 'Closed';
                    this.CaseObj.New_Closed_Reason__c = 'System Unavailable';
                }  
                
                if(selectedCallTypeMap.get(str) == 'Resolved') {
                    System.debug('Values$$$$$$$'+selectedCallTypeMap.get(str));
                    CaseObj.Status = 'Closed';
                    
                }
                else {
                    System.debug('Values$$$$$$$'+selectedCallTypeMap.get(str));
                    CaseObj.Status = 'Open';
                    this.CaseObj.New_Closed_Reason__c = '--None--';
                } 
                System.debug('Values$$$$$$$'+CaseObj.Status+'Status Message');          
                if(!String.isEmpty(CancelReason)){
                    CaseObj.Status = 'Cancelled';
                    CaseObj.Cancel_Reason__c = CancelReason;
                }                       
                if(!String.isEmpty(Autodoc)){
                    CaseObj.Autodoc__c = Autodoc;
                }               
                if(saveActionFlag){
                    CaseObj.isComplete__c = true;
                }                            
                if(str != null && !String.isEmpty(str)) {
                    //CaseObj.Topic_Type__c = str;
                    if(str.containsAny(':')) {
                        List<String> steTypeList = new List<String>();
                        for(String strType:str.split(':')) {
                            steTypeList.add(strType.trim());
                        }
                        //CaseObj.Type__c = steTypeList[0];
                        //CaseObj.Subtype__c = steTypeList[1];
                    }
                    else {
                        //CaseObj.Type__c = str;
                    }
                }
                caseList.add(CaseObj);
            }
            insert caseList;
        }
        string strInfo = 'Enter information needed by back office: ';
        if(caseList.size() > 0) {
            for(Case caseObj:caseList) {
                if(caseObj.Type__c != null) {
                    Case_Item__c caseItmObj = new Case_Item__c();
                    //caseItmObj.Type__c = caseObj.Type__c;
                    //caseItmObj.Subtype__c = CaseObj.Subtype__c;
                    caseItmObj.Case__c = CaseObj.Id;
                    if(caseObj.Status != 'Open') {
                        caseItmObj.Complete__c = true;
                    }
                    else {
                        caseItmObj.Complete__c = false;
                    }
                    //System.debug('Case Item Mapping'+recordTypeMap.get(callSubRecordTypeMapping.get(caseItmObj.Subtype__c))+'*****'+recordTypeMap+'>>>>>'+callSubRecordTypeMapping.get(recordTypeMap.get(caseItmObj.Subtype__c)));
                    //if(caseItmObj.Subtype__c != null && recordTypeMap.get(callSubRecordTypeMapping.get(caseItmObj.Subtype__c)) != null) {
                        //caseItmObj.recordTypeId = recordTypeMap.get(callSubRecordTypeMapping.get(caseItmObj.Subtype__c));
                    //}
                    //else {
                        //caseItmObj.recordTypeId = '';
                    //}
                    caseItmList.add(caseItmObj);    
                    
                    addCaseComment(caseObj.Id, AutodocComment);  
                }               
            }
            insert caseItmList; 
        }
        system.debug('caseList >>>>>>>>>>>>>>>> '+ caseItmList);
        return caseList;     
    } */
    
    /* Please don't remove the commented code - Added by Divya
    public List<CallTypeWrapper> getDynamicCallTypes() {
        List<String> callTypeList = ACETDynamicCallTypesDisplayController.getCallTypesAndAccountTypes(callTopic,'CallType');
        callTypeWrapList = new List<CallTypeWrapper>();
        if(callTypeList != null && callTypeList.size() > 0) {
            for(String callType : callTypeList) {
                if(callType != null) {
                    callTypeWrapList.add(new CallTypeWrapper(callType)); 
                }
            }
        }
        System.debug('Adding Checkbox values:::::'+callTypeWrapList);
        return callTypeWrapList;
    }
    
    public List<CallTypeWrapper> getAccountType()
    {
        List<String> accountTypeList = ACETDynamicCallTypesDisplayController.getCallTypesAndAccountTypes(callTopic,'Account');
        accountTypeWrapList = new List<CallTypeWrapper>();
        if(accountTypeList != null) {
            for(String accType : accountTypeList) {
                if(accType != null) {
                    accountTypeWrapList.add(new CallTypeWrapper(accType)); 
                } 
            } 
        }
       return accountTypeWrapList;
    }
    
    public class CallTypeWrapper {
        public String callType {get; set;}
        public Boolean optionSelected {get; set;}
        public Boolean resolvedChkBoxSelected {get; set;}
        public CallTypeWrapper(String callTypeC) {
            callType = callTypeC;
            optionSelected = false;
            resolvedChkBoxSelected = true;
        }
    }*/
     
    
}