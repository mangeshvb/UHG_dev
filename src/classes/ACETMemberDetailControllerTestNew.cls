@isTest(seealldata = false)//test
private class ACETMemberDetailControllerTestNew{
    private static void setTestData(String flow){
        
        Interaction__c inte = TestDataFactory.createInteraction();
        Account acc = ACETTestDataUtility.createAccount('testName');
        insert acc;
                
        Contact con = ACETTestDataUtility.createContact(acc.id, 'Kelly', 'Ruby');            
        insert con;
                
        ApexPages.currentPage().getParameters().put('InteractionId',inte.id);
        //ApexPages.currentPage().getParameters().put('id','73452645');
        ApexPages.currentPage().getParameters().put('SRK','73452645');        
     
        String vccdParams = '{"producerId":"123456789","idStr":"0012345","questionTypeCode":"MA","callerANI":"ANI123","TFN":"123456789"}';
        ApexPages.currentPage().getParameters().put('vccdParams',vccdParams);
        //ApexPages.currentPage().getParameters().put('id',con.id);
       // ApexPages.currentPage().getParameters().put('Id','73452645');
        ApexPages.currentPage().getParameters().put('firstName','Kelly');
        ApexPages.currentPage().getParameters().put('IsMember ','true');
        ApexPages.currentPage().getParameters().put('lastName','Ruby');
        ApexPages.currentPage().getParameters().put('sourceOriginator','Phone');
        ApexPages.currentPage().getParameters().put('subjectdob','1/1/2010');
        
        List<ISL_Webservice_Config__c> ISLWebserviceCSList = new List<ISL_Webservice_Config__c>();
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILHttpHeaderAccept', 'application/json;charset=UTF-8'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILHttpHeaderActor', 'ACET'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILHttpHeaderScope', 'read'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('ISLOAuthContentType', 'application/x-www-form-urlencoded'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('ISLOAuthGrantType', 'client_credentials'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthClientId', 'ISLStageConClientId'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetMemberEndpoint', '/GetIndividualService'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetMembershipEndpoint', '/GetMemberShipService'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_SearchMembershipEndpoint', '/FindMemberShipService'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetFamilyMembersEndpoint', '/GetFamilyMemberService'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILTimeout', '3000'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('SRKCounter', '1'));   
        insert ISLWebserviceCSList;
        //interaction and highlight panel       
                
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/27/2009';
        AdditionalInfo.EndDate = '12/27/2009';
        AdditionalInfo.groupName  = 'Member Offshore';
        AdditionalInfo.Network    = 'Test';
        AdditionalInfo.OriginatorRelationship  = 'Test';
        AdditionalInfo.PolicyNumber  = 'UHC1234';
        AdditionalInfo.Product  = 'Product Test';
        AdditionalInfo.productType  = 'Care Service';
        AdditionalInfo.Relationship  = 'Primary';     
        
        //Setting relationship codes        
        ACETRelationshipCodes__c rCodes = new ACETRelationshipCodes__c (Name = '18',Description__c = 'Self');
        insert rCodes;      
        
        ACETOrgNameToSwivelEndpointMap__c durl = new ACETOrgNameToSwivelEndpointMap__c();
        durl.Swivel_Endpoint__c = 'test';
        durl.name = 'dev_ICUEConsumerDashboard';
        insert durl;

        ACETOrgNameToSwivelEndpointMap__c setting = new ACETOrgNameToSwivelEndpointMap__c();
        setting.Name = 'dev_ICUE';
        setting.Swivel_Endpoint__c = 'https://www.google.com';
        insert setting;
        
        /* US659454
        Restricted_Policy_Number__c rpn = new Restricted_Policy_Number__c ();
        rpn.Name = '702030';
        rpn.Global_Restricted__c = true;
        rpn.UHG_Restricted__c = false;
        
        insert rpn;
        */ //US659454
                
    }

     private static testMethod void testContinuation1() {
     Test.startTest();
     setTestData('Member');
      ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
      //memberDetailController.changeOriginator();
        Continuation conti = (Continuation)memberDetailController.CallWSonPageLoad();
        Map<String, HttpRequest> requests = conti.getRequests();

        HttpResponse response;
        HttpRequest request;
        
        for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            system.debug('2323request'+ request);
            if(request.getEndpoint().contains('/api/alpha/eisl/individuals/v2.0/read')) {
                system.debug('2323inside GetIndividualService');
                response.setBody('{"getIndividualResponse":{"individual":{"individualIdentifier":"154907823","name":{"firstName":"Ruby","lastName":"Kelly","middleName":"","nameSuffix":""},"birthDate":"1959-09-21","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"HOM","addressLine1":"95 Elgar Pass","addressLine2":"","city":"HFD","postalCode":"06140","stateCode":"CT","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"321-686-6997","phoneExt":"","internationalIndicator":"N","primaryIndicator":"Y"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"ruby@optum.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"","employeeIdentifier":"","employmentStartDate":"","retirementDate":""}],"language":[{}],"otherContact":[{}],"identifiers":[{"id":"890504596","type":"SRK"},{"id":"352816681","type":"HIC"}]}}}');
                system.debug('1response'+response);
            }      
            else if(request.getEndpoint().contains('/api/alpha/eisl/individuals/membership/v2.0/search')) {
                system.debug('2323inside findMembershipsResponse');
                response.setBody('{"findMembershipsResponse":{"memberships":[{"sourceSysCode":"CR","coverages":[{"subscriberSystemSpecificIdentifiers":[{"id":"23462613","type":"subscriberSystemID"},{"id":"154907823","type":"subscriberIndividualIdentifier"},{"id":"890504596","type":"subscriberSurrogateKey"}],"groupNumber":"1118478","groupName":"Membership_services_MG33","membershipEffectiveDate":"2015-01-01","membershipExpirationDate":"9999-12-31","coverageType":"M","coverageTypeDescription":"MEDICAL","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000004","productName":"Non-Gated INN/OON","productType":""},"benefit":{"benefitPlanId":"M000000015","benefitPlanName":"CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"},"relationshipCode":"18","privacyIndicator":"","legacyAttributes":{"eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR"}}],"identifiers":[{"id":"352816681","type":"HIC"},{"id":"69688001800","type":"SCR"},{"id":"69688001800","type":"MCH"}],"enrolleeSystemSpecificIdentifiers":[{"id":"23462613","type":"enrolleeSystemID"},{"id":"154907823","type":"enrolleeIndividualIdentifier"},{"id":"890504596","type":"enrolleeSurrogateKey"}]}],"pagination":{"pageNumber":"1","pageSize":"5","recordCount":"1","totalCount":"1","totalPages":"1"}}}');
                system.debug('2response'+response);
            }     
             
            system.debug('2323response'+response.getBody());
            system.debug('RequestLabel >>> '+RequestLabel);
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(memberDetailController, conti);
        system.debug('memberDetailController.MemberDetail >>> '+memberDetailController.MemberDetail);
          
          memberDetailController.ProferredCoverageGUID = +memberDetailController.MemberDetail.CoverageLines[0].guid;          
          memberDetailController.selectPreferredCoverage();       
          
          //call get membership function
          Continuation conti2 = (Continuation)memberDetailController.CallGetMembership();
           Map<String, HttpRequest> requests2 = conti2.getRequests();

        for(String RequestLabel: requests2.keyset()){
            request = requests2.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            system.debug(RequestLabel +' :: '+request);
            if(request.getEndpoint().contains('/api/alpha/eisl/individuals/membership/v2.0/read')) {
                system.debug('2323inside GetmemberShip');
                response.setBody('{"getMembershipResponse":{"membership":{"sourceSysCode":"CR","coverages":[{"groupNumber":"1118478","groupName":"Membership_services_MG33","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"0","benefitBundleOptionDescription":"MNRP PlanOptionDesc","benefitEffectiveDate":"2015-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000015","benefitPlanName":"CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C","benefitType":"MD","coverageLevelCode":"FAM","relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"69688001800","subscriberIdCardSerialNumber":"69688001800","eligibilityStatusCode":"A","cancelReasonTypeCode":"","planType":"02","indicators":{"qmscoIndicator":"N"}}]}]}],"cob":[{}],"providers":[{}],"identifiers":[{"id":"890504596","type":"enrolleeSurrogateKey"},{"id":"154907823","type":"enrolleeIndividualIdentifier"},{"id":"23462613","type":"enrolleeSystemID"},{"id":"23462613","type":"subscriberSystemID"},{"id":"154907823","type":"subscriberIndividualIdentifer"},{"id":"890504596","type":"subscriberSurrogateKey"}]}}}');                
            }      
            else if(request.getEndpoint().contains('/api/alpha/eisl/individuals/familymembership/v2.0/read')) {
                response.setBody('{"getFamilyMembershipResponse": {"individual": [{"individualIdentifier": "154907823","name": {"firstName": "Ruby","lastName": "Kelly","middleName": "","nameSuffix": ""},"birthDate": "1959-09-21","genderCode": "M","genderDescription": "Male","socialSecurityNumber": "689220485","address": [{"typeCode": "HOM","addressLine1": "95 Elgar Pass","addressLine2": "","city": "HFD","postalCode": "06140","stateCode": "CT","countryCode": "US"}],"membership": [{"sourceSysCode": "CR","coverages": [{"groupNumber": "1118478","groupName": "Membership_services_MG33","eligibilitySystemTypeCode": "CR","claimSystemTypeCode": "CR","bundleOptions": [{"benefits": [{"benefitBundleOptionId": "0","benefitBundleOptionDescription": "MNRP PlanOptionDesc","benefitEffectiveDate": "2015-01-01","benefitExpirationDate": "9999-12-31","benefitPlanId": "M000000015","benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C","benefitType": "MD","coverageLevelCode": "FAM","relationshipCode": "18","relationshipDescription": "Self","memberIdCardSerialNumber": "69688001800","subscriberIdCardSerialNumber": "69688001800","eligibilityStatusCode": "A","cancelReasonTypeCode": "","planType": "02"}]}]}],"cob": [{}],"providers": [{}],"identifiers": [{"id": "23462613","type": "subscriberSystemId"},{"id": "23462613","type": "enrolleeSystemID"},{"id": "890504596","type": "subscriberSurrogateKey"},{"id": "890504596","type": "enrolleeSurrogateKey"},{"id": "154907823","type": "enrolleeEID"}]}]}]}}');
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result2 = Test.invokeContinuationMethod(memberDetailController, conti2);       
        memberDetailController.selectPrimaryPhysician();
        memberDetailController.getNoOfMemAlert();
        memberDetailController.getCaseHistory();
        //memberDetailController.Originator = '0032100000MrAwv';
        //memberDetailController.changeOriginator();     

        Test.stopTest();
     }  
        private static testMethod void testWrapperMisdirectedReason(){
            ACETCallTopicsDataWrapper wrapper = new ACETCallTopicsDataWrapper();
            wrapper.getMisdirectedReasons();
            wrapper.getCancelReasons();
        }
     private static testMethod void testContinuation2() {
     
     Test.startTest();
     setTestData('Member');
      ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
        
      //memberDetailController.changeOriginator();
      memberDetailController.UserGroupName = 'Member Offshore';
      memberDetailController.memberNotFound();
      
        Continuation conti = (Continuation)memberDetailController.CallWSonPageLoad();
        Map<String, HttpRequest> requests = conti.getRequests();

        HttpResponse response;
        HttpRequest request;
        
        for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            system.debug('2323request'+ request);
            if(request.getEndpoint().contains('/api/alpha/eisl/individuals/v2.0/read')) {
                system.debug('2323inside GetIndividualService');
                response.setBody('{"getIndividualResponse":{"individual":{"individualIdentifier":"154907823","name":{"firstName":"Ruby","lastName":"Kelly","middleName":"","nameSuffix":""},"birthDate":"1959-09-21","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"HOM","addressLine1":"95 Elgar Pass","addressLine2":"","city":"HFD","postalCode":"06140","stateCode":"CT","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"321-686-6997","phoneExt":"","internationalIndicator":"N","primaryIndicator":"Y"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"ruby@optum.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"","employeeIdentifier":"","employmentStartDate":"","retirementDate":""}],"language":[{}],"otherContact":[{}],"identifiers":[{"id":"890504596","type":"SRK"},{"id":"352816681","type":"HIC"}]}}}');
                system.debug('1response'+response);
            }      
            else if(request.getEndpoint().contains('/api/alpha/eisl/individuals/membership/v2.0/search')) {
                system.debug('2323inside findMembershipsResponse');
                response.setBody('{"findMembershipsResponse":{"memberships":[{"sourceSysCode":"CR","coverages":[{"subscriberSystemSpecificIdentifiers":[{"id":"23462613","type":"subscriberSystemID"},{"id":"154907823","type":"subscriberIndividualIdentifier"},{"id":"890504596","type":"subscriberSurrogateKey"}],"groupNumber":"1118478","groupName":"Membership_services_MG33","membershipEffectiveDate":"2015-01-01","membershipExpirationDate":"9999-12-31","coverageType":"M","coverageTypeDescription":"MEDICAL","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000004","productName":"Non-Gated INN/OON","productType":""},"benefit":{"benefitPlanId":"M000000015","benefitPlanName":"CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"},"relationshipCode":"18","privacyIndicator":"","legacyAttributes":{"eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR"}}],"identifiers":[{"id":"352816681","type":"HIC"},{"id":"69688001800","type":"SCR"},{"id":"69688001800","type":"MCH"}],"enrolleeSystemSpecificIdentifiers":[{"id":"23462613","type":"enrolleeSystemID"},{"id":"154907823","type":"enrolleeIndividualIdentifier"},{"id":"890504596","type":"enrolleeSurrogateKey"}]}],"pagination":{"pageNumber":"1","pageSize":"5","recordCount":"1","totalCount":"1","totalPages":"1"}}}');
                system.debug('2response'+response);
            }     
             
            system.debug('2323response'+response.getBody());
            system.debug('RequestLabel >>> '+RequestLabel);
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(memberDetailController, conti);
        system.debug('memberDetailController.MemberDetail >>> '+memberDetailController.MemberDetail);
          
          memberDetailController.ProferredCoverageGUID = +memberDetailController.MemberDetail.CoverageLines[0].guid;          
          memberDetailController.selectPreferredCoverage();       
          
          //call get membership function
          Continuation conti2 = (Continuation)memberDetailController.CallGetMembership();
           Map<String, HttpRequest> requests2 = conti2.getRequests();

        for(String RequestLabel: requests2.keyset()){
            request = requests2.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            system.debug(RequestLabel +' :: '+request);
            if(request.getEndpoint().contains('/api/alpha/eisl/individuals/membership/v2.0/read')) {
                system.debug('2323inside GetmemberShip');
                response.setBody('{"getMembershipResponse":{"membership":{"sourceSysCode":"CR","coverages":[{"groupNumber":"1118478","groupName":"Membership_services_MG33","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"0","benefitBundleOptionDescription":"MNRP PlanOptionDesc","benefitEffectiveDate":"2015-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000015","benefitPlanName":"CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C","benefitType":"MD","coverageLevelCode":"FAM","relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"69688001800","subscriberIdCardSerialNumber":"69688001800","eligibilityStatusCode":"A","cancelReasonTypeCode":"","planType":"02","indicators":{"qmscoIndicator":"N"}}]}]}],"cob":[{}],"providers":[{}],"identifiers":[{"id":"890504596","type":"enrolleeSurrogateKey"},{"id":"154907823","type":"enrolleeIndividualIdentifier"},{"id":"23462613","type":"enrolleeSystemID"},{"id":"23462613","type":"subscriberSystemID"},{"id":"154907823","type":"subscriberIndividualIdentifer"},{"id":"890504596","type":"subscriberSurrogateKey"}]}}}');                
            }      
            else if(request.getEndpoint().contains('/api/alpha/eisl/individuals/familymembership/v2.0/read')) {
                response.setBody('{"getFamilyMembershipResponse": {"individual": [{"individualIdentifier": "154907823","name": {"firstName": "Ruby","lastName": "Kelly","middleName": "","nameSuffix": ""},"birthDate": "1959-09-21","genderCode": "M","genderDescription": "Male","socialSecurityNumber": "689220485","address": [{"typeCode": "HOM","addressLine1": "95 Elgar Pass","addressLine2": "","city": "HFD","postalCode": "06140","stateCode": "CT","countryCode": "US"}],"membership": [{"sourceSysCode": "CR","coverages": [{"groupNumber": "1118478","groupName": "Membership_services_MG33","eligibilitySystemTypeCode": "CR","claimSystemTypeCode": "CR","bundleOptions": [{"benefits": [{"benefitBundleOptionId": "0","benefitBundleOptionDescription": "MNRP PlanOptionDesc","benefitEffectiveDate": "2015-01-01","benefitExpirationDate": "9999-12-31","benefitPlanId": "M000000015","benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C","benefitType": "MD","coverageLevelCode": "FAM","relationshipCode": "18","relationshipDescription": "Self","memberIdCardSerialNumber": "69688001800","subscriberIdCardSerialNumber": "69688001800","eligibilityStatusCode": "A","cancelReasonTypeCode": "","planType": "02"}]}]}],"cob": [{}],"providers": [{}],"identifiers": [{"id": "23462613","type": "subscriberSystemId"},{"id": "23462613","type": "enrolleeSystemID"},{"id": "890504596","type": "subscriberSurrogateKey"},{"id": "890504596","type": "enrolleeSurrogateKey"},{"id": "154907823","type": "enrolleeEID"}]}]}]}}');
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result2 = Test.invokeContinuationMethod(memberDetailController, conti2);       
        memberDetailController.selectPrimaryPhysician();
        memberDetailController.getNoOfMemAlert();
        memberDetailController.getCaseHistory();
        //memberDetailController.Originator = '0032100000MrAwv';

        Test.stopTest();
     }
     //US635546-SNI
     
     public static testMethod void insertCase(){
             ACETMemberDetail memberDetailObj = new ACETMemberDetail();
         	 ACETMemberDetail.CoverageLine cvrgLine = new ACETMemberDetail.CoverageLine();
         	 cvrgLine.GroupNumber = '345672';
         	 cvrgLine.SourceCode = 'CR';
         	memberDetailObj.PreferredCoverage = cvrgLine;
             Interaction__c inte = TestDataFactory.createInteraction();
             Account acc = ACETTestDataUtility.createAccount('testName');
             insert acc;
                
           Contact con = ACETTestDataUtility.createContact(acc.id, 'Kelly', 'Ruby');
           con.EID__c = '345678234';
           insert con;
                
           ApexPages.currentPage().getParameters().put('InteractionId',inte.id);
             ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
             memberDetailController.caseTopic='View Authorizations';
             memberDetailController.caseType='Additional Information Needed';
             memberDetailController.caseSubType='Awaiting Incoming Information';
             memberDetailController.originator=con.Id;
         	 memberDetailController.MemberDetail = memberDetailObj;
             memberDetailController.saveCaseOnSubmit();
     }      
}