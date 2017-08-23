public class ACETIdCardRequestController{
    public Interaction__c Interaction { get; set; }
    public Contact Subject { get; set; } 
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}
    public string memberId{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public string familyMember{get;set;}
    public List<SelectOption> familyMembers{get;set;}
    public List<ACETMemberDetail.FamilyMember> FamilyInfo {get;set;}
    public personWrapper memDetailWrap{get;set;}
    public List<ACETFormsHistoryResult>  formshistory{ set; get; }
    public string serviceName;
    ACETGetMembershipWebService ACETGetMemWebService;
    ACETGetIndividualWebService ACETGetIndWebservice;
    ACETMemberDetail memberDetail;
    public map<string,personWrapper> familyMemMap;
    public string reponseMessage{get;set;}
    public string correlationID{get;set;}
        
    public  ACETIdCardRequestController()
    {
        memDetailWrap = new PersonWrapper();
        memberId = apexpages.currentpage().getparameters().get('memberId');
        String InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        string familyInfoStr = apexpages.currentpage().getparameters().get('familyMembers');
        string subjectId= apexpages.currentpage().getparameters().get('contactId');
        string groupId= apexpages.currentpage().getparameters().get('groupId');
        familyMemMap = new map<string,personWrapper>();
        memberDetail = new ACETMemberDetail();
        
        familyMembers = new List<SelectOption>();
        familyMembers.add(new SelectOption('--None--','--None--'));
        system.debug('familyInfo--->'+familyInfoStr);
        if(subjectId != Null)
        {
             Subject = ACETMemberQueryUtil.queryContact(subjectId);
        }
        if(InteractionId != null && InteractionId != '')
        {
            Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        }
        if(familyInfoStr != null  && familyInfoStr != '')
        {   
            FamilyInfo= (list<ACETMemberDetail.FamilyMember>)JSON.deserialize(familyInfoStr,list<ACETMemberDetail.FamilyMember>.class);
            system.debug('familyInfo--->'+familyInfo);
        }
        if(FamilyInfo != Null)
        {
           for(ACETMemberDetail.FamilyMember fm : FamilyInfo){
               familyMembers.add(new SelectOption(fm.FirstName + ' ' + fm.LastName, fm.FirstName + ' ' + fm.LastName)); 
               map<String,ACETMemberDetail.Address> mapAddress = new map<String,ACETMemberDetail.Address>();
               PersonWrapper TempMemDetailWrap = new PersonWrapper();
               system.debug('fm.Addresses--->'+fm.Addresses);   
               if(fm.Addresses != null){         
                   for(ACETMemberDetail.Address address : fm.Addresses){
                       mapAddress.put(address.AddressType , address);      
                   }
               }
               system.debug('mapAddress--->'+mapAddress); 
               if(mapAddress.get('Mailing') != null){ 
                    TempMemDetailWrap.personAddOne = mapAddress.get('Mailing').AddressLine1;
                    TempMemDetailWrap.personAddTwo = mapAddress.get('Mailing').AddressLine2;
                    TempMemDetailWrap.personCity = mapAddress.get('Mailing').City;
                    TempMemDetailWrap.personState = mapAddress.get('Mailing').State;
                    TempMemDetailWrap.personZipCode = mapAddress.get('Mailing').Zip;
               }
               else if(mapAddress.get('HOM') != null){ 
                    TempMemDetailWrap.personAddOne = mapAddress.get('HOM').AddressLine1;
                    TempMemDetailWrap.personAddTwo = mapAddress.get('HOM').AddressLine2;
                    TempMemDetailWrap.personCity = mapAddress.get('HOM').City;
                    TempMemDetailWrap.personState = mapAddress.get('HOM').State;
                    TempMemDetailWrap.personZipCode = mapAddress.get('HOM').Zip;
               }
               TempMemDetailWrap.personFirstName = fm.FirstName;
               TempMemDetailWrap.personMiddleName = fm.MiddleInitial;
               TempMemDetailWrap.PersonLastName = fm.LastName;
               TempMemDetailWrap.PersonSuffix = fm.suffix;
               TempMemDetailWrap.personFullName = fm.FirstName+' '+fm.LastName;
               TempMemDetailWrap.groupNumber = fm.groupNumber;
               TempMemDetailWrap.benefitBundleOptionID = fm.benefitBundleOptionId;
               TempMemDetailWrap.memberId = fm.EID;
               system.debug('familyMemMap--->'+familyMemMap); 
               familyMemMap.put(fm.FirstName + ' ' + fm.LastName,TempMemDetailWrap);
           }    
        }
        system.debug('familyMemMap--->'+familyMemMap);   
        initHighlightPanelAdditionalInfo();
        init();
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
    
    public void init(){
        //isClaim = true;
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'ID Card Request';
       // toggleShowPlanBenefits();
    }
    
    public void getPersonInfo()
    {
        if(familyMemMap != null && familyMemMap.containsKey(familyMember))
        {    
            memDetailWrap = familyMemMap.get(familyMember);
        }
        formshistory = new List<ACETFormsHistoryResult>();
        
        ACETFormsHistoryWebService formsHistoryWebService = new ACETFormsHistoryWebService();
        formsHistoryWebService.init('ACET',Integer.ValueOf(label.ACETIDCardDocumentType),String.valueOf(system.today().addDays(-30).format()),String.valueOf(system.today().format()),String.valueOf(memDetailWrap.memberId),'MemberID'); //String.valueOf(memDetailWrap.memberId)  '23831817900'  
        ACETWSCalloutResult searchResult =  formsHistoryWebService.queryPaginatedData(1,1,1);
        system.debug('searchResult------'+searchResult.Response);
        if(searchResult.Response != null)
        {
            formshistory.addAll( (List<ACETFormsHistoryResult>) searchResult.Response);
        }
    
    }
    
    public void submitOrderCall()
    {
        ACETSubmitfulfillmentrequest submitRequestWS = new ACETSubmitfulfillmentrequest();
        ACETWSCalloutResult WSReponse = submitRequestWS.submitFulfillmentRequest(memDetailWrap.memberId,memDetailWrap.groupNumber,memDetailWrap.benefitBundleOptionID);
        if(WSReponse.Success)
        {
            reponseMessage = 'Successfully submitted the request. '+string.valueOf(WSReponse.Response);
            system.debug('WSReponse.Response------'+WSReponse.Response);
        }else
        {
            reponseMessage = 'Web Service or External System is temporarily unavailable.';
        }
    
    }
    
    public class personWrapper{
        public String personOrganization{get;set;}
        public String personFirstName{get;set;}
        public String personMiddleName{get;set;}
        public String personLastName{get;set;}
        public String personFullName{get;set;}
        public String personSuffix{get;set;}
        public String personAddOne{get;set;}
        public String personAddTwo{get;set;}
        public String personCity{get;set;}
        public String personState{get;set;}
        public String personZipCode{get;set;}
        public string groupNumber{get;set;}
        public string benefitBundleOptionID{get;set;}
        public string memberId{get;set;}
        
    }
}