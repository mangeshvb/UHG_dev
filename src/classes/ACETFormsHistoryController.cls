public class ACETFormsHistoryController {
    
    public String BusinessUnit { get; set; }
    public List<SelectOption> BUnitOptions {get; set;}
    public Set<SelectOption> DocTypeOptions {get; set;}
    Public String source {get;set;}
    Public String doctype {get;set;}
    public String neworder {get;set;}
    public String orderhistory {get;set;}
    public string order {get;set;}
    public string quantity {get;set;}
    
    public personWrapper AddOnFilePersonWrap{get;set;}
    
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public String claimnumber{get;set;}
    public String taxid{get;set;}
    public Case startdate {get;set;}
    public String enddate {get;set;}
    
    // Make Field Required
    public String claimNoReqd{get;set;}
    public String startDateReqd{get;set;}
    public String endDateReqd{get;set;}
    
    public String SortBy {get;set;}
    public String SortOrder {get;set;}
    public String LastSortBy{get;set;}
    public boolean ischecked{get;set;}
    
    public Boolean chooseAddress{get;set;}//Swetha
    
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
    public String selectAddress{get;set;}
    public string personWrapString{get;set;}
    public Interaction__c Interaction{get;set;} 
    
    public string recepientId{get;set;}
    public string idQualifier{get;set;}
    public string recipientType{get;set;}
    
    Public boolean displayhistoryresults{get;set;}
    
    public List<ACETFormsHistoryResult>  formshistory{ set; get; }
    //public Interaction__c Interaction { get; set; }
    public Boolean showSubmit {get;set;}
    
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public contact subject {get; set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}   
    
    public list<MaterialForms> vListMaterialsForms {get; set;}
    
    public ACETFormsHistoryController(){
        try{
            selectAddress = 'AddressOnFile';
            chooseAddress = true;
            showSubmit = false;
            //showPopUPAddress = true;
            AddOnFilePersonWrap = new PersonWrapper();
            //personWrapString = '';
            Interaction = ACETMemberQueryUtil.queryInteraction(ApexPages.currentPage().getParameters().get('InteractionId'));
            string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
            if(addInfo != null){
                AdditionalInfoData  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
            }
            system.debug('AdditionalInfoData---->'+AdditionalInfoData);
            Interaction = ACETMemberQueryUtil.queryInteraction(ApexPages.currentPage().getParameters().get('InteractionId'));
            if(Interaction.Originator_Type__c == 'Member'){
                findMemberInfo();
            }
            else if(Interaction.Originator_Type__c == 'Group/Employer' || Interaction.Originator_Type__c == 'Broker' || Interaction.Originator_Type__c == 'General Agent' || Interaction.Originator_Type__c == 'UHG' || Interaction.Originator_Type__c == 'Third Party'){
                if(AdditionalInfoData.isMember != null && AdditionalInfoData.isMember.contains('false')){
                    findMemberInfo();
                }
                else{
                    findGroupInfo();
                }        
            }
            else if(Interaction.Originator_Type__c == 'Producer'){
                if(AdditionalInfoData.isGroup != null && AdditionalInfoData.isGroup.contains('false')){
                    findGroupInfo();
                }
                else if(AdditionalInfoData.isMember != null && AdditionalInfoData.isMember.contains('false')){
                    findMemberInfo();
                }
                else {
                    findProducerInfo();
                    
                }        
            }
            else if(Interaction.Originator_Type__c == 'Provider'){
                if(AdditionalInfoData != null && AdditionalInfoData.isMember.contains('false')){
                    findMemberInfo();
                }
                else {
                    findProviderInfo();
                    
                }
                
                
            }
        }
        catch(Exception ex){
            
            system.debug('Exception @@ '+ ex.getLineNumber());
        }
    }
    
    Public void changeOrderDate(){
        startdate.tst_Date_Field__c = Date.today()-30;
        Date d = startdate.tst_Date_Field__c+30;
        String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('M/dd/YYYY');
        enddate = dt;
    }
    
    Public void init()
    {
        try{
            wrapper = new ACETCallTopicsDataWrapper();
            wrapper.CallTopic ='Materials Request'; 
            wrapper.init();
            wrapper.CaseObj.Topic__c = 'Materials Request';
            String strSurrogateKey = apexpages.currentpage().getparameters().get('SRK');
            wrapper.SurrogateKey = strSurrogateKey;
            System.debug('wrapper.SurrogateKey--'+wrapper.SurrogateKey);
            startdate = new case();
            //enddate = new case();
            source = 'ACET';
            doctype = '--None--';
            order = 'New Order';
            BusinessUnit = 'None';
            displayhistoryresults = false;
            orderhistory = 'Order History';
            startdate.tst_Date_Field__c = Date.today()-30;
            Date d = startdate.tst_Date_Field__c+30;
            String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('M/dd/YYYY');
            enddate = dt;
            formshistory = Null;
            quantity = Null;
            
            
            String interactionId = ApexPages.currentPage().getParameters().get('interactionId'); 
            String contactId = ApexPages.currentPage().getParameters().get('contactId');
            System.debug('Testing'+contactId+interactionId);
            //Check if User is redirected to Member Search page from Provider detail page          
            if (!String.isEmpty(interactionId)){                        
                system.debug('InteractionId: ' + InteractionId);
                Interaction = ACETProviderUtility.GetInteractionByID(interactionId);   
            }
            if(!String.isEmpty(contactId)) {
                Subject = ACETProviderUtility.GetContactByID(contactId);
            }
        }
        catch(Exception ex){
            
            system.debug('Exception @@ '+ ex.getLineNumber());
        }
        
        
    }
    
    public ACETHighlightsPanelAdditionalInfo AdditionalInfoData{get;set;}
    
    public void clearsearch()
    {
        //public string order {get;set;}
        displayhistoryresults = false;
        order  = 'Order History';
        BusinessUnit = 'None';
        displayhistoryresults = false;
        orderhistory = 'Order History';
        startdate.tst_Date_Field__c = Date.today()-30;
        Date d = startdate.tst_Date_Field__c+30;
        String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('M/dd/YYYY');
        enddate = dt;
        formshistory = Null;
        doctype = '--None--';
        source = 'ACET';
        getMaterialForms();
        
        
        
        
        
    }
    
    Public void Search()
    {
        
        system.debug('order>>>>>>>>>>>'+order);
        displayhistoryresults = true;
        formshistory = new List<ACETFormsHistoryResult>();
        
        if(order.equalsignorecase('Order History')){
            
            System.debug('Document Type@@@@'+doctype);
            System.debug('recepientId@@@@'+recepientId);
            System.debug('idQualifier@@@@'+idQualifier);
            
            ACETFormsHistoryWebService formsHistoryWebService = new ACETFormsHistoryWebService();
            formsHistoryWebService.init(source,Integer.valueof(doctype),String.valueOf(startdate.tst_Date_Field__c),String.valueOf(enddate),recepientId,idQualifier);    
            ACETWSCalloutResult searchResult =  formsHistoryWebService.queryPaginatedData(1,1,1);
            system.debug('searchResult------'+searchResult);
            if(searchResult.Response!= null)
                formshistory.addAll( (List<ACETFormsHistoryResult>) searchResult.Response);
            system.debug('formshistory>>>>'+formshistory);
            
        }
        else{
            
            ACETFormsHistoryResult result = new ACETFormsHistoryResult();
            result.Address = '3170 W Monroe St, Apt 302, Waukegan, IL, 60085';
            result.documentname = 'ADA Dental Claim Form';
            result.documenttype = 'Form';
            //result.maileddate = system.today();
            result.quantity = 5;
            result.recipient = 'Connie Grimm';
            //result.requestdate = system.today();
            result.source = 'ACET';
            result.status = 'Fulfilled';
            
            formshistory.add(result);
            
            ACETFormsHistoryResult result1 = new ACETFormsHistoryResult();
            result1.Address = '3170 W Monroe St, Apt 302, Waukegan, IL, 60085';
            result1.documentname = 'CMS-1500 Medical Claim Form (formerly HCFA-1500)';
            result1.documenttype = 'Form';
            //result1.maileddate = system.today();
            result1.quantity = 5;
            result1.recipient = 'Ruby Kelly';
            //result1.requestdate = system.today();
            
            result1.source = 'ACET';
            result1.status = 'Received';
            
            formshistory.add(result1);
            
            ACETFormsHistoryResult result2 = new ACETFormsHistoryResult();
            result2.Address = '3170 W Monroe St, Apt 302, Waukegan, IL, 60085';
            result2.documentname = 'CMS-1500 Claim Form Instructions    ';
            result2.documenttype = 'Form';
            //result2.maileddate = system.today();
            result2.quantity = 2;
            result2.recipient = 'Gregory';
            //result2.requestdate = system.today();
            
            result2.source = 'ACET';
            result2.status = 'Fulfilled';
            
            formshistory.add(result2);
        }
        order = 'Order History';
        
    }
    
    public Void CalculateEnddate(){
        system.debug('startdate.tst_Date_Field__c is '+startdate.tst_Date_Field__c);
        if(startdate.tst_Date_Field__c != null){
            Date d = startdate.tst_Date_Field__c+30;
            String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('M/dd/YYYY');
            enddate = dt;
        }
    }
    
    public List<SelectOption> getBusinessUnitValues() {
        
        
        BUnitOptions = new List<SelectOption>();
        //set<SelectOption> setValues = new set<SelectOption>();
        try{
            Schema.DescribeFieldResult fieldResult = Material_Forms__c.Business_Unit__c.getDescribe();
            List<Schema.PicklistEntry> BusinessUnitValues = fieldResult.getPicklistValues();
            BUnitOptions.add(new SelectOption('None','--None--'));
            for( Schema.PicklistEntry f : BusinessUnitValues)
            {
                BUnitOptions.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }
        catch(Exception ex){
            
            system.debug('Exception @@ '+ ex.getLineNumber());
        }
        return BUnitOptions;
    }
    
    public List<SelectOption> getdocumentTypeValues() {
        
        DocTypeOptions = new Set<SelectOption>();
        List<SelectOption> FinalValues = new List<SelectOption>();
        //set<SelectOption> setValues = new set<SelectOption>();
        //Schema.DescribeFieldResult fieldResult = Material_Forms__c.Business_Unit__c.getDescribe();
        //List<Schema.PicklistEntry> BusinessUnitValues = fieldResult.getPicklistValues();
        DocTypeOptions.add(new SelectOption('None','--None--'));
        
        for(Material_Forms__c vMForms : [SELECT Id,FulfillmentType__c,FulfillmentType_Description__c FROM Material_Forms__c]){          
            
            DocTypeOptions.add(new SelectOption(vMForms.FulfillmentType__c, vMForms.FulfillmentType_Description__c));
        }
        FinalValues.addAll(DocTypeOptions);             
        return FinalValues;
    }
    
    public class MaterialForms
    {   
        public list<Material_Forms__c> LstMaterialForms {get; set;}
        public string CategoryName {get; set;}
        
        public MaterialForms(Material_Forms__c vMForms)
        {
            CategoryName = vMForms.Category__c;
            LstMaterialForms = new list<Material_Forms__c>{vMForms};
                }
    }
    public Map<string,Material_Forms__c> getMaterialForms() {
        
        Transient Map<string,Material_Forms__c> vLstMaterialForms = new Map<string,Material_Forms__c>();
        vListMaterialsForms = new list<MaterialForms>();
        map<string, MaterialForms> mapMaterialForms = new map<string, MaterialForms>();
        
        system.debug('vListMaterialsForms@@@@@@  '+ vListMaterialsForms);
        system.debug('BusinessUnit@@@@@@  '+ BusinessUnit);
        try{
            for(Material_Forms__c vMForms : [SELECT Id, Business_Unit__c,Category__c,Document_Title__c,Document_URL__c,FulfillmentType__c,MRE__c,Quantity__c FROM Material_Forms__c where Business_Unit__c=:BusinessUnit ORDER BY Category__c ASC,Document_Title__c ASC ]){
                if(mapMaterialForms.get(vMForms.Category__c) == null){
                    mapMaterialForms.put(vMForms.Category__c, new MaterialForms(vMForms));
                    vListMaterialsForms.add(mapMaterialForms.get(vMForms.Category__c));
                }
                else{
                    mapMaterialForms.get(vMForms.Category__c).LstMaterialForms.add(vMForms);
                }                                         
            }
            system.debug('mapMaterialForms@@@@@@  '+ mapMaterialForms.size());
        }
        catch(Exception ex){
            
            system.debug('Exception@@ '+ ex.getLineNumber());
        }
        return vLstMaterialForms;
        
    }
    
    public PageReference MaterialForms() {
        getMaterialForms();
        return null;
    }
    public void findMemberInfo(){
        system.debug('findMemberInfo--->');  
        ACETMemberDetail memberDetail = new ACETMemberDetail();
        memberDetail.SurrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        System.debug('memberDetail.SurrogateKey---'+memberDetail.SurrogateKey);
        ACETGetIndividualWebService stub = new ACETGetIndividualWebService();
        ACETWSCalloutResult calloutResult ;
        if(!String.isEmpty(MemberDetail.SurrogateKey)){
            calloutResult = stub.getIndividual(MemberDetail.SurrogateKey, MemberDetail);     
        } 
        else {
            //calloutResult = stub.getIndividual(ApexPages.currentPage().getParameters().get('memberId'), MemberDetail);
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
                //recepientId = memberDetail.MemberId;
                recepientId = AdditionalInfoData.MemberId;
                system.debug('AdditionalInfoData@@@@@ '+AdditionalInfoData);
                idQualifier = 'MemberID';
                recipientType = 'Member';
                personFirstNameAA = AddOnFilePersonWrap.personFirstName = memberDetail.FirstName;
                personMiddleNameAA = AddOnFilePersonWrap.personMiddleName = memberDetail.MiddleName;
                PersonLastNameAA = AddOnFilePersonWrap.PersonLastName = memberDetail.LastName;
                PersonSuffixAA = AddOnFilePersonWrap.PersonSuffix = memberDetail.Suffix;
            }
        }
        else{
            /* if age is less than 12 get subscriber name*/
        }
        //personWrapString = JSON.serialize(AddOnFilePersonWrap);
        system.debug('test'+'AddOnFilePersonWrap.personFirstNameAA');
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
            idQualifier = 'GroupID';
            recipientType = 'Group';
        }
        //personWrapString = JSON.serialize(AddOnFilePersonWrap);
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
            idQualifier = 'ProducerID';
            recipientType = 'Producer';
        }
        //personWrapString = JSON.serialize(AddOnFilePersonWrap);
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
            recepientId = providerDetail[0].taxId;
            idQualifier = 'ProviderID';
            recipientType = 'Provider';
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
        //personWrapString = JSON.serialize(AddOnFilePersonWrap);
        
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
    
    public Pagereference btnSubmit(){
        Map<Material_Forms__c,String> successStatus = new Map<Material_Forms__c,String>();
        
        ACETProcessFulfillmentWebservice ACETPFWS = new ACETProcessFulfillmentWebservice();
        ACETWSCalloutResult proFulfillmentCalloutResult = new ACETWSCalloutResult ();
        
        for(MaterialForms clsmatform : vListMaterialsForms){
            for(Material_Forms__c matform :clsmatform.LstMaterialForms){
                if(String.IsNOTBlank(matform.Quantity__c)){
                    system.debug('Quantity---->'+matform.Quantity__c);
                    if(selectAddress.contains('AddressOnFile')){
                        if(String.ISBlank(AddOnFilePersonWrap.personFirstName) && String.IsBlank(AddOnFilePersonWrap.personLastName)){
                            AddOnFilePersonWrap.personFirstName = AddOnFilePersonWrap.personOrganization;
                            AddOnFilePersonWrap.personLastName = '.';   
                        }
                        
                        proFulfillmentCalloutResult = ACETPFWS.processRedeliveryWS(recepientId, idQualifier ,recipientType, AddOnFilePersonWrap.personFirstName, AddOnFilePersonWrap.personMiddleName, AddOnFilePersonWrap.personLastName, AddOnFilePersonWrap.personSuffix, AddOnFilePersonWrap.personAddOne, AddOnFilePersonWrap.personAddTwo, AddOnFilePersonWrap.personCity, AddOnFilePersonWrap.personState,AddOnFilePersonWrap.personZipCode, matform,AddOnFilePersonWrap.personOrganization,BusinessUnit);
                    }
                    else if(selectAddress.contains('AlternateAddress')){
                        if(String.ISBlank(personFirstNameAA) && String.IsBlank(personLastNameAA)){
                            personFirstNameAA = personOrganizationAA;
                            personLastNameAA = '.'; 
                        }
                        proFulfillmentCalloutResult = ACETPFWS.processRedeliveryWS(recepientId,idQualifier,recipientType, personFirstNameAA, personMiddleNameAA, personLastNameAA, personSuffixAA, personAddOneAA, personAddTwoAA, personCityAA, personStateAA,personZipCodeAA, matform,AddOnFilePersonWrap.personOrganization,BusinessUnit);
                    }
                    if(proFulfillmentCalloutResult.success != null && proFulfillmentCalloutResult.success ){ 
                        //selectedResWrapper[i] =  (ACETCommunicationSearchResult)docRedeliveryCalloutResult.Response;
                        successStatus.put(matform,proFulfillmentCalloutResult.Message);
                    }
                    else{
                        successStatus.put(matform,proFulfillmentCalloutResult.Message); 
                    }
                    
                }
                
            } 
        }
        Integer i = 0;
        if(successStatus!=null){
            for(String val : successStatus.values()){
                if(val.contains('Accepted')){
                    i++;
                }
                else{
                    break;
                }
                
            }
            system.debug('successStatus****'+successStatus.size()+'Integer i'+i);
            if(successStatus.size() == i){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Order Submitted Successfully'));   
            }
            else{
                
                String strErrorMessage = 'The following items failed to be submitted. Re-Submit to try again. Forms: ';
                for(MaterialForms objMaterialForms : vListMaterialsForms){
                
                    Integer index = 0;
                    for(Material_Forms__c objMaterial_Forms : objMaterialForms.LstMaterialForms){
                        
                        if(String.isNotBlank(objMaterial_Forms.Quantity__c) && Integer.valueOf(objMaterial_Forms.Quantity__c) > 0){
                            
                            strErrorMessage += objMaterial_Forms.Document_Title__c;
                            if(objMaterialForms.LstMaterialForms.size() > index){
                                
                                if(String.isNotBlank(objMaterial_Forms.Document_Title__c)){
                                    
                                    strErrorMessage += ', ';
                                }
                            }
                            index += 1;
                        }
                    }
                }
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strErrorMessage));
            }
            
        }
        return null;
    }
    
    public void checkValidQuantity(){
        
        showSubmit = false;
        system.debug('vListMaterialsForms==='+vListMaterialsForms);
        for(MaterialForms objMaterialForms : vListMaterialsForms){
            
            for(Material_Forms__c objMaterial_Forms : objMaterialForms.LstMaterialForms){
                
                if(String.isNotBlank(objMaterial_Forms.Quantity__c) && Integer.valueOf(objMaterial_Forms.Quantity__c) > 0)
                    showSubmit = true;
            }
        }
    }
}