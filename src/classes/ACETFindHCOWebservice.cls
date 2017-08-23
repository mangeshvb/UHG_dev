public class ACETFindHCOWebservice extends ACETWebservice {
    
    public String providerType;
    public String specialityCheck;
    private Map<String, Provider_Taxonomy__mdt> mapTaxonomyMDT = new Map<String, Provider_Taxonomy__mdt>();
    public ACETProviderUtility providerUtility = new ACETProviderUtility();
    
    public void Init(String ProviderId, String NPI, String TIN, String LastName, String SpecialtyTypeCode, String PostalPrefixCode, 
        String Distance, String City, String StateCode, String PhoneNumber, String NetworkSchedule, String NetworkBenefitPlan, String ProviderType) {
        system.debug(LoggingLevel.INFO, 'Provider Id: ' + ProviderId + ', NPI: ' + NPI + ', TIN: ' + TIN + ', Last Name: ' + LastName);
        system.debug(LoggingLevel.INFO, 'Specialty Type Code: ' + SpecialtyTypeCode + ', Postal Prefix Code: ' + PostalPrefixCode + ', Distance: ' + Distance);
        system.debug(LoggingLevel.INFO, 'City: ' + City + ', State Code: ' + StateCode + ', Phone Number: ' + PhoneNumber + ', Provider Type: ' + ProviderType);
        system.debug(LoggingLevel.INFO, 'Network Schedule: ' + NetworkSchedule + ', Network Benefit Plan: ' + NetworkBenefitPlan);
        ProviderId = String.isNotBlank(ProviderId) ? ProviderId : '';
        NPI = String.isNotBlank(NPI) ? NPI : '';
        TIN = String.isNotBlank(TIN) ? TIN : '';
        SpecialtyTypeCode = String.isNotBlank(SpecialtyTypeCode) ? SpecialtyTypeCode : '';
        PostalPrefixCode = String.isNotBlank(PostalPrefixCode) ? PostalPrefixCode : '';
        Distance = String.isNotBlank(Distance) ? Distance : '';
        StateCode = String.isNotBlank(StateCode) ? StateCode : '';
        NetworkSchedule = String.isNotBlank(NetworkSchedule) ? NetworkSchedule : '';
        NetworkBenefitPlan = String.isNotBlank(NetworkBenefitPlan) ? NetworkBenefitPlan : '';
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
        City = String.isNotBlank(City) ? City.toUpperCase() : '';
        RequestParameters = new List<String>{ProviderId, NPI, TIN, LastName, SpecialtyTypeCode, PostalPrefixCode, 
            Distance, City, StateCode, PhoneTypeCode, AreaCode, Phone, NetworkSchedule, NetworkBenefitPlan};
        this.specialityCheck = SpecialtyTypeCode;
        mapTaxonomyMDT = providerUtility.getProviderTaxonomy();
        if (String.isNotBlank(SpecialtyTypeCode)) {
            this.specialityCheck = mapTaxonomyMDT.get(SpecialtyTypeCode).Speciality__c;
        }       
    }
    
    public override void GetEndpoint()
    {
         GetEndpointDetail('findHCOEndpoint');
    }
    
    private void GetRequestBody() {
        RequestBody = GetRequestBody('ACETFindMedicalHCORequestJSON', RequestParameters);       
    }
    
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord) {
        system.debug(LoggingLevel.INFO, 'Page Number: ' + pageNumber + ', Page Size: ' + pageSize + ', Start Record: ' + startRecord);
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProviderLookupController.ProviderLookupResult> Providers = new List<ACETProviderLookupController.ProviderLookupResult>();
        ACETProviderLookupController.ProviderLookupResult Provider;
        List<ACETFindHCOJSON2Apex.medicalHealthcareOrganizations> SRProviders;
        ACETOILPagination Pagination;
        
        try
        {
            RequestParameters.AddAll(new List<String>{String.valueOf(pageNumber), String.valueOf(PageSize), String.valueOf(startRecord)});
            GetRequestBody();
            HttpResponse Response = Send(OAuthConfig);
            if (Response.getStatusCode() == 200 || Response.getStatusCode() == 400) {
                ACETFindHCOJSON2Apex ACETJSON2Apex = (ACETFindHCOJSON2Apex)JSON.deserialize(Response.getBody(), ACETFindHCOJSON2Apex.class);
                system.debug('ACETJSON2Apex : ' + ACETJSON2Apex);
                if (ACETJSON2Apex.findMedicalHealthcareOrganizationsResult.findMedicalHealthcareOrganizationsResponseType.errors == null) {
                    Pagination = ACETJSON2Apex.findMedicalHealthcareOrganizationsResult.findMedicalHealthcareOrganizationsResponseType.pagination;
                    if (Integer.valueOf(Pagination.totalCount) > 0) {
                        oACETWSCalloutResult.pageNumber = Pagination.pageNumber;
                        oACETWSCalloutResult.pageSize = Pagination.pageSize;
                        oACETWSCalloutResult.recordCount = Pagination.recordCount;
                        oACETWSCalloutResult.totalCount = Pagination.totalCount;
                        oACETWSCalloutResult.totalPages = Pagination.totalPages;
                        SRProviders = ACETJSON2Apex.findMedicalHealthcareOrganizationsResult.findMedicalHealthcareOrganizationsResponseType.medicalHealthcareOrganizations;
                        system.debug('ACETFindHCOWebservice. SRProviders' + SRProviders);
                        for (ACETFindHCOJSON2Apex.medicalHealthcareOrganizations SRProvider: SRProviders) {
                            provider = new ACETProviderLookupController.ProviderLookupResult();
                            Provider.radious = SRProvider.address.distance;                        
                            Provider.fullName = SRProvider.hco.providerName;
                            Provider.providerId = SRProvider.hco.providerId; 
                            Provider.TaxId = SRProvider.providerTIN.Id; 
                            Provider.providerTINTypeCode= SRProvider.providerTIN.typeCode;
                            Provider.addressId = SRProvider.address.addressId;
                            Provider.addressTypeCode = SRProvider.address.typeCode;
                            Provider.providerType = providerType;
                            Provider.addressLine1 = SRProvider.address.addressLine1;
                            Provider.addressLine2 = SRProvider.address.addressLine2;
                            Provider.city = SRProvider.address.city;
                            Provider.state = SRProvider.address.stateCode;
                            provider.zipcode = SRProvider.address.postalPrefixCode;
                            Provider.addressId = SRProvider.address.addressId;
                            Provider.addressTypeCode = SRProvider.address.typeCode;
                            if (String.isNotBlank(SRProvider.address.countyDescription)) {
                                Provider.County = SRProvider.address.countyDescription;
                            }
                            for(ACETFindHCOJSON2Apex.electronicCommunication electronicCommunication :SRProvider.electronicCommunication) {
                                if (electronicCommunication.communicationTypeCode == 'EMAIL') {
                                    Provider.Email = electronicCommunication.message;
                                }
                            }
                            Provider.address = SRProvider.address.addressLine1;
                            if (String.isNotBlank(SRProvider.address.addressLine2)) {
                                Provider.address += ' ' + SRProvider.address.addressLine2;
                            }
                            Provider.address += ' ' + SRProvider.address.city + ' ' + SRProvider.address.stateCode + ' ' + SRProvider.address.postalPrefixCode;
                            for (ACETFindHCOJSON2Apex.phone phone :SRProvider.phone) {
                                if (phone.primaryPhoneIndicator == 'Y') {
                                    if (phone.phoneTypeCode == 'TEL') {
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
                            if (String.isNotBlank(specialityCheck)) {                        
                                Provider.speciality = specialityCheck;
                            } else {
                                for (ACETFindHCOJSON2Apex.Specialty Specialty :SRProvider.Specialty) {
                                    if (Specialty.primarySpecialtyIndicator == 'Y') {
                                        if (String.isNotBlank(Specialty.typeCode)) {
                                            String strtypecode = (mapTaxonomyMDT.get(Specialty.typeCode) != null ) ? mapTaxonomyMDT.get(Specialty.typeCode).Speciality_Code__c : '';
                                            if (String.isNotBlank(strtypecode)) {
                                                Provider.speciality = (mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c != null) ? mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c : strtypecode;
                                            } else {
                                                Provider.speciality = Specialty.typeCode;
                                            }
                                        }
                                    }
                                }                            
                            }
                            if (SRProvider.Tpsm != null) {
								for (ACETFindHCOJSON2Apex.Tpsm platinum :SRProvider.Tpsm) {
									if (platinum != null) {
                                        if (platinum.code == '99Z') {
											Provider.platinum = 'No';                                        
                                        } else if (String.isBlank(platinum.code)) {
											Provider.platinum = '';
										} else {
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
                    oACETWSCalloutResult.Message = GetOILErrorMessage(ACETJSON2Apex.findMedicalHealthcareOrganizationsResult.findMedicalHealthcareOrganizationsResponseType.errors);
                    oACETWSCalloutResult.Response = null;
                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
                }
            }
            else {
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
            }
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in Find Medical Providers. Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
    
    private void GetRequestBody(String strTaxId, String strNPI, String strLastName, String strFirstName, String strState,string strCity, String strZipCode, 
                        String strphoneNumber, String strproviderType, String strRadius,String strproviderId, String strnetworkType,String strGender, String strLanguage,
                        string strSpeciality,String strNewpatientsInd, String strexistingpatientsInd,String strBenefitPlanId)
    {         
         //  RequestBody = GetRequestFormatByName('findHCO_HardcodedRequest');             
         String strstaticfilename = 'findHCOAdapterRequestTemplate';
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
       
        RequestBody = (strTaxId != null) ? RequestBody.replace('@@providerTIN@@',strTaxId) : RequestBody.replace('@@providerTIN@@', '') ;
        RequestBody =  (strNPI != null) ? RequestBody.replace('@@npi@@',strNPI) : RequestBody.replace('@@npi@@', '') ;
        RequestBody = (strLastName != null) ? RequestBody.replace('@@providerName@@',strLastName) : RequestBody.replace('@@providerName@@', '') ;
      //RequestBody = (strFirstName != null) ? RequestBody.replace('@@providerFirstName@@',strFirstName) : RequestBody.replace('@@providerFirstName@@', '') ; 
        RequestBody = (strState!= null)  ? RequestBody.replace('@@addressStateCode@@',strState) : RequestBody.replace('@@addressStateCode@@', '') ;
        RequestBody = (strZipCode!= null) ? RequestBody.replace('@@addressPostalPrefixCode@@',strZipCode) : RequestBody.replace('@@addressPostalPrefixCode@@', '') ;
     //   RequestBody = (strnetworkSchedule!= null) ? RequestBody.replace('@@networkSchedule@@',strnetworkSchedule) : RequestBody.replace('@@networkSchedule@@', '') ;
       
       String strAreaCode,strPhone;
       //if(strPhoneNumber != null ||strPhoneNumber == '' ){
       if(String.isNotBlank(strphoneNumber)){
           strAreaCode = strphoneNumber.substring(0, 3);
           strPhone = strphoneNumber.substring(3, 10);
           system.debug('strphoneNumber :: ' + strAreaCode + ' - ' + strPhone);
       }    
       
       RequestBody = (strAreaCode != null) ? RequestBody.replace('@@phoneAreaCode@@',strAreaCode) : RequestBody.replace('@@phoneAreaCode@@', '') ;
       RequestBody = (strPhone != null) ? RequestBody.replace('@@phoneNumber@@',strPhone) : RequestBody.replace('@@phoneNumber@@', '') ;
       
       
       //if(strPhone != null){
       if(String.isNotBlank(strPhoneNumber)){
           String telPhone = 'TEL';
           RequestBody = (telPhone != null) ? RequestBody.replace('@@phoneTypeCode@@',telPhone) : RequestBody.replace('@@phoneTypeCode@@', '') ;
       }else{
           RequestBody = (strPhone != null) ? RequestBody.replace('@@phoneTypeCode@@','') : RequestBody.replace('@@phoneTypeCode@@', '') ;
       }

        RequestBody = (strproviderId != null) ? RequestBody.replace('@@providerId@@',strproviderId) : RequestBody.replace('@@providerId@@', '') ;
        RequestBody = (strnetworkType != null) ? RequestBody.replace('@@networkId@@',strnetworkType) : RequestBody.replace('@@networkId@@', '') ;
        RequestBody = (strRadius != null) ? RequestBody.replace('@@addressDistance@@',strRadius) : RequestBody.replace('@@addressDistance@@', '') ;
        //RequestBody = (strLanguage != null) ? RequestBody.replace('@@languageCode@@',strLanguage) : RequestBody.replace('@@languageCode@@', '') ;
        RequestBody = (strCity!= null) ? RequestBody.replace('@@addressCity@@',strCity) : RequestBody.replace('@@addressCity@@', '') ;
        RequestBody = (strSpeciality!= null) ? RequestBody.replace('@@specialtyTypeCode@@',strSpeciality) : RequestBody.replace('@@specialtyTypeCode@@', '') ;
        RequestBody = (strNewpatientsInd != null) ? RequestBody.replace('@@acceptingNewPatientIndicator@@',strNewpatientsInd) : RequestBody.replace('@@acceptingNewPatientIndicator@@', '') ;
        RequestBody = (strexistingpatientsInd != null) ? RequestBody.replace('@@acceptingExistingPatientIndicator@@',strexistingpatientsInd) : RequestBody.replace('@@acceptingExistingPatientIndicator@@', '') ;        
        RequestBody = (strBenefitPlanId != null) ? RequestBody.replace('@@networkBenefitPlan@@',strBenefitPlanId) : RequestBody.replace('@@networkBenefitPlan@@', '') ;        
        
        system.debug('*** my json' + RequestBody); 
    }
    
    public Continuation StartRequest(String TaxId, String NPI, String providerId, String networkType, String LastName, String PhoneNumber, 
                    String providerType, String FirstName, String city, String specialityType, String language, String state, String radius, 
                    String gender,String ZipCode,String NewpatientsInd,String existingpatientsInd,String strBenefitPlanId, String CallbackMethodName, Continuation oContinuation)
    {
      /*  system.debug(LoggingLevel.INFO, 'TaxId: ' + TaxId +', NPI: ' + NPI + ', providerId: ' + providerId +', networkType: ' + networkType);
        system.debug(LoggingLevel.INFO, 'LastName: ' + LastName +', PhoneNumber: ' + PhoneNumber +', providerType: ' + providerType);
        system.debug(LoggingLevel.INFO, 'FirstName: ' + FirstName + ', city: ' + city + ', specialityType: ' + specialityType);
        system.debug(LoggingLevel.INFO, 'language: ' + language + ', state: ' + state + ', radius: ' + radius + ', gender: ' + gender);
        system.debug(LoggingLevel.INFO, 'ZipCode: ' + ZipCode + ', NewpatientsInd: ' + NewpatientsInd + ', existingpatientsInd: ' + existingpatientsInd);
        system.debug(LoggingLevel.INFO, 'CallbackMethodName: ' + CallbackMethodName + ', oContinuation: ' + oContinuation); */
        
        GetEndpoint();
        if(String.isNotBlank(LastName))
            LastName = LastName.toUpperCase();
        if(String.isNotBlank(FirstName))    
            FirstName = FirstName.toUpperCase();
        if(String.isNotBlank(City)) 
            City = City.toUpperCase();
        if(gender != null || gender != ''){
            if(gender == 'Male'){
                gender = 'M';
            }else if(gender == 'Female'){
                gender = 'F';
            }
        }  
        this.specialityCheck = specialityType;
        GetRequestBody(TaxId
        , NPI, LastName, FirstName, State, City, ZipCode, PhoneNumber, providerType, radius, providerId, networkType,
                gender, language, specialityType, NewpatientsInd, existingpatientsInd,strBenefitPlanId);
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        return oContinuation;         
    }
    
    public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel)
    {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProviderLookupController.ProviderLookupResult> Providers = new List<ACETProviderLookupController.ProviderLookupResult>();
        ACETProviderLookupController.ProviderLookupResult Provider;
        List<ACETFindHCOJSON2Apex.medicalHealthcareOrganizations> SRProviders;
       
        try
        {
            HttpResponse Response = GetHttpResponse(HttpRequestLabel);
            system.debug('Response***'+Response);
            String responseBody = response.getBody();
           
            if (Response.getStatusCode() == 200)
            {
                ACETFindHCOJSON2Apex ACTFHCOJSON2Apex = (ACETFindHCOJSON2Apex)JSON.deserialize(Response.getBody(), ACETFindHCOJSON2Apex.class);
                system.debug('ACTFHCOJSON2Apex : ' + ACTFHCOJSON2Apex);
                SRProviders = ACTFHCOJSON2Apex.findMedicalHealthcareOrganizationsResult.findMedicalHealthcareOrganizationsResponseType.medicalHealthcareOrganizations;
                system.debug('SRProviders'+SRProviders);
                if (SRProviders != null && SRProviders.size() > 0 )
                {
                    for (ACETFindHCOJSON2Apex.medicalHealthcareOrganizations SRProvider: SRProviders){
                        provider = new ACETProviderLookupController.ProviderLookupResult();
                        Provider.radious = SRProvider.address.distance;                        
                        Provider.fullName = SRProvider.hco.providerName;
                        Provider.providerId = SRProvider.hco.providerId; 
                        Provider.TaxId = SRProvider.providerTIN.Id; 
                        
                        //getHCO Request params:START
                        Provider.providerId = SRProvider.hco.providerId; 
                        Provider.TaxId = SRProvider.providerTIN.Id; 
                        Provider.providerTINTypeCode= SRProvider.providerTIN.typeCode;
                        Provider.addressId = SRProvider.address.addressId;
                        Provider.addressTypeCode = SRProvider.address.typeCode;
                        //getHCO Request params:END
                        
                        Provider.providerType = 'Facility';
                        Provider.providerTINTypeCode= SRProvider.providerTIN.typeCode;
                        Provider.addressId = SRProvider.address.addressId;
                        Provider.addressTypeCode = SRProvider.address.typeCode;
                        if(String.isNotBlank(SRProvider.address.countyDescription)){
                            Provider.County = SRProvider.address.countyDescription;
                        }
                        for(ACETFindHCOJSON2Apex.electronicCommunication electronicCommunication :SRProvider.electronicCommunication){
                            if (electronicCommunication.communicationTypeCode == 'EMAIL'){
                                Provider.Email = electronicCommunication.message;
                            }
                        }
                                               
                       // Provider.status
                       
                        Provider.address = SRProvider.address.addressLine1;
                       
                        if (String.isNotBlank(SRProvider.address.addressLine2))
                        {
                            Provider.address += ' ' + SRProvider.address.addressLine2;
                        }
                        Provider.address += ' ' + SRProvider.address.city + ' ' + SRProvider.address.stateCode + ' ' + SRProvider.address.postalPrefixCode;
                        for(ACETFindHCOJSON2Apex.phone phone :SRProvider.phone){
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
                       system.debug(LoggingLevel.INFO, 'specialityCheck: ' + specialityCheck); 
                       if(String.isBlank(specialityCheck)) { 
                           mapTaxonomyMDT = providerUtility.getProviderTaxonomy();
                           for(ACETFindHCOJSON2Apex.Specialty Specialty :SRProvider.Specialty){
                              // system.debug('Specialty.primarySpecialtyIndicator**'+Specialty.primarySpecialtyIndicator + ' *** Specialty.typeCode *** ' + Specialty.typeCode  );
                                    if(Specialty.primarySpecialtyIndicator == 'Y'){
                                      //@Rama:: Sprint 4 Change- Description to Code 
                                      
                                         if(String.isNotBlank(Specialty.typeCode)){
                                            // system.debug('mapTaxonomyMDT.size >>> ' + mapTaxonomyMDT.size() + ' ** mapTaxonomyMDT.get(Specialty.typeCode).Speciality_Code__c ** ' + mapTaxonomyMDT.get(Specialty.typeCode));
                                              
                                              String strtypecode = (mapTaxonomyMDT.get(Specialty.typeCode) != null ) ? mapTaxonomyMDT.get(Specialty.typeCode).Speciality_Code__c : '';
                                              //system.debug('mapTaxonomyMDT.size >>> ' + mapTaxonomyMDT.size() + ' *** ' + 'typecodeMDT ** ' + strtypecode + ' ***mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c***' + mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c);
                                            // Provider.speciality = (strtypecode != null) ? ((mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c != null)?mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c: Specialty.typeCode) : Specialty.typeCode;
                                              system.debug('strtypecode >>> ' + strtypecode);
                                              if(String.isNotBlank(strtypecode)){
                                                  Provider.speciality = (mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c != null) ? mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c : strtypecode;
                                              }else{
                                                 Provider.speciality = Specialty.typeCode;
                                              }
                                              
                                              //Provider.speciality = Specialty.typeCode;
                                              //Provider.speciality = Specialty.typeDescription;
                                        }
                                    }
                            }                   
                     //       Providers.add(Provider);
                        }
                        
                        /* Added by Avish on 06122017 for displaying Platinum code on UI ***/
                        system.debug(LoggingLevel.INFO,'SRProvider.Tpsm:: ' + SRProvider.Tpsm);
                        if(SRProvider.Tpsm!=null){
                             for(ACETFindHCOJSON2Apex.Tpsm platinum :SRProvider.Tpsm) {
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
       
    //Webservice method to call findHCP Lookup service
    public ACETWSCalloutResult FindHCO(String TaxId, String NPI, String providerId, String networkType, String LastName, String PhoneNumber, String providerType, 
                                    String FirstName, String city, String specialityType, String language, String state, String radius, String gender,String ZipCode,String NewpatientsInd,String existingpatientsInd, String benefitPlanId, String networkSchedule){
        System.debug('State >>> ' + state);
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProviderLookupController.ProviderLookupResult> Providers = new List<ACETProviderLookupController.ProviderLookupResult>();
        ACETProviderLookupController.ProviderLookupResult Provider;
        List<ACETFindHCOJSON2Apex.medicalHealthcareOrganizations> SRProviders;
        
        try
        {
            GetEndpoint();
            system.debug(LoggingLevel.INFO, 'specialityType: ' + specialityType); 
            mapTaxonomyMDT = providerUtility.getProviderTaxonomy(); 

            if(String.isNotBlank(LastName))  
                LastName = LastName.toUpperCase();
                
            if(String.isNotBlank(FirstName))
                FirstName = FirstName.toUpperCase();
                
            if(String.isNotBlank(City))
                City = City.toUpperCase();
            
            if(gender != null || gender != ''){
                if(gender == 'Male'){
                    gender = 'M';
                }else if(gender == 'Female'){
                    gender = 'F';
                }
            }   
            
            this.specialityCheck = specialityType;
            
            GetRequestBody(TaxId, NPI, LastName, FirstName, State,City, ZipCode,PhoneNumber,providerType,radius,providerId, networkType,gender,language,specialityType,NewpatientsInd,existingpatientsInd,benefitPlanId);
            if(String.isNotBlank(specialityType))
                this.specialityCheck = mapTaxonomyMDT.get(specialityType).Speciality__c;            
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
            System.debug('Response**********'+responseBody);
            if (Response.getStatusCode() == 200)
            {
                ACETFindHCOJSON2Apex ACTFHCOJSON2Apex = (ACETFindHCOJSON2Apex)JSON.deserialize(Response.getBody(), ACETFindHCOJSON2Apex.class);
               // ACETFindHCPJSON2Apex ACTFHCOJSON2Apex =  ACETFindHCPJSON2Apex.parse(responseBody);
                
                system.debug('ACTFHCOJSON2Apex : ' + ACTFHCOJSON2Apex);
                SRProviders = ACTFHCOJSON2Apex.findMedicalHealthcareOrganizationsResult.findMedicalHealthcareOrganizationsResponseType.medicalHealthcareOrganizations;
                system.debug('SRProviders'+SRProviders);
                if (SRProviders != null && SRProviders.size() > 0 )
                {
                    system.debug('SRProviders**** '+SRProviders);
                    for (ACETFindHCOJSON2Apex.medicalHealthcareOrganizations SRProvider: SRProviders){
                        provider = new ACETProviderLookupController.ProviderLookupResult();
                        system.debug('SRProvider *** ' + SRProvider.hco);
                        Provider.radious = SRProvider.address.distance;                        
                        Provider.fullName = SRProvider.hco.providerName;
                        Provider.providerId = SRProvider.hco.providerId; 
                        Provider.TaxId = SRProvider.providerTIN.Id; 
                        
                        //getHCO Request params:START
                        Provider.providerId = SRProvider.hco.providerId; 
                        Provider.TaxId = SRProvider.providerTIN.Id; 
                        Provider.providerTINTypeCode= SRProvider.providerTIN.typeCode;
                        Provider.addressId = SRProvider.address.addressId;
                        Provider.addressTypeCode = SRProvider.address.typeCode;
                        //getHCO Request params:END
                        
                        Provider.providerType = 'Facility';
                         Provider.providerTINTypeCode= SRProvider.providerTIN.typeCode;
                         /***added by Vishakha for Communication call topic --- Start***/
                        Provider.addressLine1 = SRProvider.address.addressLine1;
                        Provider.addressLine2 = SRProvider.address.addressLine2;
                        Provider.city = SRProvider.address.city;
                        Provider.state = SRProvider.address.stateCode;
                        provider.zipcode = SRProvider.address.postalPrefixCode;
                         /***added by Vishakha for Communication call topic--- End***/
                        Provider.addressId = SRProvider.address.addressId;
                        Provider.addressTypeCode = SRProvider.address.typeCode;
                        if(String.isNotBlank(SRProvider.address.countyDescription)){
                            Provider.County = SRProvider.address.countyDescription;
                        }
                        for(ACETFindHCOJSON2Apex.electronicCommunication electronicCommunication :SRProvider.electronicCommunication){
                            if (electronicCommunication.communicationTypeCode == 'EMAIL'){
                                Provider.Email = electronicCommunication.message;
                            }
                        }
                         // Provider.status
                        Provider.address = SRProvider.address.addressLine1;
                        if (String.isNotBlank(SRProvider.address.addressLine2))
                        {
                            Provider.address += ' ' + SRProvider.address.addressLine2;
                        }
                        Provider.address += ' ' + SRProvider.address.city + ' ' + SRProvider.address.stateCode + ' ' + SRProvider.address.postalPrefixCode;
                        //system.debug(' phoneNumber***' + SRProvider.phone[0].phoneNumber);
                        for(ACETFindHCOJSON2Apex.phone phone :SRProvider.phone){
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
                       system.debug(LoggingLevel.INFO, 'specialityCheck: ' + specialityCheck); 
                       if(String.isNotBlank(specialityCheck)) {                        
                            Provider.speciality = specialityCheck;
                        }else{
                           
                        //   system.debug('ACETFindHCOJSON2Apex.Specialty >>> ' + SRProvider.Specialty.size() + ' *** SRProvider.Specialty >>> ' + SRProvider.Specialty);
                           for(ACETFindHCOJSON2Apex.Specialty Specialty :SRProvider.Specialty){
                        //       system.debug('Specialty.primarySpecialtyIndicator**'+Specialty.primarySpecialtyIndicator + ' *** Specialty.typeCode *** ' + Specialty.typeCode  );
                                if(Specialty.primarySpecialtyIndicator == 'Y'){
                                  //@Rama:: Sprint 4 Change- Description to Code 
                                  
                                     if(String.isNotBlank(Specialty.typeCode)){
                             //            system.debug('mapTaxonomyMDT.size >>> ' + mapTaxonomyMDT.size() + ' ** mapTaxonomyMDT.get(Specialty.typeCode).Speciality_Code__c ** ' + mapTaxonomyMDT.get(Specialty.typeCode));
                                          
                                          String strtypecode = (mapTaxonomyMDT.get(Specialty.typeCode) != null ) ? mapTaxonomyMDT.get(Specialty.typeCode).Speciality_Code__c : '';
                                          //system.debug('mapTaxonomyMDT.size >>> ' + mapTaxonomyMDT.size() + ' *** ' + 'typecodeMDT ** ' + strtypecode + ' ***mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c***' + mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c);
                                        // Provider.speciality = (strtypecode != null) ? ((mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c != null)?mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c: Specialty.typeCode) : Specialty.typeCode;
                              //            system.debug('strtypecode >>> ' + strtypecode);
                                          if(String.isNotBlank(strtypecode)){
                                              Provider.speciality = (mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c != null) ? mapTaxonomyMDT.get(Specialty.typeCode).Speciality__c : strtypecode;
                                          }else{
                                             Provider.speciality = Specialty.typeCode;
                                          }
                                          
                                          //Provider.speciality = Specialty.typeCode;
                                          //Provider.speciality = Specialty.typeDescription;
                                    }
                                }
                            }                            
                        }
                        
                        /* Added by Avish on 06122017 for displaying Platinum code on UI ***/
                        system.debug(LoggingLevel.INFO,'SRProvider.Tpsm:: ' + SRProvider.Tpsm);
                        if(SRProvider.Tpsm!=null){
                            for(ACETFindHCOJSON2Apex.Tpsm platinum :SRProvider.Tpsm) {
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
                        
                        system.debug('Provider *** ' + Provider);
                        Providers.add(Provider);
                        
                    }
                }else
                {
                    oACETWSCalloutResult = ParseFailureResponse(Response);
                    system.debug('oACETWSCalloutResult for ParseFailureResponse'+ oACETWSCalloutResult);
                    oACETWSCalloutResult.Success = false;
                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
                }
            
            }
            else
            {
                oACETWSCalloutResult = ParseFailureResponse(Response);
                system.debug('oACETWSCalloutResult for ParseFailureResponse'+ oACETWSCalloutResult);
               // oACETWSCalloutResult.Success = false;
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