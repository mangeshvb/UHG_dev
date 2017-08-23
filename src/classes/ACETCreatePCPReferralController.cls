public with sharing class ACETCreatePCPReferralController {
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public string surrogateKey {get;set;}
    public string topic {get;set;}
    public string refNumber{get;set;}
    public String baseURL{get;set;}
    
    public ACETCreatePCPReferralController () {
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'Create PCP Referral';
        initHighlightPanelAdditionalInfo();
        
         String interactionId = ApexPages.currentPage().getParameters().get('interactionId'); 
          
        //Check if User is redirected to Member Search page from Provider detail page          
        if (!String.isEmpty(interactionId)){                        
            system.debug('InteractionId: ' + InteractionId);
            
        
            wrapper.Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            
        }
        
        /** added by Pavan on 1/27/2017 for US495232 *****/
        Contact varContact = [select FirstName , lastName from Contact where Id=:apexpages.currentpage().getparameters().get('contactId')];
        System.debug('*****'+wrapper.AdditionalInfo.PolicyNumber+'***'+apexpages.currentpage().getparameters().get('memberId'));
        baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
        String orginstance;
        //String orginstance = ACETUtility.GetOrgName(ACETOrgInstanceURLToOrgNameMap__c.getAll());
        //String tempBaseURL;
        for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
            system.debug('orgname.name is '+orgname.Name);
            if(baseURL.contains(orgname.Name)) {
                system.debug('tname '+orgname.name);
                orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
            }
        }
        if(orginstance != null){        
            system.debug('orginstance is '+orginstance);
            baseURL += ACETURLEncryptionUtility.getICUEURL(orginstance+'_ICUEPCPReferral');
        }
        
        /*tempBaseURL = 'cdbXrefId=780991&cdbXrefIdPartitionNumber=91';
        tempBaseURL = tempBaseURL+'&policy='+ wrapper.AdditionalInfo.PolicyNumber;
        tempBaseURL = tempBaseURL +'&subscriberId='+ apexpages.currentpage().getparameters().get('memberId');
        tempBaseURL = tempBaseURL +'&firstName='+ varContact.FirstName;
        tempBaseURL = tempBaseURL +'&lastName='+ varcontact.LastName;
        tempBaseURL = tempBaseURL +'&functionId=PcpReferral&landingPage=pcpReferral&applicationId=ACET';*/
        
        String tempBaseURL = 'cdbXrefId=780991&cdbXrefIdPartitionNumber=91&policy={0}&subscriberId={1}&firstName={2}&lastName={3}&functionId=PcpReferral&landingPage=pcpReferral&applicationId=ACET';
        List<String> fillers = new String[]{wrapper.AdditionalInfo.PolicyNumber,apexpages.currentpage().getparameters().get('memberId'),varContact.FirstName,varcontact.LastName};
        tempbaseURL = String.format(tempBaseURL, fillers);
        
        String Key = ACETWrapEncryptionKey__c.getValues(orginstance+'_ICUEEncryptionKey').Key__c;
        system.debug('Key: '+Key+'tempBaseURL: '+tempBaseURL);
        baseURL += ACETURLEncryptionUtility.GetEncryptedValue(Key,'AES256',tempBaseURL);
        //baseURL = ACETURLEncryptionUtility.getEncryptedPCPReferralURL(wrapper.AdditionalInfo.PolicyNumber, apexpages.currentpage().getparameters().get('memberId'), varContact.FirstName, varcontact.LastName);
        system.debug('**baseURL - '+ baseURL);
        
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        if(!string.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }        
    }
    
    private void initHighlightPanelAdditionalInfo(){
        string additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(additionalInfoStr, ACETHighlightsPanelAdditionalInfo.class); 
    }
    
    /*public List<SelectOption> getTopics(){
        list<SelectOption> options = new list<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Created','Created'));
        options.add(new SelectOption('Not Created','Not Created'));
        return options;        
    }*/
    
    public void updateWrapper(){
        wrapper.blockedCallTopic = topic; 
    } 
}