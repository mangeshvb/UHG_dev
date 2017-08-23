public with sharing class AutoDocTestController {

    public string swivelBRMS_URL{get;set;}
    //public list<ACETCallTopicsDataWrapper.innerWrapper> innerClassList {get; set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public string comments{get;set;} 
    public Contact Subject { get; set; }
    public Interaction__c  Interaction { get; set; }    
    public string redirectUrl {get; set;} 
    public List<String> selectedCallType{get;set;}
    public String[] tests {get; set;}
    public String callTopic {get; set;}
    public boolean notResearchUser {get;set;}
    public id interactionId{get;set;}
    public id contactid{get;set;}
    public string resolvedIds {get; set;}
    public AutoDocTestController()
    {   
        string InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        string contactId = apexpages.currentpage().getparameters().get('contactId');
        callTopic = apexpages.currentpage().getparameters().get('callTopic');
        string test = apexpages.currentpage().getparameters().get('param1');
        getloggedinProfileName();
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = callTopic;
        wrapper.AutodocComment = comments;
        System.debug('Entering'+InteractionId+contactId+callTopic);
        fetchBRMSSysURL();        
    }
     public void passParameters() {
         /*System.debug('Test>>>>>>#'+selectedValue);
         //wrapper = new ACETCallTopicsDataWrapper(); 
         wrapper.selectedCallType = selectedValue;
         //List<String> con = gettests();
         //return null;*/
     }
     private void getloggedinProfileName(){ 
       try{
            notResearchUser = true;
            List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            String loggedinProfileName = PROFILE[0].Name;
        
            //Check if the logged-in User has profile 'Research' type
               if(loggedinProfileName.contains('Research'))
                { 
                    notResearchUser = false;
                }
        }catch(exception ex){
            System.debug('The exception is'+ ex.getmessage());
        }
       
    } 
    public List<billingWrapper> billingValuesList {get; set;} 
    public List<billingWrapper> getBillingCategories()
    {
        billingValuesList = new List<billingWrapper>();
        List<Call_Topic__c> callsTopic = [select Name_OOB__c,Call_Type__c, Active__c from Call_Topic__c where Name_OOB__c =: callTopic];
        for(Call_Topic__c callType : callsTopic) {
            if(callType.Active__c == true) {
                 billingValuesList.add(new billingWrapper(callType.Call_Type__c));
            } 
        }
        return billingValuesList;
    }
    
    public class billingWrapper {
        public Boolean optionSelected {get; set;}
        public String callType {get; set;}
        public string resolvedIds {get; set;}
        public billingWrapper(String callTypeWrap) {
             callType =  callTypeWrap; 
             optionSelected = false; 
             resolvedIds ='';
        }
    }
    public List<SelectOption> getstatusList()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new selectOption('None','--None--'));
        options.add(new selectOption('resolved','Resolved'));
        options.add(new selectOption('Unresolved','Unresolved'));
        return options;
    }
    //function to fetch BRMS url 
    public void fetchBRMSSysURL(){    
         Map<String, ACETOrgNameToSwivelEndpointMap__c> mapEndpointDetails = ACETOrgNameToSwivelEndpointMap__c.getAll();
         string sandboxName = ACETUtility.GetOrgName();
         swivelBRMS_URL= ACETUtility.GetSwivelEndpointByOrgName(sandboxName,'BRMS',mapEndpointDetails);
    }
    
    public PageReference resolvedFunction() {
        for(billingWrapper bw:billingValuesList) {
            System.debug('Testing####Test%%%%'+bw.callType+'@@@@'+bw.optionSelected+'^^^^'+bw.resolvedIds);
        }
        return null;
    }
}