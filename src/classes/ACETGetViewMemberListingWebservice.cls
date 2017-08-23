public with sharing class ACETGetViewMemberListingWebservice extends ACETWebservice {
    
    public override void GetEndpoint()
    {
        GetEndpointDetail('CirrusMemberListing');
    }
    
    private void GetRequestBody(String groupID,String inquiryDate,String view,String status,String bundleID)
    {
        System.debug('Calling Request Body******'+status);
        Map<String,String> requestBodyMap = new Map<String,String>();
        requestBodyMap.put('inquiryDate',inquiryDate);
        requestBodyMap.put('memGroupID',groupID);
        requestBodyMap.put('listType',view);
        if(Status != 'All') {
            requestBodyMap.put('memberStatus',status);
        }
        requestBodyMap.put('benefitBundleOptionID',bundleID);
        
        RequestBody  = JSON.serialize(requestBodyMap);
        System.debug('Example'+RequestBody+'*******'+requestBodyMap);                             
    }
    
    public ACETWSCalloutResult getMemberListing(String groupID,String inquiryDate,String view,String status,String bundleID,List<String> SystemLabels) {
        
        System.debug('Allow Request Body'+status);
        //Status Mapping from the response
        Map<String,String> employeeStatusCodeMap = new Map<String,String>();
        employeeStatusCodeMap.put('A','Active');
        employeeStatusCodeMap.put('Z','Active Military - Overseas');
        employeeStatusCodeMap.put('Y','Active Military - USA');
        employeeStatusCodeMap.put('B','Full-Time');
        employeeStatusCodeMap.put('C','Part-Time');
        employeeStatusCodeMap.put('P','Leave Of Absence');
        employeeStatusCodeMap.put('R','Retired');
        employeeStatusCodeMap.put('T','Terminated');
        
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

        ACETWSCalloutResult searchResult = new ACETWSCalloutResult();
        List<ACETMemberListingResultsWrapper> memberListingSearchResults = new List<ACETMemberListingResultsWrapper>();
        ACETViewMemberListingJSON2Apex.responseData responseData = new ACETViewMemberListingJSON2Apex.responseData();
        List<ACETViewMemberListingJSON2Apex.MemberList> memberListingResponseData = new List<ACETViewMemberListingJSON2Apex.MemberList>();
        try
        {
            GetEndpoint();
            GetRequestBody(groupID, inquiryDate, view, status, bundleID);
            HttpResponse Response = Send(OAuthConfig);
            String responseBody = response.getBody();
            System.debug('REsonseBody_____'+responseBody);
            if (Response.getStatusCode() == 200) {
                if(responseBody  != null) {
                    ACETViewMemberListingJSON2Apex ACETMemberListJSON2Apex = ACETViewMemberListingJSON2Apex.parse(responseBody);
                    responseData = ACETMemberListJSON2Apex.responseData;
                    if(responseData != null) {
                        memberListingResponseData = ACETMemberListJSON2Apex.responseData.MemberList;
                        if(memberListingResponseData != null) {
                            searchResult.Success = true;
                            searchResult.Message = ''; 
                            for(ACETViewMemberListingJSON2Apex.MemberList memListresp:memberListingResponseData) {
                                //Demographics Section
                                ACETMemberListingResultsWrapper memberListing = new ACETMemberListingResultsWrapper();
                                
                                memberListing.firstName = memListresp.Demographics.nameFirst; // First Name
                                memberListing.lastName = memListresp.Demographics.nameLast; // Last Name
                                memberListing.memberID = memListresp.Demographics.memberID; // Member ID
                                memberListing.memberDOB = memListresp.Demographics.birthDate; // Member DOB
                                
                                //Member Affiliation Section
                                memberListing.relationShip = relationTypeMap.get(memListresp.MemberAffiliation.relationshipCode); // Relation Type
                                memberListing.status = ''; //employeeStatusCodeMap.get(memListresp.MemberAffiliation.memberStatus); // Status
                                memberListing.contractType = ''; //employeeStatusCodeMap.get(memListresp.MemberAffiliation.benefitType); // Billing Type
                                memberListing.billingGroup = memListresp.MemberAffiliation.billingPrefID; // Billing Group
                                
                                //Member Coverage List Section - consider only first element from the list
                                memberListing.effectiveDate = convertDateFormat(memListresp.MemberCoverageList[0].benPlanEffDate); //Effective Date
                                memberListing.terminationDate = convertDateFormat(memListresp.MemberCoverageList[0].benPlanExpDate); //Termination Date
                                memberListing.bundleId = memListresp.MemberCoverageList[0].coverageOptionID; //Bundle ID
                                
                                memberListingSearchResults.add(memberListing);
                            }   
                            searchResult.Response = memberListingSearchResults;
                        }
                    }
                    else {
                        searchResult.Success = true;
                        searchResult.Message = 'No Record found for this Search Criteria';
                        searchResult.Response =  ApexPages.Severity.INFO;
                    }
                }   
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
            system.debug(LoggingLevel.INFO, 'Exception in GetMemberList ' + ex); 
            system.debug('getStackTraceString' + ex.getStackTraceString());
            searchResult.Success = false;
            searchResult.Message = ex.getMessage();
            searchResult.MessageSeverity = ApexPages.Severity.ERROR;
        } 
        system.debug('oACETWSCalloutResult: ' + searchResult);         
        return searchResult;
    }
    
    public string convertDateFormat(String responseDate) {
        String[] splitDateList = responseDate.split('-');
        return (splitDateList[1]+'/'+splitDateList[2]+'/'+splitDateList[0]);
    }
}