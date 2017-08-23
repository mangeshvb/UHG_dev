public class ACETFindProviderLookupWebservice extends ACETWebservice
{
    public String providerType;
    private Map<String, Provider_Taxonomy__mdt> mapTaxonomyMDT = new Map<String, Provider_Taxonomy__mdt>();
    private String specialityCheck;
    public ACETProviderUtility providerUtility = new ACETProviderUtility();
    
    public void Init(String ProviderId, String NPI, String TIN, String LastName, String FirstName, String GenderCode, 
        String SpecialtyTypeCode, String PostalPrefixCode, String Distance, String City, String StateCode,
        String PhoneNumber, String NetworkSchedule, String NetworkBenefitPlan, String NewPatientIndicator, String ExistingPatientIndicator, 
        String LanguageCode, String ProviderTypeCode) {
        system.debug(LoggingLevel.INFO, 'Provider Id: ' + ProviderId + ', NPI: ' + NPI + ', TIN: ' + TIN);
        system.debug(LoggingLevel.INFO, 'Last Name: ' + LastName + ', First Name: ' + FirstName + ', Gender Code: ' + GenderCode);
        system.debug(LoggingLevel.INFO, 'Specialty Type Code: ' + SpecialtyTypeCode + ', Postal Prefix Code: ' + PostalPrefixCode + ', Distance: ' + Distance);
        system.debug(LoggingLevel.INFO, 'City: ' + City + ', State Code: ' + StateCode + ', Phone Number: ' + PhoneNumber);
        system.debug(LoggingLevel.INFO, 'Network Schedule: ' + NetworkSchedule + ', Network Benefit Plan: ' + NetworkBenefitPlan + ', New Patient Indicator: ' + NewPatientIndicator);
        system.debug(LoggingLevel.INFO, 'Existing Patient Indicator: ' + ExistingPatientIndicator + ', Language Code: ' + LanguageCode + ', Provider Type Code: ' + ProviderTypeCode);
        ProviderId = String.isNotBlank(ProviderId) ? ProviderId : '';
        NPI = String.isNotBlank(NPI) ? NPI : '';
        TIN = String.isNotBlank(TIN) ? TIN : '';
        GenderCode = String.isNotBlank(GenderCode) ? GenderCode : '';
        SpecialtyTypeCode = String.isNotBlank(SpecialtyTypeCode) ? SpecialtyTypeCode : '';
        PostalPrefixCode = String.isNotBlank(PostalPrefixCode) ? PostalPrefixCode : '';
        Distance = String.isNotBlank(Distance) ? Distance : '';
        StateCode = String.isNotBlank(StateCode) ? StateCode : '';
        NetworkSchedule = String.isNotBlank(NetworkSchedule) ? NetworkSchedule : '';
        NetworkBenefitPlan = String.isNotBlank(NetworkBenefitPlan) ? NetworkBenefitPlan : '';
        NewPatientIndicator = String.isNotBlank(NewPatientIndicator) ? NewPatientIndicator : '';
        ExistingPatientIndicator = String.isNotBlank(ExistingPatientIndicator) ? ExistingPatientIndicator : '';
        LanguageCode = String.isNotBlank(LanguageCode) ? LanguageCode : '';
        ProviderTypeCode = String.isNotBlank(ProviderTypeCode) ? ProviderTypeCode : '';
        
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
        City = String.isNotBlank(City) ? City.toUpperCase() : '';
        GenderCode = GenderCode == 'Male' ? 'M' : GenderCode == 'Female' ? 'F' : '';
        RequestParameters = new List<String>{ProviderId, NPI, TIN, LastName, FirstName, GenderCode, SpecialtyTypeCode, PostalPrefixCode, 
            Distance, City, StateCode, PhoneTypeCode, AreaCode, Phone, NetworkSchedule, NetworkBenefitPlan, NewPatientIndicator, 
            ExistingPatientIndicator, LanguageCode, ProviderTypeCode};
        this.specialityCheck = SpecialtyTypeCode;
        mapTaxonomyMDT = providerUtility.getProviderTaxonomy();
        if (String.isNotBlank(SpecialtyTypeCode)) {
            this.specialityCheck = mapTaxonomyMDT.get(SpecialtyTypeCode).Speciality__c;
        }       
    }
    
    public override void GetEndpoint()
    {
        GetEndpointDetail('findMedicalProviderAdapterEndpoint');
    }
    
    private void GetRequestBody() {
        RequestBody = GetRequestBody('ACETFindMedicalProvidersRequestJSON', RequestParameters);     
    }
    
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord) {
        system.debug(LoggingLevel.INFO, 'Page Number: ' + pageNumber + ', Page Size: ' + pageSize + ', Start Record: ' + startRecord);
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProviderLookupController.ProviderLookupResult> Providers = new List<ACETProviderLookupController.ProviderLookupResult>();
        ACETProviderLookupController.ProviderLookupResult Provider;
        List<ACETFindMedclProvidrLookupSrvceJSON2Apex.medicalProviders> SRProviders;
        ACETOILPagination Pagination;
        
        try
        {
            RequestParameters.AddAll(new List<String>{String.valueOf(pageNumber), String.valueOf(PageSize), String.valueOf(startRecord)});
            GetRequestBody();
            HttpResponse Response = Send(OAuthConfig);
            if (Response.getStatusCode() == 200 || Response.getStatusCode() == 400)
            {
                ACETFindMedclProvidrLookupSrvceJSON2Apex ACETJSON2Apex = (ACETFindMedclProvidrLookupSrvceJSON2Apex)JSON.deserialize(Response.getBody(), ACETFindMedclProvidrLookupSrvceJSON2Apex.class);
                system.debug(LoggingLevel.INFO, 'ACETFindProviderLookupWS. ACETJSON2Apex:' + ACETJSON2Apex); 
                if (ACETJSON2Apex.findMedicalProvidersResult.findMedicalProvidersResponseType.errors == null) { 
                    Pagination = ACETJSON2Apex.findMedicalProvidersResult.findMedicalProvidersResponseType.pagination;
                    if (Integer.valueOf(Pagination.totalCount) > 0)
                    {
                        oACETWSCalloutResult.pageNumber = Pagination.pageNumber;
                        oACETWSCalloutResult.pageSize = Pagination.pageSize;
                        oACETWSCalloutResult.recordCount = Pagination.recordCount;
                        oACETWSCalloutResult.totalCount = Pagination.totalCount;
                        oACETWSCalloutResult.totalPages = Pagination.totalPages;
                        SRProviders = ACETJSON2Apex.findMedicalProvidersResult.findMedicalProvidersResponseType.medicalProviders;
                        system.debug(LoggingLevel.INFO, 'SRProviders: ' + SRProviders);
                        for (ACETFindMedclProvidrLookupSrvceJSON2Apex.medicalProviders SRProvider: SRProviders)
                        {
                            Provider = new ACETProviderLookupController.ProviderLookupResult();
                            if(String.isNotBlank(SRProvider.address.distance)){
                                Provider.radious = SRProvider.address.distance;
                            }
                            if(String.isNotBlank(SRProvider.key.providerId)){
                                Provider.providerId = SRProvider.key.providerId; 
                            }
                            if(String.isNotBlank(SRProvider.providerTIN.id)){
                                Provider.taxId = SRProvider.providerTIN.id;
                            }
                            if(String.isNotBlank(SRProvider.providerTIN.typeCode)){
                                Provider.providerTINTypeCode = SRProvider.providerTIN.typeCode;
                            }
                            if(String.isNotBlank(SRProvider.providerTIN.statusCode)){
                                Provider.providerTINStatusCode = SRProvider.providerTIN.statusCode;
                            }                        
                            if(String.isNotBlank(SRProvider.address.addressId)){
                                Provider.addressId = SRProvider.address.addressId;
                            }
                            if(String.isNotBlank(SRProvider.address.typeCode)){
                                Provider.addressTypeCode = SRProvider.address.typeCode;
                            }
                            Provider.fullName = '';
                            if(String.isNotBlank(SRProvider.healthcareProvider.providerTypeCode)){
                                if(SRProvider.healthcareProvider.providerTypeCode == 'HCO'){
                                    Provider.providerTypeCode = SRProvider.healthcareProvider.providerTypeCode;
                                    
                                    if(String.isNotBlank(SRProvider.healthcareProvider.name)){
                                        Provider.fullName = SRProvider.healthcareProvider.name;
                                    }
                                    Provider.providerType = 'Facility';
                                }else if(SRProvider.healthcareProvider.providerTypeCode == 'HCP'){
                                    Provider.providerTypeCode = SRProvider.healthcareProvider.providerTypeCode;
                                    
                                    if(String.isNotBlank(SRProvider.healthcareProvider.providerFirstName)){
                                        Provider.fullName = SRProvider.healthcareProvider.providerFirstName;
                                    }
                                    if(String.isNotBlank(SRProvider.healthcareProvider.providerMiddleName)){
                                         Provider.fullName +=  ' ' + SRProvider.healthcareProvider.providerMiddleName;
                                    } 
                                    if(String.isNotBlank(SRProvider.healthcareProvider.name)){
                                         Provider.fullName +=  ' ' + SRProvider.healthcareProvider.name;
                                    }                                                                
                                    if(String.isNotBlank(SRProvider.healthcareProvider.providerNameSuffix)){
                                         Provider.fullName +=  ' ' + SRProvider.healthcareProvider.providerNameSuffix;
                                    } 
                                    Provider.providerType = 'Physician';
                                }
                            }   
                            Provider.address = '';
                            Provider.street = '';
                            if(String.isNotBlank(SRProvider.address.addressLine1)){
                                Provider.address = SRProvider.address.addressLine1;
                                Provider.street = SRProvider.address.addressLine1;
                            }
                            if (String.isNotBlank(SRProvider.address.addressLine2))
                            {
                                Provider.address += ' ' + SRProvider.address.addressLine2;
                                Provider.street  += ' ' + SRProvider.address.addressLine2;
                            }
                            if (String.isNotBlank(SRProvider.address.city)){
                                Provider.address += ' ' + SRProvider.address.city;
                                Provider.city = SRProvider.address.city;
                            }
                            if (String.isNotBlank(SRProvider.address.stateCode)){
                                Provider.address += ' ' + SRProvider.address.stateCode;
                                Provider.state = SRProvider.address.stateCode;
                            }
                            if (String.isNotBlank(SRProvider.address.postalPrefixCode)){
                                Provider.address += ' ' + SRProvider.address.postalPrefixCode;
                                Provider.zipCode = SRProvider.address.postalPrefixCode;
                            }                                                 
    
							for(ACETFindMedclProvidrLookupSrvceJSON2Apex.phone phone :SRProvider.phone){
								if(phone.primaryPhoneIndicator == 'Y'){
									if (phone.phoneTypeCode == 'TEL'){
										if (String.isNotBlank(phone.phoneNumber)){
											Provider.phoneNumber = '(' + phone.areaCode + ')';
											Provider.phoneNumber += + ' ' + phone.phoneNumber.substring(0, 3) + '-';
											Provider.phoneNumber += phone.phoneNumber.substring(3);
										}    
									} 
								}  
							}
                           
							if (String.isNotBlank(specialityCheck)) {                        
                                Provider.speciality = specialityCheck;
                            } else {                    
                                for(ACETFindMedclProvidrLookupSrvceJSON2Apex.Specialty Specialty :SRProvider.Specialty){
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
                            if(SRProvider.healthcareProvider!=null){
								if(String.isNotBlank(SRProvider.healthcareProvider.providerGenderCode)){
									Provider.gender = SRProvider.healthcareProvider.providerGenderCode;
								}
                            }
                            if(SRProvider.Tpsm!=null){
                                for(ACETFindMedclProvidrLookupSrvceJSON2Apex.Tpsm platinum :SRProvider.Tpsm) {
                                    if(platinum != null){
                                        if(platinum.code == '99Z' || String.isBlank(platinum.code)){
                                            Provider.platinum = '';                                        
                                        }else{
                                            Provider.platinum = 'Yes - ' +  platinum.code;   
                                        }
                                    }
                                }     
                            }
                            if(SRProvider.premiumDesignation!=null) {                        
								if(String.isNotBlank(SRProvider.premiumDesignation[0].qualityTypeDescription) && String.isNotBlank(SRProvider.premiumDesignation[0].efficiencyTypeDescription)){
									Provider.uphd ='Q - ' + SRProvider.premiumDesignation[0].qualityTypeDescription
								         + 'E - ' + SRProvider.premiumDesignation[0].efficiencyTypeDescription;
								}
                          	}
                          	
							if (SRProvider.Role!=null)  {
								for (ACETFindMedclProvidrLookupSrvceJSON2Apex.Role Role :SRProvider.Role) {
									if (role != null) {
	                                	if (String.isNotBlank(role.code)) {
	                                    	Provider.PCPRole = role.code;
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
                    oACETWSCalloutResult.Message = GetOILErrorMessage(ACETJSON2Apex.findMedicalProvidersResult.findMedicalProvidersResponseType.errors);
                    oACETWSCalloutResult.Response = null;
                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
                }
            }
            else
            {
                oACETWSCalloutResult = ParseFailureResponse(Response);
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
     
    private void GetRequestBody(String strTaxId, String strNPI, String strLastName, String strFirstName, String strState,string strCity, String strZipCode, 
                        String strPhoneNumber, String strproviderType, String strRadius,String strproviderId, String strnetworkType,String strGender, String strLanguage,string strSpeciality,String strNewpatientsInd, String strexistingpatientsInd, String StrbenefitPlanId)
    {         
        
        String strstaticfilename = 'findMedicalProviderAdapterTemplate'; 
            
        StaticResource sr = [SELECT Id,NamespacePrefix,SystemModstamp FROM StaticResource WHERE Name = :strstaticfilename LIMIT 1];
        String prefix = sr.NamespacePrefix;
        if( String.isEmpty(prefix) ) {
           prefix = '';
        } else {
           //If has NamespacePrefix
           prefix += '__';
        }
        String srPath = '/resource/' + sr.SystemModstamp.getTime() + '/' + prefix + strstaticfilename; 
        PageReference pg = new PageReference(srPath);
         
        //Added for covering in the test class  
        if(!Test.isRunningTest())
        {        
            RequestBody = pg.getContent().toString();
        }
        else 
        {
            RequestBody = 'UNIT.TEST';
        }
        //////End of the covering Test Class    
        
        RequestBody = (strTaxId != null) ? RequestBody.replace('@@providerTIN@@',strTaxId) : RequestBody.replace('@@providerTIN@@', '') ;
        RequestBody =  (strNPI != null) ? RequestBody.replace('@@npi@@',strNPI) : RequestBody.replace('@@npi@@', '') ;
     //   RequestBody = (strLastName != null) ? RequestBody.replace('@@providerLastNameOrOrganizationName@@',strLastName) : RequestBody.replace('@@providerLastNameOrOrganizationName@@', '') ;
        RequestBody = (strLastName != null) ? RequestBody.replace('@@name@@',strLastName) : RequestBody.replace('@@name@@', '') ;
        RequestBody = (strFirstName != null) ? RequestBody.replace('@@providerFirstName@@',strFirstName) : RequestBody.replace('@@providerFirstName@@', '') ; 
        RequestBody = (strState!= null)  ? RequestBody.replace('@@addressStateCode@@',strState) : RequestBody.replace('@@addressStateCode@@', '') ;
        RequestBody = (strZipCode!= null) ? RequestBody.replace('@@addressPostalPrefixCode@@',strZipCode) : RequestBody.replace('@@addressPostalPrefixCode@@', '') ;
       
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
        RequestBody = (strproviderId != null) ? RequestBody.replace('@@providerId@@',strproviderId) : RequestBody.replace('@@providerId@@', '') ;
        RequestBody = (strnetworkType != null) ? RequestBody.replace('@@networkId@@',strnetworkType) : RequestBody.replace('@@networkId@@', '') ;
        RequestBody = (strGender != null) ? RequestBody.replace('@@providerGenderCode@@',strGender) : RequestBody.replace('@@providerGenderCode@@', '') ;
        RequestBody = (strRadius != null) ? RequestBody.replace('@@addressDistance@@',strRadius) : RequestBody.replace('@@addressDistance@@', '') ;
        RequestBody = (strLanguage != null) ? RequestBody.replace('@@languageCode@@',strLanguage) : RequestBody.replace('@@languageCode@@', '') ;
        RequestBody = (strCity!= null) ? RequestBody.replace('@@addressCity@@',strCity) : RequestBody.replace('@@addressCity@@', '') ;
        RequestBody = (strSpeciality!= null) ? RequestBody.replace('@@specialtyTypeCode@@',strSpeciality) : RequestBody.replace('@@specialtyTypeCode@@', '') ;
        RequestBody = (strNewpatientsInd != null) ? RequestBody.replace('@@acceptingNewPatientIndicator@@',strNewpatientsInd) : RequestBody.replace('@@acceptingNewPatientIndicator@@', '') ;
        RequestBody = (strexistingpatientsInd != null) ? RequestBody.replace('@@acceptingExistingPatientIndicator@@',strexistingpatientsInd) : RequestBody.replace('@@acceptingExistingPatientIndicator@@', '') ;  
        RequestBody = (strproviderType != null) ? RequestBody.replace('@@providerTypeCode@@',strproviderType) : RequestBody.replace('@@providerTypeCode@@', '') ;
        //Added benefitPlanId as parameter by Avish as a part of US596131
        RequestBody = (StrbenefitPlanId != null) ? RequestBody.replace('@@networkBenefitPlan@@',StrbenefitPlanId) : RequestBody.replace('@@networkBenefitPlan@@', '') ;
        
        system.debug('*** my json' + RequestBody ); 
    }
       
    //Webservice method to call Provider Lookup service
    public ACETWSCalloutResult FindProviders(String TaxId, String NPI, String providerId, String networkType, String LastName, String PhoneNumber, String providerType, 
                                    String FirstName, String city, String specialityType, String language, String state, String radius, String gender,String ZipCode,String NewpatientsInd,String existingpatientsInd,String benefitPlanId){
        
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETProviderLookupController.ProviderLookupResult> Providers = new List<ACETProviderLookupController.ProviderLookupResult>();
        ACETProviderLookupController.ProviderLookupResult Provider;
        List<ACETFindMedclProvidrLookupSrvceJSON2Apex.medicalProviders> SRProviders;
        
        try
        {
            this.providerType = providerType;
            GetEndpoint();
            this.specialityCheck = specialityType;
            
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
            
            GetRequestBody(TaxId, NPI, LastName, FirstName, State,City, ZipCode,PhoneNumber,providerType,radius,providerId, networkType,gender,language,specialityType,NewpatientsInd,existingpatientsInd,benefitPlanId);
            mapTaxonomyMDT = providerUtility.getProviderTaxonomy();
            if(String.isNotBlank(specialityType))
                this.specialityCheck = mapTaxonomyMDT.get(specialityType).Speciality__c;   
                          
            HttpResponse Response = Send(OAuthConfig);
            // HttpResponse Response = new HttpResponse();
            System.debug('Response >>> ' + Response);
            
            //Start of Hardcode response -- Comment this block when webservice is up
            // Response.setStatusCode(200);
            // Response.setBody(ACETTestDataUtility.findMedicalProviderCallableJSON());
            //End of Hardcode response -- Comment this block when webservice is up 
            
            
            //Start of Hardcode response -- Comment this block when webservice is up
            // Response.setStatusCode(200);
            // Response.setBody(ACETTestDataUtility.findMedicalProviderCallableJSON2());
            //End of Hardcode response -- Comment this block when webservice is up 
            
            if (Response.getStatusCode() == 200)
            {
                ACETFindMedclProvidrLookupSrvceJSON2Apex ACTFPJSON2Apex = (ACETFindMedclProvidrLookupSrvceJSON2Apex)JSON.deserialize(Response.getBody(), ACETFindMedclProvidrLookupSrvceJSON2Apex.class);
                system.debug('ACTFPJSON2Apex : ' + ACTFPJSON2Apex);
                SRProviders = ACTFPJSON2Apex.findMedicalProvidersResult.findMedicalProvidersResponseType.medicalProviders;
                system.debug('SRProviders'+SRProviders);
                if (SRProviders != null && SRProviders.size() > 0 )
                {
                    for (ACETFindMedclProvidrLookupSrvceJSON2Apex.medicalProviders SRProvider: SRProviders)
                    {
                        Provider = new ACETProviderLookupController.ProviderLookupResult();
                        if(String.isNotBlank(SRProvider.address.distance)){
                            Provider.radious = SRProvider.address.distance;
                        }
                        
                        //getHCO and getHCO Request params:START
                        if(String.isNotBlank(SRProvider.key.providerId)){
                            Provider.providerId = SRProvider.key.providerId; 
                        }
                        if(String.isNotBlank(SRProvider.providerTIN.id)){
                            Provider.taxId = SRProvider.providerTIN.id;
                        }
                        if(String.isNotBlank(SRProvider.providerTIN.typeCode)){
                            Provider.providerTINTypeCode = SRProvider.providerTIN.typeCode;
                        }
                        if(String.isNotBlank(SRProvider.providerTIN.statusCode)){
                            Provider.providerTINStatusCode = SRProvider.providerTIN.statusCode;
                        }                        
                        if(String.isNotBlank(SRProvider.address.addressId)){
                            Provider.addressId = SRProvider.address.addressId;
                        }
                        if(String.isNotBlank(SRProvider.address.typeCode)){
                            Provider.addressTypeCode = SRProvider.address.typeCode;
                        }
                       //getHCO and getHCO Request params:END
                        
                        
                       // Provider.fullName ---> need mapping field from json to map here
                       Provider.fullName = '';
                       if(String.isNotBlank(SRProvider.healthcareProvider.providerTypeCode)){
                            if(SRProvider.healthcareProvider.providerTypeCode == 'HCO'){
                                Provider.providerTypeCode = SRProvider.healthcareProvider.providerTypeCode;
                                
                                if(String.isNotBlank(SRProvider.healthcareProvider.name)){
                                    Provider.fullName = SRProvider.healthcareProvider.name;
                                }
                                Provider.providerType = 'Facility';
                            }else if(SRProvider.healthcareProvider.providerTypeCode == 'HCP'){
                                Provider.providerTypeCode = SRProvider.healthcareProvider.providerTypeCode;
                                
                                if(String.isNotBlank(SRProvider.healthcareProvider.providerFirstName)){
                                    Provider.fullName = SRProvider.healthcareProvider.providerFirstName;
                                }
                                if(String.isNotBlank(SRProvider.healthcareProvider.providerMiddleName)){
                                     Provider.fullName +=  ' ' + SRProvider.healthcareProvider.providerMiddleName;
                                } 
                                if(String.isNotBlank(SRProvider.healthcareProvider.name)){
                                     Provider.fullName +=  ' ' + SRProvider.healthcareProvider.name;
                                }                                                                
                                if(String.isNotBlank(SRProvider.healthcareProvider.providerNameSuffix)){
                                     Provider.fullName +=  ' ' + SRProvider.healthcareProvider.providerNameSuffix;
                                } 
                                Provider.providerType = 'Physician';
                            }
                        }   
                       // Provider.fullName = SRProvider.healthcareProvider.name;
                   /*     if(SRProvider.healthcareProvider.providerTypeCode == 'HCO'){
                            Provider.providerType = 'Facility';
                        }else if(SRProvider.healthcareProvider.providerTypeCode == 'HCP'){
                            Provider.providerType = 'Physician';
                        }    */
                        Provider.address = '';
                        Provider.street = '';
                        if(String.isNotBlank(SRProvider.address.addressLine1)){
                            Provider.address = SRProvider.address.addressLine1;
                            Provider.street = SRProvider.address.addressLine1;
                        }
                        if (String.isNotBlank(SRProvider.address.addressLine2))
                        {
                            Provider.address += ' ' + SRProvider.address.addressLine2;
                            Provider.street  += ' ' + SRProvider.address.addressLine2;
                        }
                        if (String.isNotBlank(SRProvider.address.city)){
                            Provider.address += ' ' + SRProvider.address.city;
                            Provider.city = SRProvider.address.city;
                        }
                        if (String.isNotBlank(SRProvider.address.stateCode)){
                            Provider.address += ' ' + SRProvider.address.stateCode;
                            Provider.state = SRProvider.address.stateCode;
                        }
                        if (String.isNotBlank(SRProvider.address.postalPrefixCode)){
                            Provider.address += ' ' + SRProvider.address.postalPrefixCode;
                            Provider.zipCode = SRProvider.address.postalPrefixCode;
                        }                                                 

                    for(ACETFindMedclProvidrLookupSrvceJSON2Apex.phone phone :SRProvider.phone){
                    if(phone.primaryPhoneIndicator == 'Y'){
                        if (phone.phoneTypeCode == 'TEL'){
                              if (String.isNotBlank(phone.phoneNumber)){
                                Provider.phoneNumber = '(' + phone.areaCode + ')';
                                Provider.phoneNumber += + ' ' + phone.phoneNumber.substring(0, 3) + '-';
                                Provider.phoneNumber += phone.phoneNumber.substring(3);
                            }    
                            
                        } 
                     }
                }
                       if(String.isNotBlank(specialityCheck)) {                        
                            Provider.speciality = specialityCheck;
                        }else{                    
                            for(ACETFindMedclProvidrLookupSrvceJSON2Apex.Specialty Specialty :SRProvider.Specialty){
                                system.debug('Specialty.primarySpecialtyIndicator**'+Specialty.primarySpecialtyIndicator + ' *** Specialty.typeCode *** ' + Specialty.typeCode  );
                                if(Specialty.primarySpecialtyIndicator == 'Y'){
                                    //@Rama:: Sprint 4 Change- Description to Code 
                                    
                                    if(String.isNotBlank(Specialty.typeCode)){
                                        system.debug('mapTaxonomyMDT.size >>> ' + mapTaxonomyMDT.size() + ' ** mapTaxonomyMDT.get(Specialty.typeCode).Speciality_Code__c ** ' + mapTaxonomyMDT.get(Specialty.typeCode));
                                        
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
                        }
                        if(SRProvider.healthcareProvider!=null){
                            if(String.isNotBlank(SRProvider.healthcareProvider.providerGenderCode)){
                            Provider.gender = SRProvider.healthcareProvider.providerGenderCode;
                         }
                        }
                        
                        /* Added by Avish on 06122017 for displaying Platinum code on UI ***/
                        if(SRProvider.Tpsm!=null){
                         /*   if(String.isNotBlank(SRProvider.Tpsm[0].code)){
                                Provider.platinum = SRProvider.Tpsm[0].code;
                            }    */
                            for(ACETFindMedclProvidrLookupSrvceJSON2Apex.Tpsm platinum :SRProvider.Tpsm) {
                                if(platinum != null){
                                    if(platinum.code == '99Z' || String.isBlank(platinum.code)){
                                        Provider.platinum = '';                                        
                                    }else{
                                        Provider.platinum = 'Yes - ' +  platinum.code;   
                                    }
                                }
                            }    
                        }
                        /*** end of tpsm code **/
                     
                      if(SRProvider.premiumDesignation!=null) {                        
                          if(String.isNotBlank(SRProvider.premiumDesignation[0].qualityTypeDescription) && String.isNotBlank(SRProvider.premiumDesignation[0].efficiencyTypeDescription)){
                              Provider.uphd ='Q - ' + SRProvider.premiumDesignation[0].qualityTypeDescription
                                  + 'E - ' + SRProvider.premiumDesignation[0].efficiencyTypeDescription;
                          }
                      } 
                      if(SRProvider.Role!=null)  {
                  for(ACETFindMedclProvidrLookupSrvceJSON2Apex.Role Role :SRProvider.Role) {
                              if(role!=null) {
                                if(String.isNotBlank(role.code)){
                                    Provider.PCPRole = role.code;
                                }
                              }
                    }
                   }
                     //     Provider.PCPRole = '';
                        Providers.add(Provider);
                    }
               
                    system.debug('Providers Size :: ' + Providers.size());
                }else{
                    oACETWSCalloutResult.Success = false;
                    oACETWSCalloutResult.Message = '';
                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;                    
                }    
            }
            else
            {
                oACETWSCalloutResult = ParseFailureResponse(Response);
                system.debug('oACETWSCalloutResult for ParseFailureResponse'+ oACETWSCalloutResult);
                
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
            }
            if (Providers.size() > 0)
            {     
                system.debug('Providers Size *** ' + Providers.size());          
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