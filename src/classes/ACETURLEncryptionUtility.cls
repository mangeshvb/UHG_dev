public class ACETURLEncryptionUtility {

    /** added by Pavan on 1/25/2017 for US495218 *****/
    public Static String getEncryptedConsumerDashURL(String policynum , string memberId , String firstName , string lastName){
        //String tempBaseURL;
        String orginstance;
        String baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
        system.debug('baseURL::'+baseURL);
        for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
            
            if(baseURL.contains(orgname.Name)) {
                system.debug('tname '+orgname.name);
                orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
            }
        }
        if(orginstance != null)
        {
            system.debug('orginstance is '+orginstance);
            baseURL += getICUEURL(orginstance+'_ICUEConsumerDashboard');
            
        }
        
        /*tempBaseURL = 'cdbXrefId=780991&cdbXrefIdPartitionNumber=91&policy='+policynum;
        tempBaseURL = tempBaseURL + '&subscriberId='+memberId;
        tempBaseURL = tempBaseURL + '&firstName='+firstName;
        tempBaseURL = tempBaseURL + '&lastName='+lastName;
        tempBaseURL = tempBaseURL + '&functionId=Consumer_Dashboard&landingPage=consumerDashboard&applicationId=ACET';*/
        
        String tempBaseURL = 'cdbXrefId=780991&cdbXrefIdPartitionNumber=91&policy={0}&subscriberId={1}&firstName={2}&lastName={3}&functionId=Consumer_Dashboard&landingPage=consumerDashboard&applicationId=ACET';
        List<String> fillers = new String[]{policynum,memberId,firstName,lastName};
        tempbaseURL = String.format(tempBaseURL, fillers);
        
        system.debug('tempBaseURL '+tempBaseURL);
        String Key = ACETWrapEncryptionKey__c.getValues(orginstance+'_ICUEEncryptionKey').Key__c;
        baseURL += GetEncryptedValue(Key,'AES256',tempBaseURL);
        system.debug('tempbaseULR '+baseURL);
        return baseURL;
    }
    
    /** added by Pavan on 2/1/2017 for US495218, US468672 and US495232 *****/
    public Static String getICUEURL(String getICUEURL){
        system.debug('getICUEURL is '+getICUEURL);
        ACETOrgNameToSwivelEndpointMap__c wrapURL = ACETOrgNameToSwivelEndpointMap__c.getValues(getICUEURL);
        system.debug('wrapURL is '+wrapURL);
        String icueURL = wrapURL.Swivel_Endpoint__c;
        return icueURL ;
        
    }
    
    /** added by Pavan on 2/1/2017 for US495218, US468672 and US495232 *****/
    public Static String GetEncryptedValue(String Key, String algorithmname, String baseurl){
        system.debug('Key: '+Key+'algorithmname: '+algorithmname+'baseurl: '+baseurl);
        String tempBaseURL;
        Blob data = Blob.valueOf(baseurl);
        Blob EncryptKey = Blob.valueOf(Key);
        Blob encryptedtempBaseURLData = Crypto.encryptWithManagedIV(algorithmname, EncryptKey , data);
        tempBaseURL = EncodingUtil.base64Encode(encryptedtempBaseURLData);
        system.debug('tempbaseULR'+tempBaseURL);
        return tempBaseURL;
    }
}