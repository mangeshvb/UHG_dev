public with sharing class ACETTerminateMemberController{

    public String comments { get; set; }
    public Integer memberID { get; set; }
    public Contact subject {get;set;}
    public List<Alert__c> lstMemAlert{get;set;}
    public List<Alert__c> lstProviderAlert {get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public ACETMemberDetail MemberDetail {get;set;}
    public string swivelcirrus_URL{get;set;}
    public String memberURLId{get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public Interaction__c Interaction { get; set; }    
     public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}
    public string surrogateKey {get; set;}  
    public string groupId {get;set;}  
    
    public ACETTerminateMemberController()
    {      
        memberURLId = ApexPages.currentPage().getParameters().get('Id');        
        MemberDetail=new ACETMemberDetail();
        MemberDetail.memberID=memberURLId; 
        String InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        if(InteractionId != null && InteractionId != ''){
           Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        }
        groupId = apexpages.currentpage().getparameters().get('groupId');
        
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = label.ACETCallTopicTerminateSubscriberFamilyMember;    
        if(groupId != Null)
        wrapper.caseObj.Group_ID__c =groupId;
                
        wrapper.updategroupinfoSave = true;
        fetchCirrusSysURL();
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');  
    }
           
    public void fetchCirrusSysURL(){    
         Map<String, ACETOrgNameToSwivelEndpointMap__c> mapEndpointDetails = ACETOrgNameToSwivelEndpointMap__c.getAll();
         string sandboxName = ACETUtility.GetOrgName();
         swivelcirrus_URL= ACETUtility.GetSwivelEndpointByOrgName(sandboxName,'Cirrus',mapEndpointDetails);
    }
       
    //OIL service call to display active subscriber with family member data
    public void getMemberData(){  
        queryFamilyMembers();
    }
    
    private void queryIndividual(){        
        String Id = ApexPages.currentPage().getParameters().get('Id');
        MemberDetail.surrogateKey = ApexPages.currentPage().getParameters().get('SRK');                  
        if(!String.isEmpty(MemberDetail.SurrogateKey)){
            ACETGetIndividualWebService stub = new ACETGetIndividualWebService();
            ACETWSCalloutResult calloutResult = stub.getIndividual(MemberDetail.SurrogateKey, MemberDetail);    
        } 
        else {
            ACETGetIndividualWebService stub = new ACETGetIndividualWebService();
            ACETWSCalloutResult calloutResult = stub.getIndividual(Id, MemberDetail);
        }     
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