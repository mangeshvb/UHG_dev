public with sharing class ACETProviderLookUpDetailController {
    public Case StartDate{get;set;}
    public Case StartDateNew{get;set;}
    public String genInfoLanguage { get; set; }    
    public ACETProviderDetailController.ACETProviderDetail providerDetail {get;set;}
    public List<SelectOption> languageOptions {get;set;}
    public ACETProviderDetailController.ProviderLookupClass FacilityVF {get;set;} //Added by Vinay for getHCO
    public List<ACETGetHCOJSON2Apex.specialty> lstspc{get;set;} //Added by Vinay for getHCO
    public List<ACETProviderDetailController.ACETProviderSpeciality> specialityLst {get;set;}
    public List<SelectOption> leftnpi{get;set;} //Added by Vinay for getHCO
    public List<SelectOption> rightnpi{get;set;} //Added by Vinay for getHCO
    public string Dummy {get;set;}
    public ACETMemberDetail MemberDetail {get;set;}    
    public ACETHighlightsPanelAdditionalInfo additionalInfo {get;set;}
    public String benefitPlanId { get; set; }   
    public String Shownonpar {get;set;}
    public List<ACETProviderDetailController.ACETProviderAffiliation> Affiliations { get; set; }  
    public boolean  isProviderLookupDetailsResult{get;set;}
    public list<ACETProviderLookupController.ProviderLookupResult> lstProviderLookup{get;set;} 
    public Boolean isErrorMessageAdded {get; set;}
    public list<ACETProviderContractResult> agreements {get;set;}
    public string providerId {
        get;
        set;
    }
    public string providerType {
        get;
        set;
    }
    public string taxId {
        get;
        set;
    } 
    public string sourceOriginator {
        get;
        set;
    }
    public Contact conObj {
        get;
        set;
    }
    public string memberId {
        get;
        set;
    }
    public string policyNumber {
        get;
        set;
    }
    public Interaction__c interaction {
        get;
        set;
    }
    public String hpAdditionInfoStr {
        get;
        set;
    }
    public list<ACETProviderLookupController.ProviderLookupResult> AdditionalAddresses {
        get;
        set;
    }
    public list < PraticeInformation > lstPraticeInformation {
        get;
        set;
    }
    public set < SelectOption > networkOptions {
        get;
        set;
    }
    public String netWork {
        get;
        set;
    }
    public list < ACETProviderContractResult > lstACETProvider {
        get;
        set;
    }
    
    public list < ACETProviderContractResult > lstProviderContratResult {
        get;
        set;
    }
    public Boolean istProviderContratResult {
        get;
        set;
    }
    public boolean isContractControl {
        get;
        set;
    }
    public boolean disableContractType {
        get;
        set;
    }
    public string strType {
        get;
        set;
    }
    public string proferredCoverageGUID {
        get;
        set;
    }
    public list < ContrcatInfo > lstContrcat {
        get;
        set;
    }
    public ACETCallTopicsDataWrapper wrapper {
        get;
        set;
    }
    public ACETCaseItemWrapper caseItem {get;set;}
    public Boolean renderName {
        get {
            return optSelected == 'Active';
        }
    }
    public String optSelected {
        get;
        set;
    }
    public list <CurrentPhysician> lstCurrentPhysician {
        get;
        set;
    } 
    public list <NewPhysician> lstNewPhysician {
        get;
        set;
    }   
    ACETGetHCOWebservice ACETGetHCOWS;
    ACETGetHCPWebservice ACETGetHCPWS;  
    ACETFindHCPAffiliationsWebservice ACETHCPAffWS;
    ACETFindHCOAffiliationsWebservice ACETHCOAffWS;    
    ACETFindAgreementsWebservice ACETFindAgreementsWS;
       
    public String providerTINTypeCodeParam { get; set; }
    public String addressIdParam { get; set; }
    public String addressTypeCodeParam { get; set; }
    public String providerTINParam { get; set; }
    public String returningFromServiceParam;
    public String providerStatusCodeParam,providerTINStatusCodeParam;
    public List < SelectOption > radioValues {
        get {
            List < SelectOption > resList = new List < SelectOption > ();
            resList.add(new SelectOption('Active', 'Active'));
            resList.add(new SelectOption('All', 'All'));
            return resList;
        }
    }
    
    @RemoteAction
    public static list < ACETProviderContractResult > fetchProviderContracts(String ProvId) {
        system.debug(LoggingLevel.INFO, ', ProviderId: ' + ProvId);
        //lstProviderContratResult = (List<ACETProviderContractResult>)(ACETProviderUtility.FindAgreement(ProvId,null)).Response;
        
        // system.debug(LoggingLevel.INFO, ', lstProviderContratResult:'+lstProviderContratResult);
        return null; //lstProviderContratResult;
    }
    public ACETProviderDetailController.ACETProviderGeneralInfo ProDetailvf {get;set;}// Added by Vinay 04/12/2017
       
    //code to make asynchronous callout
    public Object CallWSOnPageLoad1(){
        //system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoad. ProviderTypeCode: ' + providerType + ', Interaction.Originator_Type__c @@@ ' + Interaction.Originator_Type__c + ' returningFromServiceParam*** ' + returningFromServiceParam + ' benefitPlanId*** ' + benefitPlanId);
        Continuation PageLoadContinuation;
        if (providerType == 'Facility') {
            ACETGetHCOWS = new ACETGetHCOWebservice();
          //  PageLoadContinuation = ACETGetHCOWS.StartRequest(providerId, taxId, providerStatusCode, providerTINStatusCode, providerTINTypeCodeParam, addressIdParam, addressTypeCodeParam, returningFromServiceParam, 'CallWSOnPageLoadCallback', null);
           PageLoadContinuation = ACETGetHCOWS.StartRequest(providerId, taxId, providerStatusCodeParam, providerTINStatusCodeParam, providerTINTypeCodeParam, addressIdParam, addressTypeCodeParam, returningFromServiceParam, 'CallWSOnPageLoadCallback1', null);
        } else {
            system.debug(LoggingLevel.INFO, 'ProviderTypeCode>>>: ' + providerType);
            ACETGetHCPWS = new ACETGetHCPWebservice();
            
            PageLoadContinuation = ACETGetHCPWS.StartRequest(providerId, taxId, providerTINTypeCodeParam, addressIdParam, addressTypeCodeParam, 'providerLookup', 'CallWSOnPageLoadCallback1', null);
            system.debug(LoggingLevel.INFO,'PageLoadContinuation *** ' + PageLoadContinuation);
        }        
        ACETFindAgreementsWS = new ACETFindAgreementsWebservice();

        //Added by Vinay for US668672 show par and non-par on 06162017
        String benefitPlanIdStr;
        system.debug('Shownonpar**'+Shownonpar);
        if(Shownonpar == 'true'){
            System.debug('Checked***');
            benefitPlanIdStr = '';
        }else{
            system.debug('Uncheked**');
            benefitPlanIdStr = benefitPlanId;
        }
        ACETFindAgreementsWS.StartRequest(providerId, taxId, providerTINTypeCodeParam, addressIdParam, addressTypeCodeParam,benefitPlanIdStr, 'CallWSOnPageLoadCallback1', PageLoadContinuation);
        
        return PageLoadContinuation; 
    }   
    
    public PageReference CallWSOnPageLoadCallback1() {
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoadCallback. ProviderTypeCode: ' + providerType);
        ACETWSCalloutResult GetProviderCalloutResult, FindAgreementsCalloutResult;
        if(Interaction.Originator_Type__c != 'Other'){
            if (providerType == 'Facility') {
                GetProviderCalloutResult = ACETGetHCOWS.ProcessResponse(null, ACETGetHCOWS.RequestLabel);
            } else if(providerType == 'Physician') {
                
                GetProviderCalloutResult = ACETGetHCPWS.ProcessResponse(returningFromServiceParam, ACETGetHCPWS.RequestLabel);
                system.debug(LoggingLevel.INFO,'GetProviderCalloutResult.Response*** ' + GetProviderCalloutResult.Response);
            }
            providerDetail = (ACETProviderDetailController.ACETProviderDetail)GetProviderCalloutResult.Response; 
            
            if (providerType == 'Facility') {
                for(ACETProviderDetailController.NPI npi: providerDetail.npis){
                    if(npi.npiName != null && npi.npiName != '')
                        leftnpi.add(new SelectOption(npi.npiName, npi.npiName));              
                } 
            }            
            //system.debug(LoggingLevel.INFO, 'ProviderDetail.GeneralInfo.NPI *** ' + ProviderDetail.GeneralInfo.lastname);        
            FindAgreementsCalloutResult = ACETFindAgreementsWS.ProcessResponse(ACETFindAgreementsWS.RequestLabel);
            if (FindAgreementsCalloutResult.Success) {
                Agreements = (list<ACETProviderContractResult>)FindAgreementsCalloutResult.Response;
            }    
        }
        return null;
    }   
    
    public void toggleShowCoverages() {
        //Coverages.clear();
        if (istProviderContratResult == null) {
            istProviderContratResult = true;
            /*if(Coverages2 != null){     
for(ACETMemberDetail.CoverageLine c : Coverages2){
if(!istProviderContratResult || c.getIsActive()){
Coverages.add(c);   
}

}
}*/
        }
    }
    
    public void providerContractResult(string strType) {
        system.debug('******ProviderDetail****' + ProviderID);
        list < ACETProviderContractResult > lstWebProviderInfo = new list < ACETProviderContractResult > ();
        if (lstProviderContratResult != null)
            lstWebProviderInfo = lstProviderContratResult;
        System.debug('lstWebProviderInfo' + lstWebProviderInfo);
       if (strType == 'Active') {
            for (ACETProviderContractResult objProviderContract: lstWebProviderInfo) {
                if (objProviderContract.isActive) {
                    lstACETProvider.add(objProviderContract);
                }
            }
        } else {
            lstACETProvider = lstWebProviderInfo;
        }
        
    }
    
    
    public PageReference getAllCoverageList() {
        istProviderContratResult = false;
        //Coverages = new list<ACETMemberDetail.CoverageLine>();    
        if (optSelected == 'Active') {
            lstACETProvider.clear();
            providerContractResult('Active');
        } else {
            //lstProviderContracts.clear();
            lstACETProvider.clear();
            providerContractResult('InActive');
        }
        
        
        return null;
    }
    
    public PageReference getCoverageList() {
        lstACETProvider.clear();
        providerContractResult('Active');
        isContractControl = true;
        return null;
    }
   
    
    public ACETProviderLookUpDetailController() {
       ACETHCOAffWS = new ACETFindHCOAffiliationsWebservice(); 
        ACETHCPAffWS = new ACETFindHCPAffiliationsWebservice(); 
         ACETFindAgreementsWS = new ACETFindAgreementsWebservice();
        ACETGetHCOWS = new ACETGetHCOWebservice();
        ACETGetHCPWS = new ACETGetHCPWebservice();
        ACETFindAgreementsWS = new ACETFindAgreementsWebservice();
        providerDetail=new ACETProviderDetailController.ACETProviderDetail();
        StartDate = new Case();
        StartDateNew = new Case();
        leftnpi = new list<SelectOption>();
        rightnpi = new list<SelectOption>();     
        
        languageOptions = new list<SelectOption>();
        lstCurrentPhysician = new list <CurrentPhysician> (); 
         
        //CurrentPhysician objCurrentPhysician1 = new CurrentPhysician(); 
        MemberDetail = new ACETMemberDetail();
        findMemberships();
       
        lstNewPhysician = new list <NewPhysician> (); 
        NewPhysician objNewPhysician = new NewPhysician();
        
        agreements = new list<ACETProviderContractResult>();
        
     //   objCurrentPhysician.isChecked = false;
       // objCurrentPhysician.firstName = 'Micheal';
        //objCurrentPhysician.lastName = 'Greenwood';  
        //objCurrentPhysician.pcpAssignmentType = 'Primart Care Physician';
        //objCurrentPhysician.effDate = '3/14/2017';
        //objCurrentPhysician.endDate = '4/22/2017';
        /*
        objCurrentPhysician1.isChecked = false;
        objCurrentPhysician1.firstName = 'Sally';
        objCurrentPhysician1.lastName = 'Long';  
        objCurrentPhysician1.pcpAssignmentType = 'OBGYN';
        objCurrentPhysician1.effDate = '3/14/2017';
        */
        system.debug('2323 MemberDetail.PCPAssignments'+MemberDetail.PCPAssignments);
        if(MemberDetail.PCPAssignments != null){
            for(ACETMemberDetail.PCPAssignment pcp : MemberDetail.PCPAssignments){
                CurrentPhysician objCurrentPhysician = new CurrentPhysician();  
                objCurrentPhysician.isChecked = false;
                objCurrentPhysician.firstName = pcp.FirstName;
                objCurrentPhysician.lastName = pcp.LastName;  
                objCurrentPhysician.pcpAssignmentType = pcp.pcpAssignmentType;
                objCurrentPhysician.effDate = pcp.effectiveDate;
                objCurrentPhysician.pcpid = pcp.id;
                objCurrentPhysician.pcptype = pcp.identifiertype;                   
                lstCurrentPhysician.add(objCurrentPhysician);   
            }
        }
        system.debug('2323 lstCurrentPhysician'+lstCurrentPhysician);
       // lstCurrentPhysician.add(objCurrentPhysician);
        //lstCurrentPhysician.add(objCurrentPhysician1);
        
        objNewPhysician.Name = 'Tom Cruise';
        objNewPhysician.Network = 'Freedom';
        objNewPhysician.Address = '2805 Camus DR STE 415 Minneapolis MN 55421';
        objNewPhysician.PhoneNo = '763-552-3426';
        objNewPhysician.Speciality = 'Internal Medicine';
        objNewPhysician.pcpNewAssignmentType = 'Primary Care Physician';
        objNewPhysician.newEffDate = '4/23/2017';
        StartDateNew.tst_Date_Field__c = Date.today();
        
        lstNewPhysician.add(objNewPhysician);     
        additionalInfo = new ACETHighlightsPanelAdditionalInfo();
        lstACETProvider = new list < ACETProviderContractResult > ();
        lstContrcat = new list < ContrcatInfo > ();
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.calltopic = 'Provider Lookup';
        caseItem = new ACETCaseItemWrapper();
        caseItem.caseObj = new Case();
        caseItem.caseObj.topic__c = 'Provider Lookup';
        caseItem.topic = caseItem.caseObj.topic__c ;
        //wrapper.init();
        
        ContrcatInfo objContract = new ContrcatInfo();
        objContract.product = 'POS';
        objContract.networkID = '1';
        objContract.networkName = 'FREEDOM';
        objContract.networkStatus = 'OON';
        objContract.feeRegion = 'TYRW';
        objContract.effective = '1/4/2016';
        objContract.cancel = '1/4/2099';
        objContract.capitation = '109 F';
        objContract.acceptingNewPatient = 'Yes';
        
        lstContrcat.add(objContract);
        
        lstPraticeInformation = new list < PraticeInformation > ();
        optSelected = 'Active';
         getCoverageList();             
        
                    
        //StateCode = new ACETStateCodeContainer('');
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');
        providerId = ApexPages.currentPage().getParameters().get('providerId');
        providerType = ApexPages.currentPage().getParameters().get('providerType');
        taxId = ApexPages.currentPage().getParameters().get('taxId');
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'Provider Lookup';
        
        benefitPlanId  = ApexPages.currentPage().getParameters().get('benefitPlanId');
        ShowNonPar  = ApexPages.currentPage().getParameters().get('ShowNonPar');
        system.debug(LoggingLevel.Info,'benefitPlanId:: ' + benefitPlanId);        
        system.debug(LoggingLevel.Info,'ShowNonPar:: ' + ShowNonPar);
        
        //Get Provider Interaction SFDC Id
        String providerResultInfo = ApexPages.currentPage().getParameters().get('ProviderObjJson');
       
        String fullName1 = ApexPages.currentPage().getParameters().get('FacilityName');
        String providerId1  = ApexPages.currentPage().getParameters().get('providerId');
        String providerType1 = ApexPages.currentPage().getParameters().get('providerType');
        String status1 = ApexPages.currentPage().getParameters().get('status');
        
        String taxId1 = ApexPages.currentPage().getParameters().get('taxId');
        String ssn1 = ApexPages.currentPage().getParameters().get('ssn');
        String address1 = ApexPages.currentPage().getParameters().get('address');
        String phoneNumber1 = ApexPages.currentPage().getParameters().get('phoneNumber');
        String platinum1 =  ApexPages.currentPage().getParameters().get('platinum');
        String speciality1 = ApexPages.currentPage().getParameters().get('speciality');
        String gender1 = ApexPages.currentPage().getParameters().get('gender');
        String network1 = ApexPages.currentPage().getParameters().get('network');
        String affiliation1 = ApexPages.currentPage().getParameters().get('affiliation');
        String uphd1 = ApexPages.currentPage().getParameters().get('uphd');
        String PCPRole1 = ApexPages.currentPage().getParameters().get('PCPRole');
        string radious1 = ApexPages.currentPage().getParameters().get('radious');
        string acceptNewPatient1 =  ApexPages.currentPage().getParameters().get('acceptNewPatient');
        string Owner1 =  ApexPages.currentPage().getParameters().get('owner');//Added by Vinay for getHCO
        string hcoTypeCode1 =  ApexPages.currentPage().getParameters().get('hcoTypeCode'); //Added by Vinay for getHCO
        isProviderLookupDetailsResult = false;
        if(ApexPages.currentPage().getParameters().get('isProviderLookupDetailsResult')=='True'){
            isProviderLookupDetailsResult = true;
        }
        
        //Added the variable as a part of US588701 by Avish 04/07/2017
        providerTINTypeCodeParam = ApexPages.currentPage().getParameters().get('providerTINTypeCode');
        addressIdParam = ApexPages.currentPage().getParameters().get('addressId');
        addressTypeCodeParam   = ApexPages.currentPage().getParameters().get('addressTypeCode');
        providerStatusCodeParam = ApexPages.currentPage().getParameters().get('providerStatusCode');
        providerTINStatusCodeParam = ApexPages.currentPage().getParameters().get('providerTINStatusCode');
        providerTINParam = ApexPages.currentPage().getParameters().get('providerTIN');
        returningFromServiceParam = ApexPages.currentPage().getParameters().get('returningFromService');
        
        //Check if User is redirected to Member Search page from Provider detail page  
        lstProviderLookup     = new list<ACETProviderLookupController.ProviderLookupResult>();   
        // system.debug();
        
        ACETProviderLookupController.ProviderLookupResult objProviderResult = new ACETProviderLookupController.ProviderLookupResult();
        objProviderResult.acceptNewPatient  = acceptNewPatient1 ;
        objProviderResult.radious = radious1 ;
        objProviderResult.uphd= uphd1;
        objProviderResult.PCPRole= PCPRole1;
        objProviderResult.affiliation = affiliation1 ;
        objProviderResult.network= network1;
        objProviderResult.gender= gender1;
        objProviderResult.speciality = speciality1 ;
        objProviderResult.phoneNumber  = phoneNumber1 ;
		objProviderResult.platinum  = platinum1 ;
        objProviderResult.owner  = Owner1 ;
        objProviderResult.hcoTypeCode  = hcoTypeCode1 ;
        //objProviderResult. gender= gender1;
        objProviderResult.address = address1 ;
        objProviderResult.ssn  = ssn1 ;
        system.debug('fullName1 :: ' + fullName1);
        objProviderResult.fullName  = fullName1;
        
        objProviderResult.providerId= providerId1;
        objProviderResult.providerType = providerType1 ;
        objProviderResult.status  = status1 ;
        system.debug(LoggingLevel.info, 'taxId1 *** ' + taxId1 + ' taxId @@@ ' + taxId);
        objProviderResult.taxId = taxId1;
        lstProviderLookup.add(objProviderResult);
        system.debug(LoggingLevel.info, 'objProviderResult.taxId @@@ ' + objProviderResult.taxId);
        if (!String.isEmpty(interactionId)) {
            system.debug('InteractionId: ' + InteractionId);
            
            //Query Provider Interaction details
            interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            sourceOriginator = Interaction.Interaction_Type__c;
            system.debug(LoggingLevel.info, 'Interaction: ' + interaction + ', sourceOriginator: ' + sourceOriginator);
        }
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        if (!String.isEmpty(contactId)) {
            conObj = ACETProviderUtility.GetContactByID(contactId);
        }
        
        //String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');
        
        //String contactId = ApexPages.currentPage().getParameters().get('contactId');
        if (!String.isEmpty(contactId)) {
            conObj = ACETProviderUtility.GetContactByID(contactId);
            //LastName = Subject.LastName;
            //FirstName = Subject.FirstName;
            memberId = conObj.EID__c;
        }
        String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');
        if (!String.isEmpty(additionalInfostr)) {
            additionalInfo = (ACETHighlightsPanelAdditionalInfo) JSON.deserialize(additionalInfostr, ACETHighlightsPanelAdditionalInfo.class);
            //AdditionalInfo.DOB = ApexPages.currentPage().getParameters().get('DOB');
            policyNumber = additionalInfo.PolicyNumber;
            hpAdditionInfoStr = JSON.serialize(additionalInfo);
        }      
        
    }
    public void findMemberships(){
        String Id = ApexPages.currentPage().getParameters().get('Id');
        MemberDetail.SurrogateKey = ApexPages.currentPage().getParameters().get('SRK'); //894666785
        string groupNumber = ApexPages.currentPage().getParameters().get('grpnum');


        system.debug('Id::'+Id);
        system.debug('membership MemberDetail.SurrogateKey::'+MemberDetail.SurrogateKey);
        if(!String.isEmpty(MemberDetail.SurrogateKey)){
            //some fields for coverage lines depends on getMembership service
            if(MemberDetail != null){
                //if(MemberDetail.PreferredCoverage != null){
                ACETGetMembershipWebService stub = new ACETGetMembershipWebService();
                ACETWSCalloutResult calloutResult = stub.getMembership(MemberDetail.SurrogateKey,groupNumber,MemberDetail);
                system.debug('--------calloutResult---->'+calloutResult);
            } 
            if(MemberDetail.PreferredCoverage != null){
                //selectedSurrogateKey = MemberDetail.PreferredCoverage.SurrogateKey;
            }        
            
            //system.debug('**calloutResult.Response**' + calloutResult.Response );                                                         
        } 
        else{
             //call findMembership service first                
            ACETfindMembershipWebService stub = new ACETfindMembershipWebService();
            ACETWSCalloutResult calloutResult = stub.findMembership(Id, MemberDetail); 
                      
            //some fields for coverage lines depends on getMembership service         
            ACETGetMembershipWebService stub2 = new ACETGetMembershipWebService();
            ACETWSCalloutResult calloutResult2 = stub2.getMembership(Id,'',MemberDetail); 
            //system.debug('**calloutResult.Response**' + calloutResult.Response );     
        }  
    }
    public PageReference callFindMedicalProvider() {
        ACETWSCalloutResult CalloutResult; 
        if(providerType == 'Facility'){
            ACETFindHCOWebservice ACTFHCOWS = new ACETFindHCOWebservice();
            CalloutResult = ACTFHCOWS.FindHCO(taxId, null, providerId, null, '', null, null, '', '', null, 
                                              null, null, null, null, null, null, null,null,null);   
        } else {
            system.debug(LoggingLevel.INFO,'taxId** '+taxId + ' providerId** ' + providerId);
            ACETFindHCPWebservice ACTFHCPWS = new ACETFindHCPWebservice();
            CalloutResult = ACTFHCPWS.FindHCP(taxId, null, providerId, null, '', null, null, '', '', null, 
                                              null, null, null, null, null, null, null, null);   
        }  
        AdditionalAddresses = (List<ACETProviderLookupController.ProviderLookupResult>)CalloutResult.Response;  
        return null;
    }
    
    /** Added by Avish as a part of US555792 and US599441 **/ 
    public Object CallFindAffiliations() {
        Continuation oContinuation; 
        system.debug(LoggingLevel.INFO, 'providerType :: ' + providerType);
        system.debug(LoggingLevel.INFO, 'providerStatusCodeParam: ' + providerStatusCodeParam);        
        if(providerType == 'Facility'){
            ACETHCOAffWS = new ACETFindHCOAffiliationsWebservice();
            oContinuation = ACETHCOAffWS.StartRequest(providerId, null, null, null, 
                        '0', '50', '0', 'FindAffiliationsCallback', null);   
        } else {
            ACETHCPAffWS = new ACETFindHCPAffiliationsWebservice();
            oContinuation = ACETHCPAffWS.StartRequest(providerId, providerStatusCodeParam, 
                            '0', '50', '0', 'FindAffiliationsCallback', null);   
        }  
        return oContinuation;
    }
    
    public PageReference FindAffiliationsCallback() {
        ACETWSCalloutResult CalloutResult;
        if(providerType == 'Facility'){
            CalloutResult = ACETHCOAffWS.ProcessResponse(ACETHCOAffWS.RequestLabel);   
        } else {
            CalloutResult = ACETHCPAffWS.ProcessResponse(ACETHCPAffWS.RequestLabel);
        }
        if (CalloutResult.Success) {
            Affiliations = (List<ACETProviderDetailController.ACETProviderAffiliation>)CalloutResult.Response;
        }
        return null;    
    }    
    
    /* End of Affiliations **/
    /*Call for UpdateindividualMembership*/
     public PageReference UpdatePCPOBGYN()   {
        
        String memberId = additionalInfo.MemberId;
        String scrId = ApexPages.currentPage().getParameters().get('scrId');
        String groupNumber= additionalInfo.GroupNumber;
        String lastName= additionalInfo.LastName;
        String firstname= additionalInfo.FirstName;
        String ssn = ApexPages.currentPage().getParameters().get('ssnId');
        String gender=additionalInfo.Gender;
        string dob=additionalInfo.DOB;
        string relationshipcode= ApexPages.currentPage().getParameters().get('rl');
        String currentpcpId;
        String currentpcptype;
        String currentpcpAssignmentType;
        String currentpcpeffectiveEndDate;
        String currentpcpeffectiveStartDate;
        
        List<ACETMemberDetail.Phone> PhoneList;
        system.debug('2323 lstCurrentPhysician'+ lstCurrentPhysician);
        for(CurrentPhysician cp : lstCurrentPhysician){
            system.debug('2323 case end date'+ cp.CaseEndDate.tst_Date_Field__c);
            if(cp.isChecked == true){           
                currentpcpId=cp.pcpid;
                currentpcptype=cp.pcptype;
                currentpcpAssignmentType=cp.pcpAssignmentType;
                currentpcpeffectiveStartDate = ACETUtility.formatDatewithslash(cp.effDate);
                currentpcpeffectiveEndDate = ACETUtility.formatDateYYYYMMDD(string.valueOf(cp.CaseEndDate.tst_Date_Field__c));
            }
        }
      
        String newpcpId=providerDetail.generalInfo.npi;
        String newpcptype='NPI';
        String newpcpAssignmentType=lstProviderLookup[0].providerType;
        String newpcpEffectiveStartDate = ACETUtility.formatDateYYYYMMDD(string.valueOf(StartDateNew.tst_Date_Field__c));
        ACETUpdateIndividualWebService UpdIndWebsrevice = new ACETUpdateIndividualWebService(); 
        if(currentpcpeffectiveEndDate!='' && currentpcpeffectiveEndDate != null){
                ACETWSCalloutResult TermCalloutResult = UpdIndWebsrevice.updateMembers(memberId,  scrId, groupNumber, lastName, firstname, '', '', ssn, gender, dob, relationshipcode, '', '', '', PhoneList, currentpcpId, currentpcptype, currentpcpAssignmentType, currentpcpeffectiveStartDate, currentpcpeffectiveEndDate);
                if (TermCalloutResult.Success)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Termination Successful'));
                }
                else
                {
                    system.Debug('2323 else condition' + TermCalloutResult.Response + TermCalloutResult.MessageSeverity+TermCalloutResult.Message);
                    ApexPages.addMessage(new ApexPages.Message(TermCalloutResult.MessageSeverity,TermCalloutResult.Message));
                }   
        }
        if(newpcpEffectiveStartDate!='' && newpcpEffectiveStartDate!=null){
                ACETWSCalloutResult UpdateCalloutResult = UpdIndWebsrevice.updateMembers(memberId,  scrId, groupNumber, lastName, firstname, '', '', ssn, gender, dob, relationshipcode, '', '', '', PhoneList, newpcpId, newpcptype, 'PCP', newpcpEffectiveStartDate, '9999-12-12');
                if (UpdateCalloutResult.Success)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Update Successful'));
                }
                else
                {
                    system.Debug('2323 else condition' + UpdateCalloutResult.Response + UpdateCalloutResult.MessageSeverity+UpdateCalloutResult.Message);
                    ApexPages.addMessage(new ApexPages.Message(UpdateCalloutResult.MessageSeverity,UpdateCalloutResult.Message));
                }   
        }        
        
        
        return null;
    }
    /*Call for UpdateindividualMembership - end of change*/
    
    
    
    
    
    public class CurrentPhysician {
        
        public CurrentPhysician(){
            CaseEndDate = new Case();
        }
        
        public string firstName {
            get;
            set;
        }
        public Boolean isChecked {
            get;
            set;
        }  
        public string lastName {
            get;
            set;
        }
        public string pcpAssignmentType {
            get;
            set;
        }
        public string effDate {
            get;
            set;
        }
       public Date EndDate {
            get; set;}
           
         public string pcpid {
            get;
            set;
        }
         public string pcptype {
            get;
            set;
        }
        public Case CaseEndDate{get;set;}
    } 
    public class NewPhysician {
        public string Name {
            get;
            set;
        }
        public string Network {
            get;
            set;
        }
        public string Address {
            get;
            set;
        }
        public string PhoneNo {
            get;
            set;
        }
        public string Speciality {
            get;
            set;
        }
        public string pcpNewAssignmentType {
            get;
            set;
        }  
        public string newEffDate {
            get;
            set;
        }  
    } 
    public class ProviderDemographics {
        public string addressType {
            get;
            set;
        }
        public string address {
            get;
            set;
        }
        public string phone {
            get;
            set;
        }
        public string fax {
            get;
            set;
        }
        public string email {
            get;
            set;
        }
        public string County {
            get;
            set;
        }
    }
    public class ACETactiveAffiliationsResult {
        public string affiliation {get; set;}
        public string providerID {get; set;}
        public string effective {get; set;}
    }
    
    public class PraticeInformation {
        public string speciality {
            get;
            set;
        }
        public string status {
            get;
            set;
        }
        public string network {
            get;
            set;
        }
        public string panel {
            get;
            set;
        }
        public string pratiseStartDate {
            get;
            set;
        }
        public string patientAgeRange {
            get;
            set;
        }
        public string extendedHours {
            get;
            set;
        }
    }
    
    public class Credencialing {
        public string qualification {
            get;
            set;
        }
        public string affilation {
            get;
            set;
        }
        public string providerRep {
            get;
            set;
        }
        public string uhn {
            get;
            set;
        }
        public string pti {
            get;
            set;
        }
    }
    
    public class UnitedHealthPremium {
        public string premiumDesigination {
            get;
            set;
        }
        public string premiumSpeciality {
            get;
            set;
        }
        public string effective {
            get;
            set;
        }
        public string cancel {
            get;
            set;
        }
    }
    
    public class ContrcatInfo {
        
        public string product {
            get;
            set;
        }
        public string networkID {
            get;
            set;
        }
        public string networkName {
            get;
            set;
        }
        public string networkStatus {
            get;
            set;
        }
        public string feeRegion {
            get;
            set;
        }
        
        public string effective {
            get;
            set;
        }
        public string cancel {
            get;
            set;
        }
        public string Capitation {
            get;
            set;
        }
        public string acceptingNewPatient {
            get;
            set;
        }        
       
    }
    
    public class ACETHCPMessageWrapper{
        public FindHCPResult findHCPResult;
    }
    
    public class FindHCPResult{
        public List<FHCP_Error> errors;
    }
    
    public class FHCP_Error{
        public String code;
        public String name;
        public String severity;
        public String origin;
        public String description;
    }
    
    
}