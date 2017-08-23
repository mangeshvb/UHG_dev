public class ACETConstituent {
    protected Contact ACETContact;
    protected Map<Id, Case> OrphanCases;
    public Contact Subject { 
        get { return ACETContact; } 
        set { ACETContact = value; } 
    }
    
    public ACETConstituent() {
        OrphanCases = new Map<Id, Case>();
    }    
    
    //Find Surrogate Keys which are present in both in OIL Response and ACET
    private Map<String, List<Case>> GetACETSurrogateKeys(ACETOILIndividual MDMMember, Map<Id, Contact> ACETContacts) {
        Map<String, List<Case>> ACETSRKCaseMap = new Map<String, List<Case>>();
        List<Case> listCaseToAdd = new List<Case>();

        //Find out Contacts and Surrogate Keys from Salesforce using Surrogate Keys in response
        for(Case oCase :[SELECT Id, CaseNumber, Interaction__c, Surrogate_Key__c, Contact.Id, Contact.FirstName, Contact.LastName, 
                Contact.AccountId, Contact.LastModifiedDate FROM Case WHERE Surrogate_Key__c IN :MDMMember.SurrogateKeys
                ORDER BY Contact.LastModifiedDate DESC, Surrogate_Key__c]) {
            system.debug(LoggingLevel.INFO, 'oCase: ' + oCase);
            
            if (!String.isBlank(oCase.Contact.Id)) {
                if (!ACETContacts.containsKey(oCase.Contact.Id)) {
                    ACETContacts.put(oCase.Contact.Id, 
                        new Contact(Id=oCase.Contact.Id, FirstName=oCase.Contact.FirstName, LastName=oCase.Contact.LastName, 
                            AccountId=oCase.Contact.AccountId));
                }
            }
            listCaseToAdd.add(oCase);
            ACETSRKCaseMap.put(oCase.Surrogate_Key__c, listCaseToAdd);
        }
        system.debug(LoggingLevel.INFO, 'ACETContacts: ' + ACETContacts);
        system.debug(LoggingLevel.INFO, 'ACETSRKCaseMap: ' + ACETSRKCaseMap);
        
        return ACETSRKCaseMap;    
    }
    
    //Find Surrogate Keys which are in ACET but not in response using Contact related to Surrogate keys
    private Map<String, List<Case>> GetACETSurrogateKeysNotInResponse(ACETOILIndividual MDMMember, Map<Id, Contact> ACETContacts) {
        Map<String, List<Case>> ACETSRKsNotInResponse = new Map<String, List<Case>>();
        
        List<Case> listCaseToAdd = new List<Case>();
        //Find Surrogate Keys which are in ACET but not in response using Contact related to Surrogate keys
        for(Case oCase :[SELECT Id, CaseNumber, Interaction__c, Surrogate_Key__c, Contact.Id, Contact.FirstName, Contact.LastName, 
            Contact.AccountId FROM Case WHERE ContactID IN :ACETContacts.keySet()]) {
            system.debug(LoggingLevel.INFO, 'oCase: ' + oCase); 
            if (!MDMMember.SurrogateKeys.contains(oCase.Surrogate_Key__c)) {
                listCaseToAdd.add(oCase);
                ACETSRKsNotInResponse.put(oCase.Surrogate_Key__c, listCaseToAdd);
            }    
        }
        system.debug(LoggingLevel.INFO, 'ACET SRK Not In Response: ' + ACETSRKsNotInResponse);
        return ACETSRKsNotInResponse;    
    }
    
    public Map<String, List<Case>> MatchMDMnACETSurrogateKeys(ACETOILIndividual MDMMember) {
        system.debug(LoggingLevel.INFO, 'MDMMember: ' + MDMMember);
        Map<Id, Contact> ACETContacts = new Map<Id, Contact>();
        Map<String, List<Case>> ACETSRKCaseMap = GetACETSurrogateKeys(MDMMember, ACETContacts);
        
        if (ACETContacts.size() == 0) {
            //No Member found in ACET for surroage keys in response
            ACETContact = GetConstitentContact(MDMMember);
            system.debug(LoggingLevel.INFO, 'New ACET Contact: ' + ACETContact);
        } 
        else {
            //Find Surrogate Keys which are in ACET but not in response using Contact related to Surrogate keys
            Map<String, List<Case>> ACETSRKNotInResponse = GetACETSurrogateKeysNotInResponse(MDMMember, ACETContacts);
            
            //Get cases to be orphanded which are associated to surrogate keys which are in ACET but not in response
            if (ACETSRKNotInResponse.size() > 0) {
                for(String str: ACETSRKNotInResponse.KeySet()){
                    for (Case OrphanCase : ACETSRKNotInResponse.get(str)) {
                        OrphanCase.ContactId = null;
                        OrphanCase.AccountId = null;
                        OrphanCase.Last_Orphaned__c = System.now();
                        OrphanCases.put(OrphanCase.Id, OrphanCase);
                    }
                }
            }
            
            //Find contact to be created or updated
            if (ACETContacts.values().get(0) == null) {
                ACETContact = GetConstitentContact(MDMMember);
            }
            else {
                ACETContact = GetConstitentContact(MDMMember, ACETContacts.values().get(0));
            }
            system.debug(LoggingLevel.INFO, 'Update ACET Contact: ' + ACETContact);
        }
        
        return ACETSRKCaseMap;
    }
    
    //New Contact
    public Contact GetConstitentContact(ACETOILIndividual MDMMember) {
        Contact ACETMember = new Contact();
        ACETMember.FirstName = MDMMember.FirstName;
        ACETMember.LastName = MDMMember.LastName;
        ACETMember.Birthdate = MDMMember.BirthDate;
        ACETMember.EID__c = MDMMember.EId;
        ACETMember.Phone = MDMMember.Phone;
        return ACETMember;
    }
    
    //Update Contact
    private Contact GetConstitentContact(ACETOILIndividual MDMMember, Contact ACETMember) {
        ACETMember.FirstName = MDMMember.FirstName;
        ACETMember.LastName = MDMMember.LastName;
        ACETMember.Birthdate = MDMMember.BirthDate;
        ACETMember.EID__c = MDMMember.EId;
        ACETMember.Phone = MDMMember.Phone;
        return ACETMember;
    }
    
    public Map<String, List<Case>> MergeNSplitCases(ACETOILIndividual MDMMember) {
        Map<String, List<Case>> ACETSRKCaseMap = MatchMDMnACETSurrogateKeys(MDMMember);
        
        //Create or Update Account
        String AccountName = String.isBlank(ACETContact.FirstName) ? ACETContact.LastName : ACETContact.FirstName + ' ' + ACETContact.LastName;
        system.debug('--------MDMMember------>'+MDMMember + '---------ACETContact----->'+ACETContact);
        if(AccountName == null || AccountName =='')
            AccountName = String.isBlank(MDMMember.FirstName) ? MDMMember.LastName : MDMMember.FirstName + ' ' + MDMMember.LastName;
        List<Account> accList = [select Id,Name ,EID__c from Account where EID__c =: ACETContact.EID__c];
        Account ACETAccount;
        if(accList.size() > 0){
        	ACETAccount = accList.get(0);
        	Database.update(ACETAccount);
        }else{
        	ACETAccount = new Account(Id=ACETContact.AccountId, Name = AccountName, EID__c = ACETContact.EID__c);
        	Database.insert(ACETAccount);
        }
        
        
        //Create or Update Contact
        ACETContact.AccountId = ACETAccount.Id;  
        //upsert ACETContact;
        Database.upsert(ACETContact, Contact.Fields.EID__c);
        
        //Orphan cases
        update OrphanCases.values();
        
        return ACETSRKCaseMap;
    } 
    
    public List<Case> ReparentCases(Id InteractionId, Map<String, List<Case>> ACETSRKCaseMap) {
        //Reparent cases
        Map<Id, Case> mapReparentCases = new Map<Id, Case>();
        for(String str: ACETSRKCaseMap.KeySet()){
            for (Case ReparentCase : ACETSRKCaseMap.get(str)) {
                if(String.isBlank(ReparentCase.ContactId)){
                    ReparentCase.Interaction__c = InteractionId; 
                }
                ReparentCase.ContactId = ACETContact.Id;
                ReparentCase.AccountId = ACETContact.AccountId;    
                ReparentCase.Last_Re_Parented__c = System.now();        
                mapReparentCases.put(ReparentCase.Id, ReparentCase);
            } 
        }
        
        update mapReparentCases.values();  
        return mapReparentCases.values();
    }
    
    /*public void MergeNSplitCases(ACETOILIndividual MDMMember, Id CurrentInteractionId) {
        Map<String, List<Case>> ACETSRKCaseMap = MatchMDMnACETSurrogateKeys(MDMMember);
        
        //Create or Update Account
        String AccountName = String.isBlank(ACETContact.FirstName) ? ACETContact.LastName : ACETContact.FirstName + ' ' + ACETContact.LastName;
        Account ACETAccount = new Account(Id=ACETContact.AccountId, Name = 'AccountName');
        upsert ACETAccount;
        
        //Create or Update Contact
        ACETContact.AccountId = ACETAccount.Id;  
        upsert ACETContact;
        
        //Orphan cases
        update OrphanCases.values();
        
        //Reparent cases
        Map<Id, Case> ReparentCases = new Map<Id, Case>();
        for(String str: ACETSRKCaseMap.KeySet()){
            for (Case ReparentCase : ACETSRKCaseMap.get(str)) {
                if(String.isBlank(ReparentCase.ContactId)){
                    ReparentCase.Interaction__c = CurrentInteractionId; 
                }
                ReparentCase.ContactId = ACETContact.Id;
                ReparentCase.AccountId = ACETAccount.Id;            
                ReparentCases.put(ReparentCase.Id, ReparentCase);
            } 
        }
        
        update ReparentCases.values();  
    }*/
}