public with sharing class ACETReinstateMemberController{

    public String comments { get; set; }
    public integer memberID { get; set; }
    public  list<Alert__c> lstProviderAlert { get; set; }
    public Contact Subject { get; set; }
    public Interaction__c  Interaction { get; set; }    
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public boolean notResearchUser {get;set;}
    
    /*********** Added by Rupsa. US# *************************/
    public ACETMemberDetail MemberDetail {get;set;}
    public string swivelcirrus_URL{get;set;}
    public boolean isTerminated{get;set;}
    public String AutoDoc {get;set;}
    public string memberURLId{get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
     public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}
    public string surrogateKey {get; set;}
    public string groupId;
    
    //Constructor 
    public ACETReinstateMemberController()
    {    
        memberURLId = ApexPages.currentPage().getParameters().get('Id');
        MemberDetail=new ACETMemberDetail(); 
        MemberDetail.memberID=memberURLId; 
        String InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        groupId = apexpages.currentpage().getparameters().get('groupId');
        if(InteractionId != null && InteractionId != ''){
        	Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);              
        }
        getloggedinProfileName();        
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = label.ACETCallTopicReinstateSubscriberFamilyMember;
        if(groupId != Null)
        	wrapper.caseObj.Group_ID__c =groupId;
        
        wrapper.updategroupinfoSave = true;
        fetchCirrusSysURL();
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
         if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }
    }
    
     
    private void getloggedinProfileName(){ 
       try{
        notResearchUser = true;
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String loggedinProfileName = PROFILE[0].Name;
    
       if(loggedinProfileName.contains('Research'))
            { notResearchUser = false;}
    }
    
    catch(Exception ex){
    
     System.debug('The exception is'+ ex.getmessage());
     
     }
     
   }    
    
    public void toggleExceptionChk(){}

    //function to fetch cirrus url 
    public void fetchCirrusSysURL(){    
         Map<String, ACETOrgNameToSwivelEndpointMap__c> mapEndpointDetails = ACETOrgNameToSwivelEndpointMap__c.getAll();
         string sandboxName = ACETUtility.GetOrgName();
         swivelcirrus_URL= ACETUtility.GetSwivelEndpointByOrgName(sandboxName,'Cirrus',mapEndpointDetails);
    }
    public void getMemberData(){
        isTerminated = false;        
        queryFamilyMembers();
        
    }
     private void queryFamilyMembers(){
        String Id = ApexPages.currentPage().getParameters().get('Id');
        String surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        if(!String.isBlank(surrogateKey)&& surrogateKey!='undefined'){
          MemberDetail.surrogateKey=surrogateKey;
        }
        else{
         MemberDetail.surrogateKey='';
        }
        if(!String.isBlank(MemberDetail.surrogateKey)){
            ACETGetFamilyMemberWebService stub = new ACETGetFamilyMemberWebService();
            ACETWSCalloutResult calloutResult = stub.getFamilyMembers(MemberDetail.surrogateKey, MemberDetail);    
        } 
        else{
            ACETGetFamilyMemberWebService stub = new ACETGetFamilyMemberWebService();
            ACETWSCalloutResult calloutResult = stub.getFamilyMembers(Id, MemberDetail);
        }
    } 
    
}