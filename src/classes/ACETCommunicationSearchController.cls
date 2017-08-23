public with sharing class ACETCommunicationSearchController{
    
    public String deliveryresult { get; set; }
    public String documentType {get; set;}
    public String selectAddress{get;set;}
    public string Commhistorytitle{get;set;}
    
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    
    public List<SelectOption> documentTypeOptions {get; set;}
    
    public List<String> listDummyString {get;set;}
    
    public List<Document_Type__mdt> listDocumentType {get; set;}
    public List<Document_Type_Search_By_Field__mdt> listSearchFilter {get; set;}
    public List<Document_Type_Search_Result_Fields__mdt> listSearchResults {get; set;}
    
    public Map<String,String> mapLableToAPIName {get; set;}

    public Boolean ShowSearchResult{get;set;}
    public Boolean showPopUPAddress{get;set;}
    public Boolean selectAll {get; set;}
    public Boolean showSearchField {get; set;}
    public Boolean chooseAddress{get;set;}//Vishakha
    public Boolean showBulkResend{get;set;}//Vishakha
    public Boolean showSubmitBtnAOF{get;set;}//Vishakha 
    public Boolean showHistory{get;set;}
    public Boolean selectRecord{get;set;} //Akhila
    public Boolean showOriginatorMsg{get;set;}
    
    public list<ACETCommunicationSearchResult> resWrapper{get;set;}//vishakha
    public list<ACETCommunicationSearchResult> selectedResWrapper{get;set;}//Vishakha
    public list<ACETCommunicationHistoryResult> Commhistory{get;set;}
    
    public personWrapper AddOnFilePersonWrap{get;set;}
    
    public String personOrganizationAA{get;set;}
    public String personFirstNameAA{get;set;}
    public String personMiddleNameAA{get;set;}
    public String personLastNameAA{get;set;}
    public String personSuffixAA{get;set;}
    public String personAddOneAA{get;set;}
    public String personAddTwoAA{get;set;}
    public String personCityAA{get;set;}
    public String personStateAA{get;set;}
    public String personZipCodeAA{get;set;}
    
    public string recepientId{get;set;}
    
    public string personWrapString{get;set;}
    
    public String DOC_CONTENT_TYPE {get;set;}
    public String IS_DOC_SIZE_MORE_THAN_ONE_MB {get;set;}
    
    public ACETHighlightsPanelAdditionalInfo AdditionalInfoData{get;set;}
    
    public Interaction__c Interaction{get;set;} 
    public map<String,ACETCommunicationSearchResult> mapFullComSearResult = new map<string,ACETCommunicationSearchResult>();
    
    public void init(){
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'Communications';//Vishakha
         String strSurrogateKey = apexpages.currentpage().getparameters().get('SRK');
        wrapper.SurrogateKey = strSurrogateKey;
    }
    
    //Constructor Class
    public ACETCommunicationSearchController(){
        
        ShowSearchResult=false;
        showSearchField = false;
        showPopUPAddress = false;
        showBulkResend = false;
        selectAll  = false;
        selectRecord = false;
        showOriginatorMsg = false;//Vishakha
        showHistory = false;
        selectAddress = 'AddressOnFile';
        
        DOC_CONTENT_TYPE = 'DocumentContentType';
        IS_DOC_SIZE_MORE_THAN_ONE_MB = 'IsDocSizeMoreThanOneMB';
        
        
        AddOnFilePersonWrap = new PersonWrapper();
        personWrapString = '';
        
        
        documentTypeOptions = new List<SelectOption>();
        listSearchFilter = new List<Document_Type_Search_By_Field__mdt>();
       
        
        Interaction = ACETMemberQueryUtil.queryInteraction(ApexPages.currentPage().getParameters().get('InteractionId'));
        
        listDocumentType = [SELECT Id,Order__c,Document_Type__c,workflow__c FROM Document_Type__mdt order By DeveloperName asc];
        
        documentTypeOptions.add(new SelectOption('-None-','--None--'));
        for(Document_Type__mdt mdtDocType :listDocumentType){
            documentTypeOptions.add(new SelectOption(mdtDocType.Document_Type__c,mdtDocType.Document_Type__c ));
            
        }
        
        string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if(addInfo != null){
            AdditionalInfoData  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
        system.debug('AdditionalInfoData---->'+AdditionalInfoData);

    }
    
    public Pagereference updateSingledocstatus(){
        
        String selectedDocId = ApexPages.currentPage().getParameters().get('selectedDocId');
        String status = ApexPages.currentPage().getParameters().get('status');
        String resDate = ApexPages.currentPage().getParameters().get('resDate');
        
        for(ACETCommunicationSearchResult var:resWrapper ){
            if(documentType.equalsIgnoreCase('Member EOB') && var.Document_ID.equalsIgnoreCase(selectedDocId) ){
                var.Resend_Date_Time = resDate;
                var.Resend_Status = status;
            }
            else if(documentType.equalsIgnoreCase('Provider PRA') && var.Document_ID_PRA.equalsIgnoreCase(selectedDocId)){
                var.Resend_Date_Time = resDate;
                var.Resend_Status = status;
            }
            else if(documentType.equalsIgnoreCase('SBC') && var.Document_ID_SBC.equalsIgnoreCase(selectedDocId)){
                var.Resend_Date_Time = resDate;
                var.Resend_Status = status;
            }
        }
        return null;
        
    }  
    
    public void search(){
        ShowSearchResult=false;
        resWrapper = new list<ACETCommunicationSearchResult>();//Vishakha 
        
        if(documentType != null){
            ShowSearchResult=true;
            listSearchResults = [SELECT Id,DeveloperName,label, DocumentType__r.Document_Type__c, Search_By_Field_Name__c,Order__c FROM Document_Type_Search_Result_Fields__mdt WHERE DocumentType__r.Document_Type__c =:documentType Order By Order__c asc ];            
            
            if(documentType.equalsIgnoreCase('Member EOB')){ // EOB
                for(Integer i=0; i<12 ;i++){
                ACETCommunicationSearchResult result = new ACETCommunicationSearchResult();
                result.Document_ID = 'Doc12345'+ Integer.valueof(i);
                result.organization = 'Oxford';
                result.Funding_Type = 'ASO';
                result.Document_Class = 'Test';
                result.Member_Id = '123456789';
                result.EOB_Date = string.valueof(system.today());
                result.policy_Number  = '987654321';
                result.Member_Name = 'Steve Gill';
                
                resWrapper.add(result);
                //mapFullComSearResult.put(result.Document_ID,result);
                }
                
                //hard-code records for testing, pending findDocument service be ready
                resWrapper[0].Document_ID = '0902b1fc800d990d';
                resWrapper[0].DocumentContentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
                resWrapper[0].IsDocSizeMoreThanOneMB = false;
                
                resWrapper[1].Document_ID = '0902b1fc800c1f2b';
                resWrapper[1].DocumentContentType = 'application/pdf';
                resWrapper[1].IsDocSizeMoreThanOneMB = false;
                
                resWrapper[2].Document_ID = '0902b1fc800d92b8';
                resWrapper[2].DocumentContentType = 'text/plain';
                resWrapper[2].IsDocSizeMoreThanOneMB = false;
                
                resWrapper[3].Document_ID = '0902b1fc800d95ba';
                resWrapper[3].DocumentContentType = 'image/jpeg';
                resWrapper[3].IsDocSizeMoreThanOneMB = false;
                                
                resWrapper[4].Document_ID = '0902b1fc800c1dd0';
                resWrapper[4].DocumentContentType = 'application/pdf';
                resWrapper[4].IsDocSizeMoreThanOneMB = false;
                
                resWrapper[5].Document_ID = '0902b1fc801297ae';
                resWrapper[5].DocumentContentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
                resWrapper[5].IsDocSizeMoreThanOneMB = false;
                
                resWrapper[6].Document_ID = '0902b1fc801297ad';
                resWrapper[6].DocumentContentType = 'application/pdf';
                resWrapper[6].IsDocSizeMoreThanOneMB = false;
                
                resWrapper[7].Document_ID = '0902b1fc801297af';
                resWrapper[7].DocumentContentType = 'text/plain';
                resWrapper[7].IsDocSizeMoreThanOneMB = false;
                
                resWrapper[8].Document_ID = '0902b1fc801297b0';
                resWrapper[8].DocumentContentType = 'image/jpeg';
                resWrapper[8].IsDocSizeMoreThanOneMB = false;
                
                resWrapper[9].Document_ID = '0902b1fc801297b1';
                resWrapper[9].DocumentContentType = 'application/msword';
                resWrapper[9].IsDocSizeMoreThanOneMB = true;
                
                resWrapper[10].Document_ID = '0902b1fc801297b2';
                resWrapper[10].DocumentContentType = 'text/plain';
                resWrapper[10].IsDocSizeMoreThanOneMB = true;
                
                resWrapper[11].Document_ID = '0902b1fc80129fe2';
                resWrapper[11].DocumentContentType = 'image/jpeg';
                resWrapper[11].IsDocSizeMoreThanOneMB = true;
                //hard-code records for testing, pending findDocument service be ready
                
            } else if(documentType.equalsIgnoreCase('Provider PRA')){ // PRA
                for(Integer i=0; i<4 ;i++){
                    ACETCommunicationSearchResult result = new ACETCommunicationSearchResult();
                    result.Document_ID_PRA = 'Doc12345'+ Integer.valueof(i);
                    result.organization = 'Oxford';
                    result.Funding_Type = 'ASO';
                    result.Document_Class = 'Test';
                    result.Tax_ID = 'Test';
                    result.PRA_Date = string.valueof(system.today());
                    result.Document_Class = 'Test';
                    result.Check_EFT_Number = 'Test';
                    result.Series_Designator  = '987654321';
                    result.Payee_Name = 'Jhon Mark';
                    result.Member_ID_PRA = '987654321';
                    resWrapper.add(result);
                    //mapFullComSearResult.put(result.Document_ID_PRA,result);
                }
            
            } else if(documentType.equalsIgnoreCase('SBC')){ // SBC
                for(Integer i=0; i<4 ;i++){
                    ACETCommunicationSearchResult result = new ACETCommunicationSearchResult();
                    result.Document_ID_SBC = 'Doc12345'+ Integer.valueof(i);
                    result.organization_SBC = 'Oxford';
                    result.Funding_Type_SBC = 'ASO';
                    result.Employer_Group_Name_SBC = '123456789';
                    result.Policy_Start_Date_SBC = string.valueof(system.today());
                    result.Policy_End_Date_SBC = string.valueof(system.today());
                    result.policy_Number_SBC  = '987654321';
                    resWrapper.add(result);
                   // mapFullComSearResult.put(result.Document_ID_SBC,result);
                }
            } else if(documentType.equalsIgnoreCase('TEST')){ // Test
                for(Integer i=0; i<1 ;i++){
                    ACETCommunicationSearchResult result = new ACETCommunicationSearchResult();
                    result.Document_ID_Test = 'Doc12345'+ Integer.valueof(i);
                    result.Funding_Type_Test = 'Oxford';
                    result.Organization_Test = 'ASO';
                    result.Policy_Number_Test = '123456789';
                    result.Tax_ID_Test = '123456789';
                    resWrapper.add(result);
                    
                }
            }
        }
        
        
        system.debug('resWrapper---->'+resWrapper);    
        if(resWrapper.size() == 1){
           resWrapper[0].selectRecord = true;
        }
        //showbulkResend();
    }
   
    public PageReference clear(){
        documentType = '';
        showHistory = false;
        ShowSearchResult = false;
        if(resWrapper != null){
            resWrapper.clear();
        }
        updateSearchField();
        listSearchFilter = new List<Document_Type_Search_By_Field__mdt>();
        return null;
    }
    
    public Pagereference resend(){
        showPopUPAddress = true;
        chooseAddress = true;
        selectAddress = 'AddressOnFile';
        personFirstNameAA = AddOnFilePersonWrap.personFirstName;
        personMiddleNameAA = AddOnFilePersonWrap.personMiddleName;
        personLastNameAA = AddOnFilePersonWrap.personLastName;
        personSuffixAA = AddOnFilePersonWrap.personSuffix;
        personAddOneAA = AddOnFilePersonWrap.personAddOne;
        personAddTwoAA = AddOnFilePersonWrap.personAddTwo;
        personCityAA = AddOnFilePersonWrap.personCity;
        personStateAA = AddOnFilePersonWrap.personState;
        personZipCodeAA = AddOnFilePersonWrap.personZipCode;
        personOrganizationAA = AddOnFilePersonWrap.personOrganization;
        return null;
    }
    
    public Pagereference showbulkResend(){
        list<String> selectedDocId = (List<String>)JSON.deserialize(ApexPages.currentPage().getParameters().get('docId'),list<string>.class);
        system.debug('selectedDocId--->'+selectedDocId);
        showHistory = true;
        selectedResWrapper = new list<ACETCommunicationSearchResult>();
        
        for(String str : selectedDocId){
            for(ACETCommunicationSearchResult var : resWrapper){
                if(documentType.equalsIgnoreCase('SBC') && var.Document_ID_SBC.equalsIgnoreCase(str)){
                    selectedResWrapper.add(var);    
                }
                else if(documentType.equalsIgnoreCase('Member EOB') &&  var.Document_ID.equalsIgnoreCase(str)){
                    selectedResWrapper.add(var);
                }
                else if(documentType.equalsIgnoreCase('Provider PRA') && var.Document_ID_PRA.equalsIgnoreCase(str)){
                    selectedResWrapper.add(var);
                }
            }
        }
        
        if(selectedDocId.size() > 1){
            showBulkResend = true;
        }
        else{
             showBulkResend = false;    
        }
        system.debug('selectedResWrapper.size() in showbulkresend is '+selectedResWrapper.size() + selectedDocId.size());
        return null;
   }
   
   public Pagereference showBulkResendAll(){
   	String bulkCheck = ApexPages.currentPage().getParameters().get('bulkCheck');
   	selectedResWrapper = new list<ACETCommunicationSearchResult>();
   	if(bulkCheck.containsIgnoreCase('true')){
   		selectedResWrapper.addAll(resWrapper);
   		showBulkResend = true;
   	}
   	else{
   		showBulkResend = false;
   	}
   	return null;
   	
   }
    
    public Void GetCommuicationHistoryResults(){
    
        
        ACETFinfFulfillmentHistoryWebservice FFH = new ACETFinfFulfillmentHistoryWebservice();
        ACETWSCalloutResult CalloutResult = FFH.FindFulfillmentHistoryWS();
        if (CalloutResult.Success){
            Commhistory = (list<ACETCommunicationHistoryResult>)CalloutResult.Response;
            system.debug('Commhistory is '+Commhistory);
            if(Commhistory == null || Commhistory.size()==0){
                Commhistorytitle = CalloutResult.Message;
            }
        }
        else{
            Apexpages.addMessage(new ApexPages.message(CalloutResult.MessageSeverity,CalloutResult.Message));
        }
        showHistory = true;
        //showbulkResend();
    }
   
   public PageReference btnSubmit(){
        
        showPopUPAddress = false;
        chooseAddress = false;
        
        ACETDocRedeliveryWebservice ACETDCWS = new ACETDocRedeliveryWebservice();
        ACETWSCalloutResult docRedeliveryCalloutResult = new ACETWSCalloutResult ();
        
        for(Integer i=0 ; i<selectedResWrapper.size();i++){
            String redeliveryId = 'ACET-R-'+String.valueof(system.now());
            
            if(selectAddress.contains('AddressOnFile')){
                if(String.ISBlank(AddOnFilePersonWrap.personFirstName) && String.IsBlank(AddOnFilePersonWrap.personLastName)){
                    AddOnFilePersonWrap.personFirstName = AddOnFilePersonWrap.personOrganization;
                    AddOnFilePersonWrap.personLastName = '.';   
                }
                docRedeliveryCalloutResult = ACETDCWS.docRedeliveryWS(redeliveryId, recepientId, 'Member', AddOnFilePersonWrap.personFirstName, AddOnFilePersonWrap.personMiddleName, AddOnFilePersonWrap.personLastName, AddOnFilePersonWrap.personSuffix, AddOnFilePersonWrap.personAddOne, AddOnFilePersonWrap.personAddTwo, AddOnFilePersonWrap.personCity, AddOnFilePersonWrap.personState,AddOnFilePersonWrap.personZipCode, selectedResWrapper[i]);
            }
            else if(selectAddress.contains('AlternateAddress')){
                if(String.ISBlank(personFirstNameAA) && String.IsBlank(personLastNameAA)){
                    personFirstNameAA = personOrganizationAA;
                    personLastNameAA = '.'; 
                }
                docRedeliveryCalloutResult = ACETDCWS.docRedeliveryWS(redeliveryId, recepientId, 'Member', personFirstNameAA, personMiddleNameAA, personLastNameAA, personSuffixAA, personAddOneAA, personAddTwoAA, personCityAA, personStateAA,personZipCodeAA, selectedResWrapper[i]);
            }
            if(docRedeliveryCalloutResult.success != null && docRedeliveryCalloutResult.success ){ 
                selectedResWrapper[i] =  (ACETCommunicationSearchResult)docRedeliveryCalloutResult.Response;
            } 
        }
        return null;
   }  
    
    public void updateSearchField(){
        ShowSearchResult=false;
        showSearchField = true;
        showSubmitBtnAOF = false;
        showBulkResend = false;
        showHistory = false;
        showOriginatorMsg = false;
        
        AddOnFilePersonWrap = new PersonWrapper();
        
        personFirstNameAA = '';
        personMiddleNameAA = '';
        personLastNameAA ='';
        personSuffixAA = '';
        personAddOneAA = '';
        personAddTwoAA = '';
        personCityAA = '';
        personStateAA = '';
        personZipCodeAA = '';
        personOrganizationAA = '';
        personWrapString = '';

        
        System.debug('documentType---'+documentType);
        System.debug('AdditionalInfoData---'+AdditionalInfoData);
        if(!String.IsBlank(documentType)){
            listSearchFilter = [SELECT Id, Document_Type__c,DeveloperName , label, Document_Type__r.Document_Type__c, Search_By_Field_Name__c, Optional__c,Order__c,Field_Type__c,WS_Search_By_Field_Name__c FROM Document_Type_Search_By_Field__mdt WHERE Document_Type__r.Document_Type__c=:documentType Order By Order__c asc];
        }
        
        
        if(Interaction.Originator_Type__c == 'Member'){
            if(documentType.equalsIgnoreCase('Member EOB') || documentType.equalsIgnoreCase('SBC')){
                findMemberInfo();
            }
            else{
                showOriginatorMsg = true;
                recepientId = AdditionalInfoData.MemberId;
                
            }
        }
        else if(Interaction.Originator_Type__c == 'Group/Employer' || Interaction.Originator_Type__c == 'Broker' || Interaction.Originator_Type__c == 'General Agent' || Interaction.Originator_Type__c == 'UHG' || Interaction.Originator_Type__c == 'Third Party'){
            
            if(AdditionalInfoData.isMember != null && AdditionalInfoData.isMember.contains('false') && (documentType.equalsIgnoreCase('Member EOB') || documentType.equalsIgnoreCase('SBC'))){
                findMemberInfo();
            }
            else if(documentType.equalsIgnoreCase('SBC')){
                findGroupInfo();
            }
            else{
                showOriginatorMsg = true;
                recepientId = AdditionalInfoData.GroupN;
            }
        }
        else if(Interaction.Originator_Type__c == 'Producer'){
            if(AdditionalInfoData.isGroup != null && AdditionalInfoData.isGroup.contains('false') && documentType.equalsIgnoreCase('SBC')){
                findGroupInfo();
            }
            else if(documentType.equalsIgnoreCase('SBC')){
                findProducerInfo();
            }
            else{
                showOriginatorMsg = true;
                recepientId = AdditionalInfoData.producerId;
            }
        }
        else if(Interaction.Originator_Type__c == 'Provider'){
             
            if(AdditionalInfoData != null && AdditionalInfoData.isMember.contains('false') && documentType.equalsIgnoreCase('Member EOB')){
                 
                findMemberInfo();
            }
            else if(AdditionalInfoData != null && AdditionalInfoData.isMember.contains('false') && documentType.equalsIgnoreCase('Provider PRA')){
                findProviderInfo();
            }
            else if(documentType.equalsIgnoreCase('Provider PRA')){
                findProviderInfo();
            }
            else{
                showOriginatorMsg = true;
                recepientId = Interaction.Originator__r.Tax_ID__c;
            }
            
        }   
        if(showOriginatorMsg == false && String.isBlank(AddOnFilePersonWrap.personAddOne) &&  String.isBlank(AddOnFilePersonWrap.personCity) && String.isBlank(AddOnFilePersonWrap.personState) &&  String.isBlank(AddOnFilePersonWrap.personZipCode) && (String.isBlank(AddOnFilePersonWrap.personOrganization)|| (String.isBlank(AddOnFilePersonWrap.personFirstName) && String.isBlank(AddOnFilePersonWrap.personLastName)))){
            showSubmitBtnAOF = true;    
        }
        system.debug('true value--->'+ showOriginatorMsg +'----'+showSubmitBtnAOF);
        
    }
    
    public PageReference btnCancel(){
        showPopUPAddress = false;
        chooseAddress = false;
        return null;
    }
    
    public void findMemberInfo(){
        ACETMemberDetail memberDetail = new ACETMemberDetail();
        memberDetail.SurrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        ACETGetIndividualWebService stub = new ACETGetIndividualWebService();
        ACETWSCalloutResult calloutResult ;
        if(!String.isEmpty(MemberDetail.SurrogateKey)){
            calloutResult = stub.getIndividual(MemberDetail.SurrogateKey, MemberDetail);     
        } 
        else {
            //calloutResult = stub.getIndividual(ApexPages.currentPage().getParameters().get('memberId'), MemberDetail);
            system.debug(AdditionalInfoData.MemberId);
            system.debug(MemberDetail);
            calloutResult = stub.getIndividual(AdditionalInfoData.MemberId, MemberDetail);
            
        }
        system.debug('calloutResult--->'+calloutResult);  
        if(calloutResult.success != null && calloutResult.success){
            memberDetail =  (ACETMemberDetail)calloutResult.Response; 
        }
            system.debug('memberDetail--->'+memberDetail);
            
            map<String,ACETMemberDetail.Address> mapAddress = new map<String,ACETMemberDetail.Address>();
            if(memberDetail.Addresses != null){         
            for(ACETMemberDetail.Address address : memberDetail.Addresses){
                mapAddress.put(address.AddressType , address);      
            }}
            if(mapAddress.get('Mailing') != null){ 
                personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get('Mailing').AddressLine1;
                personAddTwoAA = AddOnFilePersonWrap.personAddTwo = mapAddress.get('Mailing').AddressLine2;
                personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get('Mailing').City;
                personStateAA = AddOnFilePersonWrap.personState = mapAddress.get('Mailing').State;
                personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapAddress.get('Mailing').Zip;
            }
            else if(mapAddress.get('Home') != null){ 
                personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get('Home').AddressLine1;
                personAddTwoAA = AddOnFilePersonWrap.personAddTwo = mapAddress.get('Home').AddressLine2;
                personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get('Home').City;
                personStateAA = AddOnFilePersonWrap.personState = mapAddress.get('Home').State;
                personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapAddress.get('Home').Zip;
            }
            if(memberDetail.age!= null){
            if(Integer.valueof(memberDetail.age) > 12){
                recepientId = memberDetail.MemberId;
                personFirstNameAA = AddOnFilePersonWrap.personFirstName = memberDetail.FirstName;
                personMiddleNameAA = AddOnFilePersonWrap.personMiddleName = memberDetail.MiddleName;
                PersonLastNameAA = AddOnFilePersonWrap.PersonLastName = memberDetail.LastName;
                PersonSuffixAA = AddOnFilePersonWrap.PersonSuffix = memberDetail.Suffix;
            }
            }
            else{
                /* if age is less than 12 get subscriber name*/
            }
            personWrapString = JSON.serialize(AddOnFilePersonWrap);
        //system.debug('Person Address'+personAddOne+personAddTwo+personCity+personState+personZipCode);
        
    }
    
    public void findGroupInfo(){
        ACETGroupDetail groupDetails = new ACETGroupDetail();
        String groupNumber = ApexPages.currentPage().getParameters().get('groupID');
        ACETGetEmployerDetailAdapterWebService stubData = new ACETGetEmployerDetailAdapterWebService();
        ACETWSCalloutResult responseData = stubData.GetEmployerGroupDetail(groupNumber);
        
        if(responseData.Success){
            groupDetails = (ACETGroupDetail)responseData.response;
            
            map<String,ACETGroupDetail.AddressInfo> mapAddress = new map<String,ACETGroupDetail.AddressInfo>();
            for(ACETGroupDetail.AddressInfo address : groupDetails.groupAddressInfoList){
                mapAddress.put(address.addrType , address);     
            }
            if(mapAddress.get('Primary Address') != null){ 
                personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get('Primary Address').addrLine1;
                personAddTwoAA = AddOnFilePersonWrap.personAddTwo = mapAddress.get('Primary Address').addrLine2;
                personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get('Primary Address').City;
                personStateAA = AddOnFilePersonWrap.personState = mapAddress.get('Primary Address').State;
                personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapAddress.get('Primary Address').Zip;
            }
            personOrganizationAA = AddOnFilePersonWrap.personOrganization = groupDetails.genGroupInfo.groupName;
            recepientId = groupDetails.genGroupInfo.groupId;
        }
        personWrapString = JSON.serialize(AddOnFilePersonWrap);
    }
    
    public void findProducerInfo(){
        ACETGetProducerAdapterWebservice callWebservice = new ACETGetProducerAdapterWebservice();
        ACETWSCalloutResult responseData = callWebservice.GetProducer(ApexPages.currentPage().getParameters().get('producerId'));
        ACETProducerResult producerDetails = new ACETProducerResult();
        
        if(responseData.Success){
            producerDetails = (ACETProducerResult)responseData.Response;
            system.debug('producerDetails--->'+producerDetails);
            
            map<String,ACETProducerResult.ACETProducerDemography> mapAddress = new map<String,ACETProducerResult.ACETProducerDemography>();
            for(ACETProducerResult.ACETProducerDemography address : producerDetails.addresslist){
                mapAddress.put(address.addressType , address);     
            }
            if(mapAddress.get('M') != null){ 
                personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get('M').streetAddress;
                personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get('M').City;
                personStateAA = AddOnFilePersonWrap.personState = mapAddress.get('M').State;
                personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapAddress.get('M').Zip;
            }
            personOrganizationAA = AddOnFilePersonWrap.personOrganization = producerDetails.CompanyName;
            personFirstNameAA = AddOnFilePersonWrap.personFirstName = producerDetails.firstName;
            personMiddleNameAA = AddOnFilePersonWrap.personMiddleName = producerDetails.MiddleInitial;
            personLastNameAA = AddOnFilePersonWrap.PersonLastName =   producerDetails.lastName;
            recepientId = producerDetails.producerId;
        }
        personWrapString = JSON.serialize(AddOnFilePersonWrap);
    }
    
    public void findProviderInfo(){
         ACETWSCalloutResult CalloutResult;
         ACETFindHCOWebservice ACTFHCOWS = new ACETFindHCOWebservice();
         ACETFindHCPWebservice ACTFHCPWS = new ACETFindHCPWebservice();
         
         List<ACETProviderLookupController.ProviderLookupResult> providerDetail = new List<ACETProviderLookupController.ProviderLookupResult>();
         
         String ProvTypeCode = ApexPages.currentPage().getParameters().get('ProvTypeCode');
         if(String.isBlank(ProvTypeCode)){
            ProvTypeCode = AdditionalInfoData.providerType; // Provider(Member in focus)--- PRA
         }
         system.debug('ProvTypeCode--->'+ProvTypeCode);
         if (ProvTypeCode == 'HCO') {
            CalloutResult = ACTFHCOWS.FindHCO(Interaction.Originator__r.Tax_ID__c,null,Interaction.Originator__r.EID__c,null,'',null,null,'','',null,null,null,null,null,null,null,null,null,null);   
            
        } else {
            CalloutResult = ACTFHCPWS.FindHCP(Interaction.Originator__r.Tax_ID__c, null, Interaction.Originator__r.EID__c, null, '', null, null, '', '', null,null, null, null, null, null, null, null, null);
        }
        if (CalloutResult.Success) {
            providerDetail = (List<ACETProviderLookupController.ProviderLookupResult>)CalloutResult.Response;
            system.debug('ProviderDetail*****'+providerDetail);
            if(ProvTypeCode == 'HCO'){
                personOrganizationAA = AddOnFilePersonWrap.personOrganization = providerDetail[0].fullName ;
            }
            else{
                personFirstNameAa = AddOnFilePersonWrap.personFirstName = providerDetail[0].firstName ;
                personMiddlenameAA = AddOnFilePersonWrap.personMiddlename = providerDetail[0].MiddleName ;
                personLastNameAA = AddOnFilePersonWrap.personLastName =providerDetail[0].lastName ;
                PersonSuffixAA = AddOnFilePersonWrap.PersonSuffix =providerDetail[0].suffix ;
            }
            recepientId = providerDetail[0].providerId;
            map<String,ACETProviderLookupController.ProviderLookupResult> mapAddress = new map<String,ACETProviderLookupController.ProviderLookupResult>();
            for(ACETProviderLookupController.ProviderLookupResult address : providerDetail){
                mapAddress.put(address.addressTypeCode , address);      
            }
            if(mapAddress.get('BIL')!= null){
                personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get('BIL').addressLine1;
                personAddTwoAa = AddOnFilePersonWrap.personAddTwo = mapAddress.get('BIL').addressLine2;
                personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get('BIL').City;
                personStateAA = AddOnFilePersonWrap.personState = mapAddress.get('BIL').state;
                personZipCodeAa = AddOnFilePersonWrap.personZipCode = mapAddress.get('BIL').zipCode;
                    
                
            }
            
        }
        personWrapString = JSON.serialize(AddOnFilePersonWrap);
        
    }
    public class personWrapper{
        public String personOrganization{get;set;}
        public String personFirstName{get;set;}
        public String personMiddleName{get;set;}
        public String personLastName{get;set;}
        public String personSuffix{get;set;}
        public String personAddOne{get;set;}
        public String personAddTwo{get;set;}
        public String personCity{get;set;}
        public String personState{get;set;}
        public String personZipCode{get;set;}
        
    }
}