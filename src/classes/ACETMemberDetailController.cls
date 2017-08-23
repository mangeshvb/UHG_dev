public without sharing class ACETMemberDetailController { 
    public String currentAgentProfile {get;set;}
    public Map<String,String> familymemberRelatioshipMap {get;set;}
    public String IndividualIdentifier {get;set;}
    public boolean ThirdPartyActionFlag {get;set;} 
    public Interaction__c Interaction {get;set;}
    public Contact Subject {get;set;}
    public List<Contact> FamilyMembers {get;set;}
    public List<Contact> FamilyInfo {get;set;}
    public String SourceOriginator {get;set;}
    public boolean isMisdirectCaseCreation{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public string ProviderId{get;set;}
    public boolean memberEnrollment{get;set;}  
    public String GroupNumber{get;set;}
    public String EmployerName{get;set;}
    public String Zip{get;set;}
    public String State{get;set;}
    public String phonenum{get;set;}
    public boolean IsShowActivePhysiciansOnly {get;set;}    
    //If the interaction is passed to member search page, it is considerated as provider flow, otherwise considerated as member flow
    public Boolean IsProviderFlow {get;set;}
    
    //added by sumit
    public list<PrimaryCarePhysicianWrapper> lstPrimaryCarePhysicianWrapper {get;set;}
    public list<ROIWrapper> lstROIWrapper{get;set;}   
    //external fields displayed in panel from member detail
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}
    public String FamilyInfoStr{get;set;}
    //public String hpAdditionInfoStr {get;set;}
    
    //fields from OIL services
    public ACETMemberDetail MemberDetail {get;set;}
    //originator selection box  
    public String Originator {get;set;}
    public List<SelectOption> Originators {get;set;}
    
    public Boolean IsShowActiveCoveragesOnly {get;set;}
    public List<ACETMemberDetail.CoverageLine> Coverages {get;set;}        
    public ACETMemberDetail.CoverageLine PreferredCoverage {get;set;}
    public String ProferredCoverageGUID {get;set;}
    
    public List<ACETMemberDetail.otherContact> ROIcontacts {get;set;}
    //added by Khoushik on 12/14/2016
    public String selectedSurrogateKey {get;set;}     
    
    //added by Khoushik on 09/28/2016 for User Story - US378010
    public String MemberDetailResultJson{get;set;}
    
    //added by Avish on 06072017 for User Story US652217
    public String BundleOptionID {get;set;}
    
    //added by Vishakha on 11/02/2016 for User Story - US:405397,405471
    public Integer alertNumber{get;set;}
    public Boolean isAlertModal{get;set;}
    public list<Alert__c> lstMemAlert{get;set;}
    public String consumerDashURL{get;set;}
        
    //added by Khoushik on 11/22/2016 for User Story - US412557, US404372, US412570
    
    public String  UserGroupName{get;set;}
    public Boolean UHGRestricted{get;set;}
    public Boolean GlobalRestricted{get;set;}
    public Boolean DisableOpenTopicDetail{get;set;}
    public Boolean RedirecttoMisdirect{get;set;}
    public String  ErrorMessage{get;set;}
    public String  DefaultValue{get;set;}
    
    /* Code commented for US585208 - by divya - 4/5/17
    public String enrollmentLag {get; set;}
    public String groupSize {get; set;}
    public String rehirePolicy { get; set; } */   
    public String groupId {get; set;}
    public String memNotFound {get; set;}
    public String ssn{get; set;}
    public String scrId {get; set;}
    
    public boolean isGroupFlow;
    public ACETGroupDetail groupDetails{get;set;}
    public list<Alert__c> lstGroupAlert{get;set;}
    
    public String providerType{get;set;} // added by Vishakha for communication
    
    //Start: User Story - US605469
    
    ACETGetIndividualWebService ACETGetIndWebservice;
    ACETFindMembershipWebservice ACETFindMemWebservice;
    ACETGetFamilyMemberWebService ACETGetFamMemWebservice;
    ACETGetMembershipWebService ACETGetMemWebService;
    public boolean isshowGroupALert{get;set;}
    
    //End: User Story - US605469
    
    public Boolean isROI {get; set;}
    //US635546-SNI
    public String caseTopicMid {get; set;}
    public String caseTopic {get; set;}
    public String caseType {get;set;}
    public String caseSubType {get;set;}
    public Case caseMid {get;set;}
    public Boolean isIsetSource 
    { 
        get
        {
            if(isIsetSource == null)
            {
                System.debug(ApexPages.currentPage().getParameters().get('sourceApp'));
                String sourceApplication = ApexPages.currentPage().getParameters().get('sourceApp');
                if(sourceApplication == 'ISET')
                {
                    isIsetSource =  true;
                }
                else 
                {
                    isIsetSource =  false;
                }
            }
            return isIsetSource;
        }
        set;  
    }
    public ACETMemberDetailController (){
        caseMid = new Case();//US635546-SNI
        User currentUser = [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
        currentAgentProfile = currentUser.profile.name;
        familymemberRelatioshipMap = new Map<String,String>();
        ssn = ApexPages.currentPage().getParameters().get('ssn');
        scrId = ApexPages.currentPage().getParameters().get('scr');
        memNotFound = ApexPages.currentPage().getParameters().get('mnf');//@@added by Ranjit: (member not found)
        Originators = new List<SelectOption>();
        isGroupFlow = false;
        memberEnrollment = false; 
        isROI = false;
        UserGroupName =''; 
        DisableOpenTopicDetail = false;                   
        SourceOriginator = ApexPages.currentPage().getParameters().get('sourceOriginator');
        //added by sumit 
        lstPrimaryCarePhysicianWrapper = new list<PrimaryCarePhysicianWrapper>();
        lstROIWrapper = new list<ROIWrapper>();
        List<Group> lstgroup = [select Name from group where Id in (SELECT GroupId FROM GroupMember where UserOrGroupId = :UserInfo.getUserId())];
        if(lstgroup.size() > 0){
            UserGroupName =  lstgroup[0].Name;  
        }
        system.debug('232323 UserGroupName' + UserGroupName); 
        IndividualIdentifier = ApexPages.currentPage().getParameters().get('Id');
        system.debug('IndividualIdentifier >>> '+ IndividualIdentifier);
        groupId = ApexPages.currentPage().getParameters().get('groupId ');
        if(groupId != Null && groupId != '')
        {
            isGroupFlow = true;
        }
        
        //Start: User Story - US605469    
        String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
        Interaction = ACETMemberQueryUtil.queryInteraction(interactionId);
        isshowGroupALert = false;
        //End: User Story - US605469
    } 
    
    //added by Vishakha on 11/02/2016 for User Story - US:405397,405471- getting all the alert related to the member
    public void getNoOfMemAlert(){
       ACETInteractionHighlightsPanelController AlertNo = new ACETInteractionHighlightsPanelController();
       if(MemberDetail != null && AdditionalInfo != null){
           system.debug('getNoOfMemAlert:::Start MemberDetail.MemberId '+MemberDetail.MemberId +'****'+AdditionalInfo.PolicyNumber);
           lstMemAlert = AlertNo.getNoAlert('Member',MemberDetail.MemberId,AdditionalInfo.PolicyNumber);
           system.debug('lstMemAlert is '+lstMemAlert);
           if(lstMemAlert.size()>0 ){
               list<Interaction_Alert__c> lstIntAlert = new list<Interaction_Alert__c>();
               for(Alert__c varalert : lstMemAlert){
                   Interaction_Alert__c intAlert = new Interaction_Alert__c();
                   intAlert.Alert__c = varAlert.id;
                   intAlert.Interaction__c = Interaction.id;
                   intAlert.ID_Number__c = MemberDetail.MemberId;// added by vishakha 11/30 for US442332
                   intAlert.Intercation_Alert_Unique_Id_del__c = String.valueof(varAlert.id)+String.valueof(Interaction.id)+ MemberDetail.MemberId;
                   lstIntAlert.add(intAlert); 
               }
               try{
               upsert lstIntAlert Intercation_Alert_Unique_Id_del__c  ;
               }
               Catch(DMLException e){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Exception during insertion on Interaction Alert.'));
               }
           }
       }
      
    }
    public void btnHideWindowAlertWinodw() {
     
     }
     public void createConsumerDashURL(){
          User u = [select profile.Name from User where Id = :UserInfo.getUserId()];
          if(u.Profile.Name.contains('Member') || u.Profile.Name.contains('Research') /*|| u.Profile.Name.contains('System Administrator')*/){
              consumerDashURL = ACETUtility.getConsumerDashURL(MemberDetail.PolicyNumber, MemberDetail.MemberId, ApexPages.currentPage().getParameters().get('firstName'), ApexPages.currentPage().getParameters().get('lastName'));
          }
          
     }
     
     public integer caseListSize {get; set;}
    public List<Case> getCaseHistory(){
        String Id = ApexPages.currentPage().getParameters().get('Id');
        transient List<Case> cases = [select CaseNumber, Contact.Name, CreatedBy.Name, CreatedDate, Topic__c, Status, Originator_Type__c, Interaction_Type__c, Interaction__c,Rollup_Fulfillment__c, (SELECT Id, Name FROM Create_Letters__r) from Case where Contact.EID__c = :Id order by CreatedDate desc limit 500];// Remove Rollup_Fulfillment__c due to deployment issues:Swetha
        caseListSize  = cases.size();
        return cases;
    }
    
    public void renderMisdirectCaseSection(){
        isMisdirectCaseCreation=true;  
    }
    
    //Start: User Story - US605469
    public Object changeOriginator(){
        //get membership information for originator   
     
        Continuation getMembershipContinuation;
        ACETMemberDetail originatorMemberDetail = new ACETMemberDetail();
        Contact originatorObj = ACETMemberQueryUtil.queryContact(Originator);
        System.debug(originatorObj);
        if(originatorObj != null && familymemberRelatioshipMap.get(originatorObj.eid__c) != null)
            MemberDetail.OriginatorRelationShip = familymemberRelatioshipMap.get(originatorObj.eid__c);
        system.debug('88888 '+JSON.serialize(MemberDetail));
        if(PreferredCoverage != null){
            if(!String.IsEmpty(MemberDetail.SurrogateKey)) {
                ACETGetMemWebservice = new ACETGetMembershipWebService();
                getMembershipContinuation = ACETGetMemWebservice.StartRequest(originatorObj.EID__c,MemberDetail.PreferredCoverage.groupNumber, MemberDetail,'OrigGetMembershipCallback',null); 
            }else{
                ACETGetMemWebservice = new ACETGetMembershipWebService();
                getMembershipContinuation = ACETGetMemWebservice.StartRequest(originatorObj.EID__c, PreferredCoverage.PolicyNumber, MemberDetail,'OrigGetMembershipCallback',null);
            }
        }
        return  getMembershipContinuation;  
    }
    
    public PageReference OrigGetMembershipCallback() {
         
        ACETWSCalloutResult getMemCalloutResults;
        getMemCalloutResults = ACETGetMemWebservice.ProcessResponse(ACETGetMemWebservice.RequestLabel, MemberDetail);
      
        if(getMemCalloutResults.Success) {
          MemberDetail = (ACETMemberDetail)getMemCalloutResults.Response;
          //MemberDetail.OriginatorRelationship = MemberDetail.Relationship;
        }
        else{
                
                ApexPages.addMessage(new ApexPages.Message(getMemCalloutResults.MessageSeverity,getMemCalloutResults.Message));
            }
            system.debug('99999 '+JSON.serialize(MemberDetail));
        initHighlightPanelAdditionalInfo(false);
       
        Interaction.Originator__c = Originator; 
        Interaction.Third_Party__c = null;
        update Interaction;
        
        Interaction = ACETMemberQueryUtil.queryInteraction(Interaction.Id); 
        
        getNoOfMemAlert(); 
        return null;
    }
    //End: User Story - US605469
    
    public void toggleShowCoverages(){
        if(IsShowActiveCoveragesOnly == null){
            IsShowActiveCoveragesOnly = true;   
        }else{
            IsShowActiveCoveragesOnly = !IsShowActiveCoveragesOnly;
        }
        
        Coverages = new List<ACETMemberDetail.CoverageLine>();
        if(MemberDetail != null && MemberDetail.CoverageLines != null){     
            for(ACETMemberDetail.CoverageLine c : MemberDetail.CoverageLines){
                if(!IsShowActiveCoveragesOnly || c.getIsActive()){
                    Coverages.add(c);   
                }
            }
        }
    }
    
    public void selectPreferredCoverage(){ 
         
        Set<String> PolicyNumber = new Set<String>();
        system.debug('232323selectedSurrogateKey'+ selectedSurrogateKey);
        RedirecttoMisdirect = false;
        DisableOpenTopicDetail = false;
        system.debug('232323 inside select preferred coverage'+ProferredCoverageGUID);            
        for(ACETMemberDetail.CoverageLine cl : Coverages){
            system.debug('cl guid : '+cl.GUID);
            if(cl.GUID == ProferredCoverageGUID){ // Prakash 02-01-17
                PreferredCoverage = cl;
                selectedSurrogateKey = cl.SurrogateKey;
                system.debug(PreferredCoverage);
            }
            PolicyNumber.add(cl.PolicyNumber);
        }
        /* US659454 Removing Method
        //added by Khoushik to Check for Security related to Restricted Policy Numbers
        if(PreferredCoverage != null){
            if(PreferredCoverage.PolicyNumber !=null && UserGroupName !=''){
            system.debug('232323 PreferredCoverage.PolicyNumber'+PreferredCoverage.PolicyNumber);
                CheckRestrictedPolicyNumbers(PreferredCoverage.PolicyNumber, PolicyNumber.size());
            }
        }
        */ // US659454
    }
    
    /* US659454 Removing Method
    private void CheckRestrictedPolicyNumbers(String PolicyNumber, Integer Policycount){
        PolicyNumber = PolicyNumber.replaceAll( '\\s+', '');
        List<Restricted_Policy_Number__c> lstPolicy = [select Name,Global_Restricted__c,UHG_Restricted__c from Restricted_Policy_Number__c where Name =:PolicyNumber];
        if(lstPolicy.size() > 0){
            UHGRestricted = lstPolicy[0].UHG_Restricted__c;
            GlobalRestricted = lstPolicy[0].Global_Restricted__c;
            system.debug('232323 UHGRestricted' + UHGRestricted);
            system.debug('232323 GlobalRestricted' + GlobalRestricted);
            if(UserGroupName == 'Member Offshore' || UserGroupName == 'Provider Offshore'){
                if(UHGRestricted){
                     if(Policycount == 1){
                         //navigate to misdirect page
                         RedirecttoMisdirect = true;
                         DisableOpenTopicDetail = true;
                         ErrorMessage = 'ACETMemberOffshoreUHGError';
                         DefaultValue = 'UHG Restricted';
                     }else{
                         DisableOpenTopicDetail = true;
                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Access to this UHG group is restricted. Misdirect to the appropriate team or select a different policy.'));
                     }
                }
                if(GlobalRestricted){
                     if(Policycount == 1){
                         //navigate to misdirect page
                         RedirecttoMisdirect = true;
                         DisableOpenTopicDetail = true;
                         ErrorMessage = 'ACETMemberOffshoreError';
                         DefaultValue = 'Global Restricted';
                         System.debug(232323 + DefaultValue );
                     }else{
                         DisableOpenTopicDetail = true;
                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Access to this Global group is restricted. Misdirect to the appropriate team or select a different policy.'));
                     }
                }
            }            
            if(UserGroupName == 'UHG Provider Services'){                
                if(GlobalRestricted){
                     if(Policycount == 1){
                         //navigate to misdirect page
                         RedirecttoMisdirect = true;
                         DisableOpenTopicDetail = true;
                         ErrorMessage = 'ACETMemberOffshoreError';
                         DefaultValue = 'Global Restricted';
                     }else{
                         DisableOpenTopicDetail = true;
                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Access to this Global group is restricted. Misdirect to the appropriate team or select a different policy.'));
                     }
                }
            }
            if(UserGroupName == 'Provider Onshore' || UserGroupName == 'Member Onshore'){
                if(UHGRestricted){
                     if(Policycount == 1){
                         //navigate to misdirect page
                         RedirecttoMisdirect = true;
                         DisableOpenTopicDetail = true;
                         ErrorMessage = 'ACETMemberOffshoreUHGError';
                         DefaultValue = 'UHG Restricted';
                     }else{
                         DisableOpenTopicDetail = true;
                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Access to this UHG group is restricted. Misdirect to the appropriate team or select a different policy.'));
                     }
                }
            }                
        }            
    }  
    */ //US659454
     
    private void initInteractionAndSubject(){
        if(memNotFound != '1') 
        {
            String Id = ApexPages.currentPage().getParameters().get('Id');
            system.debug('@@@@Id: ' + Id);    
            
            String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
            system.debug('InteractionId: ' + InteractionId); 
            system.debug('isMember'+ApexPages.currentPage().getParameters().get('IsMember ')) ;  
            try{  
            //if (!String.isEmpty(interactionId))
            memberdetail.memberid = Id;
            if(ApexPages.currentPage().getParameters().get('IsMember ').contains('false')){                                                        
                //Query Provider Interaction details
                Interaction = ACETMemberQueryUtil.queryInteraction(interactionId);
                
                //Added swetha : update interaction from vccdParams
                Interaction = ACETVCCDUtility.populateVCCDInfo(Interaction);
                update interaction;
                IsProviderFlow = true;                   
            } else {
                IsProviderFlow = false;
            }
            //setup originator options
            Originators = new List<SelectOption>();
            
            //added by Khoushik for Surrogate Ids related Story
            System.debug('MemberDetail: ' + MemberDetail.SurrogateKey);
            if(!String.IsEmpty(MemberDetail.SurrogateKey) && 1==2) {
                Map<String, ISL_Webservice_Config__c> WSConfigurations = new Map<String, ISL_Webservice_Config__c>();
                WSConfigurations = ISL_Webservice_Config__c.getAll();
                ISL_Webservice_Config__c SRKCounter = WSConfigurations.get('SRKCounter');
                if(WSConfigurations.get('SRKCounter') != null){
                    SRKCounter.Value__c = String.valueOf(Integer.ValueOf(SRKCounter.Value__c) + 1);
                    if (Integer.valueOf(SRKCounter.Value__c) > 8) {
                        SRKCounter.Value__c = '1';
                    }
                    update SRKCounter;  
                }
                String dob = ApexPages.currentPage().getParameters().get('subjectdob');
                String Params =  ApexPages.currentPage().getParameters().get('vccdParams');
                String Phone ='';
                if(Params != '' && Params != null){
                    JSONParser parser = JSON.CreateParser(Params);
                    
                    While(parser.nextToken() !=null){
                        if((Parser.getCurrentToken() == JSONToken.FIELD_Name) && (parser.getText() =='Phone')){
                            parser.nexttoken();
                            Phone = Parser.getText();
                        }
                    }
                }
                ACETOILIndividual acetOilData = new ACETOILIndividual();
                acetOilData.FirstName = MemberDetail.FirstName;
                acetOilData.LastName = MemberDetail.LastName;
                acetOilData.EId = Id;
                acetOilData.Phone = Phone;
                acetOilData.SurrogateKeys = MemberDetail.SurrogateKeys;
                if(!String.isEmpty(dob)) {
                    acetOilData.Birthdate = date.parse(dob);
                } 
                ACETConstituent acetcon = new ACETConstituent(); 
               Map<String, List<Case>> ACETSRKCaseMap = acetcon.MergeNSplitCases(acetOilData); //SRK Code
               Subject = acetcon.GetConstitentContact(acetOilData);
                Subject = acetcon.Subject;   
                system.debug('Subject inside controller '+Subject);
                //save member and member family to contact
                createMemberAndFamilyMembers();
                
                //create a new interaction if not passed from provider page        
                //if (Interaction == null) 
                if(ApexPages.currentPage().getParameters().get('IsMember ').contains('true')){
                    createInteraction();
                }
                
                acetcon.ReparentCases(Interaction.Id, ACETSRKCaseMap); //SRK code
            }
            else {
                //save member and member family to contact
                createMemberAndFamilyMembers();
                
                //create a new interaction if not passed from provider page        
                //if (Interaction == null) 
                if(ApexPages.currentPage().getParameters().get('IsMember ').contains('true')){
                    createInteraction();
                }
            }        
            Originators = new List<SelectOption>();
            //redirected from provider page, add provider as originator
            if(IsProviderFlow){ 
                if(Interaction.Originator_Type__c == 'Other')
                {
                    originators.add(new SelectOption(Interaction.Third_Party__c, Interaction.Third_Party__r.Name));
                }else if(isGroupFlow)
                {
                   if(Interaction.Third_Party__c != Null)
                   {
                       originators.add(new SelectOption(Interaction.Contact_Name__c, Interaction.Contact_Name__c));
                   }else
                   {
                       if(Interaction != null && Interaction.Originator__c != null)
                           originators.add(new SelectOption(Interaction.Originator__c, Interaction.Originator__r.Name));
                   }       
                }else
                {           
                    if(Interaction != null && Interaction.Originator__c != null)
                        originators.add(new SelectOption(Interaction.Originator__c, Interaction.Originator__r.Name));       
                }
            }else {
                //member flow, add current member and member family
                initMemberOriginators();    
            }               
            }   
            catch(exception e){}
        }                                                      
    }
    public void memberNotFound(){
        Originators = new List<SelectOption>();
        String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
        Interaction = ACETMemberQueryUtil.queryInteraction(interactionId);
        if(memNotFound == '1'){            
            if(Interaction != null && Interaction.Originator__c != null)
                originators.add(new SelectOption(Interaction.Originator__c, Interaction.Originator__r.Name));
            
        }
        system.debug('--------IN MNF----->'+ interaction + '--------->'+memNotFound);
        
        
    }
    
    private void initMemberOriginators(){
        Originators.add(new SelectOption('' , '--None--'));
        //add current member as orignator by default
        //Originators.add(new SelectOption(Subject.Id , Subject.FirstName + ' ' + Subject.LastName));     
        //add other family members
        system.debug(FamilyMembers);
        if(FamilyMembers != null){
            for(Contact fm : FamilyMembers){
                if(fm.Id != Subject.Id){
                    Originators.add(new SelectOption(fm.Id , fm.FirstName + ' ' + fm.LastName));     
                }             
            }            
        } 
        Originators.add(new SelectOption('thirdPartId' , 'Third Party'));  
    }
    
    private void createMemberAndFamilyMembers(){
        String Id = ApexPages.currentPage().getParameters().get('Id');
        String firstName = ApexPages.currentPage().getParameters().get('firstName');
        String lastName = ApexPages.currentPage().getParameters().get('lastName');
        //bhanu jain: Added for populating date of birth for subject : starts
        String dob = ApexPages.currentPage().getParameters().get('subjectdob');
        Date dDOB;
        if(!String.isEmpty(dob)){
            dDOB  = date.parse(dob);
        }
        // Sumit Jain Adding 
        String Params =  ApexPages.currentPage().getParameters().get('vccdParams');
        String Phone ='';
        if(Params != null && Params != ''){ //added by Ranjit to resolve the Member Detail Error
            JSONParser parser = JSON.CreateParser(Params);
            
            While(parser.nextToken() !=null){
               if((Parser.getCurrentToken() == JSONToken.FIELD_Name) && (parser.getText() =='Phone')){
               parser.nexttoken();
               Phone = Parser.getText();
               }
            
            }
        }
        
        // Sumit Jain Closing
         //bhanu jain: Added for populating date of birth for subject : Ends        
        //String recordTypeId = [select Id from RecordType where Name = 'Member'].Id;
        FamilyMembers = new List<Contact>();
        //add subject 
        //if(String.IsEmpty(MemberDetail.SurrogateKey)) { 
        if(1==1) {      
            Subject = new Contact(); 
            Subject.FirstName = firstName;
            Subject.LastName = lastName;
            Subject.EID__c = Id;
            Subject.Birthdate = dDOB;
            Subject.Phone = Phone;
            FamilyMembers.add(Subject);
        } 
        system.debug('2323FamilyMembers' + FamilyMembers);
        system.debug('2323Subject' + Subject);
           
        //adding temporary code for EID flow 
        
       /* if(Subject.EID__c == null && Id == '7293276'){
            Subject.EID__c = '7293276';
            Subject.Phone=Phone; 
        }*/
        
        //add other family members
        if(MemberDetail.FamilyMembers != null){
            for(ACETMemberDetail.FamilyMember fm : MemberDetail.FamilyMembers){
                system.debug('2323fm'+fm);
                system.debug('2323checking duplicate eid'+ fm.EId + '::' + Subject.EID__c);
                if(fm.EId != Subject.EID__c){
                    Contact con = new Contact();
                    con.FirstName = fm.FirstName;
                    con.LastName = fm.LastName;
                    con.EID__c = fm.EID; 
                    Con.Phone = phone;   
                    FamilyMembers.add(con);   
                }             
            } 
            FamilyInfoStr = JSON.serialize(MemberDetail.FamilyMembers);           
        }
        system.debug('232323FamilyMembers :: ' + FamilyMembers);
        
        
        Database.upsert(FamilyMembers, Contact.Fields.EID__c,false);
        FamilyInfo = FamilyMembers;                 
    }
    
    private void createInteraction(){
        
        Interaction = new Interaction__c();
        String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
        Interaction = ACETMemberQueryUtil.queryInteraction(interactionId);  
        Interaction.Originator__c = Subject.Id;
        
        //for now, we only have the use case as member calls themselves
        Interaction.Interaction_Type__c = SourceOriginator;
        Interaction.Originator_Type__c = 'Member';
        
        // Swetha
        Interaction = ACETVCCDUtility.populateVCCDInfo(Interaction);
                   
        //Insert Interaction;
        Update Interaction; 
        Interaction = ACETMemberQueryUtil.queryInteraction(Interaction.Id);
        system.debug('Interaction:::'+Interaction);
    }
      
    //Start: User Story - US605469, added isshowAlert
    private void initHighlightPanelAdditionalInfo(boolean isshowALert){
        isshowGroupALert = isshowALert; 
        if(AdditionalInfo == null){
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        } 
        system.debug('----Interaction:::--->'+Interaction);       
        if(memNotFound != '1') 
        {           
        AdditionalInfo.GroupNumber = MemberDetail.PreferredCoverage != null ? MemberDetail.PreferredCoverage.GroupNumber : '';
        AdditionalInfo.Relationship = MemberDetail.Relationship;    
        AdditionalInfo.SitusState = MemberDetail.SitusState;
        AdditionalInfo.DOB = MemberDetail.DOB;
        AdditionalInfo.BenefitPlanId = MemberDetail.BenefitPlanId;
        AdditionalInfo.EndDate = MemberDetail.EndDate;
        AdditionalInfo.EffectiveDate = MemberDetail.EffectiveDate;
        AdditionalInfo.PolicyNumber = MemberDetail.PolicyNumber;
        AdditionalInfo.Product = MemberDetail.Product;
        AdditionalInfo.ProductType = MemberDetail.ProductType;   
        AdditionalInfo.Network = MemberDetail.Network;
        AdditionalInfo.Gender = MemberDetail.Gender;
        AdditionalInfo.FirstName = MemberDetail.FirstName;
        AdditionalInfo.LastName = MemberDetail.LastName;
        AdditionalInfo.MemberId = MemberDetail.MemberId;
        AdditionalInfo.OriginatorRelationship = MemberDetail.OriginatorRelationship;
        AdditionalInfo.IsMember = ApexPages.currentPage().getParameters().get('IsMember ');//added by Vishakha
        string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if(addInfo != null)
        {
           ACETHighlightsPanelAdditionalInfo AdditionalInfoData  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
           AdditionalInfo.producerName = AdditionalInfoData.producerName;
           AdditionalInfo.providerType  = AdditionalInfoData.providerType;//added by Vishakha
        }
       // Subject.EID__c= Memberdetail.memberid; //addeedd by Prakash
       /******added by sourabh ****/
       system.debug('Interaction:::'+Interaction);
        if(Interaction != null && Interaction.Highlight_Panel_GroupInfo__c != null)
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
             
        }
        }else if(interaction != null && memNotFound == '1') 
        {           
            system.debug('----AdditionalInfo:::---->'+Interaction +'---->'+Interaction.Originator__r.MailingState);
            //AdditionalInfo.Interaction = Interaction;
            AdditionalInfo.FirstName = Interaction.Originator__r.FirstName;
            AdditionalInfo.LastName = Interaction.Originator__r.LastName;
            AdditionalInfo.EmployerName = Interaction.Originator__r.Account.Name;
            AdditionalInfo.GroupNumber = Interaction.Id__c;
            AdditionalInfo.Zip = Interaction.Originator__r.MailingPostalCode;
            AdditionalInfo.DOB = string.valueof(Interaction.Originator__r.Birthdate);
            AdditionalInfo.State = Interaction.Originator__r.MailingState;
            AdditionalInfo.PhoneNumber = Interaction.Originator__r.Phone;   
            
            MemberDetail = new ACETMemberDetail();
            MemberDetail.FirstName = Interaction.Originator__r.FirstName;
            MemberDetail.LastName = Interaction.Originator__r.LastName;
            EmployerName = Interaction.Originator__r.Account.Name;
            GroupNumber = Interaction.Id__c;
            Zip = Interaction.Originator__r.MailingPostalCode;
            State = Interaction.Originator__r.MailingState;
            MemberDetail.Dob = string.valueof(Interaction.Originator__r.Birthdate);
            phonenum= Interaction.Originator__r.Phone;
            if(MemberDetail != null){       
                MemberDetailResultJson =   json.serialize(MemberDetail); 
            }
        }   
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
        
        
    }

    public void updateThirdParty(){
    }
    
    public List<SelectOption> getCallTopicOptions(){
        List<SelectOption> CallTopics = new List<SelectOption>();
        string memNtFnd = ApexPages.currentPage().getParameters().get('mnf');
        if(memNtFnd != '1')
            CallTopics = ACETCallTopicsPicklistUtility.getCallTopicOptions('Member Detail', Interaction.Originator_Type__c);
        else
            CallTopics = ACETCallTopicsPicklistUtility.getCallTopicOptions('Member Not Found', 'Member');
        return CallTopics;
    }
    
    public void toggleShowPrimaryPhysician(){
        if(IsShowActivePhysiciansOnly == null){
            IsShowActivePhysiciansOnly = true;   
        }else{
            IsShowActivePhysiciansOnly = !IsShowActivePhysiciansOnly;
        }
        
        lstPrimaryCarePhysicianWrapper = new list<PrimaryCarePhysicianWrapper>();
       
        PrimaryCarePhysicianWrapper objPrimaryCarePhysician = new PrimaryCarePhysicianWrapper();
        objPrimaryCarePhysician.isActive = true;
          objPrimaryCarePhysician.firstName = 'Test1';
          objPrimaryCarePhysician.lastName = 'Test';
          objPrimaryCarePhysician.pcpAssignmentType = 'Primary Care Physician';
          objPrimaryCarePhysician.effectiveDate = '01/10/2016';
          objPrimaryCarePhysician.endDate = '01/10/2016';
         lstPrimaryCarePhysicianWrapper.add(objPrimaryCarePhysician);
    } 
    
    public void selectPrimaryPhysician(){
        
        IsShowActivePhysiciansOnly = False;
        lstPrimaryCarePhysicianWrapper = new list<PrimaryCarePhysicianWrapper>();
       
        PrimaryCarePhysicianWrapper objPrimaryCarePhysician = new PrimaryCarePhysicianWrapper();
        objPrimaryCarePhysician.isActive = true;
          objPrimaryCarePhysician.firstName = 'Test1';
          objPrimaryCarePhysician.lastName = 'Test';
          objPrimaryCarePhysician.pcpAssignmentType = 'Primary Care Physician';
          objPrimaryCarePhysician.effectiveDate = '01/10/2016';
          objPrimaryCarePhysician.endDate = '01/10/2016';
          
          PrimaryCarePhysicianWrapper objPrimaryCarePhysician1 = new PrimaryCarePhysicianWrapper();
          objPrimaryCarePhysician1.isActive = false;
          objPrimaryCarePhysician1.firstName = 'Test1';
          objPrimaryCarePhysician1.lastName = 'Test';
          objPrimaryCarePhysician1.pcpAssignmentType = 'OBYGN';
          objPrimaryCarePhysician1.effectiveDate = '02/10/2016';
          objPrimaryCarePhysician1.endDate = '02/10/2016';
          lstPrimaryCarePhysicianWrapper.add(objPrimaryCarePhysician);
         lstPrimaryCarePhysicianWrapper.add(objPrimaryCarePhysician1);
    } 
    
    //Added by sumit
    public class PrimaryCarePhysicianWrapper{
      public string firstName{get;set;}
      public string lastName{get;set;}
      public string pcpAssignmentType{get;set;}
      public string effectiveDate{get;set;}
      public string endDate{get;set;}
      public boolean isActive{get;set;}
    }   
    public class ROIWrapper{
        public boolean isActive{get;set;} 
        public string firstName{get;set;}
        public string lastName{get;set;}
        public string middleIntial{get;set;}
        public string effectiveDate{get;set;}
        public string terminateDate{get;set;}
        public string ROIDoc{get;set;}
    }
    public void ROIWrapperRecordsCreator(){
        system.debug('--------Subject------>'+ Subject);
        if(Subject != null && Subject.LastName == 'Grimm'){
            lstROIWrapper = new list<ROIWrapper>();
           
            ROIWrapper objROI = new ROIWrapper();
            objROI.isActive = true;
            objROI.firstName = 'Warner';
            objROI.lastName = 'Test';
            objROI.middleIntial = 'Bill';
            objROI.effectiveDate = '01/10/2016';
            objROI.terminateDate = '04/10/2016';
            lstROIWrapper.add(objROI);
            
            ROIWrapper objROI2 = new ROIWrapper();
            objROI2.isActive = false;
            objROI2.firstName = 'Beck';
            objROI2.lastName = 'Test';
            objROI2.middleIntial = 'Konrad';
            objROI2.effectiveDate = '02/10/2016';
            objROI2.terminateDate = '05/10/2016';
            lstROIWrapper.add(objROI2);
        }
    } 
    
    //Start: User Story - US605469
    public object CallGetMembership(){
        Continuation continuationInst; 
        system.debug('inside call membership');
        if(PreferredCoverage != null){
            if(!String.IsEmpty(MemberDetail.SurrogateKey)) {
                ACETGetMemWebservice = new ACETGetMembershipWebService();
                continuationInst = ACETGetMemWebservice.StartRequest(MemberDetail.SurrogateKey,MemberDetail.PreferredCoverage.groupNumber, MemberDetail,'GetMembershipCallback',null);
                
                 //GetFamilyMembership webservice callout
                 String Id = ApexPages.currentPage().getParameters().get('Id');
                 ACETGetFamMemWebservice = new ACETGetFamilyMemberWebService();
                 continuationInst = ACETGetFamMemWebservice.StartRequest(Id, MemberDetail,'GetMembershipCallback',continuationInst);
                 
            }else{
                system.debug('inside call get member id membership');
                ACETGetMemWebservice = new ACETGetMembershipWebService();
                continuationInst = ACETGetMemWebservice.StartRequest(MemberDetail.MemberId, PreferredCoverage.PolicyNumber, MemberDetail,'GetMembershipCallback',null);
            }
        }
        return  continuationInst;
    }
    public PageReference GetMembershipCallback() {
        system.debug('inside call bacl method'); 
        ACETWSCalloutResult getMemCalloutResults;
        ACETWSCalloutResult getFamMemCalloutResults;
        getMemCalloutResults = ACETGetMemWebservice.ProcessResponse(ACETGetMemWebservice.RequestLabel, MemberDetail);
        system.debug('inside call bacl method' + getMemCalloutResults); 
        if(getMemCalloutResults.Success) {
          MemberDetail = (ACETMemberDetail)getMemCalloutResults.Response;
          
          //Added by Avish on 06072017 for User story US652217
         BundleOptionID =  MemberDetail.BundleOptionID;
         system.debug(LoggingLevel.INFO,'MemberDetail.BenefitPlanId:: ' + MemberDetail.BenefitPlanId + ' ::BundleOptionID :: ' + BundleOptionID);          
        }
        else{
                system.debug('getFamMemCalloutResults'+getMemCalloutResults);
                ApexPages.addMessage(new ApexPages.Message(getMemCalloutResults.MessageSeverity,'Error occured in one of the Services, Please contact administrator.'));
            }
        system.debug('232323Continuation:::getMemCalloutResults'+MemberDetail);
       // PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        //pageRef.setRedirect(true);
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
            system.debug('232323 memberDetail'+memberDetail);
        }
            getFamMemCalloutResults = ACETGetFamMemWebservice.ProcessResponse(ACETGetFamMemWebservice.RequestLabel, MemberDetail);
            if(getFamMemCalloutResults.Success) {
                              system.debug('>>>>>>> >>>>>> '+MemberDetail);
              MemberDetail = (ACETMemberDetail)getFamMemCalloutResults.Response;
              familymemberRelatioshipMap = new Map<String,String>();
              for(ACETMemberDetail.FamilyMember fm : MemberDetail.FamilyMembers){
                familymemberRelatioshipMap.put(fm.eid,fm.RelationShip);
              }
              
            }
            else{
                system.debug('getFamMemCalloutResults'+getFamMemCalloutResults);
                ApexPages.addMessage(new ApexPages.Message(getFamMemCalloutResults.MessageSeverity,getFamMemCalloutResults.Message));
            }
        
        MemberDetailResultJson =   json.serialize(MemberDetail);
        initInteractionAndSubject(); 
        initHighlightPanelAdditionalInfo(false);
        return null;
    }
    public Object CallWSonPageLoad()
    {
        memNotFound = ApexPages.currentPage().getParameters().get('mnf');
       memNotFound = '0';
        Continuation PageLoadContinuation;
        if(memNotFound == '1'){
            memberNotFound();
        }
        if(memNotFound != '1'){
            MemberDetail = new ACETMemberDetail(); 
            String Id = ApexPages.currentPage().getParameters().get('Id');
            MemberDetail.SurrogateKey = ApexPages.currentPage().getParameters().get('SRK');
            //GetIndividual webservice callout
            if(!String.isEmpty(MemberDetail.SurrogateKey)){
                    ACETGetIndWebservice = new ACETGetIndividualWebService();
                    PageLoadContinuation = ACETGetIndWebservice.StartRequest(MemberDetail.SurrogateKey, MemberDetail,'CallWSonPageLoadCallback',null);  
            }
            else{
                    ACETGetIndWebservice = new ACETGetIndividualWebService();
                    PageLoadContinuation = ACETGetIndWebservice.StartRequest(Id, MemberDetail,'CallWSonPageLoadCallback',null);
            }
            //FindMembership webservice callout
             if(!String.isEmpty(MemberDetail.SurrogateKey)){
                    ACETFindMemWebservice = new ACETFindMembershipWebservice();
                    PageLoadContinuation = ACETFindMemWebservice.StartRequest(MemberDetail.SurrogateKey, MemberDetail,'CallWSonPageLoadCallback',PageLoadContinuation); 
             }else{
                
                    ACETFindMemWebservice = new ACETFindMembershipWebservice();
                    PageLoadContinuation = ACETFindMemWebservice.StartRequest(Id, MemberDetail,'CallWSonPageLoadCallback',PageLoadContinuation);    
             } 
             //GetFamilyMembership webservice callout
             /*
             ACETGetFamMemWebservice = new ACETGetFamilyMemberWebService();
             PageLoadContinuation = ACETGetFamMemWebservice.StartRequest(Id, MemberDetail,'CallWSonPageLoadCallback',PageLoadContinuation);
             */
         }
          return PageLoadContinuation; 
    }
    public PageReference CallWSonPageLoadCallback() {
        memNotFound = ApexPages.currentPage().getParameters().get('mnf');
        if(memNotFound != '1'){ 
            ACETWSCalloutResult getIndCalloutResults;
            ACETWSCalloutResult findMemCalloutResults;
            ACETWSCalloutResult getFamMemCalloutResults;
            getIndCalloutResults = ACETGetIndWebservice.ProcessResponse(ACETGetIndWebservice.RequestLabel, MemberDetail);
            if(getIndCalloutResults.Success) {
              MemberDetail = (ACETMemberDetail)getIndCalloutResults.Response;
            }
            else{
                system.debug('getIndCalloutResults'+getIndCalloutResults);
                ApexPages.addMessage(new ApexPages.Message(getIndCalloutResults.MessageSeverity,'Error occured in one of the Services, Please contact administrator.'));
            }
            
            findMemCalloutResults = ACETFindMemWebservice.ProcessResponse(ACETFindMemWebservice.RequestLabel, MemberDetail);
            if(findMemCalloutResults.Success) {
              MemberDetail = (ACETMemberDetail)findMemCalloutResults.Response;
            }
            else{
                system.debug('findMemCalloutResults'+findMemCalloutResults);
                ApexPages.addMessage(new ApexPages.Message(findMemCalloutResults.MessageSeverity,findMemCalloutResults.Message));
            }
            /*getFamMemCalloutResults = ACETGetFamMemWebservice.ProcessResponse(ACETGetFamMemWebservice.RequestLabel, MemberDetail);
            if(getFamMemCalloutResults.Success) {
              MemberDetail = (ACETMemberDetail)getFamMemCalloutResults.Response;
            }
            else{
                system.debug('getFamMemCalloutResults'+getFamMemCalloutResults);
                ApexPages.addMessage(new ApexPages.Message(getFamMemCalloutResults.MessageSeverity,getFamMemCalloutResults.Message));
            }*/
            system.debug('Continuation:::MemberDetail'+MemberDetail);
            
        }     
        initHighlightPanelAdditionalInfo(true);
        toggleShowCoverages();
        if(memNotFound != '1'){
            createConsumerDashURL();        
            toggleShowPrimaryPhysician();
            ROIWrapperRecordsCreator(); 
            if(isGroupFlow == true){
                getNoOfMemAlert();
            }
            if(MemberDetail.ROIcontacts != null){
                if(MemberDetail.ROIcontacts.size() != 0){
                    isROI = true;   
                }
                    
            }
            
        }
        if(MemberDetail != null){
            MemberDetailResultJson =   json.serialize(MemberDetail);    
        }
       
             
        return null; 
    }
    //End: User Story - US605469   
    
    //US635546-SNI
    public PageReference saveCaseOnSubmit()
        {
            if(caseMid != null)
            {
                caseMid = new Case();
            }
            if(caseTopic != null && (!caseTopic.trim().startsWith('_')))
            {
                caseMid.Topic__c = caseTopic;
            }
            
            if(caseType != null && (!caseType.trim().startsWith('_')))
            {
                caseMid.Type__c = caseType;
            }
            
            if(caseSubType != null && (!caseSubType.trim().startsWith('_')))
            {
                caseMid.Subtype__c = caseSubType;
            }
            
            if(MemberDetail != null)
            {
                
                if(MemberDetail.PreferredCoverage != null)
                {
                    caseMid.Policy_Number__c = MemberDetail.PreferredCoverage.GroupNumber;
                }
                
                System.debug('vinay '+MemberDetail.PreferredCoverage);
                if(MemberDetail.PreferredCoverage != null)
                {
                    caseMid.Source_Code__c = MemberDetail.PreferredCoverage.SourceCode;
                }
                System.debug('vinay '+MemberDetail.DOB);
                
                caseMid.DOB__c = MemberDetail.DOB;
                

                caseMid.Subject_Name__c = ApexPages.currentPage().getParameters().get('firstName') + ApexPages.currentPage().getParameters().get('lastName');
                
               
            }
            
            if(originator != null && (Id.valueOf(originator).getSObjectType() == Schema.Contact.sObjectType))
            {
                caseMid.ContactId = originator;
                Contact caseCon = [SELECT AccountId,contact_type__c From Contact WHERE Id = :originator LIMIT 1];
                if(caseCon != null)
                {
                    caseMid.AccountId = caseCon.AccountId;
                    caseMid.Subject_Type__c = caseCon.contact_type__c;
                }
            }
            
            caseMid.Surrogate_Key__c  =   ApexPages.currentPage().getParameters().get('SRK');
            
            String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
            
            if(interactionId != null && (Id.valueOf(interactionId).getSObjectType() == Schema.Interaction__c.sObjectType))
            {
                caseMid.Interaction__c = interactionId;
            }
            upsert new Interaction__c(Id=interactionId, Source_Application__c = 'ISET');
            System.debug('vinay '+caseMid.DOB__c);
            insert caseMid;
            System.debug('vinay '+[SELECT ID, DOB__c FROM Case WHERE Id=:caseMid.ID].DOB__c);
            return new PageReference('/' + caseMid.Id);
        }
}