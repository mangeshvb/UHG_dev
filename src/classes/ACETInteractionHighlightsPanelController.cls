public with sharing class ACETInteractionHighlightsPanelController
{
    public Interaction__c Interaction { get; set; }
    //public String interactionId {get;set;}
    public Contact Subject { get; set; }
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo{get;set;}
    //public Integer TotalAlertNum{get;set;}
    public list<Alert__c> lstMemAlert{get;set;}//added by Vishakha on 11/03/2016 for User Story - US:405397,405471
    public list<Alert__c> lstProviderAlert{get;set;}
    public list<Alert__c> lstproducerAlert{get;set;}//added by harish on 3/22/2017 for User story -US554987
    public list<Alert__c> lstMemAlertOtherPage{get;set;}
    public list<Alert__c> lstProviderAlertDetailPage{get;set;}
    public list<Alert__c> lstProducerAlertDetailPage{get;set;}
    public list<Alert__c> lstGroupAlert{get;set;} //added by Krishna on 3/23/2017for User Story - US537355
    public list<Alert__c> lstGroupAlertDetailPage{get;set;} 
    public boolean isALertModal{get;set;}//added by Vishakha on 11/03/2016 for User Story - US:405397,405471
    public boolean isProviderALertModal{get;set;}//added by Vishakha on 11/15/2016 for User Story-US405472
    public boolean isProviderDetailALertModal{get;set;}
    public boolean isProducerALertModal{get;set;}//added by harish on 3/22/2017 for User story -US554987
    public boolean isGroupALertModal{get;set;}
    public ACETGroupDetail groupDetails{get;set;}
    public boolean isShowGroupALert{get;set;} 
    public boolean IsMember{get;set;} 
    public integer memberAlertCount{get;set;}
    public integer providerAlertCount{get;set;}
    public integer producerAlertCount{get;set;}
    public integer groupAlertCount{get;set;}
    public boolean isShowALert{get;set;}
    
    public ACETInteractionHighlightsPanelController()
    {
        system.debug('Subject is '+Subject);
        system.debug('Interaction is '+Interaction);
        isShowGroupALert = false;
        IsMember = false;
        isProducerALertModal = false;
        String Membertype = ApexPages.currentPage().getParameters().get('IsMember');
        if(Membertype == 'true')
        {
            IsMember = true;
        }
        system.debug('isALertModal is '+isALertModal);
        system.debug('isProviderALertModal is '+isProviderALertModal);
        //Debug added by Pavan 3/10
        system.debug('lstMemAlertOtherPage is '+lstMemAlertOtherPage);
       //lstMemAlert = new list<Alert__c>();
    }
    
    public void getAllAlerts()
    {
        /******* Added by sourabh to get the alert counts*******/
        memberAlertCount = 0;
        providerAlertCount = 0;
        producerAlertCount = 0;
        groupAlertCount = 0;
        /// For Member Alert
        string type = 'Member';
        String query = '';
        List<List <sObject>> searchList = new List<List<SObject>>();
        List<Alert__c> tempListAlert = new List<Alert__c>();
        if(AdditionalInfo != Null && AdditionalInfo.MemberId != Null && lstMemAlertOtherPage == null)
        {
            query = 'FIND  \'' + AdditionalInfo.MemberId + '\' IN ALL Fields Returning Alert__c';
            query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c > TODAY AND Type__c = \''+ type +'\' ORDER BY Type__c,Effective_Date__c DESC)';
            searchList = search.query(query);
            tempListAlert.addAll(((List<Alert__c>)searchList[0]));
            memberAlertCount = tempListAlert.size();
        }
        
        ////For Provider Alert
        if(Interaction != null && Interaction.Originator_Type__c == 'Provider' && lstProviderAlertDetailPage == null){
            tempListAlert = new List<Alert__c>();
            searchList = new List<List<SObject>>();
            type = Interaction.Originator_Type__c;
            query = 'FIND  \'' + Interaction.Originator__r.EID__c + '\' IN ALL Fields Returning Alert__c';
            query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c > TODAY AND Type__c = \''+ Interaction.Originator_Type__c +'\' ORDER BY Type__c,Effective_Date__c DESC)';
            searchList = search.query(query);
            system.debug('searchList--->'+searchList);
            tempListAlert.addAll(((List<Alert__c>)searchList[0]));
            
            if(subject != null && AdditionalInfo != null && AdditionalInfo.MemberId != null ){
                type += ' Group';
                query = 'FIND  \'' + Interaction.Originator__r.EID__c + '\' IN ALL Fields Returning Alert__c';
                query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c > TODAY AND Type__c = \''+ type +'\' ORDER BY Type__c,Effective_Date__c DESC)';
                searchList = search.query(query);
                system.debug('searchList22--->'+searchList);
            
                tempListAlert.addAll(((List<Alert__c>)searchList[0]));
            }
            providerAlertCount = tempListAlert.size();
        } 
        
        ///For Producer Alerts
         system.debug('lstproducerDetailPage----->'+lstProducerAlertDetailPage);
        if(Interaction != null && Interaction.Originator_Type__c == 'Producer' && lstProducerAlertDetailPage == null){
            tempListAlert = new List<Alert__c>();
            searchList = new List<List<SObject>>();
            query = 'FIND  \'' + Interaction.Originator__r.EID__c + '\' IN ALL Fields Returning Alert__c';
            query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c > TODAY AND Type__c = \''+ Interaction.Originator_Type__c +'\' ORDER BY Type__c,Effective_Date__c DESC)';
            searchList = search.query(query);
            system.debug('alertttttttttttttttttttttt'+searchList);
            tempListAlert.addAll(((List<Alert__c>)searchList[0]));
            if(tempListAlert.size() > 0)         
            producerAlertCount = tempListAlert.size();          
        }
        
        ///For group alerts
        system.debug('AdditionalInfo ----->'+AdditionalInfo);
        system.debug('lstGroupAlertDetailPage----->'+lstGroupAlertDetailPage);
        if(AdditionalInfo != null && AdditionalInfo.GroupN!=null && lstGroupAlertDetailPage == null){
            tempListAlert = new List<Alert__c>();
            searchList = new List<List<SObject>>();
            string groupId=getGroupId(AdditionalInfo.GroupN);
            query = 'FIND  \'' + groupId + '\' IN ALL Fields Returning Alert__c';
            query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c > TODAY ORDER BY Type__c,Effective_Date__c DESC)';
            searchList = search.query(query);
            system.debug('group searchList ----->'+searchList);
            tempListAlert.addAll(((List<Alert__c>)searchList[0]));
            groupAlertCount = tempListAlert.size();             
        }
    }
    
   /****added by Vishakha on 11/03/2016 for User Story - US:405397,405471***/
    public Void getMemberAlert(){
        system.debug('inside the MemberAlert'+ Subject + AdditionalInfo);
       if((Interaction != null && Interaction.Originator_Type__c == 'Member') || (subject != null && AdditionalInfo != null)){
           lstMemAlert = getNoAlert('Member',Subject.Eid__c,AdditionalInfo.PolicyNumber);
           system.debug('lstMemAlert::::'+ lstMemAlert );
           
       }
   }
   
   public Void getProviderAlert(){
       system.debug('inside the Provider alert window');
       if(Interaction != null && Interaction.Originator_Type__c == 'Provider'){
           lstProviderAlert = getNoAlert(Interaction.Originator_Type__c,Interaction.Originator__r.EID__c,Interaction.Originator__r.Tax_ID__c);
           if(subject != null && AdditionalInfo != null){
               getMemberAlert();
           }
       }  
    }
    /****added by Harish on 03/22/2017 for User Story - US:US554987***/
    public void getProducerAlert(){
         system.debug('producer window');
         system.debug('Insteraction::::'+ Interaction);
         if(Interaction != null && Interaction.Originator_Type__c == 'Producer'){
          lstproducerAlert = getNoAlert(Interaction.Originator_Type__c,Interaction.Originator__r.EID__c,Interaction.Originator__r.Tax_ID__c);
          system.debug('lstproducerAlert::::'+ lstproducerAlert);
         }
    }
    
     public void clickProducerAlert(){
       if(Interaction.Originator_Type__c == 'Producer'){
           isProducerALertModal = True;
           isShowALert = false;
          lstproducerAlert = getNoAlert(Interaction.Originator_Type__c,Interaction.Originator__r.EID__c,Interaction.Originator__r.Tax_ID__c);
          system.debug('lstproducerAlert::::'+ lstproducerAlert);
       } 
    }
    /****added by Krishna on 03/23/2017 for User Story - US537355 ***/
    public void getGroupAlert(){
           if(AdditionalInfo != null && AdditionalInfo.GroupN!=null){
            string groupId=getGroupId(AdditionalInfo.GroupN);
            lstGroupAlert = getNoAlert(null,null,groupId);
               system.debug('lstGroupAlert::::'+ lstGroupAlert );
           }  
                   
       }
       
     public void clickGroupAlert(){
         
         if(AdditionalInfo != null && AdditionalInfo.GroupN!=null){
            string groupId=getGroupId(AdditionalInfo.GroupN);
            lstGroupAlert = getNoAlert(null,null,groupId);
            isGroupALertModal=true;
            isShowALert = false;
               system.debug('lstGroupAlert::::'+ lstGroupAlert+isshowGroupALert);
           }   
         }
      /***********************
        Method Name :   get group Id from Group Name
        Purpose     :   To get the group id.
        Develper    :    Krishna
    ************************/
     public string getGroupId(String GroupName){
          String groupId;
             if(GroupName!=null){
               String Name=GroupName;
               String[] finalName= GroupName.split('\\-'); 
               groupId=finalName[0];
             }        
             return groupId;
     }
   
     /***********************
        Method Name :   getNoAlert
        Purpose     :   This method calls when the agent click on the Member Link.
        Develper    :    Vishakha Sikarwar
    ************************/
    public void clickMemberAlert(){
       if((Interaction.Originator_Type__c == 'Member') || (subject != null && AdditionalInfo != null)){
           isALertModal = True;
           isShowALert = false;
           lstMemAlert = getNoAlert('Member',Subject.Eid__c,AdditionalInfo.PolicyNumber);
       } 
    }
     /***********************
        Method Name :   getNoAlert
        Purpose     :   This method calls when the agent click on the Provider Link.
        Develper    :    Vishakha Sikarwar
    ************************/
    public void clickProviderAlert(){
        system.debug('insert the check function'+Interaction.Originator_Type__c);
       if(Interaction.Originator_Type__c == 'Provider'){
           isShowALert = false;
           lstProviderAlert = getNoAlert(Interaction.Originator_Type__c,Interaction.Originator__r.EID__c,Interaction.Originator__r.Tax_ID__c);
           isProviderALertModal= True;
       } 
    }
     /***********************
        Method Name :   getNoAlert
        Purpose     :   This method get all the alert realated to the Member or Provider.
        Develper    :    Vishakha Sikarwar
    ************************/
    public List<Alert__c> getNoAlert(String type, String memProId, String groupNo){
        String groupType = type + ' Group';
        List<Alert__c> tempListAlert = new List<Alert__c>();
     /*   for(Alert__c varAlert : [SELECT Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c from Alert__c WHERE ((Type__c =: type AND ID_Number__c != null AND ID_Number__c =:memProId) OR (Type__c =:groupType AND Group_Number__c != null AND Group_Number__c=:groupNo)OR (Group_Number__c != null AND Group_Number__c=:groupNo)) AND Effective_Date__c <= TODAY AND End_Date__c > TODAY ORDER BY Type__c,Effective_Date__c DESC]){
        tempListAlert .add(varAlert);
        } */
       
       // @Rama: SOQL replaced with SOSL to make the group Number and group ID fields compatable for shield encryption
        String query = '';
        List<List <sObject>> searchList = new List<List<SObject>>();
        if(String.isBlank(groupNo) && String.isBlank(memProId)){
            return tempListAlert;
        }
        
        if(String.isNotBlank(memProId) && memProId.length() > 1){
            query = 'FIND  \'' + memProId + '\' IN ALL Fields Returning Alert__c';
            query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c > TODAY AND Type__c = \''+ type +'\' ORDER BY Type__c,Effective_Date__c DESC)';
            searchList = search.query(query);
            tempListAlert.addAll(((List<Alert__c>)searchList[0]));
        }
        
        if(String.isNotBlank(groupNo) && groupNo.length() > 1){
              /**** IF condition is added by Krishna on 03/27/2017 for User Story - US537355 ***/
            if(type==null){  
              query = 'FIND  \'' + groupNo + '\' IN ALL Fields Returning Alert__c';
              query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c > TODAY ORDER BY Type__c,Effective_Date__c DESC)';
            }else{
                type += ' Group';
                query = 'FIND  \'' + groupNo + '\' IN ALL Fields Returning Alert__c';
                query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c > TODAY AND Type__c = \''+ type +'\' ORDER BY Type__c,Effective_Date__c DESC)';
            }
            searchList = search.query(query);
            tempListAlert.addAll(((List<Alert__c>)searchList[0]));
        }
        
        
        return tempListAlert;  
    }
    /***********************
        Method Name :   btnHideWindowAlertWinodw
        Purpose     :   This method hide the Modal box
        Develper    :    Vishakha Sikarwar
    ************************/
    public void btnHideWindowAlertWinodw(){
        isALertModal = false;
        isProviderALertModal = false;
        isGroupALertModal=false;
        isProducerALertModal = false;
                
        if(lstMemAlertOtherPage != null){
            lstMemAlertOtherPage.clear();
        }
        if(lstProviderAlertDetailPage != null){
            lstProviderAlertDetailPage.clear();
        }
        if(lstGroupAlertDetailPage!= null){
            lstGroupAlertDetailPage.clear();
        }
        if(lstProducerAlertDetailPage != null){
            lstProducerAlertDetailPage.clear();
        }
        system.debug('isProviderALertModal ::::'+isProviderALertModal );
        system.debug('isGroupALertModal ::::'+isGroupALertModal);
    }
 
}