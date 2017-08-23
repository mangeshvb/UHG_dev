public class ACETFindHCPWebservice extends ACETWebservice
{
    public String providerType;
    public String specialityCheck;
    private Map<String, Provider_Taxonomy__mdt> mapTaxonomyMDT = new Map<String, Provider_Taxonomy__mdt>();
    public ACETProviderUtility providerUtility = new ACETProviderUtility();
    
    public void Init(String ProviderId, String NPI, String TIN, String LastName, String FirstName, String GenderCode, String SpecialtyTypeCode, 
        String PostalPrefixCode, String Distance, String City, String StateCode, String PhoneNumber, String NetworkId, String NetworkBenefitPlan, 
        String NewPatientIndicator, String ExistingPatientIndicator, String LanguageCode, String ProviderType) {
        system.debug(LoggingLevel.INFO, 'Provider Id: ' + ProviderId + ', NPI: ' + NPI + ', TIN: ' + TIN + ', Last Name: ' + LastName + ', First Name: ' + FirstName);
        system.debug(LoggingLevel.INFO, 'Specialty Type Code: ' + SpecialtyTypeCode + ', Postal Prefix Code: ' + PostalPrefixCode + ', Distance: ' + Distance);
        system.debug(LoggingLevel.INFO, 'Gender Code: ' + GenderCode + ', City: ' + City + ', State Code: ' + StateCode + ', Phone Number: ' + PhoneNumber);
        system.debug(LoggingLevel.INFO, 'NewPatientIndicator: ' + NewPatientIndicator + ', ExistingPatientIndicator: ' + ExistingPatientIndicator + ', Provider Type: ' + ProviderType);
        system.debug(LoggingLevel.INFO, 'LanguageCode: ' + LanguageCode + ', Network Id: ' + NetworkId + ', Network Benefit Plan: ' + NetworkBenefitPlan);
        ProviderId = String.isNotBlank(ProviderId) ? ProviderId : '';
        NPI = String.isNotBlank(NPI) ? NPI : '';
        TIN = String.isNotBlank(TIN) ? TIN : '';
        GenderCode = String.isNotBlank(GenderCode) ? GenderCode : '';
        SpecialtyTypeCode = String.isNotBlank(SpecialtyTypeCode) ? SpecialtyTypeCode : '';
        PostalPrefixCode = String.isNotBlank(PostalPrefixCode) ? PostalPrefixCode : '';
        Distance = String.isNotBlank(Distance) ? Distance : '';
        StateCode = String.isNotBlank(StateCode) ? StateCode : '';
        NetworkId = String.isNotBlank(NetworkId) ? NetworkId : '';
        NetworkBenefitPlan = String.isNotBlank(NetworkBenefitPlan) ? NetworkBenefitPlan : '';
        NewPatientIndicator = String.isNotBlank(NewPatientIndicator) ? NewPatientIndicator : '';
        ExistingPatientIndicator = String.isNotBlank(ExistingPatientIndicator) ? ExistingPatientIndicator : '';
        LanguageCode = String.isNotBlank(LanguageCode) ? LanguageCode : '';
        ProviderType = String.isNotBlank(ProviderType) ? ProviderType : '';
        
        this.providerType = ProviderType;
        String AreaCode, Phone, PhoneTypeCode;
        AreaCode = '';
        Phone = '';
        PhoneTypeCode = '';
        if(String.isNotBlank(PhoneNumber)) {
            AreaCode = PhoneNumber.substring(0, 3);
            Phone = PhoneNumber.substring(3, 10);
            PhoneTypeCode = 'TEL';
        }
        system.debug(LoggingLevel.INFO, 'AreaCode: ' + AreaCode + ', Phone: ' + Phone + ', Phone Type Code: ' + PhoneTypeCode);
        LastName = String.isNotBlank(LastName) ? LastName.toUpperCase() : '';
        FirstName = String.isNotBlank(FirstName) ? FirstName.toUpperCase() : '';
        GenderCode = GenderCode == 'Male' ? 'M' : GenderCode == 'Female' ? 'F' : '';
        City = String.isNotBlank(City) ? City.toUpperCase() : '';
        RequestParameters = new List<String>{ProviderId, NPI, TIN, LastName, FirstName, GenderCode, SpecialtyTypeCode, PostalPrefixCode, 
            Distance, City, StateCode, PhoneTypeCode, AreaCode, Phone, NetworkId, NetworkBenefitPlan, NewPatientIndicator, 
            ExistingPatientIndicator, LanguageCode};
        this.specialityCheck = SpecialtyTypeCode;
        mapTaxonomyMDT = providerUtility.getProviderTaxonomy();
        if (String.isNotBlank(SpecialtyTypeCode)) {
            this.specialityCheck = mapTaxonomyMDT.get(SpecialtyTypeCode).Speciality__c;
        }       
    }
    
    public override void GetEndpoint()
    {
         GetEndpointDetail('findHCPEndpoint');
    }
    
    private void GetRequestBody() {
        RequestBody = GetRequestBody('ACETFindMedicalHCPRequestJSON', RequestParameters);       
    }
    
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord) {
        system.debug(LoggingLevel.INFO, 'Page Number: ' + pageNumber + ', Page Size: ' + pageSize + ', Start Record: ' + startRecord);
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProviderLookupController.ProviderLookupResult> Providers = new List<ACETProviderLookupController.ProviderLookupResult>();
        ACETProviderLookupController.ProviderLookupResult Provider;
        List<ACETFindHCPJSON2Apex.medicalHealthcareProfessionals> SRProviders;
        ACETOILPagination Pagination;
        
        try
        {
            RequestParameters.AddAll(new List<String>{String.valueOf(pageNumber), String.valueOf(PageSize), String.valueOf(startRecord), '', '', ''});
            GetRequestBody();
            HttpResponse Response = Send(OAuthConfig);
            if (Response.getStatusCode() == 200 || Response.getStatusCode() == 400) {
                ACETFindHCPJSON2Apex ACETJSON2Apex = (ACETFindHCPJSON2Apex)JSON.deserialize(Response.getBody(), ACETFindHCPJSON2Apex.class);
                system.debug('ACETJSON2Apex: ' + ACETJSON2Apex);
                if (ACETJSON2Apex.findMedicalHealthcareProfessionalsResult.findMedicalHealthcareProfessionalsResponseType.errors == null) {
                    Pagination = ACETJSON2Apex.findMedicalHealthcareProfessionalsResult.findMedicalHealthcareProfessionalsResponseType.pagination;
                    if (Integer.valueOf(Pagination.totalCount) > 0) {
                        oACETWSCalloutResult.pageNumber = Pagination.pageNumber;
                        oACETWSCalloutResult.pageSize = Pagination.pageSize;
                        oACETWSCalloutResult.recordCount = Pagination.recordCount;
                        oACETWSCalloutResult.totalCount = Pagination.totalCount;
                        oACETWSCalloutResult.totalPages = Pagination.totalPages;
                        SRProviders = ACETJSON2Apex.findMedicalHealthcareProfessionalsResult.findMedicalHealthcareProfessionalsResponseType.medicalHealthcareProfessionals;
                        system.debug('ACETFindHCPWebservice. SRProviders: '+ SRProviders);
                        for (ACETFindHCPJSON2Apex.medicalHealthcareProfessionals SRProvider: SRProviders)
                        {
                            Provider = new ACETProviderLookupController.ProviderLookupResult();
                            if (String.isNotBlank(SRProvider.address.distance)){
                                Provider.radious = SRProvider.address.distance; 
                            }
                            Provider.fullName = '';
                            if (String.isNotBlank(SRProvider.hcp.providerFirstName)) {
                                 Provider.fullName +=  SRProvider.hcp.providerFirstName;
                            }  
                            if (String.isNotBlank(SRProvider.hcp.providerMiddleName)) {
                                 Provider.fullName +=  ' ' + SRProvider.hcp.providerMiddleName;
                            } 
                            if (String.isNotBlank(SRProvider.hcp.providerLastName)) {
                                 Provider.fullName +=  ' ' + SRProvider.hcp.providerLastName;
                            } 
                            if (String.isNotBlank(SRProvider.hcp.providerNameSuffix)) {
                                 Provider.fullName +=  ' ' + SRProvider.hcp.providerNameSuffix;
                            }                                        
                          
                            if (String.isNotBlank(SRProvider.address.countyDescription)){
                                Provider.County = SRProvider.address.countyDescription;
                            }
                            for (ACETFindHCPJSON2Apex.electronicCommunication electronicCommunication :SRProvider.electronicCommunication){
                                if (electronicCommunication.communicationTypeCode == 'EMAIL'){
                                    Provider.Email = electronicCommunication.message;
                                }
                            }    
                            if (String.isNotBlank(SRProvider.hcp.providerId)){      
                                Provider.providerId = SRProvider.hcp.providerId; 
                            }
                            if(String.isNotBlank(providerType)){
                                Provider.providerType = providerType;
                            }
                            if(String.isNotBlank(SRProvider.providerTIN.id)){
                                Provider.taxId = SRProvider.providerTIN.id;
                            }
                            if(String.isNotBlank(SRProvider.providerTIN.typeCode)){
                                Provider.providerTINTypeCode= SRProvider.providerTIN.typeCode;
                            }
                            if(String.isNotBlank(SRProvider.address.addressId)){
                                Provider.addressId = SRProvider.address.addressId;
                            }
                            if(String.isNotBlank(SRProvider.address.typeCode)){
                                Provider.addressTypeCode = SRProvider.address.typeCode;
                            }
                            for(ACETFindHCPJSON2Apex.Role Role :SRProvider.Role){
                              if(role!=null) {
                                if(String.isNotBlank(role.code)){
                                    Provider.PCPRole = role.code;
                                }
                              }
                            }
                            Provider.address = '';
                            if(String.isNotBlank(SRProvider.address.addressLine1)){
                                Provider.address = SRProvider.address.addressLine1;
                            }
                            if (String.isNotBlank(SRProvider.address.addressLine2))
                            {
                                Provider.address += ' ' + SRProvider.address.addressLine2;
                            }
                            if (String.isNotBlank(SRProvider.address.city)){
                                Provider.address += ' ' + SRProvider.address.city;
                            }
                            if (String.isNotBlank(SRProvider.address.stateCode)){
                                Provider.address += ' ' + SRProvider.address.stateCode;
                            }
                            if (String.isNotBlank(SRProvider.address.postalPrefixCode)){
                                Provider.address += ' ' + SRProvider.address.postalPrefixCode;
                            }  
                            
                            for(ACETFindHCPJSON2Apex.phone phone :SRProvider.phone){
                                if(phone.primaryPhoneIndicator == 'Y'){
                                    if (phone.phoneTypeCode == 'TEL'){
                                        Provider.phoneNumber = '(' + phone.areaCode + ')';
                                        Provider.phoneNumber += + ' ' + phone.phoneNumber.substring(0, 3) + '-';
                                        Provider.phoneNumber += phone.phoneNumber.substring(3);
                                     }
                                 }
                                 if (phone.phoneTypeCode == 'FAX'){
                                    Provider.Fax = '(' + phone.areaCode + ')';
                                    Provider.Fax += + ' ' + phone.phoneNumber.substring(0, 3) + '-';
                                    Provider.Fax += phone.phoneNumber.substring(3);
                                 }
                            }
                            if(String.isNotBlank(specialityCheck)) {                        
                                Provider.speciality = specialityCheck;
                            } else {                        
                               for(ACETFindHCPJSON2Apex.Specialty Specialty :SRProvider.Specialty){
                                   if(Specialty.primarySpecialtyIndicator == 'Y'){
                                         if(String.isNotBlank(Specialty.typeCode)){                                                                  
                                              String strtypecode = (mapTaxonomyMDT.get(Specialty.typeCode) != null ) ? mapTaxonomyMDT.get(Specialty.typeCode).Speciality_Code__c : '';
                                              if(String.isNotBlank(strtypecode)){
                                                  Provider.speciality = (mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c != null) ? mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c : strtypecode;
                                              }else{
                                                 Provider.speciality = Specialty.typeCode;
                                              }
                                        }
                                   }
                                }   
                            }
                            if(String.isNotBlank(SRProvider.hcp.providerGenderCode)){
                                Provider.gender = SRProvider.hcp.providerGenderCode;
                            }
                            if(SRProvider.premiumDesignation!=null) {
                                if(String.isNotBlank(SRProvider.premiumDesignation[0].qualityTypeDescription) && String.isNotBlank(SRProvider.premiumDesignation[0].efficiencyTypeDescription)){
                                Provider.uphd ='Q - ' + SRProvider.premiumDesignation[0].qualityTypeDescription
                                    			+ 'E - ' + SRProvider.premiumDesignation[0].efficiencyTypeDescription;
                               }
                            }
                            if(SRProvider.Tpsm!=null){
                                for(ACETFindHCPJSON2Apex.Tpsm platinum :SRProvider.Tpsm) {
                                    if(platinum != null){
                                        if(platinum.code == '99Z'){
                                            Provider.platinum = 'No';                                        
                                        }else if(String.isBlank(platinum.code)){
											Provider.platinum = '';
										}else{
                                            Provider.platinum = 'Yes - ' +  platinum.code;   
                                        }
                                    }
                                }    
                            }
                            Providers.add(Provider);
                        }
                        oACETWSCalloutResult.Success = true;
                        oACETWSCalloutResult.Message = '';
                        oACETWSCalloutResult.Response = Providers;  
                    }        
                } else {
                    oACETWSCalloutResult.Success = false;
                    oACETWSCalloutResult.Message = GetOILErrorMessage(ACETJSON2Apex.findMedicalHealthcareProfessionalsResult.findMedicalHealthcareProfessionalsResponseType.errors);
                    oACETWSCalloutResult.Response = Providers;
                }   
            }
            else {
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
            }
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in Find Medical Providers. Details: ' + ex); 
            System.debug('getStackTraceString ' + ex.getStackTraceString());
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
  
    private void GetRequestBody(String strTaxId, String strNPI, String strLastName, String strFirstName, String strState, String strZipCode, 
                        String strPhoneNumber, String strproviderType, String strRadius,String strproviderId, String strnetworkType,String strGender, 
                        String strLanguage,String strCity,String strNewpatientsInd, String strexistingpatientsInd,String strBenefitPlanId,String strSpecialityType)
    {         
 
            String strstaticfilename = 'findHCPAdapterRequestTemplate';
            StaticResource sr = [SELECT Id,NamespacePrefix,SystemModstamp FROM StaticResource WHERE Name = :strstaticfilename LIMIT 1];
            String prefix = sr.NamespacePrefix;
            if( String.isEmpty(prefix) ) {
                prefix = '';
            } else {
                prefix += '__';
            }
            String srPath = '/resource/' + sr.SystemModstamp.getTime() + '/' + prefix + strstaticfilename; 
            PageReference pg = new PageReference(srPath);
            
            if(!Test.isRunningTest())
            {        
                RequestBody = pg.getContent().toString();
            }
            else 
            {
                RequestBody = 'UNIT.TEST';
            }
            RequestBody = (strnetworkType != null) ? RequestBody.replace('@@networkId@@',strnetworkType) : RequestBody.replace('@@networkId@@', '') ;            
            RequestBody = (strNewpatientsInd != null) ? RequestBody.replace('@@acceptingNewPatientIndicator@@',strNewpatientsInd) : RequestBody.replace('@@acceptingNewPatientIndicator@@', '') ;
            RequestBody = (strexistingpatientsInd != null) ? RequestBody.replace('@@acceptingExistingPatientIndicator@@',strexistingpatientsInd) : RequestBody.replace('@@acceptingExistingPatientIndicator@@', '') ;
            RequestBody = (strBenefitPlanId != null) ? RequestBody.replace('@@networkBenefitPlan@@',strBenefitPlanId) : RequestBody.replace('@@networkBenefitPlan@@', '') ;
    //    } 
        
        RequestBody = (strTaxId != null) ? RequestBody.replace('@@providerTIN@@',strTaxId) : RequestBody.replace('@@providerTIN@@', '') ;
        RequestBody = (strNPI != null) ? RequestBody.replace('@@NPI@@',strNPI) : RequestBody.replace('@@NPI@@', '') ;
        RequestBody = (strLastName != null) ? RequestBody.replace('@@providerLastName@@',strLastName) : RequestBody.replace('@@providerLastName@@', '') ;
        RequestBody = (strFirstName != null) ? RequestBody.replace('@@providerFirstName@@',strFirstName) : RequestBody.replace('@@providerFirstName@@', '') ; 
        RequestBody = (strState!= null)  ? RequestBody.replace('@@addressStateCode@@',strState) : RequestBody.replace('@@addressStateCode@@', '') ;
        RequestBody = (strZipCode!= null) ? RequestBody.replace('@@addressPostalPrefixCode@@',strZipCode) : RequestBody.replace('@@addressPostalPrefixCode@@', '') ;           
        RequestBody = (strproviderId != null) ? RequestBody.replace('@@providerId@@',strproviderId) : RequestBody.replace('@@providerId@@', '') ;

        RequestBody = (strGender != null) ? RequestBody.replace('@@providerGenderCode@@',strGender) : RequestBody.replace('@@providerGenderCode@@', '') ;
        RequestBody = (strRadius != null) ? RequestBody.replace('@@addressDistance@@',strRadius) : RequestBody.replace('@@addressDistance@@', '') ;
        RequestBody = (strLanguage != null) ? RequestBody.replace('@@languageCode@@',strLanguage) : RequestBody.replace('@@languageCode@@', '') ;
        RequestBody = (strCity != null) ? RequestBody.replace('@@addressCity@@',strCity) : RequestBody.replace('@@addressCity@@', '') ;
        RequestBody = (strSpecialityType != null) ? RequestBody.replace('@@specialtyTypeCode@@',strSpecialityType) : RequestBody.replace('@@specialtyTypeCode@@', '') ;
        String strAreaCode,strPhone;
        if(String.isNotBlank(strPhoneNumber)){
            strAreaCode = strPhoneNumber.substring(0, 3);
            strPhone = strPhoneNumber.substring(3, 10);
            system.debug('strPhoneNumber :: ' + strAreaCode + ' - ' + strPhone);
        }    
       
        RequestBody = (strAreaCode != null) ? RequestBody.replace('@@phoneAreaCode@@',strAreaCode) : RequestBody.replace('@@phoneAreaCode@@', '') ;
        RequestBody = (strPhone != null) ? RequestBody.replace('@@phoneNumber@@',strPhone) : RequestBody.replace('@@phoneNumber@@', '') ;
              
        if(String.isNotBlank(strPhoneNumber)){
            String telPhone = 'TEL';
            RequestBody = (telPhone != null) ? RequestBody.replace('@@phoneTypeCode@@',telPhone) : RequestBody.replace('@@phoneTypeCode@@', '') ;
        }else{
            RequestBody = (strPhone != null) ? RequestBody.replace('@@phoneTypeCode@@','') : RequestBody.replace('@@phoneTypeCode@@', '') ;
        }

    
    }
    
    public Continuation StartRequest(String TaxId, String NPI, String providerId, String networkType, String LastName, String PhoneNumber, 
                    String providerType, String FirstName, String city, String specialityType, String language, String state, String radius, 
                    String gender,String ZipCode,String NewpatientsInd,String existingpatientsInd, String memberId, String CallbackMethodName, Continuation oContinuation)
    {
       system.debug(LoggingLevel.INFO, 'TaxId: ' + TaxId +', NPI: ' + NPI + ', providerId: ' + providerId +', networkType: ' + networkType);
        system.debug(LoggingLevel.INFO, 'LastName: ' + LastName +', PhoneNumber: ' + PhoneNumber +', providerType: ' + providerType);
        system.debug(LoggingLevel.INFO, 'FirstName: ' + FirstName + ', city: ' + city + ', specialityType: ' + specialityType);
        system.debug(LoggingLevel.INFO, 'language: ' + language + ', state: ' + state + ', radius: ' + radius + ', gender: ' + gender);
        system.debug(LoggingLevel.INFO, 'ZipCode: ' + ZipCode + ', NewpatientsInd: ' + NewpatientsInd + ', existingpatientsInd: ' + existingpatientsInd);
        system.debug(LoggingLevel.INFO, 'memberId: ' + memberId + ', CallbackMethodName: ' + CallbackMethodName + ', oContinuation: ' + oContinuation);   
        
        GetEndpoint();
        if(String.isNotBlank(LastName))
            LastName = LastName.touppercase();
        if(String.isNotBlank(FirstName))
            FirstName = FirstName.touppercase();
        if(String.isNotBlank(City))
            City = City.touppercase();
            
        if(gender != null || gender != '') {
            if(gender == 'Male') {
                gender = 'M';
            } else if(gender == 'Female') {
                gender = 'F';
            }
        }   
         
        mapTaxonomyMDT = providerUtility.getProviderTaxonomy();
        if(String.isNotBlank(specialityType))
            this.specialityCheck = mapTaxonomyMDT.get(specialityType).Speciality__c;
                  
        GetRequestBody(TaxId, NPI, LastName, FirstName, State, ZipCode, PhoneNumber, providerType, radius, providerId, networkType, gender,
                    language, city, NewpatientsInd, existingpatientsInd, memberId,specialityType);
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        return oContinuation;         
    }
    
    public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel) {
        
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProviderLookupController.ProviderLookupResult> Providers = new List<ACETProviderLookupController.ProviderLookupResult>();
        ACETProviderLookupController.ProviderLookupResult Provider;
        List<ACETFindHCPJSON2Apex.medicalHealthcareProfessionals> SRProviders;
        
        try
        {
            HttpResponse Response = GetHttpResponse(HttpRequestLabel);
            String responseBody = response.getBody();
            if (Response.getStatusCode() == 200)
            {
                ACETFindHCPJSON2Apex ACTFHCPJSON2Apex = (ACETFindHCPJSON2Apex)JSON.deserialize(Response.getBody(), ACETFindHCPJSON2Apex.class);
                system.debug('ACTFHCPJSON2Apex : ' + ACTFHCPJSON2Apex);
                SRProviders = ACTFHCPJSON2Apex.findMedicalHealthcareProfessionalsResult.findMedicalHealthcareProfessionalsResponseType.medicalHealthcareProfessionals;
                system.debug('SRProviders'+SRProviders);
                if (SRProviders != null && SRProviders.size() > 0 )
                {
                    for (ACETFindHCPJSON2Apex.medicalHealthcareProfessionals SRProvider: SRProviders)
                    {
                        Provider = new ACETProviderLookupController.ProviderLookupResult();
                        if(String.isNotBlank(SRProvider.address.distance)){
                            Provider.radious = SRProvider.address.distance; 
                        }
                        Provider.fullName = '';
                        if(String.isNotBlank(SRProvider.hcp.providerFirstName)) {
                             Provider.fullName +=  SRProvider.hcp.providerFirstName;
                        }  
                        if(String.isNotBlank(SRProvider.hcp.providerMiddleName)) {
                             Provider.fullName +=  ' ' + SRProvider.hcp.providerMiddleName;
                        } 
                        if(String.isNotBlank(SRProvider.hcp.providerLastName)) {
                             Provider.fullName +=  ' ' + SRProvider.hcp.providerLastName;
                        } 
                        if(String.isNotBlank(SRProvider.hcp.providerNameSuffix)) {
                             Provider.fullName +=  ' ' + SRProvider.hcp.providerNameSuffix;
                        }                                        
                      
                        if(String.isNotBlank(SRProvider.address.countyDescription)){
                            Provider.County = SRProvider.address.countyDescription;
                        }
                        for(ACETFindHCPJSON2Apex.electronicCommunication electronicCommunication :SRProvider.electronicCommunication){
                            if (electronicCommunication.communicationTypeCode == 'EMAIL'){
                                Provider.Email = electronicCommunication.message;
                            }
                        }    
                        if(String.isNotBlank(SRProvider.hcp.providerId)){      
                            Provider.providerId = SRProvider.hcp.providerId; 
                        }
                        if(String.isNotBlank(providerType)){
                            Provider.providerType = providerType;
                        }
                        if(String.isNotBlank(SRProvider.providerTIN.id)){
                            Provider.taxId = SRProvider.providerTIN.id;
                        }
                        if(String.isNotBlank(SRProvider.providerTIN.typeCode)){
                            Provider.providerTINTypeCode= SRProvider.providerTIN.typeCode;
                        }
                        if(String.isNotBlank(SRProvider.address.addressId)){
                            Provider.addressId = SRProvider.address.addressId;
                        }
                        if(String.isNotBlank(SRProvider.address.typeCode)){
                            Provider.addressTypeCode = SRProvider.address.typeCode;
                        }
                    for(ACETFindHCPJSON2Apex.Role Role :SRProvider.Role){
                      if(role!=null) {
                        if(String.isNotBlank(role.code)){
                            Provider.PCPRole = role.code;
                        }
                      }
                    }
                        Provider.address = '';
                        if(String.isNotBlank(SRProvider.address.addressLine1)){
                            Provider.address = SRProvider.address.addressLine1;
                        }
                        if (String.isNotBlank(SRProvider.address.addressLine2))
                        {
                            Provider.address += ' ' + SRProvider.address.addressLine2;
                        }
                        if (String.isNotBlank(SRProvider.address.city)){
                            Provider.address += ' ' + SRProvider.address.city;
                        }
                        if (String.isNotBlank(SRProvider.address.stateCode)){
                            Provider.address += ' ' + SRProvider.address.stateCode;
                        }
                        if (String.isNotBlank(SRProvider.address.postalPrefixCode)){
                            Provider.address += ' ' + SRProvider.address.postalPrefixCode;
                        }  
                        
                        for(ACETFindHCPJSON2Apex.phone phone :SRProvider.phone){
                            if(phone.primaryPhoneIndicator == 'Y'){
                                if (phone.phoneTypeCode == 'TEL'){
                                    Provider.phoneNumber = '(' + phone.areaCode + ')';
                                    Provider.phoneNumber += + ' ' + phone.phoneNumber.substring(0, 3) + '-';
                                    Provider.phoneNumber += phone.phoneNumber.substring(3);
                                 }
                             }
                             if (phone.phoneTypeCode == 'FAX'){
                                Provider.Fax = '(' + phone.areaCode + ')';
                                Provider.Fax += + ' ' + phone.phoneNumber.substring(0, 3) + '-';
                                Provider.Fax += phone.phoneNumber.substring(3);
                             }
                        }
                       if(String.isNotBlank(specialityCheck)) {                        
                            Provider.speciality = specialityCheck;
                        }else{                        
                          // mapTaxonomyMDT = getProviderTaxonomy(); 
                           for(ACETFindHCPJSON2Apex.Specialty Specialty :SRProvider.Specialty){
                               if(Specialty.primarySpecialtyIndicator == 'Y'){
                                  //@Rama:: Sprint 4 Change- Description to Code 
                                  
                                     if(String.isNotBlank(Specialty.typeCode)){                                                                  
                                          String strtypecode = (mapTaxonomyMDT.get(Specialty.typeCode) != null ) ? mapTaxonomyMDT.get(Specialty.typeCode).Speciality_Code__c : '';
                                          system.debug('strtypecode >>> ' + strtypecode);
                                          if(String.isNotBlank(strtypecode)){
                                              Provider.speciality = (mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c != null) ? mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c : strtypecode;
                                          }else{
                                             Provider.speciality = Specialty.typeCode;
                                          }
                                    }
                               }
                            }   
                        }
                           
                        if(String.isNotBlank(SRProvider.hcp.providerGenderCode)){
                            Provider.gender = SRProvider.hcp.providerGenderCode;
                        }
                        if(SRProvider.premiumDesignation!=null) {
                            if(String.isNotBlank(SRProvider.premiumDesignation[0].qualityTypeDescription) && String.isNotBlank(SRProvider.premiumDesignation[0].efficiencyTypeDescription)){
                                Provider.uphd ='Q - ' + SRProvider.premiumDesignation[0].qualityTypeDescription
                                    			+ 'E - ' + SRProvider.premiumDesignation[0].efficiencyTypeDescription;
                            }
                       }
                        Providers.add(Provider);
                    }
                }
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = Providers;
            }
            else
            {
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
            }
            if (Providers.size() > 0)
            {               
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = Providers;
            }
            
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in Find Medical Providers. Details: ' + ex); 
            System.debug('getStackTraceString ' + ex.getStackTraceString());
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
       
    //Webservice method to call findHCP Adapter Lookup service
    public ACETWSCalloutResult FindHCP(String TaxId, String NPI, String providerId, String networkType, String LastName, String PhoneNumber, String providerType, 
                                    String FirstName, String city, String specialityType, String language, String state, String radius, String gender,String ZipCode,String NewpatientsInd,String existingpatientsInd, String benefitPlanId){
        
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProviderLookupController.ProviderLookupResult> Providers = new List<ACETProviderLookupController.ProviderLookupResult>();
        ACETProviderLookupController.ProviderLookupResult Provider;
        List<ACETFindHCPJSON2Apex.medicalHealthcareProfessionals> SRProviders;
        system.debug(LoggingLevel.INFO, 'specialityType: ' + specialityType);
        try
        {
            GetEndpoint();
            if(String.isNotBlank(LastName)){
                LastName = LastName.touppercase();
            }
            if(String.isNotBlank(FirstName)){
                FirstName = FirstName.touppercase();
            }
            if(String.isNotBlank(City)){
                City = City.touppercase();
            }
            if(gender != null || gender != ''){
                if(gender == 'Male'){
                    gender = 'M';
                }else if(gender == 'Female'){
                    gender = 'F';
                }
            }  
            
            mapTaxonomyMDT = providerUtility.getProviderTaxonomy();
            if(String.isNotBlank(specialityType))
               this.specialityCheck = mapTaxonomyMDT.get(specialityType).Speciality__c;              
            
            GetRequestBody(TaxId, NPI, LastName, FirstName, State, ZipCode,PhoneNumber,providerType,radius,providerId, networkType,gender,language,city,NewpatientsInd,existingpatientsInd,benefitPlanId,specialityType);
            HttpResponse Response = Send(OAuthConfig);
           // HttpResponse Response = new HttpResponse();
            System.debug('Response >>> ' + response.getBody());
            
            //Start of Hardcode response -- Comment this block when webservice is up
           //  Response.setStatusCode(200);
           //  Response.setBody(ACETTestDataUtility.findMedicalProviderCallableJSON());
            //End of Hardcode response -- Comment this block when webservice is up 
            
            
            //Start of Hardcode response -- Comment this block when webservice is up
            // Response.setStatusCode(200);
            // Response.setBody(ACETTestDataUtility.findMedicalProviderCallableJSON2());
            //End of Hardcode response -- Comment this block when webservice is up 
            String responseBody = response.getBody();
            System.debug('OAuthConfig >>> ' + OAuthConfig);
            if (Response.getStatusCode() == 200)
            {
                ACETFindHCPJSON2Apex ACTFHCPJSON2Apex = (ACETFindHCPJSON2Apex)JSON.deserialize(Response.getBody(), ACETFindHCPJSON2Apex.class);
               // ACETFindHCPJSON2Apex ACTFHCPJSON2Apex =  ACETFindHCPJSON2Apex.parse(responseBody);
                system.debug('ACTFHCPJSON2Apex : ' + ACTFHCPJSON2Apex);
                if(ACTFHCPJSON2Apex.findMedicalHealthcareProfessionalsResult != null)
                 SRProviders = ACTFHCPJSON2Apex.findMedicalHealthcareProfessionalsResult.findMedicalHealthcareProfessionalsResponseType.medicalHealthcareProfessionals;
                system.debug('SRProviders'+SRProviders);
                if (SRProviders != null && SRProviders.size() > 0 )
                {
                    for (ACETFindHCPJSON2Apex.medicalHealthcareProfessionals SRProvider: SRProviders)
                    {
                        Provider = new ACETProviderLookupController.ProviderLookupResult();
                        if(String.isNotBlank(SRProvider.address.distance)){
                            Provider.radious = SRProvider.address.distance; 
                        }
                        Provider.fullName = '';
                        if(String.isNotBlank(SRProvider.hcp.providerFirstName)) {
                             Provider.fullName +=  SRProvider.hcp.providerFirstName;
                             provider.firstName = SRProvider.hcp.providerFirstName;
                        }  
                        if(String.isNotBlank(SRProvider.hcp.providerMiddleName)) {
                             Provider.fullName +=  ' ' + SRProvider.hcp.providerMiddleName;
                             Provider.MiddleName = SRProvider.hcp.providerMiddleName;
                        } 
                        if(String.isNotBlank(SRProvider.hcp.providerLastName)) {
                             Provider.fullName +=  ' ' + SRProvider.hcp.providerLastName;
                             Provider.LastName = SRProvider.hcp.providerLastName;
                        } 
                        if(String.isNotBlank(SRProvider.hcp.providerNameSuffix)) {
                             Provider.fullName +=  ' ' + SRProvider.hcp.providerNameSuffix;
                             provider.suffix =  SRProvider.hcp.providerNameSuffix;
                        }                                        
                      
                        if(String.isNotBlank(SRProvider.address.countyDescription)){
                            Provider.County = SRProvider.address.countyDescription;
                        }
                        for(ACETFindHCPJSON2Apex.electronicCommunication electronicCommunication :SRProvider.electronicCommunication){
                            if (electronicCommunication.communicationTypeCode == 'EMAIL'){
                                Provider.Email = electronicCommunication.message;
                            }
                        }    
                       //getHCP Request params:START
                        if(String.isNotBlank(SRProvider.hcp.providerId)){      
                            Provider.providerId = SRProvider.hcp.providerId; 
                        }
                        if(String.isNotBlank(providerType)){
                            Provider.providerType = providerType;
                        }
                        if(String.isNotBlank(SRProvider.providerTIN.id)){
                            Provider.taxId = SRProvider.providerTIN.id;
                        }
                        if(String.isNotBlank(SRProvider.providerTIN.typeCode)){
                            Provider.providerTINTypeCode= SRProvider.providerTIN.typeCode;
                        }
                        if(String.isNotBlank(SRProvider.address.addressId)){
                            Provider.addressId = SRProvider.address.addressId;
                        }
                        if(String.isNotBlank(SRProvider.address.typeCode)){
                            Provider.addressTypeCode = SRProvider.address.typeCode;
                        }
                     for(ACETFindHCPJSON2Apex.Role Role :SRProvider.Role){
                       if(role!=null) {
                        if(String.isNotBlank(role.code)){
                            Provider.PCPRole = role.code;
                        }
                      }
                    }  
                        //getHCP Request params:END 
                                               
                       // Provider.status
                        Provider.address = '';
                        if(String.isNotBlank(SRProvider.address.addressLine1)){
                            Provider.address = SRProvider.address.addressLine1;
                            provider.addressLine1 = SRProvider.address.addressLine1;
                        }
                        if (String.isNotBlank(SRProvider.address.addressLine2))
                        {
                            Provider.address += ' ' + SRProvider.address.addressLine2;
                            provider.addressLine2 = SRProvider.address.addressLine2;
                        }
                        if (String.isNotBlank(SRProvider.address.city)){
                            Provider.address += ' ' + SRProvider.address.city;
                            provider.city = SRProvider.address.city;
                        }
                        if (String.isNotBlank(SRProvider.address.stateCode)){
                            Provider.address += ' ' + SRProvider.address.stateCode;
                            provider.State =  SRProvider.address.stateCode;
                        }
                        if (String.isNotBlank(SRProvider.address.postalPrefixCode)){
                            Provider.address += ' ' + SRProvider.address.postalPrefixCode;
                            provider.zipCode = SRProvider.address.postalPrefixCode;
                        }
                        
                        for(ACETFindHCPJSON2Apex.phone phone :SRProvider.phone){
                            if(phone.primaryPhoneIndicator == 'Y'){
                                if (phone.phoneTypeCode == 'TEL'){
                                    Provider.phoneNumber = '(' + phone.areaCode + ')';
                                    Provider.phoneNumber += + ' ' + phone.phoneNumber.substring(0, 3) + '-';
                                    Provider.phoneNumber += phone.phoneNumber.substring(3);
                                 }
                             }
                             if (phone.phoneTypeCode == 'FAX'){
                                Provider.Fax = '(' + phone.areaCode + ')';
                                Provider.Fax += + ' ' + phone.phoneNumber.substring(0, 3) + '-';
                                Provider.Fax += phone.phoneNumber.substring(3);
                             }
                        } 
                       if(String.isNotBlank(specialityCheck)) {                        
                            Provider.speciality = specialityCheck;
                        }else{                                                                     
//                       mapTaxonomyMDT = getProviderTaxonomy(); 
                           for(ACETFindHCPJSON2Apex.Specialty Specialty :SRProvider.Specialty){
                               system.debug('Specialty.primarySpecialtyIndicator**'+Specialty.primarySpecialtyIndicator + ' *** Specialty.typeCode *** ' + Specialty.typeCode  );
                                if(Specialty.primarySpecialtyIndicator == 'Y'){
    
                                  //@Rama:: Sprint 4 Change- Description to Code 
                                  
                                     if(String.isNotBlank(Specialty.typeCode)){
                                         system.debug('mapTaxonomyMDT.size >>> ' + mapTaxonomyMDT.size() + ' ** mapTaxonomyMDT.get(Specialty.typeCode).Speciality_Code__c ** ' + mapTaxonomyMDT.get(Specialty.typeCode));
                                          
                                          String strtypecode = (mapTaxonomyMDT.get(Specialty.typeCode) != null ) ? mapTaxonomyMDT.get(Specialty.typeCode).Speciality_Code__c : '';
                                          system.debug('strtypecode >>> ' + strtypecode);
                                          if(String.isNotBlank(strtypecode)){
                                              Provider.speciality = (mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c != null) ? mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c : strtypecode;
                                          }else{
                                             Provider.speciality = Specialty.typeCode;
                                          }                                  
                                    }
                               }
                            }
                        }
                        
                        if(String.isNotBlank(SRProvider.hcp.providerGenderCode)){
                            Provider.gender = SRProvider.hcp.providerGenderCode;
                        }
                        // Provider.network
                        // Provider.affiliation
                        if(SRProvider.premiumDesignation!=null) {                        
                             if(String.isNotBlank(SRProvider.premiumDesignation[0].qualityTypeDescription) && String.isNotBlank(SRProvider.premiumDesignation[0].efficiencyTypeDescription)){
                                 Provider.uphd ='Q - ' + SRProvider.premiumDesignation[0].qualityTypeDescription
                                     + 'E - ' + SRProvider.premiumDesignation[0].efficiencyTypeDescription;
                             }
                          } 
                      
                        /* Added by Avish on 06122017 for displaying Platinum code on UI ***/
                        system.debug(LoggingLevel.INFO,'SRProvider.Tpsm:: ' + SRProvider.Tpsm);
                        if(SRProvider.Tpsm!=null){
                            for(ACETFindHCPJSON2Apex.Tpsm platinum :SRProvider.Tpsm) {
                                if(platinum != null){
                                    if(platinum.code == '99Z'){
                                        Provider.platinum = 'No';                                        
                                    }else if(String.isBlank(platinum.code)){
                                        Provider.platinum = '';
                                    }else{
                                        Provider.platinum = 'Yes - ' +  platinum.code;   
                                    }
                                 }
                            }    
                        }
                        /*** end of tpsm code **/                      
                        
                        Providers.add(Provider);
                    }
                    oACETWSCalloutResult.Success = true;
                    oACETWSCalloutResult.Message = '';
                    oACETWSCalloutResult.Response = Providers;                    
                }else
                {
                    oACETWSCalloutResult.Success = true;
                    oACETWSCalloutResult.Message = '';
                    oACETWSCalloutResult.Response = Providers;
                }
            }
            else
            {
                oACETWSCalloutResult = ParseFailureResponse(Response);
                system.debug('oACETWSCalloutResult for ParseFailureResponse'+ oACETWSCalloutResult);
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
            }
            if (Providers.size() > 0)
            {               
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = Providers;
            }
            
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in Find Medical Providers. Details: ' + ex); 
            System.debug('getStackTraceString ' + ex.getStackTraceString());
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
    
}