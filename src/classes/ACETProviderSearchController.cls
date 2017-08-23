global with sharing class ACETProviderSearchController 
{
    public String InteractionType { get; set; }
    public String CallerName { get; set; }
    public String TaxID { get; set; }
    public String NPI { get; set; }
    public String LastName { get; set; }
    public String FirstName { get; set; }
    public ACETStateCodeContainer StateCode { get; set; }
    public String ZipCode { get; set; }
    private String providerTypeCodeVal;
    public String PhoneNumber { get; set; }
    public String FilterBy { get; set; }
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public ACETDatatableWrapper DTWrapper { get; set; }     //Used by pagination component
	    
    public ACETProviderSearchController()
    {
        StateCode = new ACETStateCodeContainer('');
    }
    
    public void Search()
    {
        system.debug(LoggingLevel.INFO, 'FilterBy:: ' + FilterBy);
        if (FilterBy == 'FACL') {
           this.providerTypeCodeVal = 'HCO' ;
        } else if(FilterBy == 'PROF') {
            this.providerTypeCodeVal = 'HCP' ;
        } else {
            this.providerTypeCodeVal = 'BOTH' ;
        }
    	
    	ACETFindProviderLookupWebservice ACTFPWS = new ACETFindProviderLookupWebservice();
        ACTFPWS.Init(null, NPI, TaxId, LastName, FirstName, null, null, ZipCode, null, null, stateCode.value, PhoneNumber, 
        				null, null, null, null, null, providerTypeCodeVal);
        ACTFPWS.GetEndpoint();	 
        DTWrapper = new ACETDatatableWrapper('ACETFindProviderLookupWebservice', ACTFPWS);   
        DTWrapper.PageSize = ACTFPWS.PageSize;
        DTWrapper.PageStartNumber = 0;
        DTWrapper.PageNumber = 0;
        DTWrapper.StartRecord = 0;
        DTWrapper.initOnDocumentReady = false;
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(Label.ACETProviderSearchTaxIdLabel, 'taxId'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(Label.ACETProviderSearchPlatinumProviderLabel, 'platinum'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(Label.ACETProviderSearchFullNameLabel, 'fullName'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(Label.ACETProviderSearchStreetAddressLabel, 'street'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(Label.ACETProviderSearchCityLabel, 'city'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(Label.ACETProviderSearchStateLabel, 'state'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(Label.ACETProviderSearchZipCodeLabel, 'zipCode'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(Label.ACETProviderSearchPhoneNumberLabel, 'phoneNumber'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(Label.ACETProviderSearchFacilityLabel, 'providerType'));
    }
    
    public void clearResults() {
    	DTWrapper = null;	        
    }    
    
    @RemoteAction
    public static Interaction__c RedirectToProviderDetail(String InteractionType, String ContactName, String ProviderId, String TaxID, String NPI, String GroupName, String ProviderType)
    {
        system.debug(LoggingLevel.INFO, 'InteractionType : ' + InteractionType + ', ContactName: ' + ContactName + ', ProviderId: ' + ProviderId + ', TaxId: ' + TaxId);
        system.debug(LoggingLevel.INFO, ', NPI: ' + NPI + ', GroupName: ' + GroupName + ', ProviderType: ' + ProviderType);
        
        Interaction__c Interaction;
        
        try {
            Account ProviderAccount = ACETProviderUtility.CreateProviderAccount(ProviderId, GroupName, TaxID);
            upsert ProviderAccount EID__c;
            system.debug(LoggingLevel.INFO, 'ProviderAccount: ' + ProviderAccount);
            
            Contact ProviderContact = ACETProviderUtility.CreateProviderContact(ProviderType, ProviderAccount, ProviderId, TaxID, NPI);
            upsert ProviderContact EID__c;
            system.debug(LoggingLevel.INFO, 'ProviderContact: ' + ProviderContact);
                    
            Interaction = ACETProviderUtility.CreateInteraction(ProviderContact.Id, InteractionType, Label.ACETProviderSearchOriginatorType, ContactName);
            insert Interaction;
            
            Interaction = [SELECT Id, Name, Originator__r.LastName FROM Interaction__c WHERE Id =:Interaction.Id];
            
            system.debug(LoggingLevel.INFO, 'Interaction: ' + Interaction);
        }
        catch (Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Error creating Interaction. Details: ' + ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.ACETUnexpectedErrorMessage));
        }
        return Interaction;                 
    }
    
    public List<SelectOption> getInteractionTypes()
    {
        List<SelectOption> lstInteractionTypes = new List<SelectOption>();
         /**** added by Vishakha US424980 START***/
        User currentUser = [Select profile.name from User where Id =: UserInfo.getUserID()];
        if(currentUser.profile.Name.contains('Research User')){
            lstInteractionTypes.add(new SelectOption(label.ACETResearchUserInteractionType, label.ACETResearchUserInteractionType));    
        } /**** added by Vishakha US424980 END***/
        else{
            for(String IntrType :Label.ACETProviderSearchInteractionTypes.split(','))
            {
                lstInteractionTypes.add(new SelectOption(IntrType, IntrType));
            }
            system.debug(LoggingLevel.INFO, 'lstInteractionTypes: ' + lstInteractionTypes);
        }
        return lstInteractionTypes;
    }
}