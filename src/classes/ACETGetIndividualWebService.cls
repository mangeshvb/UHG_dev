public class ACETGetIndividualWebService extends ACETWebService{
    public override void getEndpoint(){
        GetEndpointDetail('GetMemberEndpoint');
        
    }
    public void getEndpoint(Boolean isCallableService,Boolean isAdaptorService){
        if(isCallableService){
            RelativeURL = '/api/bravo/eisl/individuals/individualmembership/v2.0/read';
        }else if(isAdaptorService){
            RelativeURL =  '/api/alpha/eisl/individuals/v2.0/read';
        }else{
            GetEndpointDetail('GetMemberEndpoint');
        }
               
    }    
    public void getRequestBody(String memberId){
        RequestBody = '{"getIndividual": {'
                    + '"getIndividualRequestMsgType": {'
                    + '"individualId": {'
                    + '"id": ' + '"' + memberId + '"'
                    + '}}}}'; 
                    system.debug('2323 RequestBody' + RequestBody + memberId);                
    }
    public void getRequestBodyCallable(){
       RequestBody = '{"getIndividualMembershipRequest" : {"identifier": "123","identifierType": "SRK"}}'; 
    }      
    public void getRequestBodyAdaptor(String identifier){
       RequestBody = '{"getIndividualRequest" : {"identifier": "'+identifier+'","identifierType": "SRK"}}'; 
    }    
    
    
    public ACETWSCalloutResult getIndividual(String memberId, ACETMemberDetail memberDetail){
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();
        }
        
           Boolean isBravo = String.isBlank(MemberDetail.SurrogateKey) ? true : false;//for memberid 00589997121
           Boolean isCallable = !String.isBlank(MemberDetail.SurrogateKey) && (MemberDetail.SurrogateKey).startsWith('dummy')? true : false;//for memberid 123456789
           Boolean isAdaptor = !isBravo && !isCallable ? true : false;//for memberid 077920053
           //Boolean isSRK = (TempMemberId.startsWith('SRK')) ? true : false;  
                   
        String SRKCounter = '1';
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        If(WSConfigurations.get('SRKCounter') != null){  
            SRKCounter = WSConfigurations.get('SRKCounter').Value__c;
        }
        system.debug(LoggingLevel.INFO, 'memberId: ' + memberId + ', memberDetail:' + memberDetail + 'SRKCounter ::' +SRKCounter );
        try {
            HttpResponse  response;
            getEndpoint(isCallable,isAdaptor);
            if(isCallable){
                getRequestBodyCallable();
            }else if(isAdaptor){
                getRequestBodyAdaptor(memberId);
            }else{
                getRequestBody(memberId);
            }
            
            response = Send(OAuthConfig); 
            
            if(response.getStatusCode() == 200){
                if(response.getBody() != null){
                    //Hardcoded just to check the flow of code
                    system.debug('MemberDetail.SurrogateKey: ' + MemberDetail.SurrogateKey);
                    if(isBravo){
                        //replace date with date2 as date is a preserved keyword
                        System.debug('responseBody---'+response.getBody());
                        String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                        //replace desc with desc2 as desc is a preserved keyword
                        responseBody = responseBody.replace('\"desc\":', '\"desc2\":');
                        system.debug(responseBody);
                        
                        ACETGetIndividualJSON2Apex jSON2Apex = (ACETGetIndividualJSON2Apex)JSON.deserialize(responseBody, ACETGetIndividualJSON2Apex.class);
                        system.debug('JSON2Apex : ' + jSON2Apex);
                        
                        ACETGetIndividualJSON2Apex.Individual individual = json2Apex.getIndividualResult.getIndividualResponseMsgType.individual;
                        memberDetail.MemberId = individual.individualId[0].id;
                        memberDetail.FirstName = individual.name.firstName;
                        memberDetail.LastName = individual.name.lastName;
                        System.debug('!!!!!!!!!!Lastname'+ individual.name.lastName + '!!!!!!!!!!' +memberDetail.LastName);
                        memberDetail.DOB = formatDate(individual.birthDate.date2);
                        memberDetail.MiddleInitial = individual.name.middleInitialName;
                        memberDetail.Gender = individual.genderCode.code;
                        memberDetail.Age = getAgeFromBirthday(individual.birthDate.date2);  
                        memberDetail.SSN = getMaskedSSN(individual.socialSecurityNumberId.id);
                        memberDetail.FullSSN = getSSNHyphen(individual.socialSecurityNumberId.id); 
                        //NEED TO WORK ON IT : BHANU
                        memberDetail.SpokenLanguage = individual.Language[0].languageCode;
                        //memberDetail.RelationShip = individual.relationship[0].relationshipCode.code;
                        memberDetail.Email = individual.electronicContact[0].electronicAddressId.id;
                        memberDetail.DeceasedDate = formatDate(individual.deceasedDate.date2);
                        //memberDetail.AsianInitiativeIndicator =  
                        //memberDetail.MigrationDate = 
                        //memberDetail.OriginalEffectiveDate =
                        
                       MemberDetail.Addresses = new List<ACETMemberDetail.Address>();
                       for(ACETGetIndividualJSON2Apex.Address addr : individual.address){
                            ACETMemberDetail.Address address = new ACETMemberDetail.Address();
                            address.AddressLine1 = addr.postalAddress.line1;    
                            address.AddressLine2 = addr.postalAddress.line2;
                            address.City = addr.postalAddress.city;
                            address.State = addr.postalAddress.state.code;
                            address.Zip = addr.postalAddress.postalCode[0].part1;   
                            address.AddressType = addr.postalAddress.code.code; 
                            MemberDetail.Addresses.add(address);
                       }
                       
                       MemberDetail.Phones = new List<ACETMemberDetail.Phone>();
                       for(ACETGetIndividualJSON2Apex.Telephone telephone : individual.telephone){
                            ACETMemberDetail.Phone phone = new ACETMemberDetail.Phone();
                            phone.PhoneNumber = telephone.telephoneNumber;
                            phone.PhoneNumberType = telephone.primary.code;
                            MemberDetail.Phones.add(phone);
                       }
                       //added by Khoushik on 09/28/2016 for User Story - US378010
                       memberDetail.MiddleName = individual.name.middleName;
                     
                        Date DateOfEmployment= null;
                         if(individual.employment[0].status[0].employmentDateRange.startDate != null)
                         {
                            if(individual.employment[0].status[0].employmentDateRange.startDate != '')
                            {
                                DateOfEmployment= Date.valueOf(individual.employment[0].status[0].employmentDateRange.startDate);
                            }
                         } 
                         memberDetail.DateOfEmployment= DateOfEmployment; 
                         memberDetail.EmploymentStatus= individual.employment[0].status[0].typeCode.code; 
                         
                         //Added by Khoushik for Surrogate Id's related User Stories
                         if (individual.otherIdentifiers != null && individual.otherIdentifiers.size() > 0) {                       
                                for (ACETGetIndividualJSON2Apex.OtherIdentifiers otherIdentifiers: individual.otherIdentifiers) {
                                    if (otherIdentifiers.code == 'SRK') {
                                        memberDetail.SurrogateKeys.add(otherIdentifiers.id);
                                        memberDetail.SurrogateKey = otherIdentifiers.id;    
                                    }
                                }
                          }         
                        calloutResult.Success = true;
                        calloutResult.Message = '';
                        System.debug('!!!!!!!!!!!!!!!!!!!!'+memberDetail );
                        calloutResult.Response = memberDetail;
                    }else if(isAdaptor){
                        String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                        responseBody = responseBody.replace('\"desc\":', '\"desc2\":');
                        
                        ACETGetIndividualJSON2APexADP jSON2Apex = (ACETGetIndividualJSON2APexADP)JSON.deserialize(responseBody, ACETGetIndividualJSON2APexADP.class);
                        system.debug('JSON2Apex : ' + jSON2Apex);
                        
                        ACETGetIndividualJSON2APexADP.cls_individual individual = json2Apex.getIndividualResponse.individual;                       
                        //This is incorrect
                       memberDetail.MemberId = individual.individualIdentifier;
                       memberDetail.FirstName = individual.name.firstName;
                       memberDetail.LastName = individual.name.lastName;
                       memberDetail.MiddleName = individual.name.middleName;
                       memberDetail.Suffix = individual.name.nameSuffix;

                       memberDetail.DOB = formatDate(individual.birthDate);
                       memberDetail.MiddleInitial = individual.name.middleName;
                       memberDetail.Gender = individual.genderCode;
                       memberDetail.Age = getAgeFromBirthday(individual.birthDate);  
                       memberDetail.SSN = getMaskedSSN(individual.socialSecurityNumber);
                       memberDetail.FullSSN = getSSNHyphen(individual.socialSecurityNumber);
                       memberDetail.EmploymentStatus = individual.employment[0].employmentStatus;
                       memberDetail.EmploymentStartDate = individual.employment[0].employmentStartDate;
                      // memberDetail.SpokenLanguage = individual.language[0].code;
                       //memberDetail.RelationShip = individual.relationship[0].relationshipCode.code;
                      
                        for(ACETGetIndividualJSON2APexADP.cls_email emailObj : individual.email){
                            if(emailObj.primaryIndicator == 'Y'){
                                memberDetail.email = emailObj.electronicAddress;
                            }
                        }                       
                       memberDetail.DeceasedDate = formatDate(individual.deceasedDate);
                       //memberDetail.AsianInitiativeIndicator =  
                       //memberDetail.MigrationDate = 
                       //memberDetail.OriginalEffectiveDate =
                        MemberDetail.Addresses = new List<ACETMemberDetail.Address>();
                        for(ACETGetIndividualJSON2APexADP.cls_address addr : individual.address){
                            ACETMemberDetail.Address address = new ACETMemberDetail.Address();
                            address.AddressLine1 = addr.AddressLine1;    
                            address.AddressLine2 = addr.AddressLine2;
                            address.City = addr.City;
                            address.State = addr.stateCode;
                            address.Zip = addr.postalCode;   
                            if (addr.typeCode == 'HOM')
                            address.AddressType = 'Home'; 
                            else if (addr.typeCode == 'WRK')
                            address.AddressType = 'Work'; 
                            else if (addr.typeCode == 'BILL')
                            address.AddressType = 'Billing';
                            else if (addr.typeCode == 'MAIL')
                            address.AddressType = 'Mailing';  
                            MemberDetail.Addresses.add(address);
                        }
                        MemberDetail.Phones = new List<ACETMemberDetail.Phone>();
                        for(ACETGetIndividualJSON2APexADP.cls_phone telephone : individual.phone){
                            ACETMemberDetail.Phone phone = new ACETMemberDetail.Phone();
                            phone.PhoneNumber = telephone.phoneNumber;
                            if(telephone.phoneType == 'H')
                                phone.PhoneNumberType = 'Home';
                            if(telephone.phoneType == 'F')
                                phone.PhoneNumberType = 'Fax';
                            if(telephone.phoneType == 'W')
                                phone.PhoneNumberType = 'Work';
                            if(telephone.phoneType == 'M')
                                phone.PhoneNumberType = 'Mobile';
                            if(telephone.primaryIndicator == 'Y')
                                phone.primaryIndicator = 'Primary';
                            else
                                phone.primaryIndicator = '';
                            MemberDetail.Phones.add(phone);
                        }
                        MemberDetail.ROIcontacts = new List<ACETMemberDetail.otherContact>();
                        system.debug('MemberDetail.ROIcontacts----1--->'+ MemberDetail.ROIcontacts + '---->'+individual.otherContact);
                        for(ACETGetIndividualJSON2APexADP.cls_otherContact otherCon : individual.otherContact){
                            ACETMemberDetail.otherContact ROIrec = new ACETMemberDetail.otherContact();
                            ROIrec.firstName = otherCon.name.firstName;
                            ROIrec.middleName = otherCon.name.MiddleName;
                            ROIrec.lastName = otherCon.name.Lastname;
                            //ROIrec.effectiveDate = formatDate('');
                            //ROIrec.terminationDate = formatDate('');
                            ROIrec.docLink = '';
                            MemberDetail.ROIcontacts.add(ROIrec);
                        }
                        system.debug('MemberDetail.ROIcontacts----2--->'+ MemberDetail.ROIcontacts);
                        
                        
                    if (individual.Identifiers != null && individual.Identifiers.size() > 0) {                       
                                for (ACETGetIndividualJSON2APexADP.cls_identifiers Identifier: individual.Identifiers) {
                                    if (Identifier.type  == 'SRK') {
                                        memberDetail.SurrogateKeys.add(String.ValueOf(Identifier.id));
                                        memberDetail.SurrogateKey = String.ValueOf(Identifier.id);    
                                    }
                                }
                          }         
                        calloutResult.Success = true;
                        calloutResult.Message = '';
                        System.debug('!!!!!!!!!!!!!!!!!!!!'+memberDetail );
                        calloutResult.Response = memberDetail;                                                
                    
                    }else {
                        //replace date with date2 as date is a preserved keyword
                        System.debug('responseBody---'+response.getBody());
                        String responseBody = response.getBody().replace('\"type\":', '\"type_Z\":');
                        responseBody = responseBody.replace('\"date\":', '\"date2\":');
                        responseBody = responseBody.replace('\"desc\":', '\"desc2\":');
                        system.debug('getIndividual SRK Response: ' + responseBody);
                        
                        ACETIndiMembershipJSON2APex jSON2Apex = (ACETIndiMembershipJSON2APex)JSON.deserialize(responseBody, ACETIndiMembershipJSON2APex.class);
                        system.debug('JSON2Apex2 : ' + jSON2Apex);                        
                        
                        ACETIndiMembershipJSON2APex.cls_individual individual = jSON2Apex.getIndividualMembershipResponse.individual;
                       
                        memberDetail.MemberId = String.valueOf(individual.individualIdentifier);
                        memberDetail.FirstName = individual.name.firstName;
                        memberDetail.LastName = individual.name.lastName;
                        System.debug('!!!!!!!!!!Lastname'+ individual.name.lastName + '!!!!!!!!!!' +memberDetail.LastName);
                        memberDetail.DOB = formatDate(individual.birthDate);
                        memberDetail.MiddleInitial = individual.name.middleName;
                        memberDetail.Gender = individual.genderCode;
                        memberDetail.Age = getAgeFromBirthday(individual.birthDate);  
                        memberDetail.SSN = getMaskedSSN(individual.socialSecurityNumber);
                        for(ACETIndiMembershipJSON2APex.cls_email emailObj : individual.email){
                            if(emailObj.primaryIndicator == 'Y'){
                                memberDetail.email = emailObj.electronicAddress;
                            }
                        }                        
                        //memberDetail.FullSSN = getSSNHyphen(individual.socialSecurityNumberId.id); 
                        //memberDetail.SpokenLanguage = individual.language[0].code;
                        //memberDetail.RelationShip = individual.relationship[0].relationshipCode.code;
                        //memberDetail.Email = individual.electronicContact[0].electronicAddressId.id;
                        memberDetail.DeceasedDate = formatDate(individual.deceasedDate);
                        //memberDetail.AsianInitiativeIndicator =  
                        //memberDetail.MigrationDate = 
                        //memberDetail.OriginalEffectiveDate =
                         
                       MemberDetail.Addresses = new List<ACETMemberDetail.Address>();
                       for(ACETIndiMembershipJSON2APex.cls_address addr : individual.address){
                            ACETMemberDetail.Address address = new ACETMemberDetail.Address();
                            address.AddressLine1 = addr.addressLine1;
                            address.AddressLine2 = addr.addressLine2;
                            address.City = addr.city;
                            address.State = addr.stateCode;
                            address.Zip = addr.postalCode;                              
                            address.AddressType = addr.typeCode; 
                            MemberDetail.Addresses.add(address);
                       }
                       
                       MemberDetail.Phones = new List<ACETMemberDetail.Phone>();
                       for(ACETIndiMembershipJSON2APex.cls_phone telephone : individual.phone){
                            ACETMemberDetail.Phone phone = new ACETMemberDetail.Phone();
                            phone.PhoneNumber = telephone.phoneNumber;
                            phone.PhoneNumberType = telephone.phoneType;
                            MemberDetail.Phones.add(phone);
                       }
                       /*
                       //added by Khoushik on 09/28/2016 for User Story - US378010
                       memberDetail.MiddleName = individual.name.middleName;
                     
                        Date DateOfEmployment= null;
                         if(individual.employment[0].status[0].employmentDateRange.startDate != null)
                         {
                            if(individual.employment[0].status[0].employmentDateRange.startDate != '')
                            {
                                DateOfEmployment= Date.valueOf(individual.employment[0].status[0].employmentDateRange.startDate);
                            }
                         } 
                         memberDetail.DateOfEmployment= DateOfEmployment; 
                         memberDetail.EmploymentStatus= individual.employment[0].status[0].typeCode.code;  
                         */
                         //Added by Khoushik for Surrogate Id's related User Stories
                         if (individual.Identifiers != null && individual.Identifiers.size() > 0) {                       
                                for (ACETIndiMembershipJSON2APex.cls_identifiers Identifiers: individual.Identifiers) {
                                    if (Identifiers.type_Z  == 'SRK') {
                                        memberDetail.SurrogateKeys.add(String.ValueOf(Identifiers.id));
                                        memberDetail.SurrogateKey = String.ValueOf(Identifiers.id);    
                                    }
                                }
                          }         
                        calloutResult.Success = true;
                        calloutResult.Message = '';
                        System.debug('!!!!!!!!!!!!!!!!!!!!'+memberDetail );
                        calloutResult.Response = memberDetail;
                    
                    }
                }
                system.debug('memberDetail.SurrogateKeys ::' + memberDetail.SurrogateKeys);
            }else if(response.getStatusCode() == 500){                
                //currently servce returns 500 if no records found
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.Success = true;                
                calloutResult.Response = new ACETMemberDetail();
                system.debug(calloutResult);                
            }
            }catch(Exception e){
                    system.debug(e.getStackTraceString());
                    system.debug(e.getMessage());
                    calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                    calloutResult.Success = false;
                    calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
           }
        
        return calloutResult;    
    } 
 /* public Continuation StartRequest(String memberId, ACETMemberDetail memberDetail, String CallbackMethodName, Continuation oContinuation){
            if(memberDetail == null){
                memberDetail = new ACETMemberDetail();
            }
        
           Boolean isBravo = String.isBlank(MemberDetail.SurrogateKey) ? true : false;//for memberid 00589997121
           Boolean isCallable = !String.isBlank(MemberDetail.SurrogateKey) && (MemberDetail.SurrogateKey).startsWith('dummy')? true : false;//for memberid 123456789
           Boolean isAdaptor = !isBravo && !isCallable ? true : false;//for memberid 077920053
            getEndpoint(isCallable,isAdaptor);
            if(isCallable){
                getRequestBodyCallable();
            }else if(isAdaptor){
                getRequestBodyAdaptor(memberId);
            }else{
                getRequestBody(memberId);
            }
            oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
            return oContinuation;         
    }*/

    
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
    
    public String getSSNHyphen(String ssn){
        if(String.isEmpty(ssn) || ssn.length() < 9) return '';
               
        return ssn.substring(0,3) + '-' + ssn.substring(3,5) + '-' + ssn.substring(5,9);
    }
    public Continuation StartRequest(String memberId, ACETMemberDetail MemberDetail, String CallbackMethodName, Continuation oContinuation)
    {   
        if(MemberDetail == null){
            MemberDetail = new ACETMemberDetail();
        }
        Boolean isBravo = String.isBlank(MemberDetail.SurrogateKey) ? true : false;//for memberid 00589997121
        Boolean isCallable = !String.isBlank(MemberDetail.SurrogateKey) && (MemberDetail.SurrogateKey).startsWith('dummy')? true : false;//for memberid 123456789
        Boolean isAdaptor = !isBravo && !isCallable ? true : false;//for memberid 077920053
        //Boolean isSRK = (TempMemberId.startsWith('SRK')) ? true : false;
        String SRKCounter = '1';
        
        If(WSConfigurations.get('SRKCounter') != null){  
            SRKCounter = WSConfigurations.get('SRKCounter').Value__c;
        }
        
        getEndpoint(isCallable,isAdaptor); 
        system.debug('isCallable,isAdaptor' + isCallable + isAdaptor);
        if(isCallable){
                getRequestBodyCallable();
        }else if(isAdaptor){
                getRequestBodyAdaptor(memberId);
        }else{
                getRequestBody(memberId);
        }
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        return oContinuation;         
    }
     public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel, ACETMemberDetail memberDetail){
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();
        }
        system.debug('calling process response in service');
           Boolean isBravo = String.isBlank(MemberDetail.SurrogateKey) ? true : false;//for memberid 00589997121
           Boolean isCallable = !String.isBlank(MemberDetail.SurrogateKey) && (MemberDetail.SurrogateKey).startsWith('dummy')? true : false;//for memberid 123456789
           Boolean isAdaptor = !isBravo && !isCallable ? true : false;//for memberid 077920053
           //Boolean isSRK = (TempMemberId.startsWith('SRK')) ? true : false;  
         system.debug('isCallable,isAdaptor' + isCallable + isAdaptor);
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
       
       
        try {
           
            HttpResponse response = GetHttpResponse(HttpRequestLabel);
            system.debug('response >> '+response);
            if(response.getStatusCode() == 200){
                if(response.getBody() != null){
                    //Hardcoded just to check the flow of code
                    system.debug('MemberDetail.SurrogateKey: ' + MemberDetail.SurrogateKey);
                    if(isBravo){
                        //replace date with date2 as date is a preserved keyword
                        System.debug('responseBody---'+response.getBody());
                        String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                        //replace desc with desc2 as desc is a preserved keyword
                        responseBody = responseBody.replace('\"desc\":', '\"desc2\":');
                        system.debug(responseBody);
                        
                        ACETGetIndividualJSON2Apex jSON2Apex = (ACETGetIndividualJSON2Apex)JSON.deserialize(responseBody, ACETGetIndividualJSON2Apex.class);
                        system.debug('JSON2Apex : ' + jSON2Apex);
                        
                        ACETGetIndividualJSON2Apex.Individual individual = json2Apex.getIndividualResult.getIndividualResponseMsgType.individual;
                        memberDetail.MemberId = individual.individualId[0].id;
                        memberDetail.FirstName = individual.name.firstName;
                        memberDetail.LastName = individual.name.lastName;
                        System.debug('!!!!!!!!!!Lastname'+ individual.name.lastName + '!!!!!!!!!!' +memberDetail.LastName);
                        memberDetail.DOB = formatDate(individual.birthDate.date2);
                        memberDetail.MiddleInitial = individual.name.middleInitialName;
                        memberDetail.Gender = individual.genderCode.code;
                        memberDetail.Age = getAgeFromBirthday(individual.birthDate.date2);  
                        memberDetail.SSN = getMaskedSSN(individual.socialSecurityNumberId.id);
                        memberDetail.FullSSN = getSSNHyphen(individual.socialSecurityNumberId.id); 
                        //memberDetail.SpokenLanguage = individual.language[0].code;
                        memberDetail.SpokenLanguage = ACETLanguage__c.getValues(individual.language[0].languageCode).Description__c;
                      // memberDetail.SpokenLanguage = individual.language[0].spokenIndicator.code;
                        //memberDetail.RelationShip = individual.relationship[0].relationshipCode.code;
                        memberDetail.Email = individual.electronicContact[0].electronicAddressId.id;
                        memberDetail.DeceasedDate = formatDate(individual.deceasedDate.date2);
                        //memberDetail.AsianInitiativeIndicator =  
                        //memberDetail.MigrationDate = 
                        //memberDetail.OriginalEffectiveDate =
                        
                       MemberDetail.Addresses = new List<ACETMemberDetail.Address>();
                       for(ACETGetIndividualJSON2Apex.Address addr : individual.address){
                            ACETMemberDetail.Address address = new ACETMemberDetail.Address();
                            address.AddressLine1 = addr.postalAddress.line1;    
                            address.AddressLine2 = addr.postalAddress.line2;
                            address.City = addr.postalAddress.city;
                            address.State = addr.postalAddress.state.code;
                            address.Zip = addr.postalAddress.postalCode[0].part1;   
                            address.AddressType = addr.postalAddress.code.code; 
                            MemberDetail.Addresses.add(address);
                       }
                       
                       MemberDetail.Phones = new List<ACETMemberDetail.Phone>();
                       for(ACETGetIndividualJSON2Apex.Telephone telephone : individual.telephone){
                            ACETMemberDetail.Phone phone = new ACETMemberDetail.Phone();
                            phone.PhoneNumber = telephone.telephoneNumber;
                            phone.PhoneNumberType = telephone.primary.code;
                            MemberDetail.Phones.add(phone);
                       }
                       //added by Khoushik on 09/28/2016 for User Story - US378010
                       memberDetail.MiddleName = individual.name.middleName;
                     
                        Date DateOfEmployment= null;
                         if(individual.employment[0].status[0].employmentDateRange.startDate != null)
                         {
                            if(individual.employment[0].status[0].employmentDateRange.startDate != '')
                            {
                                DateOfEmployment= Date.valueOf(individual.employment[0].status[0].employmentDateRange.startDate);
                            }
                         } 
                         memberDetail.DateOfEmployment= DateOfEmployment; 
                         memberDetail.EmploymentStatus= individual.employment[0].status[0].typeCode.code; 
                         
                         //Added by Khoushik for Surrogate Id's related User Stories
                         if (individual.otherIdentifiers != null && individual.otherIdentifiers.size() > 0) {                       
                                for (ACETGetIndividualJSON2Apex.OtherIdentifiers otherIdentifiers: individual.otherIdentifiers) {
                                    if (otherIdentifiers.code == 'SRK') {
                                        memberDetail.SurrogateKeys.add(otherIdentifiers.id);
                                        memberDetail.SurrogateKey = otherIdentifiers.id;    
                                    }
                                }
                          }         
                        calloutResult.Success = true;
                        calloutResult.Message = '';
                        System.debug('!!!!!!!!!!!!!!!!!!!!'+memberDetail );
                        calloutResult.Response = memberDetail;
                    }else if(isAdaptor){
                        String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                        responseBody = responseBody.replace('\"desc\":', '\"desc2\":');
                        system.debug('responseBody >>> '+response);
                        ACETGetIndividualJSON2APexADP jSON2Apex = (ACETGetIndividualJSON2APexADP)JSON.deserialize(responseBody, ACETGetIndividualJSON2APexADP.class);
                        system.debug('JSON2Apex : ' + jSON2Apex);
                        
                        ACETGetIndividualJSON2APexADP.cls_individual individual = json2Apex.getIndividualResponse.individual;                       
                       
                       system.debug('------individual.identifiers------->'+individual.identifiers);
                       for(ACETGetIndividualJSON2APexADP.cls_identifiers indv : individual.identifiers){
                           system.debug('------indv------->'+indv);
                           if(indv.type == 'MCH')
                               memberDetail.MemberId = indv.id;
                       }                           
                       
                       memberDetail.FirstName = individual.name.firstName;
                       memberDetail.LastName = individual.name.lastName;
                       memberDetail.MiddleName = individual.name.middleName;
                       memberDetail.Suffix = individual.name.nameSuffix;

                       memberDetail.DOB = formatDate(individual.birthDate);
                       memberDetail.MiddleInitial = individual.name.middleName;
                       memberDetail.Gender = individual.genderCode;
                       memberDetail.Age = getAgeFromBirthday(individual.birthDate);  
                       memberDetail.SSN = getMaskedSSN(individual.socialSecurityNumber);
                       memberDetail.FullSSN = getSSNHyphen(individual.socialSecurityNumber);
                       memberDetail.EmploymentStatus = individual.employment[0].employmentStatus;
                       memberDetail.EmploymentStartDate = individual.employment[0].employmentStartDate;
                      // memberDetail.SpokenLanguage = individual.language[0].code;
                      for(ACETGetIndividualJSON2APexADP.cls_Language lan : individual.language){
                      		if(lan !=null){
                      			if(lan.languageUsedTypeCode == '7'){
                      				memberDetail.SpokenLanguage = ACETLanguage__c.getValues(lan.languageCode).Description__c;	
                      			}
                      			if(lan.languageUsedTypeCode == '5' && memberDetail.SpokenLanguage =='' || memberDetail.SpokenLanguage == null){
                      				memberDetail.SpokenLanguage = ACETLanguage__c.getValues(lan.languageCode).Description__c;	
                      			}
                      			if(lan.languageUsedTypeCode == '6' && (memberDetail.SpokenLanguage =='' || memberDetail.SpokenLanguage == null)){
                      				memberDetail.SpokenLanguage = ACETLanguage__c.getValues(lan.languageCode).Description__c;	
                      			}                      			
                      			
                      		}	
                      }
                      
                       //memberDetail.RelationShip = individual.relationship[0].relationshipCode.code;
                      
                        for(ACETGetIndividualJSON2APexADP.cls_email emailObj : individual.email){
                            if(emailObj.primaryIndicator == 'Y'){
                                memberDetail.email = emailObj.electronicAddress;
                            }
                        }                       
                       memberDetail.DeceasedDate = formatDate(individual.deceasedDate);
                       //memberDetail.AsianInitiativeIndicator =  
                       //memberDetail.MigrationDate = 
                       //memberDetail.OriginalEffectiveDate =
                        MemberDetail.Addresses = new List<ACETMemberDetail.Address>();
                        for(ACETGetIndividualJSON2APexADP.cls_address addr : individual.address){
                            ACETMemberDetail.Address address = new ACETMemberDetail.Address();
                            address.AddressLine1 = addr.AddressLine1;    
                            address.AddressLine2 = addr.AddressLine2;
                            address.City = addr.City;
                            address.State = addr.stateCode;
                            address.Zip = addr.postalCode;   
                            if (addr.typeCode == 'HOM')
                            address.AddressType = 'Home'; 
                            else if (addr.typeCode == 'WRK')
                            address.AddressType = 'Work'; 
                            else if (addr.typeCode == 'BILL')
                            address.AddressType = 'Billing';
                            else if (addr.typeCode == 'MAIL')
                            address.AddressType = 'Mailing'; 
                            MemberDetail.Addresses.add(address);
                        }
                        MemberDetail.Phones = new List<ACETMemberDetail.Phone>();
                        for(ACETGetIndividualJSON2APexADP.cls_phone telephone : individual.phone){
                            ACETMemberDetail.Phone phone = new ACETMemberDetail.Phone();
                            phone.PhoneNumber = telephone.phoneNumber;
                            if(telephone.phoneType == 'H')
                                phone.PhoneNumberType = 'Home';
                            if(telephone.phoneType == 'F')
                                phone.PhoneNumberType = 'Fax';
                            if(telephone.phoneType == 'W')
                                phone.PhoneNumberType = 'Work';
                            if(telephone.phoneType == 'M')
                                phone.PhoneNumberType = 'Mobile';
                            if(telephone.primaryIndicator == 'Y')
                                phone.primaryIndicator = 'Primary';
                            else
                                phone.primaryIndicator = '';
                            MemberDetail.Phones.add(phone);
                        }
                        MemberDetail.ROIcontacts = new List<ACETMemberDetail.otherContact>();
                        system.debug('MemberDetail.ROIcontacts----1--->'+ MemberDetail.ROIcontacts + '---->'+individual.otherContact);
                        for(ACETGetIndividualJSON2APexADP.cls_otherContact otherCon : individual.otherContact){
                            ACETMemberDetail.otherContact ROIrec = new ACETMemberDetail.otherContact();
                            if(otherCon.name != null){
                                ROIrec.firstName = otherCon.name.firstName;
                                ROIrec.middleName = otherCon.name.MiddleName;
                                ROIrec.lastName = otherCon.name.Lastname;   
                            }
                            
                            //ROIrec.effectiveDate = formatDate('');
                            //ROIrec.terminationDate = formatDate('');
                            ROIrec.docLink = '';
                            MemberDetail.ROIcontacts.add(ROIrec);
                        }
                        system.debug('MemberDetail.ROIcontacts----2--->'+ MemberDetail.ROIcontacts);
                        
                        
                    if (individual.Identifiers != null && individual.Identifiers.size() > 0) {                       
                                for (ACETGetIndividualJSON2APexADP.cls_identifiers Identifier: individual.Identifiers) {
                                    if (Identifier.type  == 'SRK') {
                                        memberDetail.SurrogateKeys.add(String.ValueOf(Identifier.id));
                                        memberDetail.SurrogateKey = String.ValueOf(Identifier.id);    
                                    }
                                }
                          }         
                        calloutResult.Success = true;
                        calloutResult.Message = '';
                        System.debug('!!!!!!!!!!!!!!!!!!!!'+memberDetail );
                        calloutResult.Response = memberDetail;                                                
                    
                    }else {
                        //replace date with date2 as date is a preserved keyword
                        System.debug('responseBody---'+response.getBody());
                        String responseBody = response.getBody().replace('\"type\":', '\"type_Z\":');
                        responseBody = responseBody.replace('\"date\":', '\"date2\":');
                        responseBody = responseBody.replace('\"desc\":', '\"desc2\":');
                        system.debug('getIndividual SRK Response: ' + responseBody);
                        
                        ACETIndiMembershipJSON2APex jSON2Apex = (ACETIndiMembershipJSON2APex)JSON.deserialize(responseBody, ACETIndiMembershipJSON2APex.class);
                        system.debug('JSON2Apex2 : ' + jSON2Apex);                        
                        
                        ACETIndiMembershipJSON2APex.cls_individual individual = jSON2Apex.getIndividualMembershipResponse.individual;
                       
                        memberDetail.MemberId = String.valueOf(individual.individualIdentifier);
                        memberDetail.FirstName = individual.name.firstName;
                        memberDetail.LastName = individual.name.lastName;
                        System.debug('!!!!!!!!!!Lastname'+ individual.name.lastName + '!!!!!!!!!!' +memberDetail.LastName);
                        memberDetail.DOB = formatDate(individual.birthDate);
                        memberDetail.MiddleInitial = individual.name.middleName;
                        memberDetail.Gender = individual.genderCode;
                        memberDetail.Age = getAgeFromBirthday(individual.birthDate);  
                        memberDetail.SSN = getMaskedSSN(individual.socialSecurityNumber);
                        for(ACETIndiMembershipJSON2APex.cls_email emailObj : individual.email){
                            if(emailObj.primaryIndicator == 'Y'){
                                memberDetail.email = emailObj.electronicAddress;
                            }
                        }                        
                        //memberDetail.FullSSN = getSSNHyphen(individual.socialSecurityNumberId.id); 
                        //memberDetail.SpokenLanguage = individual.language[0].code;
                        //memberDetail.RelationShip = individual.relationship[0].relationshipCode.code;
                        //memberDetail.Email = individual.electronicContact[0].electronicAddressId.id;
                        memberDetail.DeceasedDate = formatDate(individual.deceasedDate);
                        //memberDetail.AsianInitiativeIndicator =  
                        //memberDetail.MigrationDate = 
                        //memberDetail.OriginalEffectiveDate =
                         
                       MemberDetail.Addresses = new List<ACETMemberDetail.Address>();
                       for(ACETIndiMembershipJSON2APex.cls_address addr : individual.address){
                            ACETMemberDetail.Address address = new ACETMemberDetail.Address();
                            address.AddressLine1 = addr.addressLine1;
                            address.AddressLine2 = addr.addressLine2;
                            address.City = addr.city;
                            address.State = addr.stateCode;
                            address.Zip = addr.postalCode;                              
                            address.AddressType = addr.typeCode; 
                            MemberDetail.Addresses.add(address);
                       }
                       
                       MemberDetail.Phones = new List<ACETMemberDetail.Phone>();
                       for(ACETIndiMembershipJSON2APex.cls_phone telephone : individual.phone){
                            ACETMemberDetail.Phone phone = new ACETMemberDetail.Phone();
                            phone.PhoneNumber = telephone.phoneNumber;
                            phone.PhoneNumberType = telephone.phoneType;
                            MemberDetail.Phones.add(phone);
                       }
                       /*
                       //added by Khoushik on 09/28/2016 for User Story - US378010
                       memberDetail.MiddleName = individual.name.middleName;
                     
                        Date DateOfEmployment= null;
                         if(individual.employment[0].status[0].employmentDateRange.startDate != null)
                         {
                            if(individual.employment[0].status[0].employmentDateRange.startDate != '')
                            {
                                DateOfEmployment= Date.valueOf(individual.employment[0].status[0].employmentDateRange.startDate);
                            }
                         } 
                         memberDetail.DateOfEmployment= DateOfEmployment; 
                         memberDetail.EmploymentStatus= individual.employment[0].status[0].typeCode.code;  
                         */
                         //Added by Khoushik for Surrogate Id's related User Stories
                         if (individual.Identifiers != null && individual.Identifiers.size() > 0) {                       
                                for (ACETIndiMembershipJSON2APex.cls_identifiers Identifiers: individual.Identifiers) {
                                    if (Identifiers.type_Z  == 'SRK') {
                                        memberDetail.SurrogateKeys.add(String.ValueOf(Identifiers.id));
                                        memberDetail.SurrogateKey = String.ValueOf(Identifiers.id);    
                                    }
                                }
                          }         
                        calloutResult.Success = true;
                        calloutResult.Message = '';
                        System.debug('!!!!!!!!!!!!!!!!!!!!'+memberDetail );
                        calloutResult.Response = memberDetail;
                    
                    }
                }
                system.debug('memberDetail.SurrogateKeys ::' + memberDetail.SurrogateKeys);
            }
            //commented by khoushik 6-7-2017 
            else if(response.getStatusCode() == 500){                
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