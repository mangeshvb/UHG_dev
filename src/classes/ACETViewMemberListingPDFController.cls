public with sharing class ACETViewMemberListingPDFController {

    public List<ACETViewMemberListingResultsWrapper> searchMemberListingResults {get;set;}
    //public List<MemberListingWrapper> membListWrap {get; set;}
    public String statusPDF {get; set;}
    public String groupName {get; set;}
    public String groupId {get; set;}
    public String request {get; set;}
    public String bundleID {get; set;}
    public String dateValues {get; set;}
    public String inquiryDate {get; set;}
    public String renderAs {get; set;}
    public Integer pageNumber {get; set;}
    public Integer pageSize {get; set;}
    public Integer startRecord {get; set;}
    public ACETDatatableWrapper DTWrapper {get; set;}
    
    public ACETViewMemberListingPDFController() {
        //searchMemberListingResults = new List<ACETViewMemberListingResultsWrapper>();
        String groupNameId;
        request = apexpages.currentpage().getparameters().get('view');
        statusPDF = apexpages.currentpage().getparameters().get('status');
        groupNameId = apexpages.currentpage().getparameters().get('groupIdName');
        inquiryDate = apexpages.currentpage().getparameters().get('inqDate');
        bundleID = apexpages.currentpage().getparameters().get('bundleId');
        pageNumber = Integer.valueOf(apexpages.currentpage().getparameters().get('pageNo'));
        pageSize = Integer.valueOf(apexpages.currentpage().getparameters().get('pgSize'));
        startRecord = 1;
        renderAs = 'PDF';
        System.debug('Entering Values:::'+request+groupNameId);
        if(groupNameId != null) {
            String[] strSplit = groupNameId.split('-');
            if(strSplit.size() > 0) {
                groupId = strSplit[0].trim();
                groupName = strSplit[1].trim();
            }
        } 
        
    }
    
    public List<ACETViewMemberListingResultsWrapper> getSearchMemberListingResultsResp() {
        Map<String,String> viewMap = ACETViewMemberListingController.getMapViewValues();
        Map<String,String> statusMap = ACETViewMemberListingController.getMapStatusValues();
        dateValues = ACETViewMemberListingController.convertDateFormat(inquiryDate);
        Boolean isSubscriber = ACETViewMemberListingController.isSubscriber(viewMap.get(request));
        ACETViewMemberListingWebService getMemberListing = new ACETViewMemberListingWebService();
        getMemberListing.init('1458495',dateValues,isSubscriber,statusMap.get(statusPDF),bundleID);
        ACETWSCalloutResult searchResults = getMemberListing.queryPaginatedData(pageNumber,pageSize,startRecord);
        List<ACETViewMemberListingResultsWrapper> searchMemberListingResultsResponse = new List<ACETViewMemberListingResultsWrapper>();
        Object A = searchResults.Response;
        searchMemberListingResultsResponse = (List<ACETViewMemberListingResultsWrapper>)A;
        return searchMemberListingResultsResponse ;
    }
    /* public List<MemberListingWrapper> getMemberList() {
        membListWrap = new List<MemberListingWrapper>();
        membListWrap.add(new MemberListingWrapper('Connieeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee','Grim','00589997121','Subscriber','123456','3/1/2016','','1','S','BG01','Active'));
        membListWrap.add(new MemberListingWrapper('John','Jaodsifja','1234567890','Subscriber','123456','3/1/2016','9/31/2016','1','S','BG02','Termed'));
        membListWrap.add(new MemberListingWrapper('Mary','Malskdjnfdzo','2345678901','Subscriber','123456','3/1/2016','','4','F','BG02','Hold'));
        membListWrap.add(new MemberListingWrapper('Robert','Ralsefdgh','3456789012','Subscriber','123456','3/1/2016','','3','PCH','BG01','Active'));
        membListWrap.add(new MemberListingWrapper('Jane','Tpsorawertyy','4567890123','Subscriber','123456','3/1/2016','9/31/2016','2','C','BG01','Termed'));
        return membListWrap;  
    } */
}