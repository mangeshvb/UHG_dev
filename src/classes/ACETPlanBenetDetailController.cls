public with sharing class ACETPlanBenetDetailController{
    public List<PolicyOverviewWrapper> policies{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}    
    
    public ACETPlanBenetDetailController(){
        policies = new List<PolicyOverviewWrapper>();
        
        PolicyOverviewWrapper polovr = new PolicyOverviewWrapper();
        polovr.isSelected=true;
        polovr.policyNumber='000737';
        polovr.policyEffDate=system.today();
        polovr.policyEndDate=system.today().addYears(-5);
        polovr.productName='Indemnity';
        polovr.tieredProduct='Yes';
        polovr.gated='Yes';
        polovr.productYear=polovr.policyEndDate.year();
        polovr.carryOver='Yes';
        polovr.revisionDate=system.today().addMonths(3);
        polovr.revisionReason='Many';
        
        policies.add(polovr);
        
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'Plan Benefits';  
    }
    
    public class PolicyOverviewWrapper{
        public boolean isSelected{get;set;}
        public String policyNumber{get;set;}
        public Date policyEffDate{get;set;}
        public Date policyEndDate{get;set;}
        public String productName{get;set;}
        public String tieredProduct{get;set;}
        public String gated{get;set;}
        public Integer productYear{get;set;}
        public String carryOver{get;set;}
        public Date revisionDate{get;set;}
        public String revisionReason{get;set;}
    }
}