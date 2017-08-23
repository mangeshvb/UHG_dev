public with Sharing class ACETPharmacyController 
{    
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public boolean showSA {get;set;}
    public string hpAdditionInfoStr{get;set;}
    public ACETHighlightsPanelAdditionalInfo additionalInfo {
        get;
        set;
    }
    public string policyNumber {
        get;
        set;
    }
    
    public string csrfNumber {get;set;}
    
    public Contact conObj {
        get;
        set;
    }
    
    public string memberId {
        get;
        set;
    }
    
    public Interaction__c interaction {
        get;
        set;
    }
    
    public String selectedValue { get; set; }
    
    public string sourceOriginator {get;set;}
    public String ISETURL { get; set; }
    public String surrogateKey;
    
    public ACETPharmacyController(){
        showSA = false; 
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = 'Pharmacy Inquiry';
        wrapper.CaseRecordTypeLabel = 'Employer&Broker';
        system.debug('Test=='+ apexpages.currentpage().getparameters().get('SRK'));
        String strSurrogateKey = apexpages.currentpage().getparameters().get('SRK');
         wrapper.SurrogateKey = strSurrogateKey;
        additionalInfo = new ACETHighlightsPanelAdditionalInfo();
        String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');
        System.debug('additionalInfostr::'+ additionalInfostr);
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        Wrapper.caseobj.surrogate_key__c = surrogatekey;
        System.debug('surrogateKey ---'+surrogateKey );
        System.debug('contactId::'+ contactId);
        conObj  = new Contact();
        if (!String.isEmpty(contactId)) {
            conObj = ACETProviderUtility.GetContactByID(contactId);
            system.debug(LoggingLevel.INFO, 'conObj: ' + conObj);
            memberId = conObj.EID__c;
        }
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');
        System.debug('interactionId::'+ interactionId);
        interaction = ACETProviderUtility.GetInteractionByID(interactionId);
        sourceOriginator = Interaction.Interaction_Type__c;
        
        if (!String.isEmpty(additionalInfostr)) {
            additionalInfo = (ACETHighlightsPanelAdditionalInfo) JSON.deserialize(additionalInfostr, ACETHighlightsPanelAdditionalInfo.class);
            //AdditionalInfo.DOB = ApexPages.currentPage().getParameters().get('DOB');
            policyNumber = additionalInfo.PolicyNumber;
            hpAdditionInfoStr = JSON.serialize(additionalInfo);            
            system.debug(LoggingLevel.INFO, 'additionalInfo: ' + additionalInfo);
            /*if (memberId == '707481') {
                ISETURL = GenerateISETURL('1111', 'Leslie', 'Hall', '08/20/1974', 'F');
            }
            else {
                ISETURL = GenerateISETURL('1000016501', 'Leslie', 'Hall', '08/20/1974', 'F');
            }*/   
            ISETURL = GenerateISETURL(additionalInfo.MemberId, additionalInfo.FirstName, additionalInfo.LastName, additionalInfo.DOB, additionalInfo.Gender);
        }
    }    
    
    public void showSaMethodCon(){
        showSA = true;
    }
    public List<SelectOption> getPharmacyInquiryCallTypes() {
        List<SelectOption> options = new List<SelectOption>();            
        options.add(new SelectOption('Authorizations/Overrides','Authorizations/Overrides'));             
        options.add(new SelectOption('Benefits/Eligibility','Benefits/Eligibility'));
        options.add(new SelectOption('Claim Status','Claim Status'));
        options.add(new SelectOption('Drug Pricing','Drug Pricing'));
        options.add(new SelectOption('Mail Order Information','Mail Order Information'));
        options.add(new SelectOption('Pharmacy Lookup','Pharmacy Lookup'));
        options.add(new SelectOption('Specialty Pharmacy','Specialty Pharmacy'));
        options.add(new SelectOption('Other','Other'));        
        
        return options;
        
    }
    
    public String getCSRFURL() {
        String sandboxName = ACETUtility.GetOrgName();
        return ACETUtility.GetSwivelEndpointByOrgName(sandboxName, 'CSRF');
    }
    
    private String GenerateISETURL(String MemberId, String FirstName, String LastName, String DOB, String Gender) {
        system.debug(LoggingLevel.INFO, 'MemberId: ' + MemberId + ', FirstName: ' + FirstName + ', LastName: ' + LastName + ', DOB: ' + DOB + ', Gender: ' + Gender);
        String OrgInstanceURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm()); 
        String OrgName = ACETUtility.GetOrgName();
        System.debug('OrgName::'+OrgName);
        System.debug('All::'+ACETOrgNameToSwivelEndpointMap__c.getall().values());
        System.debug('dev one::'+ACETOrgNameToSwivelEndpointMap__c.getValues('dev_ISETWrap'));
        System.debug('dev one::'+ACETOrgNameToSwivelEndpointMap__c.getValues(OrgName + '_ISETWrap'));        
        ACETOrgNameToSwivelEndpointMap__c ISETWrapURLMap = new ACETOrgNameToSwivelEndpointMap__c();        
        ISETWrapURLMap =  ACETOrgNameToSwivelEndpointMap__c.getValues(OrgName + '_ISETWrap');
        System.debug('ISETWrapURLMap.Swivel_Endpoint__c::'+ ISETWrapURLMap.Swivel_Endpoint__c);        
        String ISETWrapURL = ISETWrapURLMap.Swivel_Endpoint__c;
        ACETWrapEncryptionKey__c ACETWrapEncryptionKey = ACETWrapEncryptionKey__c.getValues(OrgName + '_ISETEncryptionKey');
        String EncryptionKey = ACETWrapEncryptionKey.Key__c;
        String AlgorithmName = ACETWrapEncryptionKey.Algorithm_Name__c;
        system.debug(LoggingLevel.INFO, 'OrgInstanceURL: ' + OrgInstanceURL + ', ISETWrapURL: ' + ISETWrapURL + ', EncryptionKey: ' + EncryptionKey);
        
        Integer AppSourceIndex = ISETWrapURL.indexOf('applicationSource=');
        String ISETQSTemplate = ISETWrapURL.right(ISETWrapURL.length() - AppSourceIndex);
        ISETWrapURL = ISETWrapURL.remove(ISETQSTemplate);
        system.debug(LoggingLevel.INFO, 'ISETWrapURL: ' + ISETWrapURL + ', ISETQSTemplate: ' + ISETQSTemplate);
        
        String ISETQS = String.format(ISETQSTemplate, new List<String>{MemberId, FirstName, LastName, DOB, Gender});
        String ISETQSEncrypted = ACETURLEncryptionUtility.GetEncryptedValue(EncryptionKey, AlgorithmName, ISETQS);
        system.debug(LoggingLevel.INFO, 'ISETQS: ' + ISETQS + ', ISETQSEncrypted: ' + ISETQSEncrypted);
        
        //ISETWrapURL = OrgInstanceURL + ISETWrapURL + EncodingUtil.urlEncode(ISETQS, 'UTF-8');
        ISETWrapURL = OrgInstanceURL + ISETWrapURL + EncodingUtil.urlEncode(ISETQSEncrypted, 'UTF-8');
        return ISETWrapURL;
    }
    
    public PageReference SaveAndClose(){
        if(wrapper.isSystemUnavailable){
            wrapper.caseObj.New_Closed_Reason__c ='System Unavailable';
        }
        else{
        }
        wrapper.caseObj.Topic__c ='Pharmacy Inquiry';
        wrapper.caseObj.Status='Closed';
        System.debug('surrogateKeyif -----'+surrogateKey);
        wrapper.caseObj.Surrogate_Key__c = surrogateKey;
        //wrapper.caseObj.AutoDoc__c = AutoDoc;
        wrapper.createCase();  
        system.debug('wrapper closedreason'+wrapper.caseObj.New_Closed_Reason__c);         
        PageReference caseDetailsReference = new PageReference('/apex/ACETCallTopicSaveAndClose?caseId=' + wrapper.CaseObj.Id);
        system.debug('wrapper.CaseObj.Id  >>>  '+wrapper.CaseObj.Id);
        return caseDetailsReference; 
        
    } 
    
}