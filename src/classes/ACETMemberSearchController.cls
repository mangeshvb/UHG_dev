public with sharing class ACETMemberSearchController{ 
    public ACETDatatableWrapper DTWrapper {get;set;}
    public String SourceOriginator {get;set;}
        
    public Interaction__c Interaction { get; set; } 
     
    public Contact Provider {get;set;}  
    
    //member search fields
    //public String interactionTyp{get;set;}
    //public String InteractionIdStr {get;set;}
    
    public String MemberId {get;set;}
    public String FirstName {get;set;}
    public String LastName {get;set;}
    public String ZipCode {get;set;}
    public String State {get;set;}
     //stub record to display a calendar for date of birth
    public Case CaseStub {get;set;}
    public boolean isMisdirectCaseCreation{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    
    public List<ACETMemberSearchResult> Results {get;set;}
    public map<String,ACETMemberSearchResult> mapResults{get;set;}
    public ACETMemberSearchResult selectedResult{get;set;}
    
    //sort member search result    
    public String SortBy {get;set;}
    public String SortOrder {get;set;}
    public String LastSortBy{get;set;}
    
    public Boolean IsShowMisdirectedCall {get;set;}
    public String Comments {get;set;}     
    public String MisdirectedReason {get;set;}
    public String ClosedReason {get;set;}
        
    public String ErrorMessage {get;set;}
    /* Code commented for US585208 -- by divya
    public String enrollmentLag {get; set;}
    public String groupSize {get; set;}
    public String rehirePolicy { get; set; } */
    public String groupId{ get; set; }
    
    public Boolean IsMember{get;set;}
    
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}
    public Interaction__c sourceApplication {get; set;}//US635546-SNI
    public ACETMemberSearchController(){
        CaseStub = new Case();
        IsShowMisdirectedCall = false;
        //InteractionIdStr = ApexPages.currentPage().getParameters().get('InteractionId');
        //interactionTyp = ApexPages.currentPage().getParameters().get('interactionType');
        //if(interactionTyp == null || interactionTyp ==''){
            //interactionTyp = 'Phone Call';//Default Value
        //}
        //system.debug('-------InteractionIdStr----->'+InteractionIdStr);
        sourceApplication = new Interaction__c();//US635546-SNI
    }
    
    public void init(){
        IsMember = true;
        String providerId = ApexPages.currentPage().getParameters().get('id');
        isMisdirectCaseCreation=false;
        if(!String.isEmpty(providerId)){
            Provider = [select id,FirstName, LastName, Tax_ID__c, NPI__c from Contact where Id = :providerId];
        }   
        
        //Get Provider Interaction SFDC Id
        String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');    
        //Check if User is redirected to Member Search page from Provider detail page         
        if (!String.isEmpty(interactionId)){                        
            system.debug('InteractionId: ' + InteractionId);
            
            //Query Provider Interaction details
            Interaction = ACETMemberQueryUtil.queryInteraction(interactionId);
            IsMember = false;
            SourceOriginator = Interaction.Interaction_Type__c;
            system.debug('Interaction: ' + Interaction + ', SourceOriginator: ' + SourceOriginator);
        }
        /* Code commented for US585208 -- by divya
        enrollmentLag = ApexPages.currentPage().getParameters().get('enrolLag');
        groupSize = ApexPages.currentPage().getParameters().get('groupSize');
        rehirePolicy = ApexPages.currentPage().getParameters().get('rehirePolicy'); */
        groupId = ApexPages.currentPage().getParameters().get('groupId');
        system.debug('--------groupId----'+groupId);
        initHighlightPanelAdditionalInfo();
    }
    
    private void initHighlightPanelAdditionalInfo(){
        if(AdditionalInfo == null){
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
            if(ApexPages.currentPage().getParameters().get('ProvTypeCode') != null && ApexPages.currentPage().getParameters().get('ProvTypeCode') != ''){//added by Vishakha for Communication
                AdditionalInfo.providerType = ApexPages.currentPage().getParameters().get('ProvTypeCode');
            }
        }        
        string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if(addInfo != null)
        {
            AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
        /******added by sourabh ****/ 
        if(Interaction != Null && Interaction.Highlight_Panel_GroupInfo__c != null)
        {
            ACETGroupDetailsWrapper deserializedExceptionData = (ACETGroupDetailsWrapper)JSON.deserialize(Interaction.Highlight_Panel_GroupInfo__c, ACETGroupDetailsWrapper.class);
            AdditionalInfo.UHCBS = deserializedExceptionData.UHCBS;    
            AdditionalInfo.GroupN = deserializedExceptionData.GroupName ;
            AdditionalInfo.GroupStatus = deserializedExceptionData.GroupStatus;
            AdditionalInfo.ServiceTeam = deserializedExceptionData.ServiceTeam;
            AdditionalInfo.EffectiveStartDate = deserializedExceptionData.EffectiveStartDate;
            AdditionalInfo.RiskManagement = deserializedExceptionData.RiskManagement;
            AdditionalInfo.RatingMethod = '';
            AdditionalInfo.RenewalDate= deserializedExceptionData.RenewalDate; 
            AdditionalInfo.RelationshipType = deserializedExceptionData.RelationshipType ; 
        }
           
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
    }
        
    public void search(){
        try{
            system.debug(State);
            Results = null;
            mapResults = null;
            ISShowMisdirectedCall = false;   
            ErrorMessage = null;
           
            String dob = CaseStub.tst_Date_Field__c != null ? (CaseStub.tst_Date_Field__c.year() + '-' + CaseStub.tst_Date_Field__c.month() + '-' + CaseStub.tst_Date_Field__c.day())  : '';
                        
            ACETFindMemberWebService FindMemberService = new ACETFindMemberWebService();
            FindMemberService.init(MemberId, FirstName, LastName, dob, State, ZipCode);
                        
            DTWrapper = new ACETDatatableWrapper('ACETFindMemberWebService', FindMemberService);         
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Last Name', 'LastName'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('First Name', 'FirstName'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Middle Name', 'MiddleInitial'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Gender', 'Gender'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Date Of Birth', 'DOB'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('SSN', 'SSN'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Address', 'Address'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('City', 'City'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('State', 'State'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Zip', 'Zip'));
            //if(MemberId != '00589997121')
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('SourceCode', 'SourceCode'));
            //else
                //DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('SourceCode', ''));
            //ACETFindMemberWebService service = new ACETFindMemberWebService();                        
            //ACETWSCalloutResult calloutResult = service.findMembers(MemberId, FirstName, LastName, dob, State, ZipCode);            
            //system.debug('result controller : '+calloutResult);            
            /*
            if(calloutResult.Success){
                 Results = new List<ACETMemberSearchResult>();  
                 mapResults = new Map<String,ACETMemberSearchResult>();               
                 Results = (List<ACETMemberSearchResult>)calloutResult.Response;
                 system.debug('Results in ctrnl >> '+JSON.serialize(Results)); 
                 for(ACETMemberSearchResult ac :Results){
                    system.debug('Id--->'+ac.id);
                    if(ac.Id != null){
                        mapResults.put(ac.Id , ac);
                    }
                    else{
                        mapResults.put(ac.SurrogateKey , ac);
                    }
                 }                               
            }else{
                ErrorMessage = calloutResult.Message;
                ApexPages.addMessage(new ApexPages.Message(calloutResult.MessageSeverity, calloutResult.Message));  
            }
            
            SortBy = 'LastName'; 
            SortOrder = 'Asc';
            sortTable();  
            */
            
            string vccdParam = ApexPages.currentPage().getParameters().get('vccdParams');
            system.debug('------vccdParam------'+vccdParam );
            if(vccdParam != '' && vccdParam != null){
                ApexPages.currentPage().getParameters().put('noAutoSearch','true');
            }
            
        }catch(Exception ex){
            //ErrorMessage = 'Web Service or External System is temporarily unavailable.';
            ErrorMessage = ex.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorMessage));
        }
        
       
    }
    public void renderMisdirectCaseSection(){
        isMisdirectCaseCreation=true;  
    }
    
    public void clear(){
        MemberId = '';
        FirstName = '';
        LastName = '';
        ZipCode = '';
        State = '';
        CaseStub = new Case(); 
        ISShowMisdirectedCall = false;
        SourceOriginator = '';   
        Results = null;
        ErrorMessage = null;
        DTWrapper = null;
    }
        
    public void saveMisredirectedCase(){
        if(Interaction == null){
            interaction = new Interaction__c();
            interaction.Interaction_Type__c = SourceOriginator;
            insert interaction; 
        }
        
        Case c = new Case();
        c.Interaction__c = Interaction.Id;
        c.Status = 'Cancelled';
        c.Misdirected_Reason__c = MisdirectedReason;
        c.Comments__c = Comments;
        insert c;
        
        clear();    
    }
    
    public void saveSystemUnavailableCase(){
        try{
        if(Interaction == null){
            interaction = new Interaction__c();
            interaction.Interaction_Type__c = SourceOriginator;
            insert interaction; 
        }
         
        Case c = new Case();
        c.Interaction__c = Interaction.Id;
        c.Status = 'Closed';
        c.New_Closed_Reason__c = 'System Unavailable';
        c.Comments__c = Comments;
        
        insert c;
        
        clear();
        }
        catch(exception e){}    
    }
    
    public void sortTable(){   
        if(LastSortBy != null){             
            if(LastSortBy != SortBy){
                SortOrder = 'Asc';                      
            }else{
                SortOrder = (SortOrder == 'Asc'? 'Desc' : 'Asc');
            }
        }
        
        ACETMemberSearchResult.SortBy = SortBy;
        ACETMemberSearchResult.SortOrder = SortOrder;
        Results.sort();
        LastSortBy = SortBy;                                
    }
    
    public void showMisdirectedCall(){
        ISShowMisdirectedCall = true;
    }
    
    public List<SelectOption> getMisdirectedReasons(){
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Cosmos','Cosmos'));
        options.add(new SelectOption('CSP Facets','CSP Facets'));
        options.add(new SelectOption('Dental Plan','Dental Plan'));
        options.add(new SelectOption('Member Serivce','Member Service'));
        options.add(new SelectOption('Other','Other'));
        options.add(new SelectOption('Pharmacy RX Other','Pharmacy RX Other'));
        options.add(new SelectOption('Prime','Prime'));
        options.add(new SelectOption('Provider Relations','Provider Relations'));
        options.add(new SelectOption('Pulse','Pulse'));
        options.add(new SelectOption('UNET','UNET'));
        options.add(new SelectOption('Vision Plan','Vision Plan'));
        options.add(new SelectOption('Wrong Carrier','Wrong Carrier'));
        return options;     
    }
        
    public List<SelectOption> getClosedReasons(){
        List<SelectOption> options = new List<SelectOption>();                
        options.add(new SelectOption('System Unavailable','System Unavailable'));        
        return options;     
    }
    
    public List<SelectOption> getSourceOriginators(){
        List<SelectOption> options = new List<SelectOption>();
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
    public static String createInteraction(String interactionType, String interactionId){
        
        Interaction__c interaction = new Interaction__c();  
        interaction.Interaction_Type__c = interactionType;
        Interaction.Originator_Type__c = 'Member';
        insert interaction;         
        return interaction.Id;    
        
        /**
        if(interactionId == null || interactionId == ''){            
            interaction.Interaction_Type__c = interactionType;
            insert interaction;              
        }else{
            interaction = ACETMemberQueryUtil.queryInteraction(interactionId);
        }       
        if(interaction != null)
            return interaction.Id;
        else
            return null;   
        */    
    }

    
    /**
    public void createInteraction(){
        String selSrrKey = apexpages.currentpage().getparameters().get('SelSrrKey');
        
        selectedResult = new ACETMemberSearchResult();
        selectedResult = mapResults.get(selSrrKey);
            
        if(IsMember == true){
            interaction = new Interaction__c();
            interaction.Interaction_Type__c = SourceOriginator;
            insert interaction; 
        }               
    }
    */   
}