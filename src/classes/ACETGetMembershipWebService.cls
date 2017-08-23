public with sharing class ACETGetMembershipWebService extends ACETWebService{ 
    public override void getEndpoint(){
        GetEndpointDetail('GetMembershipEndpoint');
    }
    public void getEndpoint(Boolean isCallableService, Boolean isAdaptorService){
        if(isCallableService){
            //No callable endpoint
        }else if(isAdaptorService){
            RelativeUrl = '/api/alpha/eisl/individuals/membership/v2.0/read';
        }else{
            GetEndpointDetail('GetMembershipEndpoint');
        }               
    }    
    public void getRequestBody(String memberId, String customerAccountId){
        RequestBody = '{'
            + '"getMembershipRequest": {'
            + '"membershipRequestType": {'
            + '"searchId": "' + memberId + '","customerAccountId": "' + customerAccountId + '","coverageTypeCode": ["ALL"],"effectiveDates": {'
            + '"startDate": "2011-08-01","stopDate": "9999-12-31"}'
            + '}}}';                  
    } 
    public void getRequestBodyAdaptor(String identifier, String groupNumber){
        RequestBody = '{"getMembershipRequest" : {"identifier" : "'+identifier+'","identifierType" : "SRK","groupNumber" : "'+groupNumber+'"}}';                  
    }    
    public ACETWSCalloutResult getMembership(String memberId, String customerAccountId, ACETMemberDetail memberDetail){               
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();  
        }        
            Boolean isBravo = String.isBlank(MemberDetail.SurrogateKey) ? true : false;
            Boolean isCallable = !String.isBlank(MemberDetail.SurrogateKey) && (MemberDetail.SurrogateKey).startsWith('dummy')? true : false;
            Boolean isAdaptor = !isBravo && !isCallable ? true : false;
                    

            getEndpoint(isCallable,isAdaptor);
            if(isCallable || isAdaptor){
                getRequestBodyAdaptor(MemberDetail.SurrogateKey,customerAccountId);
            }else{
                GetRequestBody(memberId, customerAccountId);
            }
            ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
            try{
            
            HttpResponse response = Send(OAuthConfig);                   
        
            if(response.getStatusCode() == 200){
                if(response.getBody() != null){
                    if(isBravo){

                    //replace date with date2 as date is a preserved keyword
                    String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                    
                    //replace desc with desc2 as desc is a preserved keyword
                    responseBody = responseBody.replace('\"desc\":', '\"desc_Z\":');
                    system.debug(responseBody);
                    
                    //special fix for different response type for postal type
                    //responseBody = responseBody.replace('"postalCode": {"part1": "07920"},', '"postalCode": {"part1": "07920","part2": "0000"},');
                    
                    //ACETGetMembershipJSON2Apex jSON2Apex = (ACETGetMembershipJSON2Apex)JSON.deserialize(responseBody, ACETGetMembershipJSON2Apex.class);
                    ACETGetMembershipJSON2Apex jSON2Apex = ACETGetMembershipJSON2Apex.parse(responseBody);
                    system.debug('JSON2Apex : ' + jSON2Apex);
                    
                    ACETGetMembershipJSON2Apex.Memberships membership = jSON2Apex.getMembershipResponse.membershipResponseType.memberships[0];
                    memberDetail.RelationShip = membership.eligibilityRelationshipCode.desc_Z;
                    memberDetail.SitusState = membership.customerAccount.customerPurchase[0].situsStateCode.code;
                    memberDetail.PolicyNumber = membership.customerAccount.customerAccountId.id;
                    memberDetail.FundingArragement = membership.customerAccount.customerPurchase[0].fundingArrangementCode.code;
                    
                    memberDetail.Network = membership.providerSelection[0].networkId.id;                    
                    memberDetail.MigrationDate = formatDate(membership.migrationDate);   
                                   
                    //memberDetail.AsianInitiativeIndicator =  
                    memberDetail.OriginalEffectiveDate = formatDate(membership.providerSelection[0].effectiveDateRange.startDate);                                                                                                                     
                   
                   //added by Khoushik on 09/28/2016 for User Story - US378010
                        
                   List<ACETMemberDetail.COB> amdlstCOB = new List<ACETMemberDetail.COB>();    
                      if(membership.coordinationOfBenefits !=null)
                        {
                            if(membership.coordinationOfBenefits.size() > 0 )
                            {
                            
                            
                            for(ACETGetMembershipJSON2Apex.CoordinationOfBenefits cob: membership.coordinationOfBenefits)
                            {
                                    ACETMemberDetail.COB amdcob  = new ACETMemberDetail.COB();
                                    
                                     amdcob.InsuranceType = cob.insuranceTypeCode.code;
                                     
                                      Date Startdt = null;
                                     if(cob.insuranceEffectiveDateRange.startDate != null)
                                    {
                                        if(cob.insuranceEffectiveDateRange.startDate != '')
                                        {
                                            Startdt  = Date.valueOf(cob.insuranceEffectiveDateRange.startDate);
                                        }
                                    }
                                     amdcob.Startdt = Startdt;
                                     
                                      Date Enddt = null;
                                     if(cob.insuranceEffectiveDateRange.stopDate != null)
                                    {
                                        if(cob.insuranceEffectiveDateRange.stopDate != '')
                                        {
                                            Enddt  = Date.valueOf(cob.insuranceEffectiveDateRange.stopDate);
                                        }
                                    }
                                     amdcob.Enddt = Enddt;
                                     
                                 Date LastUpdate = null;
                                 if(cob.insuranceVerificationDate.date2!= null){
                                    if(cob.insuranceVerificationDate.date2!= ''){
                                        LastUpdate  = Date.valueOf(cob.insuranceVerificationDate.date2); 
                                    }
                                 }
                                     amdcob.LastUpdate = LastUpdate;
                                     amdcob.IsMedicarePrimary = cob.payerResponsibilitySequenceCode.code;
                                     amdcob.EntitlementReason = cob.medicareEntitlementTypeCode.code;
                                     amdcob.MedicareType = cob.medicareEntitlementTypeCode.code;
                                    
                                    amdlstCOB.add(amdcob);
                            }
                          //  memberDetail.lstCOB = amdlstCOB;
                            }
                        }     
                        memberDetail.EligibilityStatus = membership.benefitsStatusCode.code; 
                        memberDetail.CoverageLevel= membership.coverageLevelCode.code; 
                        memberDetail.GroupName = membership.organization.name[0].name;
                        
                        
                        memberDetail.ClaimAddressline1 = membership.claimOffice[0].postalAddress.line1; 
                        memberDetail.ClaimAddressline2 = membership.claimOffice[0].postalAddress.line2;
                        memberDetail.ClaimAddresscity = membership.claimOffice[0].postalAddress.city; 
                        memberDetail.ClaimAddressstate = membership.claimOffice[0].postalAddress.state.code;
                        memberDetail.ClaimAddresspostalCode = membership.claimOffice[0].postalAddress.postalCode.part1; 
                        memberDetail.ClaimAddresscountyCode = membership.claimOffice[0].postalAddress.countyCode.code; 
                        
                        
                        
                        
                        
                        
                                              
                    calloutResult.Success = true;
                    calloutResult.Message = '';
                    calloutResult.Response = memberDetail;
                                        
                    }else if(isCallable || isAdaptor){
                    String responseBody = response.getBody();   
                    ACETGetMembershipJSON2ApexADP jSON2Apex = (ACETGetMembershipJSON2ApexADP)JSON.deserialize(responseBody, ACETGetMembershipJSON2ApexADP.class);
                    system.debug('JSON2Apex : ' + jSON2Apex);
                    ACETGetMembershipJSON2ApexADP.cls_membership Membership = jSON2Apex.getMembershipResponse != null ? jSON2Apex.getMembershipResponse.membership : null;
                    if(Membership != null){
                        for(ACETGetMembershipJSON2ApexADP.cls_coverages coverage : Membership.coverages ){
                            memberDetail.SitusState = coverage.bundleOptions[0].benefits[0].stateOfIssueCode; 
                            memberDetail.FundingArragement = coverage.bundleOptions[0].benefits[0].fundingArrangementDescription;
                            memberDetail.BenefitPlanId = coverage.bundleOptions[0].benefits[0].benefitPlanId;
                            memberDetail.FundingArragementCode = coverage.bundleOptions[0].benefits[0].fundingArrangementCode;
                            //memberDetail.Network = OIL Gap
                            memberDetail.RelationShip = coverage.bundleOptions[0].benefits[0].relationshipDescription;//No relationship description is coming from OIL currently
                            memberDetail.RelationShipCode = coverage.bundleOptions[0].benefits[0].relationshipCode;//No relationship description is coming from OIL currently
                            memberDetail.EffectiveDate = coverage.bundleOptions[0].benefits[0].benefitEffectiveDate;
                            memberDetail.EndDate = coverage.bundleOptions[0].benefits[0].benefitExpirationDate;
                            memberDetail.EligibilityStatus = coverage.bundleOptions[0].benefits[0].eligibilityStatusCode;
                            memberDetail.EligibilityStatus = coverage.bundleOptions[0].benefits[0].eligibilityStatusCode;
                            //memberDetail.PCPRequired = coverage.bundleOptions[0].benefits[0].;                            
                        } 
                        system.debug('----------Membership.providers---------->'+Membership.providers);
                        memberDetail.PCPAssignments = new List<ACETMemberDetail.PCPAssignment>();
                        for(ACETGetMembershipJSON2ApexADP.cls_providers provider : Membership.providers ){
                            system.debug('----------ACETMemberDetail---------->'+provider);
                            ACETMemberDetail.PCPAssignment pcp = new ACETMemberDetail.PCPAssignment();
                            pcp.FirstName = provider.firstName;  
                            pcp.LastName = provider.lastName;
                            pcp.pcpAssignmentType = provider.assignmentType;
                            system.debug('----Dates---->'+provider.effectiveDate+'-----Today----->'+Date.Today());
                            if(provider.effectiveDate != null && provider.effectiveDate != '')
                            pcp.endDate = formatdate(provider.expirationDate);                         
                            //memberDetail.Network = OIL Gap
                            if(provider.effectiveDate != null && provider.effectiveDate != '')
                                pcp.effectiveDate = formatdate(provider.effectiveDate);
                           // pcp.effectiveDate = date.parse('2016-01-01 00:00:00');
                            system.debug('----Dates---->'+pcp.effectiveDate+'-----Today----->'+Date.Today()); 
                            memberDetail.PCPAssignments.add(pcp);
                        } 
                      }
                    calloutResult.Success = true;
                    calloutResult.Message = '';
                    calloutResult.Response = memberDetail;
                    }
                }
                
            }else if(response.getStatusCode() == 500){                
                //currently servce returns 500 if no records found
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.Success = true;                
                calloutResult.Response = new ACETMemberDetail();
                system.debug(calloutResult);                
            }
            }catch(Exception e){
                    system.debug(e);
                    calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                    calloutResult.Success = false;
                    calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
           }
        
        return calloutResult;    
    } 
    
    //to remove to global util class
    public String formatDate(String dateString){
        if(dateString == null) return null;
        
        List<String> dateParts = dateString.split('-');
        if(dateParts.size() == 3){
            String mm = dateParts[1];
            String dd = dateParts[2];
            String yyyy = dateParts[0];
            
            mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','') : mm ; 
            dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','') : dd; 
                                   
            return mm  + '/' + dd + '/' + yyyy;
        }else{
            return dateString;
        }
    }
    
    public String getAgeFromBirthday(String birthDate){
        Date d = Date.valueOf(birthDate);
        return String.valueOf(d.daysBetween(Date.today())/365);
    }
    
    public String getMaskedSSN(String ssn){
        if(String.isEmpty(ssn) || ssn.length() < 4) return '';
        
        return 'xxx-xx-' + ssn.substring(ssn.length() - 4);
    }
     public Continuation StartRequest(String memberId, String customerAccountId, ACETMemberDetail MemberDetail, String CallbackMethodName, Continuation oContinuation)
    {   
         if(memberDetail == null){
            memberDetail = new ACETMemberDetail();  
        }        
            Boolean isBravo = String.isBlank(MemberDetail.SurrogateKey) ? true : false;
            Boolean isCallable = !String.isBlank(MemberDetail.SurrogateKey) && (MemberDetail.SurrogateKey).startsWith('dummy')? true : false;
            Boolean isAdaptor = !isBravo && !isCallable ? true : false;
                    

            getEndpoint(isCallable,isAdaptor);
            if(isCallable || isAdaptor){
                getRequestBodyAdaptor(MemberDetail.SurrogateKey,customerAccountId);
            }else{
                GetRequestBody(memberId, customerAccountId);
            }
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        system.debug('CallbackMethodName'+ CallbackMethodName + oContinuation);
        return oContinuation;         
    } 
     public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel, ACETMemberDetail memberDetail){              
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();  
        }        
            Boolean isBravo = String.isBlank(MemberDetail.SurrogateKey) ? true : false;
            Boolean isCallable = !String.isBlank(MemberDetail.SurrogateKey) && (MemberDetail.SurrogateKey).startsWith('dummy')? true : false;
            Boolean isAdaptor = !isBravo && !isCallable ? true : false;
            ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
            try{
           HttpResponse response = GetHttpResponse(HttpRequestLabel);                  
        
            if(response.getStatusCode() == 200){
                if(response.getBody() != null){
                    if(isBravo){

                    //replace date with date2 as date is a preserved keyword
                    String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                    
                    //replace desc with desc2 as desc is a preserved keyword
                    responseBody = responseBody.replace('\"desc\":', '\"desc_Z\":');
                    system.debug(responseBody);
                    
                    //special fix for different response type for postal type
                    //responseBody = responseBody.replace('"postalCode": {"part1": "07920"},', '"postalCode": {"part1": "07920","part2": "0000"},');
                    
                    //ACETGetMembershipJSON2Apex jSON2Apex = (ACETGetMembershipJSON2Apex)JSON.deserialize(responseBody, ACETGetMembershipJSON2Apex.class);
                    ACETGetMembershipJSON2Apex jSON2Apex = ACETGetMembershipJSON2Apex.parse(responseBody);
                    system.debug('JSON2Apex : ' + jSON2Apex);
                    
                    ACETGetMembershipJSON2Apex.Memberships membership = jSON2Apex.getMembershipResponse.membershipResponseType.memberships[0];
                    memberDetail.RelationShip = membership.eligibilityRelationshipCode.desc_Z;
                    memberDetail.SitusState = membership.customerAccount.customerPurchase[0].situsStateCode.code;
                    memberDetail.PolicyNumber = membership.customerAccount.customerAccountId.id;
                    memberDetail.FundingArragement = membership.customerAccount.customerPurchase[0].fundingArrangementCode.code;
                    
                    memberDetail.Network = membership.providerSelection[0].networkId.id;                    
                    memberDetail.MigrationDate = formatDate(membership.migrationDate);   
                                   
                    //memberDetail.AsianInitiativeIndicator =  
                    memberDetail.OriginalEffectiveDate = formatDate(membership.providerSelection[0].effectiveDateRange.startDate);                                                                                                                     
                   
                   //added by Khoushik on 09/28/2016 for User Story - US378010
                        
                   List<ACETMemberDetail.COB> amdlstCOB = new List<ACETMemberDetail.COB>();    
                      if(membership.coordinationOfBenefits !=null)
                        {
                            if(membership.coordinationOfBenefits.size() > 0 )
                            {
                            
                            
                            for(ACETGetMembershipJSON2Apex.CoordinationOfBenefits cob: membership.coordinationOfBenefits)
                            {
                                    ACETMemberDetail.COB amdcob  = new ACETMemberDetail.COB();
                                    
                                     amdcob.InsuranceType = cob.insuranceTypeCode.code;
                                     
                                      Date Startdt = null;
                                     if(cob.insuranceEffectiveDateRange.startDate != null)
                                    {
                                        if(cob.insuranceEffectiveDateRange.startDate != '')
                                        {
                                            Startdt  = Date.valueOf(cob.insuranceEffectiveDateRange.startDate);
                                        }
                                    }
                                     amdcob.Startdt = Startdt;
                                     
                                      Date Enddt = null;
                                     if(cob.insuranceEffectiveDateRange.stopDate != null)
                                    {
                                        if(cob.insuranceEffectiveDateRange.stopDate != '')
                                        {
                                            Enddt  = Date.valueOf(cob.insuranceEffectiveDateRange.stopDate);
                                        }
                                    }
                                     amdcob.Enddt = Enddt;
                                     
                                 Date LastUpdate = null;
                                 if(cob.insuranceVerificationDate.date2!= null){
                                    if(cob.insuranceVerificationDate.date2!= ''){
                                        LastUpdate  = Date.valueOf(cob.insuranceVerificationDate.date2); 
                                    }
                                 }
                                     amdcob.LastUpdate = LastUpdate;
                                     amdcob.IsMedicarePrimary = cob.payerResponsibilitySequenceCode.code;
                                     amdcob.EntitlementReason = cob.medicareEntitlementTypeCode.code;
                                     amdcob.MedicareType = cob.medicareEntitlementTypeCode.code;
                                    
                                    amdlstCOB.add(amdcob);
                            }
                          //  memberDetail.lstCOB = amdlstCOB;
                            }
                        }     
                        memberDetail.EligibilityStatus = membership.benefitsStatusCode.code; 
                        memberDetail.CoverageLevel= membership.coverageLevelCode.code; 
                        memberDetail.GroupName = membership.organization.name[0].name;
                        
                        
                        memberDetail.ClaimAddressline1 = membership.claimOffice[0].postalAddress.line1; 
                        memberDetail.ClaimAddressline2 = membership.claimOffice[0].postalAddress.line2;
                        memberDetail.ClaimAddresscity = membership.claimOffice[0].postalAddress.city; 
                        memberDetail.ClaimAddressstate = membership.claimOffice[0].postalAddress.state.code;
                        memberDetail.ClaimAddresspostalCode = membership.claimOffice[0].postalAddress.postalCode.part1; 
                        memberDetail.ClaimAddresscountyCode = membership.claimOffice[0].postalAddress.countyCode.code; 
                    calloutResult.Success = true;
                    calloutResult.Message = '';
                    calloutResult.Response = memberDetail;
                                        
                    }else if(isCallable || isAdaptor){
                    String responseBody = response.getBody();   
                    ACETGetMembershipJSON2ApexADP jSON2Apex = (ACETGetMembershipJSON2ApexADP)JSON.deserialize(responseBody, ACETGetMembershipJSON2ApexADP.class);
                    system.debug('JSON2Apex : ' + jSON2Apex);
                    ACETGetMembershipJSON2ApexADP.cls_membership Membership = jSON2Apex.getMembershipResponse != null ? jSON2Apex.getMembershipResponse.membership : null;
                    if(Membership != null){
                        for(ACETGetMembershipJSON2ApexADP.cls_coverages coverage : Membership.coverages ){
                            memberDetail.SitusState = coverage.bundleOptions[0].benefits[0].stateOfIssueCode; 
                            memberDetail.FundingArragement = coverage.bundleOptions[0].benefits[0].fundingArrangementDescription;
                            memberDetail.BenefitPlanId = coverage.bundleOptions[0].benefits[0].benefitPlanId;
                            memberDetail.FundingArragementCode = coverage.bundleOptions[0].benefits[0].fundingArrangementCode;
                            //memberDetail.Network = OIL Gap
                            memberDetail.RelationShip = coverage.bundleOptions[0].benefits[0].relationshipDescription;//No relationship description is coming from OIL currently
                            memberDetail.RelationShipCode = coverage.bundleOptions[0].benefits[0].relationshipCode;//No relationship description is coming from OIL currently
                            memberDetail.EffectiveDate = coverage.bundleOptions[0].benefits[0].benefitEffectiveDate;
                            memberDetail.EndDate = coverage.bundleOptions[0].benefits[0].benefitExpirationDate;
                            memberDetail.EligibilityStatus = coverage.bundleOptions[0].benefits[0].eligibilityStatusCode;
                            memberDetail.EligibilityStatus = coverage.bundleOptions[0].benefits[0].eligibilityStatusCode;
                            //memberDetail.PCPRequired = coverage.bundleOptions[0].benefits[0].;                            
                        } 
                        system.debug('----------Membership.providers---------->'+Membership.providers);
                        memberDetail.PCPAssignments = new List<ACETMemberDetail.PCPAssignment>();
                        for(ACETGetMembershipJSON2ApexADP.cls_providers provider : Membership.providers ){
                            ACETMemberDetail.PCPAssignment pcp = new ACETMemberDetail.PCPAssignment();
                            pcp.FirstName = provider.firstName;  
                            pcp.LastName = provider.lastName;
                            pcp.pcpAssignmentType = provider.assignmentType;
                        /*    if(provider.expirationDate != '' && provider.expirationDate != null){
                                pcp.endDate = null;//date.parse(provider.expirationDate);
                            } */
                                                      
                            //memberDetail.Network = OIL Gap
                           system.debug('----Dates---->'+provider.effectiveDate+'-----Today----->'+Date.Today());
                            if(provider.effectiveDate != null && provider.effectiveDate != '')
                           pcp.endDate = formatdate(provider.expirationDate);                         
                            //memberDetail.Network = OIL Gap
                            if(provider.effectiveDate != null && provider.effectiveDate != '')
                              pcp.effectiveDate = formatdate(provider.effectiveDate);
                          //  pcp.effectiveDate = date.parse('05/05/2017');
                            system.debug('----Dates---->'+pcp.effectiveDate+'-----Today----->'+Date.Today());
                            memberDetail.PCPAssignments.add(pcp);
                        }
                        system.debug('----------memberDetail.PCPAssignments---------->'+memberDetail.PCPAssignments); 
                      }
                    calloutResult.Success = true;
                    calloutResult.Message = '';
                    calloutResult.Response = memberDetail; 
                    }
                }
                
            }else if(response.getStatusCode() == 500){                
                //currently servce returns 500 if no records found
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.Success = true;                
                calloutResult.Response = new ACETMemberDetail();
                system.debug(calloutResult);                
            }
            else{
                calloutResult = ParseFailureResponse(response);
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
            }
            }catch(Exception e){
                    system.debug(e.getStackTraceString());
                    calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                    calloutResult.Success = false;
                    calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
           }
        
        return calloutResult;    
    }      
}