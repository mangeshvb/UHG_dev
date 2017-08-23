public with sharing class ACETCreateAuthorizationController {
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public string surrogateKey {get;set;}
    public string topic {get;set;}
    public string authNumber{get;set;}
    public String baseURL{get;set;}
    
    public ACETCreateAuthorizationController() {
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'Create Authorization';
        initHighlightPanelAdditionalInfo();
        
        /** added by Pavan on 1/30/2017 for US468672 *****/
        Contact varContact = [select FirstName , lastName from Contact where Id=:apexpages.currentpage().getparameters().get('contactId')];
        System.debug('*****'+wrapper.AdditionalInfo.PolicyNumber+'***'+apexpages.currentpage().getparameters().get('memberId'));
        baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
        String orginstance ;
        for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
            
            if(baseURL.contains(orgname.Name)) {
                system.debug('tname '+orgname.name);
                orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
            }
        }
        if(orginstance != null){
            system.debug('orginstance is '+orginstance);
            baseURL += ACETURLEncryptionUtility.getICUEURL(orginstance+'_ICUECreateAuthorization');
        }
        String tempBaseURL = 'cdbXrefId=780991&cdbXrefIdPartitionNumber=91&policy={0}&subscriberId={1}&firstName={2}&lastName={3}&functionId=Initiate_Hsc_Intake&landingPage=initiateHscIntake&applicationId=ACET';
        List<String> fillers = new String[]{ wrapper.AdditionalInfo.PolicyNumber,apexpages.currentpage().getparameters().get('memberId'),varContact.FirstName,varcontact.LastName};
        tempbaseURL = String.format(tempBaseURL, fillers);
        System.debug('tempbaseURL-->'+tempBaseURL);
        //String Key = ACETWrapEncryptionKey__c.getValues(orginstance+'_ICUEEncryptionKey').Key__c;
        //baseURL += ACETURLEncryptionUtility.GetEncryptedValue(Key,'AES128',tempBaseURL);
        baseURL += ACETURLEncryptionUtility.GetEncryptedValue(ACETWrapEncryptionKey__c.getValues(orginstance+'_ICUEEncryptionKey').Key__c,'AES256',tempbaseURL);
        system.debug('base url' + baseURL);
        
        
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        if(!string.isEmpty(surrogateKey)){
            wrapper.surrogateKey = surrogateKey;
        }
        
    }
    private void initHighlightPanelAdditionalInfo(){
        string additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(additionalInfoStr, ACETHighlightsPanelAdditionalInfo.class); 
    }
    public List<SelectOption> getTopics(){
        list<SelectOption> options = new list<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Created','Created'));
        options.add(new SelectOption('Not Created','Not Created'));
        return options;        
    }
    public void updateWrapper(){
        wrapper.blockedCallTopic = topic; 
    } 
    
}