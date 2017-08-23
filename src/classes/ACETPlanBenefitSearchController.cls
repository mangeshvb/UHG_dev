public with sharing class ACETPlanBenefitSearchController {
    public ACETCallTopicsDataWrapper wrapper {get;set;}    
    public Case CaseStub {get;set;} //stub record to display a calendar for date of birth
    public String PolicyNumber {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get {
        return JSON.serialize(wrapper.AdditionalInfo);
    }set;}
    public string surrogateKey {get; set;}
    public Interaction__c Interaction {get;set;}
    public Contact subject{get;set;}    
    public String SourceOriginator {get;set;}
    public List<String> networkSchList {get;set;}
    //for temporary purpose
    public String MemberId {get;set;}
    public String FirstName {get;set;}
    public String LastName {get;set;}
    public String ZipCode {get;set;}
    public String State {get;set;}
    public boolean noGroupsFound {get;set;}
    //searchResults
   // public List<ACETPlanBenefitSearchResult> Results {get;set;} 
    public String ErrorMessage {get;set;}   
    //sort member search result    
    public String SortBy {get;set;}
    public String SortOrder {get;set;}
    public String LastSortBy{get;set;}
    //public List<GroupInfo> GroupInfos{get;set;}
    public List<ACETGroupSearchResult> GroupInfos {get;set;}
    public String groupNumber {get;set;}
    public String groupName {get;set;}
    public boolean groupSearchResult{get;set;}
    public String interactionId{get;set;}
    
    //To be removed once moved to adapter
    public ACETGroupDetail oACETGroupDetail;
    private string networkId;
    public String bundleOptionId {get;set;}
    
    public List<ACETGroupDetail.GroupPlanWrapper> GroupPlanBenefitResultsList {get; set;}
    public static List<ACETGroupDetail.GroupPlanWrapper> GroupPlanSearchResults {get; set;}
    public static ACETGroupDetail groupPlanDetails{get;set;}
    public Boolean IsShowActiveBenefitsOnly {get;set;}
    public String searchGroupName{get;set;}
    public List<ACETGroupPlanBenefitWrapper.PlanInformationWrapper> planInfoList {get; set;}
    public ACETGroupPlanBenefitWrapper planInfoWrapper {get; set;}
    
    public ACETStateCodeContainer StateCode { get; set; }
    public ACETPlanBenefitSearchController() {
        CaseStub = new Case();
        Casestub.tst_Date_Field__c = Date.today();
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'Plan Benefits'; 
        //wrapper.caseItem.Topic = 'Plan Benefits';  
        interactionId = ApexPages.currentPage().getParameters().get('interactionId');   
        String additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        bundleOptionId = apexpages.currentpage().getparameters().get('bundleOptionId');
        system.debug(LoggingLevel.INFO,'bundleOptionId:: '+ bundleOptionId);
        wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(additionalInfoStr,ACETHighlightsPanelAdditionalInfo.class);  
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
         if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }
        //searchByGroupName();
        noGroupsFound = false;
        groupSearchResult=false;           
        StateCode = new ACETStateCodeContainer('');
        networkSchList = new List<String>();
         }
         
    public void CallGetSubscriptionBenefitWS(){
        system.debug(LoggingLevel.INFO,'Inside CallGetSubscriptionBenefitWS ');
        ACETGetSubscriptionBenefitWebservice stubData = new ACETGetSubscriptionBenefitWebservice();
        ACETWSCalloutResult responseData = stubData.getSubscriptionBenefitSearch(bundleOptionId, 'true');
        system.debug(LoggingLevel.INFO,'responseData:: ' + responseData);
        if(responseData.success){
            planInfoList  = new List<ACETGroupPlanBenefitWrapper.PlanInformationWrapper>();
            planInfoWrapper = (ACETGroupPlanBenefitWrapper)responseData.response;
            planInfoList = planInfoWrapper.planInfoWrapperList;
            system.debug(LoggingLevel.INFO,'planInfoList:: ' + planInfoList);
            if(planInfoList!=null){             
                for(ACETGroupPlanBenefitWrapper.PlanInformationWrapper networkSch : planInfoList){
                    if(networkSch.networkSchedules != null){
                        for(ACETGroupPlanBenefitWrapper.networkScheduleIds netSchObj : networkSch.networkSchedules ){
                            networkSchList.add(netSchObj.networkSchId);
                      }
                    }
                }
            }
        }
    }
         
    public void search(){
            GroupInfos = null;   
            GroupPlanBenefitResultsList  = null;
             
        try{
         
            ErrorMessage = null;           
             String dob = CaseStub.tst_Date_Field__c != null ? (CaseStub.tst_Date_Field__c.year() + '-' + CaseStub.tst_Date_Field__c.month() + '-' + CaseStub.tst_Date_Field__c.day())  : '';
          
            SortBy = 'policyNumber'; 
            SortOrder = 'Asc';
            sortTable(); 
       
            noGroupsFound = false;      
            
            try{
                
                ACETFindEmployerGroupSearchWebService FindGroupService = new ACETFindEmployerGroupSearchWebService();
                FindGroupService.init(PolicyNumber,PolicyNumber,groupName,State);               
                system.debug('stateCode.value *** ' + State);
                String taxId;
                String g_groupId = PolicyNumber;
                String g_gName = groupName;
                String g_state = State;
          
                    ACETWSCalloutResult result = FindGroupService.queryPaginatedData(1,10,1);               
                      if (String.isEmpty(result.Message)){
                        GroupInfos = (List<ACETGroupSearchResult>)result.response;
                        if(GroupInfos == null){
                            GroupInfos = new List<ACETGroupSearchResult>();
                            GroupPlanBenefitResultsList = new List<ACETGroupDetail.GroupPlanWrapper>();
                        }
                        system.debug('-------107--------'+GroupInfos);
                         
                    }
             
            }catch(Exception e){
                GroupInfos = null;
                noGroupsFound = true;
            }            
           
        }
        catch(Exception ex){
            ErrorMessage = 'Web Service or External System is temporarily unavailable.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorMessage));
        }
    } 
    
    public ACETWSCalloutResult callwebservice(string groupId)
    {
        ACETGetEmployerDetailAdapterWebService stubData = new ACETGetEmployerDetailAdapterWebService();
        ACETWSCalloutResult responseData = stubData.GetEmployerGroupDetail(groupId);     
        System.debug('Allowing.................'+responseData);
        return responseData;
    }      
        
    public void searchPlans(){   

        if(IsShowActiveBenefitsOnly == null) {
            IsShowActiveBenefitsOnly = true;   
        }
        else{
            IsShowActiveBenefitsOnly = !IsShowActiveBenefitsOnly;
        }  
         
        groupSearchResult=true; 
        system.debug('IsShowActiveBenefitsOnly :: ' + IsShowActiveBenefitsOnly);  
        System.debug('All******'+GroupPlanSearchResults);
        groupPlanDetails = new ACETGroupDetail(); 
        GroupPlanBenefitResultsList = new List<ACETGroupDetail.GroupPlanWrapper>();
        try {
            system.debug('groupName >>> ' + searchGroupName);
            ACETWSCalloutResult responseGroupPlanData = callwebservice(searchGroupName);
            System.debug('Response1...'+responseGroupPlanData);
            if(responseGroupPlanData.Success) {
                GroupPlanSearchResults = new List<ACETGroupDetail.GroupPlanWrapper>();
                groupPlanDetails = (ACETGroupDetail)responseGroupPlanData.response;
                System.debug('Response2...'+groupPlanDetails);
                GroupPlanSearchResults = groupPlanDetails.GroupPlanBenefitList;
                System.debug('callout result for Groupdetails'+GroupPlanSearchResults);  
                if(GroupPlanSearchResults != null) {
                    for(ACETGroupDetail.GroupPlanWrapper groupPlan:GroupPlanSearchResults) {
                        if(!IsShowActiveBenefitsOnly || groupPlan.getImage() == 'active') {
                            System.debug('All1******'+groupPlan);
                            GroupPlanBenefitResultsList.add(groupPlan);
                        }
                    }
                }     
                system.debug('GroupPlanBenefitResultsList *** ' + GroupPlanBenefitResultsList.size() + ' *** ' + GroupPlanBenefitResultsList);     
            }
            else{ 
                ApexPages.addMessage(new ApexPages.Message(responseGroupPlanData.MessageSeverity, responseGroupPlanData.Message));  
            }
        }  
        catch(Exception ex)
        { 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETOILNotAvailable )); 
        }            
            
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
       // Results.sort();
        LastSortBy = SortBy;                                
    }
    
    public class PlanInfo{
        public String PolicyNumber {get;set;}
        public String PlanId {get;set;}
        public String Product {get;set;}
        public String EffectiveDate {get;set;}
        public String EndDate {get;set;}
        public String ExpirationDate{get;set;}
        public String RevisionDate {get;set;}
        public String GroupName {get;set;}
    }
    public class GroupInfo{
        public String groupName {get;set;}
        public String address {get;set;}
        public String city {get;set;}
        public String status {get;set;}
        public String state {get;set;}
        public String zip {get;set;}
        public String phoneNumber {get;set;}
    }   
    public void clear(){
        
        PolicyNumber='';
        groupName='';
        StateCode=new ACETStateCodeContainer('');   
        GroupPlanBenefitResultsList = null;
        GroupInfos = null;
    } 
    
    public List<SelectOption> getStateOptions(){                        
        List<SelectOption> stateOptions = new List<SelectOption>();   
             
        stateOptions.add(new SelectOption('', '--None--'));
        stateOptions.add(new SelectOption('AK', 'AK'));
        stateOptions.add(new SelectOption('AL', 'AL'));
        stateOptions.add(new SelectOption('AR', 'AR'));
        stateOptions.add(new SelectOption('AZ', 'AZ'));
        stateOptions.add(new SelectOption('CA', 'CA'));
        stateOptions.add(new SelectOption('CO', 'CO'));
        stateOptions.add(new SelectOption('CT', 'CT'));
        stateOptions.add(new SelectOption('DC', 'DC'));
        stateOptions.add(new SelectOption('DE', 'DE'));
        stateOptions.add(new SelectOption('FL', 'FL'));
        stateOptions.add(new SelectOption('GA', 'GA'));
        stateOptions.add(new SelectOption('HI', 'HI'));
        stateOptions.add(new SelectOption('IA', 'IA'));
        stateOptions.add(new SelectOption('ID', 'ID'));
        stateOptions.add(new SelectOption('IL', 'IL'));
        stateOptions.add(new SelectOption('IN', 'IN'));
        stateOptions.add(new SelectOption('KS', 'KS'));
        stateOptions.add(new SelectOption('KY', 'KY'));
        stateOptions.add(new SelectOption('LA', 'LA'));
        stateOptions.add(new SelectOption('MA', 'MA'));
        stateOptions.add(new SelectOption('MD', 'MD'));
        stateOptions.add(new SelectOption('ME', 'ME'));
        stateOptions.add(new SelectOption('MI', 'MI'));
        stateOptions.add(new SelectOption('MN', 'MN'));
        stateOptions.add(new SelectOption('MO', 'MO'));
        stateOptions.add(new SelectOption('MS', 'MS'));
        stateOptions.add(new SelectOption('MT', 'MT'));
        stateOptions.add(new SelectOption('NC', 'NC'));
        stateOptions.add(new SelectOption('ND', 'ND'));
        stateOptions.add(new SelectOption('NE', 'NE'));
        stateOptions.add(new SelectOption('NH', 'NH')); 
        stateOptions.add(new SelectOption('NJ', 'NJ'));
        stateOptions.add(new SelectOption('NM', 'NM'));
        stateOptions.add(new SelectOption('NV', 'NV'));
        stateOptions.add(new SelectOption('NY', 'NY'));
        stateOptions.add(new SelectOption('OH', 'OH'));
        stateOptions.add(new SelectOption('OK', 'OK'));
        stateOptions.add(new SelectOption('OR', 'OR'));
        stateOptions.add(new SelectOption('PA', 'PA'));
        stateOptions.add(new SelectOption('PR', 'PR'));
        stateOptions.add(new SelectOption('RI', 'RI'));
        stateOptions.add(new SelectOption('SC', 'SC'));
        stateOptions.add(new SelectOption('SD', 'SD'));
        stateOptions.add(new SelectOption('TN', 'TN'));
        stateOptions.add(new SelectOption('TX', 'TX'));
        stateOptions.add(new SelectOption('UT', 'UT'));
        stateOptions.add(new SelectOption('VA', 'VA'));
        stateOptions.add(new SelectOption('VT', 'VT'));
        stateOptions.add(new SelectOption('WA', 'WA'));
        stateOptions.add(new SelectOption('WI', 'WI'));
        stateOptions.add(new SelectOption('WV', 'WV'));
        stateOptions.add(new SelectOption('WY', 'WY'));        
        return stateOptions;
    }     

    public String ReplaceKeywords(String ResponsBody) {
        return ResponsBody.replaceAll('"desc"','"descr"').replaceAll('"date"','"dte"').replaceAll('"dateTime"','"dteTime"').replaceAll('"number"','"numbr"').replaceAll('"type"','"eType"').replaceAll('"object"','"Object_Z"');
    }          
    
}