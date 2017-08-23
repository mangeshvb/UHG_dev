public with sharing class ACETProducerSearchController {

    public String ProducerId { get;set; }
    public String FirstName { get;set; }
    public String producerTaxId {get; set;}
    public String producerSSN {get; set;}
    public String LastName { get;set; }
    public String Companyname { get;set; }
    public string groupNumber {get;set;}
    public String FilterBy { get; set; }
    Public boolean Searched{ get;set; }
    Public string SortBy{ get;set; }
    public String State { get;set; }
    public String LastSortBy{ get;set; }
    public String SortOrder{ get;set; }
    public static string SourceOriginator{ get;set; }
    public static Contact Subject { get;set; }
    public static Interaction__c Interaction { get;set; }
    public String interactionIdAferInsert { get;set; }
    public String urlParam { get;set; }
    public String lastNameParam { get;set; }
    public String firstNameParam { get;set; }
    public String producerIdParam { get;set; }
    public String ErrorMessage { get;set; }
    public ACETDatatableWrapper DTWrapper {get;set;}
    
    Public List<ACETProducerSearchResult> ProducerSearchResults{get;set;}

    Public void sortTable(){
         if(LastSortBy != null){
            if(LastSortBy != SortBy){
                SortOrder = 'Asc';
            }else{
                SortOrder = (SortOrder == 'Asc'? 'Desc' : 'Asc');
            }
        }

        ACETProducerSearchResult.SortBy = SortBy;
        ACETProducerSearchResult.SortOrder = SortOrder;
        LastSortBy = SortBy;

    }

    public void doinit(){
     searched = false;
    }

    public void clear()
    {
      searched = false;
      State = '';
    }

    Public void search()
    {
        try{
            SortBy = 'LastName';
            SortOrder = 'Asc';   
            ErrorMessage = null; 
            //added by Ranjit : vccd integration
            string vccdParam = ApexPages.currentPage().getParameters().get('vccdParams');
            if(vccdParam != '' && vccdParam != null){
                ApexPages.currentPage().getParameters().put('noAutoSearch','true');
            }
    
            searched = true;
            ProducerSearchResults = null;
            groupNumber = '';
            if(producerID == '111111'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETWebServiceUnavailableErrorMessage));
                ProducerSearchResults = null;
                searched = false;
            }else{       
                ACETFindProducerWebservice ACTFPWS = new ACETFindProducerWebservice();
                ACTFPWS.init(producerSSN, producerTaxId, producerID, companyName, groupNumber, LastName, FirstName, State, SortBy, SortOrder,FilterBy);
                DTWrapper = new ACETDatatableWrapper('ACETFindProducerWebservice', ACTFPWS);         
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Agency Name', 'CompanyName'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Last Name', 'LastName'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('First Name', 'FirstName'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Middle Initial', 'MiddleInitial'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Producer ID', 'ProducerID'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('TIN/SSN', 'ProducerTIN'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Producer State', 'producerState'));
                DTWrapper.PageSize = 50;
                           
            }      
           
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETWebServiceUnavailableErrorMessage));
        }
    }

   public List<SelectOption> getSourceOriginators(){
        List<SelectOption> options = new List<SelectOption>();
        SourceOriginator = 'Phone Call';
        /**** added by Vishakha US424980 START***/
        User currentUser = [select profile.Name from User where Id = :UserInfo.getUserId()];
        if(currentUser.profile.Name.contains('Research User')){
            options.add(new SelectOption('Research Only','Research Only'));
        } /**** added by Vishakha US424980 END***/
        else{
            options.add(new SelectOption('Phone Call','Phone Call'));
            options.add(new SelectOption('Chat','Chat'));
            options.add(new SelectOption('Email','Email'));
            options.add(new SelectOption('Fax','Fax'));
            options.add(new SelectOption('Inbound Correspondence','Inbound Correspondence'));
            options.add(new SelectOption('Mail','Mail'));
            options.add(new SelectOption('Outbound Call','Outbound Call'));
            options.add(new SelectOption('Portal','Portal'));
            options.add(new SelectOption('Text','Text'));
            options.add(new SelectOption('Walk-In','Walk-In'));
        }
        return options;
    }
    
    @RemoteAction
    public static String crtInteraction(string firstNameParam,string lastNameParam,string producerIdParam){
        system.debug('producerIdParam :: ' + producerIdParam);
        //added by Ranjit : vccd integration
       /* string vccdParam = ApexPages.currentPage().getParameters().get('vccdParams');
        if(vccdParam != '' && vccdParam != null){
            ApexPages.currentPage().getParameters().put('noAutoSearch','clicked');
        } */
        //Code to insert Account and Contact
        Account UpsertAccount;
        List<Account> existingAccount = [SELECT id, name,EID__c from Account where EID__c =: producerIdParam];
        system.debug('existingAccount :: ' + existingAccount.size() + ' >>> firstName >>> ' + firstNameParam + ' ' + lastNameParam);

        if(existingAccount.size() == 0){
            UpsertAccount = new Account();
            UpsertAccount.Name = firstNameParam + ' ' + lastNameParam;
            UpsertAccount.EID__c = producerIdParam;
            Insert UpsertAccount;
        }else{
            UpsertAccount = existingAccount[0];
            UpsertAccount.Name = firstNameParam + ' ' + lastNameParam;
            upsert UpsertAccount;
        } 
        system.debug('UpsertAccount :: ' + UpsertAccount);

        List<Contact> existingContact = [SELECT id, LastName,FirstName,EID__c,AccountId from Contact where EID__c =: producerIdParam];
        system.debug('existingContact :: ' + existingContact.size());
        if(existingContact.size() > 0){
            
            Subject = new Contact(id=existingContact[0].id);
            Subject.FirstName = firstNameParam;
            Subject.LastName = lastNameParam;
            Subject.Tax_ID__c = producerIdParam;
            Subject.AccountId = UpsertAccount.Id;
            upsert Subject;
        }else{
            Subject = new Contact();
            Subject.FirstName = firstNameParam;
            Subject.LastName = lastNameParam;
            Subject.EID__c = producerIdParam;
            Subject.Tax_ID__c = producerIdParam;
            Subject.AccountId = UpsertAccount.Id;
            insert Subject;
        }
        system.debug('Subject :: ' + Subject);
        
        Interaction = new Interaction__c();
        Interaction.Originator__c = Subject.Id;

        //for now, we only have the use case as member calls themselves
        Interaction.Interaction_Type__c = SourceOriginator;
        Interaction.Originator_Type__c = 'Producer'; 
        upsert Interaction;
        Interaction = ACETMemberQueryUtil.queryInteraction(Interaction.Id);
        system.debug('Interaction:::'+Interaction);
        return Interaction.id;
        
        
    }

}