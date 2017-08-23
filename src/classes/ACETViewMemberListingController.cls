public with sharing class ACETViewMemberListingController {
    
    public string view {get;set;}
    public string status {get;set;}
    public string bundleID {get;set;}
    public string inquiryDate {get; set;}
    public string selectedSubscriber {get; set;}
    public string selectedStatus {get; set;}
    public string groupID {get; set;}
    public Boolean isSubscriberOnly {get; set;}
    
    public Contact Subject {get;set;}
    public ACETGroupDetail groupDetails {get; set;}
    public List<ACETViewMemberListingResultsWrapper> searchMemberListingResults {get;set;}
    public static String ErrorMessage {get; set;}
    public Interaction__c Interaction { get; set; } 
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public ACETDatatableWrapper DTWrapper {get; set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}
    
    public class applicationException extends Exception {}
    
    public ACETViewMemberListingController() {
        String InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        groupID = apexpages.currentpage().getparameters().get('groupId');
        //groupID = '1458495';
        system.debug('GroupID information ====>'+groupID);        
        groupDetails = new ACETGroupDetail();
        wrapper = new ACETCallTopicsDataWrapper();
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        initHighlightPanelAdditionalInfo();
    }
    
    //View Dropdown values
    public List<SelectOption> getviewList () {
        List<SelectOption> viewList = new List<SelectOption>();
        viewList.add(new SelectOption('Subscriber','Subscriber Only'));
        viewList.add(new SelectOption('All Members','All Members'));
        return viewList;
    }
    
    //Status Dropdown values
    public List<SelectOption> getstatusList () {
        List<SelectOption> statusList = new List<SelectOption>();
        statusList.add(new SelectOption('Active','Active'));
        statusList.add(new SelectOption('Termed','Termed'));
        statusList.add(new SelectOption('Hold','Hold'));
        return statusList;
    }
    
    //Below method calls on page load. By default it takes view,status and date values to get the data from cirrus
    public void getMemberListingOnLoad() {
        Date dateVal = Date.Today();
        searchMemberListingResults = new List<ACETViewMemberListingResultsWrapper>();
        selectedSubscriber = apexpages.currentpage().getparameters().get('subscriber');
        selectedStatus = apexpages.currentpage().getparameters().get('status');
       // groupID = '1458495';
        bundleId = ''; 
        isSubscriberOnly = isSubscriber(selectedSubscriber);
        getMemberListingResults(groupID,convertDateFormat(dateVal.format()),isSubscriberOnly,selectedStatus,bundleId);
    }
    
    // Onclick of search functionality -- Starts
    public void search() {
        searchMemberListingResults = new List<ACETViewMemberListingResultsWrapper>();
       // groupID = '1458495';
        Map<String,String> viewMap = getMapViewValues();
        Map<String,String> statusMap = getMapStatusValues();
        isSubscriberOnly = isSubscriber(viewMap.get(view));
        getMemberListingResults(groupID,convertDateFormat(inquiryDate),isSubscriberOnly,statusMap.get(status),bundleID);
    }
    
    public void clear() {
        
        view = 'Subscriber';
        status = 'Active';
        Date dateVal = Date.Today();
        inquiryDate = dateVal.format();
        bundleId = '';
        
        Map<String,String> viewMap = getMapViewValues();
        Map<String,String> statusMap = getMapStatusValues();
        isSubscriberOnly = isSubscriber(viewMap.get(view));
        getMemberListingResults(groupID,convertDateFormat(inquiryDate),isSubscriberOnly,statusMap.get(status),bundleID);
    }
    
    public void getMemberListingResults(string groupID,string inquiryDate,Boolean view,string status,string bundleId) {
        List<ACETViewMemberListingResultsWrapper> searchResults = null;
        try {
            ApexPages.currentPage().getParameters().put('autosearch','0');
            // Testing Oil Not Available Message
            if(label.ACETOILNotAvailableTestFlag == '1')
            {
                throw new applicationException();
            }

            ACETViewMemberListingWebService getMemberListing = new ACETViewMemberListingWebService();
            getMemberListing.init(groupID,inquiryDate,view,status,bundleId);
            DTWrapper = new ACETDatatableWrapper('ACETViewMemberListingWebService', getMemberListing); 
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Last Name', 'lastName'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('First Name', 'firstName'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Member ID', 'memberID'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Relation Type', 'relationShip'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Benefit Bundle Option ID', 'bundleId'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Effective Date', 'effectiveDate'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Termination Date', 'terminationDate'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Contract Type', 'contractType'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Billing Group', 'billingGroup'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Status', 'status'));
            DTWrapper.PageSize = 20;//50;
            DTWrapper.PagingType = 'simple';
            //DTWrapper.PageNumber = 0;
            
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETOILNotAvailable));   
        }
    }
    
     private void initHighlightPanelAdditionalInfo(){
        if(AdditionalInfo == null){
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        }        
        string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if(addInfo != null)
        {
            AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
        if(Interaction != Null && Interaction.Highlight_Panel_GroupInfo__c != null)
        {
            ACETGroupDetailsWrapper deserializedExceptionData = (ACETGroupDetailsWrapper)JSON.deserialize(Interaction.Highlight_Panel_GroupInfo__c, ACETGroupDetailsWrapper.class);
            System.debug('Group Additional information'+deserializedExceptionData);
            AdditionalInfo.UHCBS = deserializedExceptionData.UHCBS;    
            AdditionalInfo.GroupN = deserializedExceptionData.GroupName ;
            AdditionalInfo.GroupStatus = deserializedExceptionData.GroupStatus;
            AdditionalInfo.ServiceTeam = deserializedExceptionData.ServiceTeam;
            AdditionalInfo.EffectiveStartDate = deserializedExceptionData.EffectiveStartDate;
            AdditionalInfo.RiskManagement = deserializedExceptionData.RiskManagement;
            AdditionalInfo.RatingMethod = '';
            AdditionalInfo.RenewalDate= deserializedExceptionData.RenewalDate; 
            AdditionalInfo.RelationshipType = deserializedExceptionData.RelationshipType ;
            AdditionalInfo.groupSName = deserializedExceptionData.groupSName;
        }
           
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
    }
    
    public static string convertDateFormat(String selectedDate) {
        String[] splitDateList;
        if(selectedDate != null) {
            splitDateList = selectedDate.split('/');
        }
        return (splitDateList[2]+'-'+splitDateList[0]+'-'+splitDateList[1]);
    }
    
    public static Map<String,String> getMapViewValues() {
        Map<String,String> mapReponseViewValues = new Map<String,String>();
        mapReponseViewValues.put('All Members','');
        mapReponseViewValues.put('Subscriber','Subscriber');
        return mapReponseViewValues;
    }
    
    public static Map<String,String> getMapStatusValues() {
        Map<String,String> mapReponseStatusValues = new Map<String,String>();
        mapReponseStatusValues.put('Active','Active');
        mapReponseStatusValues.put('Termed','Term');
        mapReponseStatusValues.put('Hold','Pend');
        return mapReponseStatusValues;
    }
    
    public static Boolean isSubscriber(String selectedSubscriberVal) {
        Boolean isSelected = false;
        if(selectedSubscriberVal == 'Subscriber') {
            isSelected = true;
        }
        return isSelected;
    }
}