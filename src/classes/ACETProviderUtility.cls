public without sharing class ACETProviderUtility
{   
 
  public static ACETWSCalloutResult FindAuthorization(String MemberId, String DOB, String FirstName, String LastName, String StartDate, String EndDate,String FederationID, List<String> SystemLabels)
    {
        system.debug(LoggingLevel.INFO, 'MemberId: ' + MemberId + ', DOB: ' + DOB + ', FirstName: ' + FirstName + ', LastName: ' + LastName + ', StartDate: ' + StartDate + ', EndDate: ' + EndDate + ', FederationID: ' + FederationID);    
        ACETFindAuthorizationWebservice ACTFAWS = new ACETFindAuthorizationWebservice();
        ACETWSCalloutResult oACETWSCalloutResult=ACTFAWS.FindAuthorizations(MemberId, DOB, FirstName, LastName,  StartDate,  EndDate, FederationID, SystemLabels);    
        return oACETWSCalloutResult;
    }
    public static ACETWSCalloutResult GetAuthorizationDetail(String AuthId, String XRefId,String Type,String federationID, List<String> SystemLabels)
    {
        system.debug(LoggingLevel.INFO, 'AuthId: ' + AuthId + ', XRefId: ' + XRefId +'Type: ' + Type+'::federationID:: ' + federationID);    
        ACETGetAuthorizationWebservice ACTGAWS = new ACETGetAuthorizationWebservice();
        ACETWSCalloutResult oACETWSCalloutResult=ACTGAWS.GetAuthorizationDetail(AuthId, XRefId,Type,federationID,SystemLabels);    
        return oACETWSCalloutResult;
    }
    
    public static Account CreateProviderAccount(String ProviderId, String ProviderName, String TaxId)
    {
        Account ProviderAccount = new Account();
        ProviderAccount.EID__c = ProviderId;
        ProviderAccount.Name = ProviderName;
        ProviderAccount.Tax_Id__c = TaxId;
        return ProviderAccount;
    }
    
    public static Contact CreateProviderContact(String ProviderType, Account ProviderAccount, String ProviderId, String TaxId, String NPI)
    {
        Contact ProviderContact = new Contact();
        if (ProviderType.equalsIgnoreCase(Label.ACETProviderPhysician))
        {
            String[] Names = ProviderAccount.Name.split(' ');
            ProviderContact.FirstName = Names[0];
            if (Names.size() > 1)
            {
                Integer lenStr = Names.size();               
                ProviderContact.LastName = Names[lenStr-1];
            }
        }
        else
        {
            ProviderContact.FirstName = '';
            ProviderContact.LastName = ProviderAccount.Name;
        }   
        ProviderContact.AccountId = ProviderAccount.Id;
        ProviderContact.EID__c = ProviderId;
        ProviderContact.Tax_Id__c = TaxId;
        ProviderContact.NPI__c = NPI;
        return ProviderContact;
    }
    
    public static Interaction__c CreateInteraction(Id ContactId, String InteractionType, String OriginatorType, String ContactName)
    {
        Interaction__c interaction = new Interaction__c();
        interaction.Originator__c = ContactId; 
        interaction.Interaction_Type__c = InteractionType;
        interaction.Originator_Type__c = OriginatorType;
        interaction.Contact_Name__c = ContactName;
        return interaction;
    }
    
    public static Interaction__c CreateInteraction(String InteractionType, String OriginatorType, String CallerName, String TaxId, String Npi, String LastName, String FirstName, String PhoneNumber)
    {
        Third_Party__c ManualProvider = new Third_Party__c();
        ManualProvider.Tax_ID__c = TaxId;
        ManualProvider.NPI__c = Npi;           
        ManualProvider.Name = LastName;
        ManualProvider.First_Name__c = FirstName;
        ManualProvider.Phone_Number__c = PhoneNumber;
        insert ManualProvider;
        
        Interaction__c interaction = new Interaction__c();
        Interaction.Interaction_Type__c = InteractionType;
        Interaction.Originator_Type__c = OriginatorType;
        Interaction.Contact_Name__c = CallerName; 
        Interaction.Third_party__c = ManualProvider.Id;
        
        return interaction;
    }
    
    public static Interaction__c GetInteractionByID(Id InteractionId)
    {
        Interaction__c Interaction = [SELECT Id, Name, Interaction_Type__c, Originator_Type__c, Caller_Type__c,Highlight_Panel_GroupInfo__c , Contact_Name__c, Originator__c, Originator__r.EID__c, Originator__r.Tax_ID__c, Originator__r.NPI__c, 
            Originator__r.Name, Originator__r.LastName, Originator__r.FirstName, Originator__r.AccountId, Originator__r.Account.Name,Third_party__c, Third_party__r.Tax_ID__c, Third_party__r.NPI__c, 
            Third_party__r.FullName__c, Third_party__r.Name, Third_party__r.First_Name__c, Third_party__r.Phone_Number__c, Third_party__r.Email__c
            FROM Interaction__c WHERE Id =:InteractionId];
        system.debug(JSON.serialize(Interaction));    
        return Interaction;
    }
    
    public static Contact GetContactByID(Id contactId)
    {
        Contact subject = [select id,name,firstname,lastname,eid__c,npi__c,other_originator__c,Account.Name,Relationship_To_Member__c,Tax_ID__c,Birthdate from contact where id =:  contactId];
            
        return subject;    
    }   
     
    public static List<ACETContactHistoryCase> GetACETContactCaseHistory(String TaxId)
    {
        /*List<Case> lstCases = new List<Case>([SELECT Id, CaseNumber, Contact.Name, CreatedBy.Name, CreatedDate, Topic__c, Status, 
                                              Interaction__r.Originator_Type__c, Interaction__r.Interaction_Type__c, Interaction__r.Id, Interaction__r.Name
                                              FROM Case WHERE Tax_ID__c = :TaxId ORDER BY CreatedDate DESC limit 1000]);*/
        
        
        // Rama: Modified above SOQL to SOSL to make the tax ID field compatable for encryption
        List<ACETContactHistoryCase> HistoryCases = new List<ACETContactHistoryCase>();
        
        if(String.isBlank(TaxId) ||  TaxId.length() < 2){
            return HistoryCases;
        }
        List<List <SObject>> searchList = new List<List<SObject>>();
        
        String query = 'FIND  \'' + TaxId + '\' IN ALL Fields Returning Case';
        query += ' (Id, TaxID__c, CaseNumber, Contact.Name, CreatedBy.Name, CreatedDate, Topic__c, Status, Interaction__r.Originator_Type__c, Interaction__r.Interaction_Type__c, Interaction__r.Id, Interaction__r.Name ORDER BY CreatedDate DESC limit 1000)';
        searchList = search.query(query);
        
        Set<String> setCaseId = new Set<String>();
        Map<String,Integer> mapCaseIdtoChildRecordsCount = new Map<String,Integer>();
        for(Case oCase : (List<Case>)searchList[0]){
             
            setCaseId.add(oCase.Id); 
        }
        
        for(AggregateResult objAgg: [SELECT Count(Id) cnt,Case__c FROM Create_Letter__c WHERE Case__c =: setCaseId Group by Case__c]){
            
            mapCaseIdtoChildRecordsCount.put(String.valueOf(objAgg.get('Case__c')),Integer.valueOf(objAgg.get('cnt')));
        }
        
        ACETContactHistoryCase HistoryCase;
        for(Case oCase : (List<Case>)searchList[0]){
            if(oCase.TaxID__c == TaxId){
                HistoryCase = new ACETContactHistoryCase();    
                HistoryCase.SFDCId = oCase.Id;
                HistoryCase.CaseNumber = oCase.CaseNumber;
                HistoryCase.SubjectName = String.isBlank(oCase.Contact.Name) ? '' : oCase.Contact.Name;
                HistoryCase.CreatedBy = oCase.CreatedBy.Name;
                HistoryCase.CreatedDate = oCase.CreatedDate;
                HistoryCase.CallTopic = String.isBlank(oCase.Topic__c) ? '' : oCase.Topic__c;
                HistoryCase.Status = String.isBlank(oCase.Status) ? '' : oCase.Status;
                HistoryCase.OriginatorType = oCase.Interaction__r.Originator_Type__c;
                HistoryCase.InteractionType = oCase.Interaction__r.Interaction_Type__c;
                HistoryCase.InteractionSFDCId = oCase.Interaction__r.Id;
                HistoryCase.InteractionName = oCase.Interaction__r.Name;
                HistoryCase.FullfillmentSize = (mapCaseIdtoChildRecordsCount.containsKey(oCase.Id))?mapCaseIdtoChildRecordsCount.get(oCase.Id):0;
                HistoryCases.add(HistoryCase);
            }
        }
        
        return HistoryCases;
    }
    
    //Code Snippet to get the Custom Metadata Types added by Avish 05192017
    public Map<String, Provider_Taxonomy__mdt> getProviderTaxonomy(){
        Map<String, Provider_Taxonomy__mdt> mapTaxonomy = new Map<String, Provider_Taxonomy__mdt>();
        List<Provider_Taxonomy__mdt> provTaxonomyLst = [select Classification__c,Provider_Type__c,Speciality__c,Speciality_Code__c from Provider_Taxonomy__mdt];
        for(Provider_Taxonomy__mdt pt : provTaxonomyLst){
          //  if(!mapTaxonomy.containsKey(pt.Speciality_Code__c)){
                mapTaxonomy.put(pt.Speciality_Code__c, pt);
          //  }
        }           
                
        return mapTaxonomy;
    } 
    
    //Added By Avish to get the federaionID value to map while making web service callout on 06052017
    public static String getFederationIDByUserID(){
        User usr = [Select Id, FederationIdentifier from User where Id=:userinfo.getuserId()];
        return usr.FederationIdentifier;
    }

    //Added By Avish to concatenate fields on View Authorization page on 06122017
    public static String validateConcatenateOfStrings(String firstString, String secondString, String symbolToAppend){
        String resultStr = '';
        if(String.isNotBlank(firstString) && String.isNotBlank(secondString)){
            resultStr = firstString + ' ' + symbolToAppend + ' ' + secondString;
        }else if(String.isNotBlank(firstString) && String.isBlank(secondString)){
            resultStr = firstString + ' ' + symbolToAppend;
        }else if(String.isNotBlank(secondString) && String.isBlank(firstString)){
            resultStr = symbolToAppend + ' ' + secondString;
        }
        
        return resultStr;
    }        
       
}