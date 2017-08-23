public with sharing class ACETMemberLevelExceptionPDFController{
   public String comments{get;set;} 
    public string redirectUrl {get; set;} 
    public final Case caseObj;
    
    /******* input fields for Member Level Exception Form *********/
    public string phone{get;set;}
    public string selectedExceptionType{get;set;}
    public string selectedRootCauseException{get;set;}
    public string selectedServiceTerm{get;set;}
    public string selectedBatchCode{get;set;}
    public string broekrId{get;set;}
    public string broekrName{get;set;}
    public string accManager{get;set;}
    public string salesRep{get;set;}
    public boolean displayFlag{get; set;}
    public string selectedrequestor{get;set;}
    public list<memberDetailWrap> memberDetailList{get;set;}
    public boolean RRUser {get; set;}
    public ACETSystemUnavailableWrapper wrapperObj {get; set;}
    public ACETMemberExceptionWrapper deserializedExceptionData{get; set;} 
    
    public case caseObj1;
    public ACETMemberLevelExceptionPDFController(ApexPages.StandardController controller) {
        
        //Assign value 
        this.caseObj = (Case)controller.getRecord();
        caseObj1 = [select id,Member_Level_Exception_String__c from case where id=:caseObj.id];
        id caseId = caseObj.id;  
        if(caseObj1.Member_Level_Exception_String__c != null)
        deserializedExceptionData = (ACETMemberExceptionWrapper)JSON.deserialize(caseObj1.Member_Level_Exception_String__c, ACETMemberExceptionWrapper.class);
        system.debug('deserializedExceptionData----->'+deserializedExceptionData);      
        memberDetailList = new list<memberDetailWrap>();
        memberDetailWrap wrapp = new memberDetailWrap();
        memberDetailList.add(wrapp);
        displayFlag = true;
        //deserializedExceptionData = new List<ACETMemberExceptionWrapper>();
      //  redirectUrl = '/apex/ACETOriginatingPageServiceRenewal?Originator='+Interaction.Originator__r.Name+'&OriginatorType='+Interaction.Originator_Type__c+'&InteractionId='+InteractionId+'&contactid='+Interaction.Originator__c; 
    }
    
    public void memberExceptionData()
    {
        //caseObj.
        //deserializedExceptionData = new ACETMemberExceptionWrapper();
        if(caseObj1.Member_Level_Exception_String__c != null)
        deserializedExceptionData = (ACETMemberExceptionWrapper)JSON.deserialize(caseObj1.Member_Level_Exception_String__c, ACETMemberExceptionWrapper.class);
        system.debug('deserializedExceptionData----->'+deserializedExceptionData);
    }
    
    
    public class memberDetailWrap{
        public string memberId{get;set;}
        public string memberFName{get;set;}
        public string memberLName{get;set;}    
    
    }

}