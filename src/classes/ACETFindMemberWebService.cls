public class ACETFindMemberWebService extends ACETWebService {
    private String m_memberId;
    private String m_firstName;
    private String m_lastName;
    private String m_dob;
    private String m_state;
    private String m_zip;
    
    public override void getEndpoint(){
        GetEndpointDetail('SearchMembersEndpoint');               
    }
       
    public void getRequestBodyAdaptor(String memberId, String firstname, String lastName, String dob,String state, String zip){
    	
    	RequestBody =   '{"findIndividualsRequest": {"searchId": "'+memberId+'","searchTypeCode": "","firstName": "'+firstname+'","lastName": "'+lastName+'",'
                +'"birthDate": "'+dob+'",'
                +'"stateCode": "'+state+'",'
                +'"postalCode": "'+zip+'",'
                +'"telephoneNumber": "",'
                +'"systemSpecificIndicator": "",'
                +'"pagination": {'
                +'"pageNumber": "1",'
                +'"pageSize": "1",'
                +'"startRecord": "1"'
                +'}'
            +'}'
        +'}';            
                                       
    } 
    //init service query params
    public void init(String memberId, String firstname, String lastName, String dob,String state, String zip){ 
        m_memberId = memberId;
        m_firstName = firstName;
        m_lastName = lastName;
        m_dob = dob;
        m_state = state;
        m_zip = zip;                                
    }
    
    //implement pagianted data service
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord){                    
        ACETWSCalloutResult searchResult = new ACETWSCalloutResult();
        List<ACETMemberSearchResult> memberSearchResult;
        String TempMemberId = m_memberId;
        
        try{
            ServiceName = 'FindIndividualsService';
            getEndpoint();                        
            getRequestBodyAdaptor(m_memberId,m_firstname,m_lastName,m_dob,m_state,m_zip);                          
            
            RequestBody = RequestBody.replace('"pageNumber": "1"','"pageNumber": "' + pageNumber + '"');
            RequestBody = RequestBody.replace('"pageSize": "1"','"pageSize": "' + pageSize + '"');
            RequestBody = RequestBody.replace('"startRecord": "1"','"startRecord": "' + startRecord + '"');
                                   
            HttpResponse response;  
            response = Send(OAuthConfig);                       
            
            system.debug(response.getStatusCode());          
            if(response.getStatusCode() == 200){ 
                system.debug(response.getBody());                            
                if(response.getBody() != null){
                    //replace date with date2 as date is preserved keyword
                        String responseBody = response.getBody().replace('\"type\":', '\"type_Z\":');
                        ACETFindIndividualResultJSON2Apex  ACTFMJSON2Apex = (ACETFindIndividualResultJSON2Apex)JSON.deserialize(responseBody, ACETFindIndividualResultJSON2Apex.class);
                        system.debug('ACTFMJSON2Apex : ' + ACTFMJSON2Apex );
                       memberSearchResult = new List<ACETMemberSearchResult>();
                        List<ACETFindIndividualResultJSON2Apex.Individuals> members = ACTFMJSON2Apex.findIndividualsResponse.individuals;
                        system.debug('232323members::' + members);
                       integer randomSRK = 123;
                       
                        for(ACETFindIndividualResultJSON2Apex.Individuals m : members){
                            ACETMemberSearchResult sr = new ACETMemberSearchResult();   
                            sr.ID = m.individualIdentifier;
                            sr.LastName = m.name != null && m.name.lastName != null ? m.name.lastName : '' ;
                            sr.FirstName = m.name != null && m.name.FirstName != null ? m.name.FirstName : '';
                            sr.MiddleInitial = m.name != null && m.name.middleName != null ? m.name.middleName : '';
                            sr.Gender = m.genderCode;
                            sr.DOB = !String.isEmpty(m.birthDate) ? formatDate(m.birthDate) : sr.DOB;
                            sr.SSNum = m.socialSecurityNumber;
                            sr.SSN = !String.isEmpty(m.socialSecurityNumber) ? 'xxx-xx-'+ m.socialSecurityNumber.substring(5,9) : 'xxx-xx-'+sr.SSN;
                            sr.Address = m.address != null ? m.address.addressline1 : sr.Address;
                            sr.City = m.address != null ? m.address.city : sr.city; 
                            sr.State = m.address != null ? m.address.statecode : sr.State;
                            sr.Zip = m.address != null ? m.address.postalCode : sr.Zip;
                            sr.SourceCode = '';
                           system.debug('232323 Identifiers:::'+m.Identifiers); 
                            if (m.Identifiers != null && m.Identifiers.size() > 0) {
                                Set<String> sourceCodeSet = new Set<String>();                       
                                for (ACETFindIndividualResultJSON2Apex.Identifiers Identifiers: m.Identifiers) {
                                    system.debug('232323 Identifiers.type_Z :::'+Identifiers.type_Z ); 
                                    if (Identifiers.type_Z == 'SRK' && Identifiers.sourceSysCode == 'CR') {
                                        sr.SurrogateKeys.add(Identifiers.id);
                                        sr.SurrogateKey = Identifiers.id;
                                        
                                    }
                                    if (Identifiers.type_Z == 'MCH') {
                                        sr.IDs.add(Identifiers.id);
                                        sr.ID = Identifiers.id;  
                                    }
                                    if (Identifiers.type_Z == 'SCR') {
                                        sr.IDs.add(Identifiers.id);
                                        sr.SCRID = Identifiers.id;  
                                    }
                                    if (Identifiers.type_Z == 'SRK' || Identifiers.type_Z == 'MCH' || Identifiers.type_Z == 'MBR' || Identifiers.type_Z == 'SCR') {
                                        sourceCodeSet.add(Identifiers.sourceSysCode);
                                    }
                                }
                                for(String sc : sourceCodeSet){
                                    if(String.isEmpty(sr.SourceCode)){
                                        sr.SourceCode = sc;
                                    }else{
                                        sr.SourceCode = sr.SourceCode + ',' + sc;
                                    }
                                }
                                if(!String.isBlank(sr.SurrogateKeysStr)){
                                    sr.SourceCode = (sr.SourceCode).subString(0,(sr.SourceCode).length() - 2);
                                }
                            }
                            if(String.isEmpty(sr.SurrogateKey) ){
                                if( sr.SurrogateKeys.isEmpty()){
                                    sr.SurrogateKey = 'dummy' + String.valueOf(randomSRK);//bhanu : hardcoding for the callable service
                                }else{
                                    for(String key : sr.SurrogateKeys){
                                        sr.SurrogateKey = key;
                                    }
                                }                                
                            }                            
                            randomSRK ++;
                             system.debug('232323 SurrogateKeys:::'+sr.SurrogateKeys);   
                            memberSearchResult.add(sr); 
                        }
                        searchResult.Success = true;
                        searchResult.Message = '';
                        searchResult.Response = memberSearchResult; 
                                                
                        ACETFindIndividualResultJSON2Apex.Pagination pagination = ACTFMJSON2Apex.findIndividualsResponse.pagination;                                                                         
                        searchResult.pageNumber =  pagination.pageNumber; 
                        searchResult.pageSize = pagination.pageSize; 
                        searchResult.recordCount = pagination.recordCount;
                        searchResult.totalCount = pagination.totalCount;
                        searchResult.totalPages = pagination.totalPages;                      
                }                 
            }else if(response.getStatusCode() == 404 || response.getStatusCode() == 500){                
                searchResult.MessageSeverity = ApexPages.Severity.INFO;
                searchResult.Success = true;                
                searchResult.Response = new List<ACETMemberSearchResult>();
                searchResult.Message = 'Search criteria returned no matches.';                
                searchResult.recordCount = '0';                
                system.debug(searchResult);                
            }
            }catch(Exception e){
                    system.debug(e);
                    searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                    searchResult.Success = false;
                    searchResult.Message = 'Web Service or External System is temporarily unavailable.';
                    searchResult.recordCount = '0';
           }
        
        return searchResult;        
    }
   
    public ACETWSCalloutResult findMembers(String memberId, String firstname, String lastName, String dob,String state, String zip){
        
        ACETWSCalloutResult searchResult = new ACETWSCalloutResult();
        List<ACETMemberSearchResult> memberSearchResult;
        String TempMemberId = memberId;
 
        try {
            ServiceName = 'FindIndividualsService';
            getEndpoint();                        
            getRequestBodyAdaptor(memberId,firstname,lastName,dob,state,zip);
            
            HttpResponse response;  

                response = new HttpResponse();
                response.setStatusCode(200);
                response.setBody(GetRequestFormatByName('findIndividualsResult'));
      
            if(response.getStatusCode() == 200){
          
                if(response.getBody() != null){
                    //replace date with date2 as date is preserved keyword
						// this else condition is introduced because the sample findIndividual structure has changed
                        String responseBody = response.getBody().replace('\"type\":', '\"type_Z\":');
                        ACETFindIndividualResultJSON2Apex  ACTFMJSON2Apex = (ACETFindIndividualResultJSON2Apex)JSON.deserialize(responseBody, ACETFindIndividualResultJSON2Apex.class);
                        system.debug('ACTFMJSON2Apex : ' + ACTFMJSON2Apex );
                       memberSearchResult = new List<ACETMemberSearchResult>();
                        List<ACETFindIndividualResultJSON2Apex.Individuals> members = ACTFMJSON2Apex.findIndividualsResponse.individuals;
                        system.debug('232323members::' + members);
                       integer randomSRK = 123;
                       
                        for(ACETFindIndividualResultJSON2Apex.Individuals m : members){
                            ACETMemberSearchResult sr = new ACETMemberSearchResult();   
                            sr.ID = m.individualIdentifier;
                            sr.LastName = m.name.lastName;
                            sr.FirstName = m.name.firstName;
                            system.debug('------m.name.middleName----->'+m.name.middleName);
                            sr.MiddleInitial = m.name.middleName;
                            sr.Gender = m.genderCode;
                            sr.DOB = !String.isEmpty(m.birthDate) ? formatDate(m.birthDate) : sr.DOB;
                            //sr.SSN = m.socialSecurityNumber.substring(0,4);
                            sr.SSN = !String.isEmpty(m.socialSecurityNumber) ? 'xxx-xx-'+m.socialSecurityNumber.substring(5,9) : 'xxx-xx-'+sr.SSN;
                            sr.Address = m.address != null ? m.address.addressline1 : sr.Address;
                            sr.City = m.address != null ? m.address.city : sr.city; 
                            sr.State = m.address != null ? m.address.statecode : sr.State;
                            sr.Zip = m.address != null ? m.address.postalCode : sr.Zip;
                           system.debug('232323 Identifiers:::'+m.Identifiers); 
                            if (m.Identifiers != null && m.Identifiers.size() > 0) {
                                Set<String> sourceCodeSet = new Set<String>();                       
                                for (ACETFindIndividualResultJSON2Apex.Identifiers Identifiers: m.Identifiers) {
                                    system.debug('232323 Identifiers.type_Z :::'+Identifiers.type_Z ); 
                                    if (Identifiers.type_Z == 'SRK' && Identifiers.sourceSysCode == 'CR') {
                                        sr.SurrogateKeys.add(Identifiers.id);
                                        sr.SurrogateKey = Identifiers.id;
                                        
                                    }
                                     if (Identifiers.type_Z == 'MCH') {
                                        sr.IDs.add(Identifiers.id);
                                        sr.ID = Identifiers.id;  
                                    }
                                    if (Identifiers.type_Z == 'SRK' || Identifiers.type_Z == 'MCH' || Identifiers.type_Z == 'MBR' || Identifiers.type_Z == 'SCR') {
                                        sourceCodeSet.add(Identifiers.sourceSysCode);
                                    }
                                }
                                for(String sc : sourceCodeSet){
                                    if(String.isEmpty(sr.SourceCode)){
                                        sr.SourceCode = sc;
                                    }else{
                                        sr.SourceCode = sr.SourceCode + ',' + sc;
                                    }
                                }
                                if(!String.isBlank(sr.SurrogateKeysStr)){
                                    sr.SourceCode = (sr.SourceCode).subString(0,(sr.SourceCode).length() - 2);
                                }
                            }
                            if(String.isEmpty(sr.SurrogateKey) ){
                                if( sr.SurrogateKeys.isEmpty()){
                                    sr.SurrogateKey = 'dummy' + String.valueOf(randomSRK);//bhanu : hardcoding for the callable service
                                }else{
                                    for(String key : sr.SurrogateKeys){
                                        sr.SurrogateKey = key;
                                    }
                                }                                
                            }                            
                            randomSRK ++;
                             system.debug('232323 SurrogateKeys:::'+sr.SurrogateKeys);   
                            memberSearchResult.add(sr); 
                        }
                        searchResult.Success = true;
                        searchResult.Message = '';
                        searchResult.Response = memberSearchResult;                                         
                }                 
            }
            else if(response.getStatusCode() == 500){
                
                //currently servce returns 500 if no records found
                searchResult.MessageSeverity = ApexPages.Severity.INFO;
                searchResult.Success = true;                
                searchResult.Response = new List<ACETMemberSearchResult>();
                system.debug(searchResult);                
            }else if(response.getStatusCode() == 404){
                
                //currently servce returns 404 if no records found (Adapters)
                searchResult.MessageSeverity = ApexPages.Severity.INFO;
                searchResult.Success = true;
                searchResult.message = 'Member not Found';                
                searchResult.Response = new List<ACETMemberSearchResult>();
                system.debug(searchResult);                
            }
            }catch(Exception e){
                    system.debug(e);
                    searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                    searchResult.Success = false;
                    searchResult.Message = 'Web Service or External System is temporarily unavailable.';
                    //searchResult.Message = e.getMessage() ;
           }
        
        return searchResult;    
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
 }