public class ACETGetFamilyMemberWebService extends ACETWebService{
    public Map<String,String> coverageTypeVsDescMap;
    public Map<String,String> primaryIndicatorVsDescMap;
    public ACETGetFamilyMemberWebService(){
        coverageTypeVsDescMap = new Map<String,String>();
        coverageTypeVsDescMap.put('1','Commercial');
        coverageTypeVsDescMap.put('2','Government');
        coverageTypeVsDescMap.put('3','Motor Vehicle Accident');
        coverageTypeVsDescMap.put('4','Worker\'s Compensation');
        coverageTypeVsDescMap.put('5','Other');
        
        primaryIndicatorVsDescMap = new Map<String,String>();
        primaryIndicatorVsDescMap.put('P','Primary');
        primaryIndicatorVsDescMap.put('S','Secondary');
        primaryIndicatorVsDescMap.put('T','Teritiary');
        primaryIndicatorVsDescMap.put('U','Unknown');
    }
    public override void getEndpoint(){
        GetEndpointDetail('GetFamilyMembersEndpoint');
    }
    public void getEndpoint(Boolean isCallableService){
        if(isCallableService){
            //RelativeURL = '/api/bravo/eisl/individuals/familymembership/v2.0/read';
            RelativeURL = '/api/alpha/eisl/individuals/familymembership/v2.0/read'; 
        }else{
            GetEndpointDetail('GetFamilyMembersEndpoint');
        }               
    }
    public void getRequestBodyCallable(){
        RequestBody = '{"getFamilyMembershipRequest": {"identifier": "11801753","identifierType": "SRK","groupNumber": "5678","membershipEffectiveDate": "2016-03-01"}}';
    } 
    public void getRequestBodyAdaptor(String identifier,String groupNumber,String effectiveDate){
        RequestBody = '{"getFamilyMembershipRequest": {"identifier": "'+identifier+'","identifierType": "SRK","groupNumber": "'+groupNumber+'","membershipEffectiveDate": "'+effectiveDate+'"}}';
    }             
    public void getRequestBody(String memberId){
        RequestBody = '{'
                        + '"memberfamilyRequest": {'
                            +'"getMemberFamilyRequestMsgType": {'
                                +'"membership": {'
                                        +'"subscriberEntityId": {'
                                        +'"id":'+memberId
                                    +'},'
                                    +'"effectiveDateRange": {'
                                    +'  "startDate": "2011-08-01"'
                                    +'}'
                                +'},'
                                +'"customerAccount": {'
                                +'  "customerAccountId": {'
                                +'      "id": "000737"'
                                +'  }'
                                +'}'
                            +'}'
                        +'}'
                    +'}';                  
    } 
    
    public ACETWSCalloutResult getFamilyMembers(String memberId, ACETMemberDetail memberDetail){
           Boolean isBravo = String.isBlank(MemberDetail.SurrogateKey) ? true : false;//for memberid 00589997121
           Boolean isCallable = !String.isBlank(MemberDetail.SurrogateKey) ? true : false;//for memberid 123456789      
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();
        }
        
        try{

                getEndpoint(isCallable);
                if(isCallable){
                    getRequestBodyCallable();
                }else{
                GetRequestBody(memberId);
                }
            HttpResponse response = Send(OAuthConfig);
            if(response.getStatusCode() == 200){
                if(response.getBody() != null){
                    if(isBravo){
                    //replace date with date2 as date is a preserved keyword
                    String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                    
                    //replace desc with desc2 as desc is a preserved keyword
                    responseBody = responseBody.replace('\"desc\":', '\"desc2\":');
                    system.debug(responseBody);
                    ACETGetFamilyMemberJSONtoApex jSON2Apex = (ACETGetFamilyMemberJSONtoApex)JSON.deserialize(responseBody, ACETGetFamilyMemberJSONtoApex.class);
                    
                    memberDetail.FamilyMembers = new List<ACETMemberDetail.FamilyMember>();
                    for(ACETGetFamilyMemberJSONtoApex.Individuals individual : jSON2Apex.readResult.getMemberFamilyResponseMsgType.memberFamily[0].individuals){
                        ACETMemberDetail.FamilyMember fm = new ACETMemberDetail.FamilyMember();
                        fm.FirstName = individual.name.firstName;
                        fm.LastName = individual.name.lastName;
                        fm.MiddleInitial = individual.name.middleInitialName;
                        fm.Gender = individual.genderCode.code;
                        fm.DOB = formatDate(individual.birthDate.date2);
                        fm.Age = getAgeFromBirthday(individual.birthDate.date2);
                        fm.Relationship = individual.memberShip.eligibilityRelationshipCode.desc2;
                        fm.EID = individual.IndividualId.id; //Added by Swetha//
                        memberDetail.FamilyMembers.add(fm); 
                    }                    
                    
                    system.debug(memberDetail);                                                           
                    calloutResult.Success = true;
                    calloutResult.Message = '';
                    calloutResult.Response = memberDetail;
                    }else{
                    //replace date with date2 as date is a preserved keyword
                    String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                    
                    //replace desc with desc2 as desc is a preserved keyword
                    responseBody = responseBody.replace('\"desc\":', '\"desc2\":');
                    system.debug('responseBody-->'+responseBody);
                    ACETFamilyMembershipJson2Apex jSON2Apex = (ACETFamilyMembershipJson2Apex)JSON.deserialize(responseBody, ACETFamilyMembershipJson2Apex.class);
                    system.debug('jSON2Apex -->'+jSON2Apex);                    
                    memberDetail.FamilyMembers = new List<ACETMemberDetail.FamilyMember>();
                    List<ACETMemberDetail.COB> amdlstCOB = new List<ACETMemberDetail.COB>();  
                    for(ACETFamilyMembershipJson2Apex.cls_individual individual : jSON2Apex.getFamilyMembershipResponse.individual){
                        ACETMemberDetail.FamilyMember fm = new ACETMemberDetail.FamilyMember();
                        fm.FirstName = individual.name.firstName;
                        fm.LastName = individual.name.lastName;
                        fm.MiddleInitial = individual.name.middleName;
                        fm.suffix = individual.name.nameSuffix;
                        fm.FamilyId = individual.membership[0].identifiers[0].id ;
                        fm.Gender = individual.genderCode;
                        fm.DOB = formatDate(individual.birthDate);
                        fm.Age = getAgeFromBirthday(individual.birthDate);
                        fm.Relationship = individual.relationshipCode;
                        fm.EID = individual.individualIdentifier; //Added by Swetha//

                        memberDetail.FamilyMembers.add(fm); 
                        //Khoushik adding code for Coordination Of Benefits
                          for(ACETFamilyMembershipJson2Apex.cls_membership membership : individual.membership){
                            for(ACETFamilyMembershipJson2Apex.cls_cob cob : membership.cob){
                              Date Startdt = null;
                              Date Enddt = null;
                              Date LastUpdate = null;
                              ACETMemberDetail.COB cb = new ACETMemberDetail.COB();
                              cb.Name = individual.name.firstName + ' ' + individual.name.lastName;
                              cb.DateOfBirth = formatDate(individual.birthDate);
                              if(!String.isEmpty(cb.DateOfBirth)){
                                Date dob = Date.parse(cb.DateOfBirth);
                                Integer days = dob.daysBetween(Date.Today());
                                        Integer age = Integer.valueOf(days/365);
                            cb.Age = String.valueOf(age);
                                
                              }
                               
                              cb.InsuranceType = cob.cobTypeCodeDescription;
                              cb.IsOtherInsurancePrimary = cob.otherInsurancePrimacyIndicator;
                              system.debug('cobEffectiveStartDate' + cob.cobEffectiveStartDate);
                              system.debug('cobEffectiveEndDate' + cob.cobEffectiveEndDate);
                              if(cob.cobEffectiveStartDate != null){
                                    Startdt = Date.ValueOf(cob.cobEffectiveStartDate);  
                              }
                              if(cob.cobEffectiveEndDate != null){
                                    Enddt = Date.ValueOf(cob.cobEffectiveEndDate);  
                              }
                               
                              cb.Startdt = Startdt;
                              cb.Enddt = Enddt;
                              //LastUpdate
                              for(ACETFamilyMembershipJson2Apex.cls_coverages cov : membership.coverages){
                                for(ACETFamilyMembershipJson2Apex.cls_bundleOptions bun : cov.bundleOptions){
                                    for(ACETFamilyMembershipJson2Apex.cls_benefits benefits : bun.benefits){
                                        if(benefits.coverageLastUpdateDate != null){
                                            LastUpdate = Date.ValueOf(benefits.coverageLastUpdateDate.substring(0,4)+ '-' + benefits.coverageLastUpdateDate.substring(4,6) + '-' + benefits.coverageLastUpdateDate.substring(6,8)); 
                                            system.debug('benefits.coverageLastUpdateDate'+benefits.coverageLastUpdateDate);
                                            system.debug('LastUpdate '+LastUpdate);
                                        }
                                        cb.Relationship = benefits.relationshipDescription;           
                                    }   
                                }           
                              }
                              
                              cb.LastUpdate = LastUpdate;
                              cb.MedicareType = cob.coverageType;
                              cb.IsMedicarePrimary = cob.otherInsurancePrimacyIndicator;                              
                              amdlstCOB.add(cb);
                            }
                                                           
                          }                           
                        
                      }
                      system.debug('amdlstCOB'+amdlstCOB);                    
                     memberDetail.lstCOB = amdlstCOB; 
                    system.debug(memberDetail);                                                           
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
    
    public ACETWSCalloutResult findMembers(String memberId,String firstname, String lastName, String dob,String zip, String state , String filterBy){
        //ToDo: implement service with more filters
        return null;    
    }
     public Continuation StartRequest(String memberId, ACETMemberDetail MemberDetail, String CallbackMethodName, Continuation oContinuation)
    {   
         Boolean isBravo = String.isBlank(MemberDetail.SurrogateKey) ? true : false;//for memberid 00589997121
         Boolean isCallable = !String.isBlank(MemberDetail.SurrogateKey) ? true : false;//for memberid 123456789      
        
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();
        }
          getEndpoint(isCallable);
          if(isCallable){
            //getRequestBodyCallable();
            getRequestBodyAdaptor(MemberDetail.SurrogateKey, MemberDetail.PreferredCoverage.groupNumber, ACETWebServicehelper.formatToYYYYMMDD(MemberDetail.PreferredCoverage.effectiveDate));
          }else{
          GetRequestBody(memberId);
          }
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        return oContinuation;         
    }
     public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel, ACETMemberDetail memberDetail){
           Boolean isBravo = String.isBlank(MemberDetail.SurrogateKey) ? true : false;//for memberid 00589997121
           Boolean isCallable = !String.isBlank(MemberDetail.SurrogateKey) ? true : false;//for memberid 123456789      
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();
        }
        
        try{

           HttpResponse response = GetHttpResponse(HttpRequestLabel);     
           //String body = '{"getFamilyMembershipResponse":{"individual":[{"individualIdentifier":"159070094","name":{"firstName":"Christopher","lastName":"Lawson","middleName":"Fred","nameSuffix":"VIII"},"birthDate":"1961-06-16","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"598315411","privacyIndicator":"R","address":[{"typeCode":"HOM","addressLine1":"108 Pearson Drive","addressLine2":"suite 2","city":"CANTON","postalCode":"06019","stateCode":"CT","countryCode":"US"}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1228498","groupName":"ACCUM_MG_01","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1890004","benefitBundleOptionDescription":"","benefitEffectiveDate":"2017-03-15","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000014_ACCUM1","benefitPlanName":"M000000014_Accum1","benefitType":"MD","coverageLevelCode":"E2D","relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"81773650800","subscriberIdCardSerialNumber":"81773650800","eligibilityStatusCode":"C","cancelReasonTypeCode":"","planType":"02","indicators":{"qmscoIndicator":"N"}},{"benefitBundleOptionId":"1890004","benefitBundleOptionDescription":"","benefitEffectiveDate":"2017-03-15","benefitExpirationDate":"9999-12-31","benefitPlanId":"RX00000081_ACCUM1","benefitPlanName":"RX00000081_AccUM1","benefitType":"RX","coverageLevelCode":"E2D","relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"81773650800","subscriberIdCardSerialNumber":"81773650800","eligibilityStatusCode":"C","cancelReasonTypeCode":"","planType":"02","indicators":{"qmscoIndicator":"N"}}]}]}],"cob":[{"cobTypeCode":"48","cobTypeCodeDescription":"Hospital - Inpatient","otherInsurancePrimacyIndicator":"T","coverageType":"3","cobEffectiveStartDate":"2017-03-15","cobEffectiveEndDate":"9999-12-31","otherInsuranceVerifyDate":"2017-05-15","otherInsurancePolicyNumber":"1228498","otherInsuranceCardholderId":"23452521","otherInsuranceCarrierName":"Oxford","cobRelatedEntityContactTelephoneNumber":"545-344-6565"}],"providers":[{"providerIdentifiers":[{"id":"212226509","type":"SY"},{"id":"980788","type":"MPI"},{"id":"44K201","type":"1C"},{"id":"1427160985","type":"NPI"},{"id":"143346191229299883","type":"LTK"}],"assignmentType":"PCP","effectiveDate":"2017-03-15","expirationDate":"9999-12-31","firstName":"LINDA","lastName":"TAO","networkId":"1018476","organizationLocationId":"0"}],"identifiers":[{"id":"159070094","type":"enrolleeEID"},{"id":"23452521","type":"subscriberSystemId"},{"id":"23452521","type":"enrolleeSystemID"},{"id":"894666792","type":"subscriberSurrogateKey"},{"id":"894666792","type":"enrolleeSurrogateKey"}]}]},{"individualIdentifier":"161626388","name":{"firstName":"Christine","lastName":"Lawson","middleName":"Sally","nameSuffix":"Sr"},"birthDate":"1967-06-16","genderCode":"F","genderDescription":"Female","socialSecurityNumber":"598374411","privacyIndicator":"R","address":[{"typeCode":"HOM","addressLine1":"108 Pearson Drive","addressLine2":"suite 2","city":"CANTON","postalCode":"06019","stateCode":"CT","countryCode":"US"}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1228498","groupName":"ACCUM_MG_01","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1890004","benefitBundleOptionDescription":"","benefitEffectiveDate":"2017-03-15","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000014_ACCUM1","benefitPlanName":"M000000014_Accum1","benefitType":"MD","coverageLevelCode":"E2D","relationshipCode":"01","relationshipDescription":"Spouse","memberIdCardSerialNumber":"81773650801","subscriberIdCardSerialNumber":"81773650800","eligibilityStatusCode":"C","cancelReasonTypeCode":"","planType":"02","indicators":{"qmscoIndicator":"N"}},{"benefitBundleOptionId":"1890004","benefitBundleOptionDescription":"","benefitEffectiveDate":"2017-03-15","benefitExpirationDate":"9999-12-31","benefitPlanId":"RX00000081_ACCUM1","benefitPlanName":"RX00000081_AccUM1","benefitType":"RX","coverageLevelCode":"E2D","relationshipCode":"01","relationshipDescription":"Spouse","memberIdCardSerialNumber":"81773650801","subscriberIdCardSerialNumber":"81773650800","eligibilityStatusCode":"C","cancelReasonTypeCode":"","planType":"02","indicators":{"qmscoIndicator":"N"}}]}]}],"cob":[{"cobTypeCode":"54","cobTypeCodeDescription":"Long Term Care","otherInsurancePrimacyIndicator":"P","coverageType":"4","cobEffectiveStartDate":"2017-03-15","cobEffectiveEndDate":"9999-12-31","otherInsuranceVerifyDate":"2017-05-15","otherInsurancePolicyNumber":"1228498","otherInsuranceCardholderId":"23932505","otherInsuranceCarrierName":"Oxford","cobRelatedEntityContactTelephoneNumber":"353-645-3455"}],"providers":[{"providerIdentifiers":[{"id":"212226509","type":"SY"},{"id":"980788","type":"MPI"},{"id":"44K201","type":"1C"},{"id":"1427160985","type":"NPI"},{"id":"143346191229299883","type":"LTK"}],"assignmentType":"PCP","effectiveDate":"2017-03-15","expirationDate":"9999-12-31","firstName":"LINDA","lastName":"TAO","networkId":"1018476","organizationLocationId":"0"}],"identifiers":[{"id":"161626388","type":"enrolleeEID"},{"id":"23452521","type":"subscriberSystemId"},{"id":"23932505","type":"enrolleeSystemID"},{"id":"894666792","type":"subscriberSurrogateKey"},{"id":"897220275","type":"enrolleeSurrogateKey"}]}]},{"individualIdentifier":"161626389","name":{"firstName":"Jeff","lastName":"Lawson","middleName":"Bobby","nameSuffix":"Jr"},"birthDate":"1978-06-16","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"598317411","privacyIndicator":"R","address":[{"typeCode":"HOM","addressLine1":"108 Pearson Drive","addressLine2":"suite 2","city":"CANTON","postalCode":"06019","stateCode":"CT","countryCode":"US"}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1228498","groupName":"ACCUM_MG_01","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1890004","benefitBundleOptionDescription":"","benefitEffectiveDate":"2017-03-15","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000014_ACCUM1","benefitPlanName":"M000000014_Accum1","benefitType":"MD","coverageLevelCode":"E2D","relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"81773650802","subscriberIdCardSerialNumber":"81773650800","eligibilityStatusCode":"C","cancelReasonTypeCode":"","planType":"02","indicators":{"qmscoIndicator":"N"}},{"benefitBundleOptionId":"1890004","benefitBundleOptionDescription":"","benefitEffectiveDate":"2017-03-15","benefitExpirationDate":"9999-12-31","benefitPlanId":"RX00000081_ACCUM1","benefitPlanName":"RX00000081_AccUM1","benefitType":"RX","coverageLevelCode":"E2D","relationshipCode":"19","relationshipDescription":"Child","memberIdCardSerialNumber":"81773650802","subscriberIdCardSerialNumber":"81773650800","eligibilityStatusCode":"C","cancelReasonTypeCode":"","planType":"02","indicators":{"qmscoIndicator":"N"}}]}]}],"cob":[{"cobTypeCode":"35","cobTypeCodeDescription":"Dental Care","otherInsurancePrimacyIndicator":"S","coverageType":"2","cobEffectiveStartDate":"1995-09-18","cobEffectiveEndDate":"9999-12-31","otherInsuranceVerifyDate":"2017-05-15","otherInsurancePolicyNumber":"1228498","otherInsuranceCardholderId":"23932506","otherInsuranceCarrierName":"Oxford","cobRelatedEntityContactTelephoneNumber":"345-345-2345"},{"cobTypeCode":"1","cobTypeCodeDescription":"Medical Care","otherInsurancePrimacyIndicator":"P","coverageType":"1","cobEffectiveStartDate":"2008-08-01","cobEffectiveEndDate":"9999-12-31","otherInsuranceVerifyDate":"","otherInsurancePolicyNumber":"0","otherInsuranceCardholderId":"12345","otherInsuranceCarrierName":"","cobRelatedEntityContactTelephoneNumber":""}],"providers":[{"providerIdentifiers":[{"id":"212226509","type":"SY"},{"id":"980788","type":"MPI"},{"id":"44K201","type":"1C"},{"id":"1427160985","type":"NPI"},{"id":"143346191229299883","type":"LTK"}],"assignmentType":"PCP","effectiveDate":"2017-03-15","expirationDate":"9999-12-31","firstName":"LINDA","lastName":"TAO","networkId":"1018476","organizationLocationId":"0"}],"identifiers":[{"id":"161626389","type":"enrolleeEID"},{"id":"23452521","type":"subscriberSystemId"},{"id":"23932506","type":"enrolleeSystemID"},{"id":"894666792","type":"subscriberSurrogateKey"},{"id":"897220276","type":"enrolleeSurrogateKey"}]}]' 
           //+'}]}}';
           //response = new HttpResponse();
           //response.setBody(body);
           //response.setStatusCode(200);
            if(response.getStatusCode() == 200){
                if(response.getBody() != null){
                    if(isBravo){
                    //replace date with date2 as date is a preserved keyword
                    String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                    
                    //replace desc with desc2 as desc is a preserved keyword
                    responseBody = responseBody.replace('\"desc\":', '\"desc2\":');
                    system.debug(responseBody);
                    ACETGetFamilyMemberJSONtoApex jSON2Apex = (ACETGetFamilyMemberJSONtoApex)JSON.deserialize(responseBody, ACETGetFamilyMemberJSONtoApex.class);
                    
                    memberDetail.FamilyMembers = new List<ACETMemberDetail.FamilyMember>();
                    for(ACETGetFamilyMemberJSONtoApex.Individuals individual : jSON2Apex.readResult.getMemberFamilyResponseMsgType.memberFamily[0].individuals){
                        ACETMemberDetail.FamilyMember fm = new ACETMemberDetail.FamilyMember();
                        fm.FirstName = individual.name.firstName;
                        fm.LastName = individual.name.lastName;
                        fm.MiddleInitial = individual.name.middleInitialName;
                        fm.Gender = individual.genderCode.code;
                        fm.DOB = formatDate(individual.birthDate.date2);
                        fm.Age = getAgeFromBirthday(individual.birthDate.date2);
                        //fm.Relationship = ACETRelationshipCodes__c.getValues(individual.memberShip.eligibilityRelationshipCode.code).Description__c; //individual.memberShip.eligibilityRelationshipCode.desc2;
                        fm.Relationship = individual.memberShip.eligibilityRelationshipCode.desc2;
                        fm.EID = individual.IndividualId.id; //Added by Swetha//
                        memberDetail.FamilyMembers.add(fm); 
                    }                    
                    
                    system.debug(memberDetail);                                                           
                    calloutResult.Success = true;
                    calloutResult.Message = '';
                    calloutResult.Response = memberDetail;
                    }else{
                    //replace date with date2 as date is a preserved keyword
                    String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                    
                    //replace desc with desc2 as desc is a preserved keyword
                    responseBody = responseBody.replace('\"desc\":', '\"desc2\":');
                    system.debug('responseBody-->'+responseBody);
                    ACETFamilyMembershipJson2Apex jSON2Apex = (ACETFamilyMembershipJson2Apex)JSON.deserialize(responseBody, ACETFamilyMembershipJson2Apex.class);
                    system.debug('jSON2Apex -->'+jSON2Apex);                    
                    memberDetail.FamilyMembers = new List<ACETMemberDetail.FamilyMember>();
                    List<ACETMemberDetail.COB> amdlstCOB = new List<ACETMemberDetail.COB>();  
                    for(ACETFamilyMembershipJson2Apex.cls_individual individual : jSON2Apex.getFamilyMembershipResponse.individual){
                        ACETMemberDetail.FamilyMember fm = new ACETMemberDetail.FamilyMember();
                        fm.FirstName = individual.name.firstName;
                        fm.LastName = individual.name.lastName;
                        fm.MiddleInitial = individual.name.middleName;
                        fm.suffix = individual.name.nameSuffix;
                        fm.FamilyId = individual.membership[0].identifiers[0].id ;//should be mch
                        fm.Gender = individual.genderCode;
                        fm.DOB = formatDate(individual.birthDate);
                        fm.Age = getAgeFromBirthday(individual.birthDate);
                        fm.Relationship = individual.relationshipCode;
                        fm.EID = individual.individualIdentifier; //Added by Swetha//
                        
                        fm.Addresses = new List<ACETMemberDetail.Address>();
                        for(ACETFamilyMembershipJson2Apex.cls_address addr : individual.address){
                            ACETMemberDetail.Address address = new ACETMemberDetail.Address();
                            address.AddressLine1 = addr.addressLine1;    
                            address.AddressLine2 = addr.addressLine2;
                            address.City = addr.city;
                            address.State = addr.statecode;
                            address.Zip = addr.postalCode;   
                            address.AddressType = addr.typeCode; 
                            address.countryCode = addr.countryCode;
                            fm.Addresses.add(address);
                       }
                        //fm.Relationship = ACETRelationshipCodes__c.getValues(individual.memberShip.eligibilityRelationshipCode.code).Description__c; //individual.memberShip.eligibilityRelationshipCode.desc2;
                        memberDetail.FamilyMembers.add(fm); 
                        //Khoushik adding code for Coordination Of Benefits
                          for(ACETFamilyMembershipJson2Apex.cls_membership membership : individual.membership){
                            for(ACETFamilyMembershipJson2Apex.cls_cob cob : membership.cob){
                                
                              Date Startdt = null;
                              Date Enddt = null;
                              Date LastUpdate = null;
                              ACETMemberDetail.COB cb = new ACETMemberDetail.COB();
                              cb.CoverageTypeCode = cob.coverageType;
                              cb.Name = individual.name.firstName + ' ' + individual.name.lastName;
                              cb.DateOfBirth = formatDate(individual.birthDate);
                              if(cb.DateOfBirth != null && cb.DateOfBirth != '' ){
                                Date dob = Date.parse(cb.DateOfBirth);
                                Integer days = dob.daysBetween(Date.Today());
                                        Integer age = Integer.valueOf(days/365);
                            cb.Age = String.valueOf(age);
                              cb.BenefitType = cob.cobTypeCodeDescription;  
                              } 
                              //Insurance type will be equal to coverage type description                              
                              cb.InsuranceType = coverageTypeVsDescMap.get(cob.coverageType);
                              cb.COBTypeDesc = (cob.cobTypeCode == '1' || cob.cobTypeCode == '54' || cob.cobTypeCode == '48' || cob.cobTypeCode == '50' || cob.cobTypeCode == 'A4' || cob.cobTypeCode == 'AG' || cob.cobTypeCode == 'BB') ? 'Medical Care' : ((cob.cobTypeCode == '35' || cob.cobTypeCode == '88' || cob.cobTypeCode == '89' || cob.cobTypeCode == '90') ? 'Pharmacy' : '');
                             // cb.COBTypeDesc = //cob.cobTypeCodeDescription;
                              cb.OrderOfBenefit = primaryIndicatorVsDescMap.get(cob.otherInsurancePrimacyIndicator);
                              cb.IsOtherInsurancePrimary = cob.otherInsurancePrimacyIndicator;
                              system.debug('cobEffectiveStartDate' + cob.cobEffectiveStartDate);
                              system.debug('cobEffectiveEndDate' + cob.cobEffectiveEndDate);
                              if(cob.cobEffectiveStartDate != null){
                                    Startdt = Date.ValueOf(cob.cobEffectiveStartDate);  
                              }
                              if(cob.cobEffectiveEndDate != null){
                                    Enddt = Date.ValueOf(cob.cobEffectiveEndDate);  
                              }
                               
                              cb.Startdt = Startdt;
                              cb.Enddt = Enddt;
                              //LastUpdate
                              for(ACETFamilyMembershipJson2Apex.cls_coverages cov : membership.coverages){
                                for(ACETFamilyMembershipJson2Apex.cls_bundleOptions bun : cov.bundleOptions){
                                    for(ACETFamilyMembershipJson2Apex.cls_benefits benefits : bun.benefits){
                                        if(benefits.coverageLastUpdateDate != null){
                                            LastUpdate = Date.ValueOf(benefits.coverageLastUpdateDate.substring(0,4)+ '-' + benefits.coverageLastUpdateDate.substring(4,6) + '-' + benefits.coverageLastUpdateDate.substring(6,8)); 
                                            system.debug('benefits.coverageLastUpdateDate'+benefits.coverageLastUpdateDate);
                                            system.debug('LastUpdate '+LastUpdate);
                                        }
                                        cb.Relationship = benefits.relationshipDescription;
                                        fm.Relationship =  benefits.relationshipCode;  
                                        fm.subscriberIndividualId = benefits.memberIdCardSerialNumber;
                                        fm.FamilyId = benefits.memberIdCardSerialNumber;
                                        fm.benefitBundleOptionId = benefits.benefitBundleOptionId;
                                                
                                    }  
                                    
                                }    
                                fm.groupNumber =  cov.groupNumber;       
                              }
                              
                              cb.LastUpdate = LastUpdate;
                              cb.MedicareType = cob.coverageType;
                              cb.IsMedicarePrimary = cob.otherInsurancePrimacyIndicator;                              
                              amdlstCOB.add(cb);
                            }
                                                           
                          }                           
                        fm.Relationship = ACETRelationshipCodes__c.getValues(fm.Relationship).Description__c; //individual.memberShip.eligibilityRelationshipCode.desc2; 
                      }
                      system.debug('amdlstCOB'+amdlstCOB);                    
                     memberDetail.lstCOB = amdlstCOB; 
                    system.debug(memberDetail);                                                           
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
                    system.debug(e);
                    calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                    calloutResult.Success = false;
                    calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
           }
        
        return calloutResult;    
    }          
}