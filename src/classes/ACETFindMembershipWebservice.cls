public with sharing class ACETFindMembershipWebservice extends ACETWebService{
    public override void getEndpoint(){
        GetEndpointDetail('SearchMembershipEndpoint');
    }
    
    public void getEndpoint(Boolean isCallableService, Boolean isAdaptorService){
        if(isCallableService){
        	RelativeURL = '/api/bravo/eisl/individuals/membership/v2.0/search';
        }else if(isAdaptorService){
        	RelativeUrl = '/api/alpha/eisl/individuals/membership/v2.0/search';
        }else{
        	GetEndpointDetail('SearchMembershipEndpoint');
        }               
    }  
        
    public void getRequestBody(String memberId){
        RequestBody = '{"findMembershipRequest": {'
                    + '"findMembershipRequestType": {'
                    + '"individualId": { "id": "' + memberId + '"},'
                    + '"customerAccountId": "000737",'
                    + '"coverageTypeCode": ["33"],'
                    + '"timelineIndicator": "2",'
                    + '"effectiveDates": { "startDate": "2011-08-01" }}}}';                
    } 
    public void getRequestBodyCallable(String identifier){
       RequestBody = '{"findMembershipsRequest":{"identifier":"'+identifier+'","identifierType":"SRK","groupNumber":"","coverageType":"","effectiveStartDate":"","effectiveEndDate":"","systemSpecificIndicator":"","pagination":{"pageNumber":1,"pageSize":5,"startRecord":""}}}'; 
    }    
    
    public ACETWSCalloutResult findMembership(String memberId, ACETMemberDetail memberDetail){ 
        //setServiceName('FindMemberShipService');              
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();  
        }     
			Boolean isBravo = String.isBlank(MemberDetail.SurrogateKey) ? true : false;//for memberid 00589997121
   			Boolean isCallable = !String.isBlank(MemberDetail.SurrogateKey) && (MemberDetail.SurrogateKey).startsWith('dummy')? true : false;//for memberid 123456789
            Boolean isAdaptor = !isBravo && !isCallable ? true : false;//for memberid 077920053
        
        String SRKCounter = '1';

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        If(WSConfigurations.get('SRKCounter') != null){  
            SRKCounter = WSConfigurations.get('SRKCounter').Value__c;
        }
        try{
            HttpResponse  response;
         /*   System.debug('memberId---inFM'+memberId);
            if (!String.isBlank(MemberDetail.SurrogateKey)) {
                response = new HttpResponse();
                response.setStatusCode(200);
                response.setStatus('OK');
                String getIndividualSRName = 'FindMembershipResponse_' + SRKCounter;
                String RequestBodyFormat;
                StaticResource RequestJSONSR = [SELECT Body FROM StaticResource WHERE Name =:getIndividualSRName];
                RequestBodyFormat = RequestJSONSR.Body.toString(); 
                system.debug(LoggingLevel.INFO, 'RequestBodyFormat: ' + RequestBodyFormat);
                response.setBody(RequestBodyFormat);
                system.debug(LoggingLevel.INFO, 'getIndividualSRName: ' + getIndividualSRName + ', response:' + response);
            }
            else {
                getEndpoint();
                GetRequestBody(memberId);
                response = Send(OAuthConfig);
            }
           */ 
            getEndpoint(isCallable,isAdaptor);
            if(isCallable || isAdaptor){
            	getRequestBodyCallable(MemberDetail.SurrogateKey);
            }else{
            	getRequestBody(memberId);
            }
            
            response = Send(OAuthConfig);            
            system.debug(LoggingLevel.INFO, 'response.getStatusCode(): ' + response.getStatusCode());
            if(response.getStatusCode() == 200){
                system.debug(LoggingLevel.INFO, 'response.getBody(): ' + response.getBody());
                if(response.getBody() != null){
               	
                    String responseBody;
                    system.debug(LoggingLevel.INFO, 'memberId: ' + memberId);
                    //if(String.isBlank(MemberDetail.SurrogateKey)){
                    if(isBravo){
                        //replace date with date2 as date is a preserved keyword
                        responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                        
                        //replace desc with desc2 as desc is a preserved keyword
                        responseBody = responseBody.replace('\"desc\":', '\"desc_Z\":');
                        system.debug(LoggingLevel.INFO, 'responseBody: ' + responseBody);
                                                                
                        ACETFindMembershipJSON2Apex jSON2Apex = ACETFindMembershipJSON2Apex.parse(responseBody);
                        system.debug('JSON2Apex : ' + jSON2Apex);
                        
                        memberDetail.CoverageLines = new List<ACETMemberDetail.CoverageLine>();                    
                        List<ACETFindMembershipJSON2Apex.Membership> memberships = jSON2Apex.findMembershipResponse.findMembershipResponseType.individual[0].membership;
                        for(ACETFindMembershipJSON2Apex.Membership membership : memberships){
                            
                            for(ACETFindMembershipJSON2Apex.Coverage c : membership.coverage){
                                ACETMemberDetail.CoverageLine cl = new ACETMemberDetail.CoverageLine();
                                cl.CoverageType = c.healthCoverageTypeCode.code;
                                cl.CoverageLevel = c.coverageLevelCode.code;
                                cl.EffectiveDate = formatDate(c.effectiveDateRange.startDate);
                                cl.EndDate = formatDate(c.effectiveDateRange.stopDate); 
                                cl.PolicyNumber = membership.customerAccount.customerAccountId.id;
                                cl.Product = membership.plan.planCode.code;
                                cl.ProductType = membership.plan.planTypeCode.code; 
                                cl.SourceCode = membership.sourceSystemCode.code;
                                if(membership.subscriberSurrogateKey != null){
                                    cl.SurrogateKey = membership.subscriberSurrogateKey.Id; 
                                } 
                                memberDetail.CoverageLines.add(cl);                              
                            }                                                                                                                                          
                        }
                        
                        //test data                    
                        if(memberDetail.CoverageLines.size() > 7){
                            memberDetail.CoverageLines[0].EffectiveDate = '8/8/2012';
                            memberDetail.CoverageLines[0].EndDate = '1/1/8888';
                            memberDetail.CoverageLines[1].EffectiveDate = '1/1/2010';
                            memberDetail.CoverageLines[1].EndDate = '1/1/2015';
                            memberDetail.CoverageLines[2].EffectiveDate = '2/2/2010';
                            memberDetail.CoverageLines[2].EndDate = '10/31/9999';   
                            memberDetail.CoverageLines[3].EffectiveDate = '10/2/1998';
                            memberDetail.CoverageLines[3].EndDate = '12/31/9999';
                            memberDetail.CoverageLines[4].EffectiveDate = '10/2/2014';
                            memberDetail.CoverageLines[4].EndDate = '11/13/2015';  
                            memberDetail.CoverageLines[5].EffectiveDate = '3/17/2013';
                            memberDetail.CoverageLines[5].EndDate = '12/13/7777';  
                            memberDetail.CoverageLines[6].EffectiveDate = '5/16/2013';
                            memberDetail.CoverageLines[6].EndDate = '2/3/2050';                   
                        }
                        
                         if(memberDetail.CoverageLines.size() > 0){
                            memberDetail.PreferredCoverage = memberDetail.CoverageLines[0];     
                         }
                         
                         memberDetail.EffectiveDate = memberDetail.PreferredCoverage.EffectiveDate;
                         memberDetail.EndDate = memberDetail.PreferredCoverage.EndDate;
                         memberDetail.PolicyNumber =  memberDetail.PreferredCoverage.PolicyNumber;
                         //memberDetail.GroupName =  
                         memberDetail.Product =  memberDetail.PreferredCoverage.Product;
                         memberDetail.ProductType =  memberDetail.PreferredCoverage.ProductType;
                         //memberDetail.Network = 
                                            
                        calloutResult.Success = true;
                        calloutResult.Message = '';
                        calloutResult.Response = memberDetail;
                    } else{
                        responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                        
                        //replace desc with desc2 as desc is a preserved keyword
                        responseBody = responseBody.replace('\"desc\":', '\"desc_Z\":');
                        
                        //replace date with date2 as date is a preserved keyword
                        responseBody = responseBody.replace('\"type\":', '\"type_Z\":');
                        responseBody = responseBody.replace('\"id\":', '\"idstr\":');
                        system.debug('responseBody: ' + responseBody);
                                                                
                        ACETFindMembershipAdaptorJSON2Apex jSON2Apex = ACETFindMembershipAdaptorJSON2Apex.parse(responseBody);
                        system.debug('JSON2Apex : ' + jSON2Apex);
                        
                        
                        memberDetail.CoverageLines = new List<ACETMemberDetail.CoverageLine>();                    
                        List<ACETFindMembershipAdaptorJSON2Apex.cls_memberships> memberships = jSON2Apex.findMembershipsResponse.memberships;
                        system.debug('memberships --- : ' + memberships);
                        for(ACETFindMembershipAdaptorJSON2Apex.cls_memberships membership : memberships){
                            system.debug('membership.coverages ---- : ' + membership.coverages);
                            if(membership != null && membership.coverages != null){
	                            for(ACETFindMembershipAdaptorJSON2Apex.cls_coverages c : membership.coverages){
	                                ACETMemberDetail.CoverageLine cl = new ACETMemberDetail.CoverageLine();
	                                
	                                cl.CoverageType = c.coverageTypeDescription;
	                                cl.CoverageLevel = c.coverageLevelCode;
	                                cl.EffectiveDate = formatDate(c.membershipEffectiveDate);
	                                cl.EndDate = formatDate(c.membershipExpirationDate); 
	                                cl.PolicyNumber = c.legacyAttributes.policyNumber;
	                                cl.GroupName = c.GroupName;
	                                cl.GroupNumber = c.groupNumber;
	                                cl.Product = c.product.productName;
	                                cl.ProductType = c.product.productType;
	                                cl.SourceCode = membership.sourceSysCode;
	                                if(!c.subscriberSystemSpecificIdentifiers.isEmpty() ){ 
	                                    for(ACETFindMembershipAdaptorJSON2Apex.cls_subscriberSystemSpecificIdentifiers sssi : c.subscriberSystemSpecificIdentifiers){
	                                    	if(sssi.type_z == 'subscriberSurrogateKey'){
	                                    		cl.SurrogateKey = sssi.idstr; 
	                                    	}
	                                    	
	                                    }
	                                }  
	                                memberDetail.CoverageLines.add(cl); 
	                            	}        
                    			}                                                                                                                                  
                        }
                        system.debug('memberDetail------>'+memberDetail);
                        //test data
                        if(memberDetail.CoverageLines.size() > 7){
                            memberDetail.CoverageLines[0].EffectiveDate = '8/8/2012';
                            memberDetail.CoverageLines[0].EndDate = '1/1/8888';
                            memberDetail.CoverageLines[1].EffectiveDate = '1/1/2010';
                            memberDetail.CoverageLines[1].EndDate = '1/1/2015';
                            memberDetail.CoverageLines[2].EffectiveDate = '2/2/2010';
                            memberDetail.CoverageLines[2].EndDate = '10/31/9999';   
                            memberDetail.CoverageLines[3].EffectiveDate = '10/2/1998';
                            memberDetail.CoverageLines[3].EndDate = '12/31/9999';
                            memberDetail.CoverageLines[4].EffectiveDate = '10/2/2014';
                            memberDetail.CoverageLines[4].EndDate = '11/13/2015';  
                            memberDetail.CoverageLines[5].EffectiveDate = '3/17/2013';
                            memberDetail.CoverageLines[5].EndDate = '12/13/7777';  
                            memberDetail.CoverageLines[6].EffectiveDate = '5/16/2013';
                            memberDetail.CoverageLines[6].EndDate = '2/3/2050';                   
                        }
                        system.debug('check coverage line size '+memberDetail.CoverageLines.size());
                         if(memberDetail.CoverageLines.size() > 0){
                            memberDetail.PreferredCoverage = memberDetail.CoverageLines[0];     
                         }
          					system.debug('memberDetail.PreferredCoverage '+memberDetail.PreferredCoverage);
                         memberDetail.EffectiveDate = memberDetail.PreferredCoverage.EffectiveDate;
                         memberDetail.EndDate = memberDetail.PreferredCoverage.EndDate;
                         memberDetail.PolicyNumber =  memberDetail.PreferredCoverage.PolicyNumber;
                         memberDetail.GroupName =  memberDetail.PreferredCoverage.groupname;
                         memberDetail.Product =  memberDetail.PreferredCoverage.Product;
                         memberDetail.ProductType =  memberDetail.PreferredCoverage.ProductType;
                         //memberDetail.Network = 
                                            
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
    public Continuation StartRequest(String memberId, ACETMemberDetail MemberDetail, String CallbackMethodName, Continuation oContinuation)
    {	
    	if(memberDetail == null){
            memberDetail = new ACETMemberDetail();  
        }     
			Boolean isBravo = String.isBlank(MemberDetail.SurrogateKey) ? true : false;//for memberid 00589997121
   			Boolean isCallable = !String.isBlank(MemberDetail.SurrogateKey) && (MemberDetail.SurrogateKey).startsWith('dummy')? true : false;//for memberid 123456789
            Boolean isAdaptor = !isBravo && !isCallable ? true : false;//for memberid 077920053
        
        String SRKCounter = '1';

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        If(WSConfigurations.get('SRKCounter') != null){  
            SRKCounter = WSConfigurations.get('SRKCounter').Value__c;
        }
         getEndpoint(isCallable,isAdaptor);
            if(isCallable || isAdaptor){
            	getRequestBodyCallable(MemberDetail.SurrogateKey);
            }else{
            	getRequestBody(memberId);
            }
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        return oContinuation;         
    }
    public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel, ACETMemberDetail memberDetail){
    
        //setServiceName('FindMemberShipService');              
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();  
        }     
			Boolean isBravo = String.isBlank(MemberDetail.SurrogateKey) ? true : false;//for memberid 00589997121
   			Boolean isCallable = !String.isBlank(MemberDetail.SurrogateKey) && (MemberDetail.SurrogateKey).startsWith('dummy')? true : false;//for memberid 123456789
            Boolean isAdaptor = !isBravo && !isCallable ? true : false;//for memberid 077920053
        
     

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        
        try{
         
            HttpResponse response = GetHttpResponse(HttpRequestLabel);           
            system.debug(LoggingLevel.INFO, 'response.getStatusCode(): ' + response.getStatusCode());
            if(response.getStatusCode() == 200){
                system.debug(LoggingLevel.INFO, 'response.getBody(): ' + response.getBody());
                if(response.getBody() != null){
               	
                    String responseBody;
                   
                    //if(String.isBlank(MemberDetail.SurrogateKey)){
                    if(isBravo){
                        //replace date with date2 as date is a preserved keyword
                        responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                        
                        //replace desc with desc2 as desc is a preserved keyword
                        responseBody = responseBody.replace('\"desc\":', '\"desc_Z\":');
                        system.debug(LoggingLevel.INFO, 'responseBody: ' + responseBody);
                                                                
                        ACETFindMembershipJSON2Apex jSON2Apex = ACETFindMembershipJSON2Apex.parse(responseBody);
                        system.debug('JSON2Apex : ' + jSON2Apex);
                        
                        memberDetail.CoverageLines = new List<ACETMemberDetail.CoverageLine>();                    
                        List<ACETFindMembershipJSON2Apex.Membership> memberships = jSON2Apex.findMembershipResponse.findMembershipResponseType.individual[0].membership;
                        for(ACETFindMembershipJSON2Apex.Membership membership : memberships){
                            
                            for(ACETFindMembershipJSON2Apex.Coverage c : membership.coverage){
                                ACETMemberDetail.CoverageLine cl = new ACETMemberDetail.CoverageLine();
                                cl.CoverageType = c.healthCoverageTypeCode.code;
                                cl.CoverageLevel = c.coverageLevelCode.code;
                                cl.EffectiveDate = formatDate(c.effectiveDateRange.startDate);
                                cl.EndDate = formatDate(c.effectiveDateRange.stopDate); 
                                cl.PolicyNumber = membership.customerAccount.customerAccountId.id;
                                cl.Product = membership.plan.planCode.code;
                                cl.ProductType = membership.plan.planTypeCode.code; 
                                cl.SourceCode = membership.sourceSystemCode.code;
                                if(membership.subscriberSurrogateKey != null){
                                    cl.SurrogateKey = membership.subscriberSurrogateKey.Id; 
                                } 
                                memberDetail.CoverageLines.add(cl);                              
                            }                                                                                                                                          
                        }
                        
                        //test data                    
                        if(memberDetail.CoverageLines.size() > 7){
                            memberDetail.CoverageLines[0].EffectiveDate = '8/8/2012';
                            memberDetail.CoverageLines[0].EndDate = '1/1/8888';
                            memberDetail.CoverageLines[1].EffectiveDate = '1/1/2010';
                            memberDetail.CoverageLines[1].EndDate = '1/1/2015';
                            memberDetail.CoverageLines[2].EffectiveDate = '2/2/2010';
                            memberDetail.CoverageLines[2].EndDate = '10/31/9999';   
                            memberDetail.CoverageLines[3].EffectiveDate = '10/2/1998';
                            memberDetail.CoverageLines[3].EndDate = '12/31/9999';
                            memberDetail.CoverageLines[4].EffectiveDate = '10/2/2014';
                            memberDetail.CoverageLines[4].EndDate = '11/13/2015';  
                            memberDetail.CoverageLines[5].EffectiveDate = '3/17/2013';
                            memberDetail.CoverageLines[5].EndDate = '12/13/7777';  
                            memberDetail.CoverageLines[6].EffectiveDate = '5/16/2013';
                            memberDetail.CoverageLines[6].EndDate = '2/3/2050';                   
                        }
                        
                         if(memberDetail.CoverageLines.size() > 0){
                            memberDetail.PreferredCoverage = memberDetail.CoverageLines[0];     
                         }
                         
                         memberDetail.EffectiveDate = memberDetail.PreferredCoverage.EffectiveDate;
                         memberDetail.EndDate = memberDetail.PreferredCoverage.EndDate;
                         memberDetail.PolicyNumber =  memberDetail.PreferredCoverage.PolicyNumber;
                         memberDetail.GroupName =  memberDetail.PreferredCoverage.groupname;
                         memberDetail.Product =  memberDetail.PreferredCoverage.Product;
                         memberDetail.ProductType =  memberDetail.PreferredCoverage.ProductType;
                         //memberDetail.Network = 
                                            
                        calloutResult.Success = true;
                        calloutResult.Message = '';
                        calloutResult.Response = memberDetail;
                    } else{
                        responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                        
                        //replace desc with desc2 as desc is a preserved keyword
                        responseBody = responseBody.replace('\"desc\":', '\"desc_Z\":');
                        
                        //replace date with date2 as date is a preserved keyword
                        responseBody = responseBody.replace('\"type\":', '\"type_Z\":');
                        responseBody = responseBody.replace('\"id\":', '\"idstr\":');
                        system.debug('responseBody: ' + responseBody);
                                                                
                        ACETFindMembershipAdaptorJSON2Apex jSON2Apex = ACETFindMembershipAdaptorJSON2Apex.parse(responseBody);
                        system.debug('JSON2Apex : ' + jSON2Apex);
                        
                        
                        memberDetail.CoverageLines = new List<ACETMemberDetail.CoverageLine>();                    
                        List<ACETFindMembershipAdaptorJSON2Apex.cls_memberships> memberships = jSON2Apex.findMembershipsResponse.memberships;
                        system.debug('memberships --- : ' + memberships);
                        for(ACETFindMembershipAdaptorJSON2Apex.cls_memberships membership : memberships){
                            system.debug('membership.coverages ---- : ' + membership.coverages);
                            if(membership != null && membership.coverages != null){
	                            for(ACETFindMembershipAdaptorJSON2Apex.cls_coverages c : membership.coverages){
	                                ACETMemberDetail.CoverageLine cl = new ACETMemberDetail.CoverageLine();
	                                
	                                cl.CoverageType = c.coverageTypeDescription;
	                                cl.CoverageLevel = c.coverageLevelCode;
	                                cl.EffectiveDate = formatDate(c.membershipEffectiveDate);
	                                cl.EndDate = formatDate(c.membershipExpirationDate); 
	                                cl.PolicyNumber = c.legacyAttributes.policyNumber;
	                                cl.GroupName = c.GroupName;
	                                cl.GroupNumber = c.groupNumber;
	                                cl.Product = c.product.productName;
	                                cl.ProductType = c.product.productType;
	                             
	                               cl.SourceCode = membership.sourceSysCode;
	                              
	                                if(c.subscriberSystemSpecificIdentifiers != null){
	                                
	                                if(!c.subscriberSystemSpecificIdentifiers.isEmpty() ){ 
	                                    for(ACETFindMembershipAdaptorJSON2Apex.cls_subscriberSystemSpecificIdentifiers sssi : c.subscriberSystemSpecificIdentifiers){
	                                    	if(sssi.type_z == 'subscriberSurrogateKey'){
	                                    		cl.SurrogateKey = sssi.idstr; 
	                                    	}
	                                    	
	                                    }
	                                }
	                                }  
	                                memberDetail.CoverageLines.add(cl); 
	                            	}        
                    			}                                                                                                                                  
                        }
                        system.debug('memberDetail------>'+memberDetail);
                        //test data
                        if(memberDetail.CoverageLines.size() > 7){
                            memberDetail.CoverageLines[0].EffectiveDate = '8/8/2012';
                            memberDetail.CoverageLines[0].EndDate = '1/1/8888';
                            memberDetail.CoverageLines[1].EffectiveDate = '1/1/2010';
                            memberDetail.CoverageLines[1].EndDate = '1/1/2015';
                            memberDetail.CoverageLines[2].EffectiveDate = '2/2/2010';
                            memberDetail.CoverageLines[2].EndDate = '10/31/9999';   
                            memberDetail.CoverageLines[3].EffectiveDate = '10/2/1998';
                            memberDetail.CoverageLines[3].EndDate = '12/31/9999';
                            memberDetail.CoverageLines[4].EffectiveDate = '10/2/2014';
                            memberDetail.CoverageLines[4].EndDate = '11/13/2015';  
                            memberDetail.CoverageLines[5].EffectiveDate = '3/17/2013';
                            memberDetail.CoverageLines[5].EndDate = '12/13/7777';  
                            memberDetail.CoverageLines[6].EffectiveDate = '5/16/2013';
                            memberDetail.CoverageLines[6].EndDate = '2/3/2050';                   
                        }
                        system.debug('check coverage line size '+memberDetail.CoverageLines.size());
                         if(memberDetail.CoverageLines.size() > 0){
                            memberDetail.PreferredCoverage = memberDetail.CoverageLines[0];     
                         }
          					system.debug('memberDetail.PreferredCoverage '+memberDetail.PreferredCoverage);
                         memberDetail.EffectiveDate = memberDetail.PreferredCoverage.EffectiveDate;
                         memberDetail.EndDate = memberDetail.PreferredCoverage.EndDate;
                         memberDetail.PolicyNumber =  memberDetail.PreferredCoverage.PolicyNumber;
                         memberDetail.GroupName =  memberDetail.PreferredCoverage.groupname;
                         memberDetail.Product =  memberDetail.PreferredCoverage.Product;
                         memberDetail.ProductType =  memberDetail.PreferredCoverage.ProductType;
                         //memberDetail.Network = 
                                            
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
                system.debug(e.getstacktracestring());
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;
                calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
           }
        
        return calloutResult;    
    }     
}