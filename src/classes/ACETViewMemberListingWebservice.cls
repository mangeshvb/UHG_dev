public with sharing class ACETViewMemberListingWebservice extends ACETWebservice {
    private String g_groupId;
    private String g_inquiryDate;
    private Boolean g_view;
    private String g_status;
    private String g_bundleID;

    public override void GetEndpoint()
    {
        GetEndpointDetail('CirrusMemberListing');
    }
    
    public void init(String groupID,String inquiryDate,Boolean view,String status,String bundleID) {
        g_groupId = groupID;
        g_inquiryDate = inquiryDate;
        g_view = view;
        g_status = status;
        g_bundleID = bundleID;
    }
    private void GetRequestBody(String groupID,String inquiryDate,Boolean view,String status,String bundleID)
    {
        /*Map<String,String> requestBodyMap = new Map<String,String>();
        Boolean isSubscriber = false;
        requestBodyMap.put('inquiryDate',inquiryDate);
        requestBodyMap.put('memGroupID',groupID);
        if(view == 'Subscriber') {
            isSubscriber = true;
            requestBodyMap.put('subscriberOnly',isSubscriber);    
        }
        else {
            requestBodyMap.put('subscriberOnly',isSubscriber); 
        }
        if(Status != 'All') {
            requestBodyMap.put('memberStatus',status);
        }
        requestBodyMap.put('coverageOptionID',bundleID);
        RequestBody  = JSON.serialize(requestBodyMap);*/
        if(bundleID != '') {
            RequestBody = '{'
            +'"inquiryDate":"'+inquiryDate+'",'
            +'"memGroupID":"'+groupID+'",'
            +'"subscriberOnly":'+view+','
            +'"memberStatus":"'+status+'",'
            +'"coverageOptionID":"'+bundleID+'"'
            +'}';
        }
        else {
            RequestBody = '{'
            +'"inquiryDate":"'+inquiryDate+'",'
            +'"memGroupID":"'+groupID+'",'
            +'"subscriberOnly":'+view+','
            +'"memberStatus":"'+status+'"'
            +'}';
        }
    }
   
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord) {                    
        //Relation Type Mapping from the response
        Map<String,String> relationTypeMap = new Map<String,String>();
        relationTypeMap.put('01','Spouse');
        relationTypeMap.put('07','Nephew or Niece');
        relationTypeMap.put('08','Cousin');
        relationTypeMap.put('09','Adopted Child');
        relationTypeMap.put('10','Foster Child');
        relationTypeMap.put('15','Ward');
        relationTypeMap.put('17','Stepson or Stepdaughter');
        relationTypeMap.put('18','Self');
        relationTypeMap.put('19','Child');
        relationTypeMap.put('23','Sponsored Dependent');
        relationTypeMap.put('24','Dependent of a Minor Dependent');
        relationTypeMap.put('26','Guardian');
        relationTypeMap.put('31','Court Appointed Guardian');
        relationTypeMap.put('38','Collateral Dependent');
        relationTypeMap.put('53','Life Partner');
        relationTypeMap.put('NB','Newborn');

        //Adapter Callout Webservice Code Starts from here
        Integer pageNo;
        ACETWSCalloutResult searchResult = new ACETWSCalloutResult();
        List<ACETViewMemberListingResultsWrapper> memberListingSearchResults = new List<ACETViewMemberListingResultsWrapper>();
        ACETViewMemberListingJSON2Apex.responseData responseData = new ACETViewMemberListingJSON2Apex.responseData();
        List<ACETViewMemberListingJSON2Apex.MemberList> memberListingResponseData = new List<ACETViewMemberListingJSON2Apex.MemberList>();
        try
        {
            pageNo = pageNumber-1;
            ServiceName = 'GetMembersList';
            GetEndpoint();
            relativeURL = '/api/alp/cirrus/v1.0/members/search?size='+pageSize+'&page='+pageNo;
            GetRequestBody(g_groupID, g_inquiryDate, g_view, g_status, g_bundleID);
            HttpResponse Response = Send(OAuthConfig);
            String responseBody = response.getBody();
            System.debug('Response************'+responseBody);
            if (Response.getStatusCode() == 200) {
                if(responseBody != null) {
                    ACETViewMemberListingJSON2Apex ACETMemberListJSON2Apex = ACETViewMemberListingJSON2Apex.parse(responseBody);
                    responseData = ACETMemberListJSON2Apex.responseData;
                    if(responseData != null) {
                        memberListingResponseData = ACETMemberListJSON2Apex.responseData.MemberList;
                        if(memberListingResponseData != null) {
                            searchResult.Success = true;
                            searchResult.Message = ''; 
                            for(ACETViewMemberListingJSON2Apex.MemberList memListresp:memberListingResponseData) {
                                //Demographics Section
                                ACETViewMemberListingResultsWrapper memberListing = new ACETViewMemberListingResultsWrapper();
                                
                                memberListing.firstName = (memListresp.Demographics.nameFirst != null)?memListresp.Demographics.nameFirst:''; // First Name
                                memberListing.lastName = (memListresp.Demographics.nameLast != null)?memListresp.Demographics.nameLast:''; // Last Name
                                if(memListresp.Demographics.memberID != null) {
                                    memberListing.memberID = (memListresp.Demographics.memberID != null && memListresp.Demographics.memberID != '')?memListresp.Demographics.memberID:memListresp.Demographics.memberID; // Member ID
                                }
                                else {
                                     memberListing.memberID = '';
                                }
                                memberListing.memberDOB = (memListresp.Demographics.birthDate != null)?memListresp.Demographics.birthDate:''; // Member DOB
                                
                                //Member Affiliation Section
                                if(relationTypeMap.get(memListresp.MemberAffiliation.relationshipCode) != null) {
                                    memberListing.relationShip = relationTypeMap.get(memListresp.MemberAffiliation.relationshipCode); // Relation Type
                                }
                                else {
                                    memberListing.relationShip = '';
                                }
                                memberListing.contractType = '';// Billing Type
                                if(memListresp.MemberAffiliation.billingPrefID != null) {
                                    memberListing.billingGroup = (memListresp.MemberAffiliation.billingPrefID != null)?memListresp.MemberAffiliation.billingPrefID:memListresp.MemberAffiliation.billingPrefID; // Billing Group
                                }
                                else {
                                    memberListing.billingGroup = '';
                                }
                                //Member Coverage List Section - consider only first element from the list
                                memberListing.effectiveDate = (memListresp.MemberCoverageList[0].benPlanEffDate != null)?string.valueOf(Date.valueOf(memListresp.MemberCoverageList[0].benPlanEffDate).format()):''; //Effective Date
                                memberListing.terminationDate = (memListresp.MemberCoverageList[0].benPlanExpDate != null)?string.valueOf(Date.valueOf(memListresp.MemberCoverageList[0].benPlanExpDate).format()):''; //Termination Date
                                memberListing.bundleId = (memListresp.MemberCoverageList[0].coverageOptionID != null)?memListresp.MemberCoverageList[0].coverageOptionID:''; //Bundle ID
                                memberListing.Status = (memListresp.MemberCoverageList[0].memberStatus != null)?memListresp.MemberCoverageList[0].memberStatus:''; //Bundle ID
                                memberListingSearchResults.add(memberListing);
                            }
                            searchResult.Response = memberListingSearchResults;
                            searchResult.pageNumber =  String.valueOf(ACETMemberListJSON2Apex.ResponseData.pageNumber+1); 
                            searchResult.pageSize = String.valueOf(pageSize);
                            searchResult.totalPages = String.valueOf(ACETMemberListJSON2Apex.ResponseData.pageNumber+1);
                            
                            if(ACETMemberListJSON2Apex.ResponseData.hasNextPage == true) {
                               System.debug('JSON:::::::::::::::::::::::');
                               searchResult.recordCount = String.valueOf((ACETMemberListJSON2Apex.ResponseData.pageNumber+1)*pageSize+1);
                               searchResult.totalCount = String.valueOf((ACETMemberListJSON2Apex.ResponseData.pageNumber+1)*pageSize+1);
                            }
                            else { 
                               searchResult.recordCount = String.valueOf((ACETMemberListJSON2Apex.ResponseData.pageNumber)*pageSize + ACETMemberListJSON2Apex.ResponseData.size);
                               searchResult.totalCount = String.valueOf((ACETMemberListJSON2Apex.ResponseData.pageNumber)*pageSize + ACETMemberListJSON2Apex.ResponseData.size);
                            }
                            System.debug('JSON:::::::::::::::::::::::1'+searchResult+pageSize+startRecord);
                        }
                        else {
                            searchResult.MessageSeverity = ApexPages.Severity.INFO;
                            searchResult.Success = true;
                            searchResult.Message = 'No Record found for this Search Criteria';                
                            searchResult.Response = new List<ACETViewMemberListingResultsWrapper>();
                        }
                    }
                    else {
                        searchResult.Success = true;
                        searchResult.Message = 'Service Failure. Please try again later';
                        searchResult.Response =   new List<ACETViewMemberListingResultsWrapper>();
                        
                    }
                }   
            }
            else if(response.getStatusCode() == 500 || response.getStatusCode() == 404){
                System.debug('Entering...........');
                //currently servce returns 500 if no records found
                searchResult.MessageSeverity = ApexPages.Severity.INFO;
                searchResult.Success = true;                
                searchResult.Response = new List<ACETViewMemberListingResultsWrapper>();
            }
            else {
                searchResult.Success = false;
                String errorMessage = '';
                Map<String, Object> mapOAuthFailedResponse = (Map<String, Object>)JSON.deserializeUntyped(Response.getBody());
                string errorMsg = (String)mapOAuthFailedResponse.get('ErrorMessage');
                if(errorMsg == 'Error') {
                    searchResult.Message = 'Service Failure. Please try again later';
                    searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                }
                else {
                    ACETViewMemberListingJSON2Apex ACETMemberListJSON2Apex = ACETViewMemberListingJSON2Apex.parse(responseBody);
                    for(ACETViewMemberListingJSON2Apex.responseMessageList metaInfo:ACETMemberListJSON2Apex.metaInformation.responseMessageList) {
                        errorMessage += metaInfo.message+',';       
                    }
                    errorMessage = errorMessage.subString(0,errorMessage.length());
                    searchResult.Message = ''+errorMessage +'for the below search criteria. Please change the search criteria and try again.';
                    searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                }        
            }
        }
        catch(Exception ex){
            searchResult.Success = false;
            searchResult.Message = ex.getMessage();
            searchResult.MessageSeverity = ApexPages.Severity.ERROR;
        }         
        return searchResult;
    }
}