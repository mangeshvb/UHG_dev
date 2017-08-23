public with sharing class ACETGetHCPWebservice extends ACETWebservice {
    public String returningFromService;
    private Map<String, Provider_Taxonomy__mdt> mapTaxonomyMDT = new Map<String, Provider_Taxonomy__mdt>();
    public ACETProviderUtility providerUtility = new ACETProviderUtility();
    
    public override void GetEndpoint() {
      /*  if (returningFromService == 'providerSearch') {
            GetEndpointDetail('getHCPEndpoint');
        } else if(returningFromService == 'providerLookup') {   */
            GetEndpointDetail('getHCPAdapterEndpoint');
    //    }    
    }
    
    private void GetRequestBody(String ProviderId, String TaxID,String strProviderTINTypeCode, String strAddressId, String strAddressTypeCode) {                
     /*   if (returningFromService == 'providerSearch') {
            RequestBody = GetRequestFormatByName('getHCP_HardcodedRequest');
        } else if(returningFromService == 'providerLookup') {        */   
            String strstaticfilename = 'getHCP_AdapterRequestTemplate';        
            StaticResource resourceFile = [SELECT Id,NamespacePrefix,SystemModstamp FROM StaticResource WHERE Name = :strstaticfilename LIMIT 1];
            String prefix = resourceFile.NamespacePrefix;
            if( String.isEmpty(prefix) ) {
                prefix = '';
            } else {
                prefix += '__';
            }
            String srPath = '/resource/' + resourceFile.SystemModstamp.getTime() + '/' + prefix + strstaticfilename; 
            PageReference pageRef = new PageReference(srPath);
            
            if(!Test.isRunningTest())
            {        
                RequestBody = pageRef.getContent().toString();
            }
            else 
            {
                RequestBody = 'UNIT.TEST';
            }
            
            RequestBody = (TaxId != null) ? RequestBody.replace('@@providerTIN@@',TaxId) : RequestBody.replace('@@providerTIN@@', ''); 
            RequestBody = (ProviderId != null) ? RequestBody.replace('@@providerId@@',ProviderId) : RequestBody.replace('@@providerId@@', '');
            RequestBody = (strProviderTINTypeCode != null) ? RequestBody.replace('@@providerTINTypeCode@@',strProviderTINTypeCode) : RequestBody.replace('@@providerTINTypeCode@@', '');                
            RequestBody = (strAddressId != null)  ? RequestBody.replace('@@addressId@@',strAddressId) : RequestBody.replace('@@addressId@@', '') ;
            RequestBody = (strAddressTypeCode != null) ? RequestBody.replace('@@addressTypeCode@@',strAddressTypeCode) : RequestBody.replace('@@addressTypeCode@@', '') ;             
     //   }
    }
    @TestVisible
    private ACETProviderDetailController.ACETProviderDetail ParseSuccessResponse(String ResponseBody)  {
        //ACETGetHCPJSON2Apex ACTGPJSON2Apex;
        ACETGetHCPAdapterJSON2Apex ACTGetHCPJSON2Apex,ACTGPJSON2Apex,ACTGetHCPJSON2Apex1;
        ACETProviderDetailController.ACETProviderDetail providerDetail = new ACETProviderDetailController.ACETProviderDetail();
        
        if (returningFromService == 'providerSearch') {        
          //  ACTGPJSON2Apex = (ACETGetHCPJSON2Apex)JSON.deserialize(ResponseBody, ACETGetHCPJSON2Apex.class);
         //   system.debug(LoggingLevel.INFO, 'returningFromService*** ' + returningFromService + ', ACTGPJSON2Apex *** ' + ACTGPJSON2Apex);
         //   ACETGetHCPJSON2Apex.medicalHealthcareProfessional generalInformation = ACTGPJSON2Apex.GetMedicalHealthcareProfessionalResponse.getMedicalHealthcareProfessionalResponseType.medicalHealthcareProfessional;
            ACTGPJSON2Apex = (ACETGetHCPAdapterJSON2Apex)JSON.deserialize(ResponseBody, ACETGetHCPAdapterJSON2Apex.class);
            if(ACTGPJSON2Apex.getMedicalHealthcareProfessionalResult != null){
                if(ACTGPJSON2Apex.getMedicalHealthcareProfessionalResult.getMedicalHealthcareProfessionalResponseType != null){
                if(ACTGPJSON2Apex.getMedicalHealthcareProfessionalResult.getMedicalHealthcareProfessionalResponseType.MedicalHealthcareProfessional != null){
                    ACETGetHCPAdapterJSON2Apex.MedicalHealthcareProfessional generalInformation = ACTGPJSON2Apex.getMedicalHealthcareProfessionalResult.getMedicalHealthcareProfessionalResponseType.MedicalHealthcareProfessional;            
                    providerDetail.generalInfo.lastName = generalInformation.hcp.providerLastName + '' + generalInformation.hcp.providerNameSuffix;
                    providerDetail.generalInfo.firstName = !String.isBlank(generalInformation.hcp.providerFirstName) ? generalInformation.hcp.providerFirstName : '';
                    if(String.isnotblank(generalInformation.providerTIN.id)){
                        providerDetail.generalInfo.taxId = generalInformation.providerTIN.id;
                    }
                    if(String.isnotblank(generalInformation.npi[0].id)){
                        providerDetail.generalInfo.npi = generalInformation.npi[0].id;
                    }
                    if(String.isnotblank(generalInformation.hcp.providerId)){
                        providerDetail.generalInfo.providerID = generalInformation.hcp.providerId;
                    }
                    if(String.isnotblank(generalInformation.providerTIN.owner)){
                        providerDetail.generalInfo.providerTINOwner = generalInformation.providerTIN.owner;
                    }
                               
                    //Speciality section mapping logic
                    List<ACETGetHCPAdapterJSON2Apex.Specialty> practiceInformationLst = new List<ACETGetHCPAdapterJSON2Apex.Specialty>();
                    practiceInformationLst = ACTGPJSON2Apex.getMedicalHealthcareProfessionalResult.getMedicalHealthcareProfessionalResponseType.medicalHealthcareProfessional.specialty;
                    if(practiceInformationLst != null) {
                        for(Integer index = 0; index < practiceInformationLst.size(); index++) {
                            ACETProviderDetailController.ACETProviderSpeciality specialityObj = new ACETProviderDetailController.ACETProviderSpeciality();
                            
                            system.debug(LoggingLevel.INFO,'primarySpeciality :: ' + practiceInformationLst[index].primarySpecialtyIndicator);
                            system.debug(LoggingLevel.INFO,'typeDescription :: ' + practiceInformationLst[index].typeDescription);
                            system.debug(LoggingLevel.INFO,'cancelDate :: ' + practiceInformationLst[index].cancelDate);  
                            String typeCodeCMD = practiceInformationLst[index].typeCode;  
                            system.debug(LoggingLevel.INFO,'typeCode :: ' + typeCodeCMD);
                                            
                            if(String.isNotBlank(practiceInformationLst[index].primarySpecialtyIndicator)) {
                                specialityObj.primarySpeciality = practiceInformationLst[index].primarySpecialtyIndicator;
                            }else{
                                specialityObj.primarySpeciality = 'N';
                            }
        
                            if(String.isNotBlank(practiceInformationLst[index].cancelDate)) {
                                specialityObj.cancelDate = ChangeDateFormat(practiceInformationLst[index].cancelDate);
                            } 
                             
                            /*** Added this snippet as a part of US638204 by Avish on 05192017 ***/
                             
                            if(String.isNotBlank(practiceInformationLst[index].typeCode)) {
                                mapTaxonomyMDT = providerUtility.getProviderTaxonomy();
                                if(mapTaxonomyMDT.get(typeCodeCMD) != null ){
                                    system.debug(LoggingLevel.INFO,'Speciality__c:: ' + typeCodeCMD);
                                    specialityObj.speciality = (mapTaxonomyMDT.get(typeCodeCMD).Speciality__c != null) ? mapTaxonomyMDT.get(typeCodeCMD).Speciality__c : typeCodeCMD;
                                }else{
                                    specialityObj.speciality = typeCodeCMD;
                                }
                            }    
                          if(String.isNotBlank(practiceInformationLst[index].BoardCertification.boardCertificationCode)){
                              if(practiceInformationLst[index].BoardCertification.boardCertificationCode == 'C')
                                  specialityObj.boardCert = 'Yes';
                              else
                                  specialityObj.boardCert = 'No';
                          }else{
                              specialityObj.boardCert = 'No';
                          }                    
                            /***** End of Code ***/          
                                    
                            providerDetail.specialities.add(specialityObj);
                        }
                    }
                    
                    //Premium section mapping logic
                    List<ACETGetHCPAdapterJSON2Apex.PremiumDesignation> premiumDesignLst = new List<ACETGetHCPAdapterJSON2Apex.PremiumDesignation>();
                    premiumDesignLst = ACTGPJSON2Apex.getMedicalHealthcareProfessionalResult.getMedicalHealthcareProfessionalResponseType.medicalHealthcareProfessional.PremiumDesignation;  
                     
                    if(premiumDesignLst != null) {
                        for(Integer index =0; index < premiumDesignLst.size(); index++){   
                            ACETProviderDetailController.ACETProviderUnitedPremium aCETProUniPremium = new ACETProviderDetailController.ACETProviderUnitedPremium();
                            if(String.isNotBlank(premiumDesignLst[index].qualityTypeCode)){
                                aCETProUniPremium.premiumDesignation = premiumDesignLst[index].qualityTypeCode;
                            }
                            if(String.isNotBlank(premiumDesignLst[index].diseaseGroupTypeCode)){
                                aCETProUniPremium.premiumSpeciality = premiumDesignLst[index].diseaseGroupTypeCode;
                            }
                            if(String.isNotBlank(premiumDesignLst[index].effectiveDate)){
                                aCETProUniPremium.effectiveDate = ChangeDateFormat(premiumDesignLst[index].effectiveDate);
                            }
                            if(String.isNotBlank(premiumDesignLst[index].cancelDate)){
                                aCETProUniPremium.premiumCancelDate = ChangeDateFormat(premiumDesignLst[index].cancelDate);
                            }
                            ProviderDetail.unitedPremiums.add(ACETProUniPremium);
                        }  
                    } 
                } 
            }
        }
      
        } else if (returningFromService == 'providerLookup') { 
        
            ACTGetHCPJSON2Apex = (ACETGetHCPAdapterJSON2Apex)JSON.deserialize(ResponseBody, ACETGetHCPAdapterJSON2Apex.class);
            if(ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResult != null){
                if(ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResult.getMedicalHealthcareProfessionalResponseType.MedicalHealthcareProfessional != null){
                    ACETGetHCPAdapterJSON2Apex.MedicalHealthcareProfessional generalInformation = ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResult.getMedicalHealthcareProfessionalResponseType.MedicalHealthcareProfessional;
                    system.debug(LoggingLevel.INFO, 'generalInformation>>>: ' + generalInformation);
                    if(String.isNotBlank(generalInformation.Hcp.providerFirstName)) {
                        providerDetail.generalInfo.lastName = generalInformation.Hcp.providerFirstName;
                    } 
                    if(String.isNotBlank(generalInformation.Hcp.providerMiddleName)) {
                        providerDetail.generalInfo.lastName += ' ' + generalInformation.Hcp.providerMiddleName;
                    }    
                    if(String.isNotBlank(generalInformation.Hcp.providerLastName)) {
                        providerDetail.generalInfo.lastName += ' ' + generalInformation.Hcp.providerLastName;
                    } 
                    if(String.isNotBlank(generalInformation.Hcp.providerNameSuffix)) {
                        providerDetail.generalInfo.lastName += ' ' + generalInformation.Hcp.providerNameSuffix;
                    }   
                    if(String.isNotBlank(generalInformation.ProviderTIN.typeCode)) {
                        providerDetail.generalInfo.providerTINTypeCode = generalInformation.ProviderTIN.typeCode;
                    }   
                    providerDetail.generalInfo.providerType = 'Physician';
                    if (String.isNotBlank(generalInformation.ProviderTIN.id)) {
                        providerDetail.generalInfo.taxId = generalInformation.ProviderTIN.id;
                    }
                    if(String.isNotBlank(generalInformation.Hcp.providerId)) {
                        providerDetail.generalInfo.providerID = generalInformation.Hcp.providerId;
                    }
                    if(String.isNotBlank(generalInformation.npi[0].id)) {
                        providerDetail.generalInfo.npi = generalInformation.npi[0].id;  
                    }
                     
                    if(String.isNotBlank(generalInformation.Hcp.providerGenderCode)) {
                        providerDetail.generalInfo.providerGenderCode = generalInformation.Hcp.providerGenderCode;
                    } 
                    if(String.isNotBlank(generalInformation.Hcp.providerBirthDate)) {
                        providerDetail.generalInfo.providerBirthDate = ChangeDateFormat(generalInformation.Hcp.providerBirthDate);
                    } 
                    if(String.isNotBlank(generalInformation.PatientAgeLimit[0].beginAgeNumber)) {
                        providerDetail.generalInfo.patientAgeRange = generalInformation.PatientAgeLimit[0].beginAgeNumber;
                    }   
                    if(String.isNotBlank(generalInformation.PatientAgeLimit[0].endAgeNumber)) {
                        providerDetail.generalInfo.patientAgeRange += ' - ' + generalInformation.PatientAgeLimit[0].endAgeNumber;
                    }  
                    if(String.isNotBlank(generalInformation.providerTIN.owner)) {
                        providerDetail.generalInfo.providerTINOwner = generalInformation.providerTIN.owner;
                    }
                    //Start of Specialty snippet
                    List<ACETGetHCPAdapterJSON2Apex.Specialty> practiceInformationLst = new List<ACETGetHCPAdapterJSON2Apex.Specialty>();
                    practiceInformationLst = ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResult.getMedicalHealthcareProfessionalResponseType.medicalHealthcareProfessional.specialty;
                    system.debug('practiceInformationLst :: ' + practiceInformationLst.size());
                   
                    if(practiceInformationLst != null){
                        for(Integer index =0; index < practiceInformationLst.size(); index++){
                            ACETProviderDetailController.ACETProviderSpeciality specialityObj = new ACETProviderDetailController.ACETProviderSpeciality();
                           /* system.debug(LoggingLevel.INFO,'primarySpeciality :: ' + practiceInformationLst[index].primarySpecialtyIndicator);
                            system.debug(LoggingLevel.INFO,'typeDescription :: ' + practiceInformationLst[index].typeDescription);
                            system.debug(LoggingLevel.INFO,'cancelDate :: ' + practiceInformationLst[index].cancelDate);    */
                            
                            if(String.isNotBlank(practiceInformationLst[index].primarySpecialtyIndicator)){
                                specialityObj.primarySpeciality = practiceInformationLst[index].primarySpecialtyIndicator;
                            }else{
                                specialityObj.primarySpeciality = 'N';
                            }
                            
                            /*** Added this snippet as a part of US638204 by Avish on 05192017 ***/
                             String typeCodeCMD = practiceInformationLst[index].typeCode;   
                            if(String.isNotBlank(practiceInformationLst[index].typeCode)) {
                                mapTaxonomyMDT = providerUtility.getProviderTaxonomy();
                                if(mapTaxonomyMDT.get(typeCodeCMD) != null ){
                                    system.debug(LoggingLevel.INFO,'Speciality__c:: ' + typeCodeCMD);
                                    specialityObj.speciality = (mapTaxonomyMDT.get(typeCodeCMD).Speciality__c != null) ? mapTaxonomyMDT.get(typeCodeCMD).Speciality__c : typeCodeCMD;
                                }else{
                                    specialityObj.speciality = typeCodeCMD;
                                }
                            }    
                            /***** End of Code ***/ 
                            
                          if(String.isNotBlank(practiceInformationLst[index].BoardCertification.boardCertificationCode)){
                              if(practiceInformationLst[index].BoardCertification.boardCertificationCode == 'C')
                                  specialityObj.boardCert = 'Yes';
                              else
                                  specialityObj.boardCert = 'No';
                          }else{
                              specialityObj.boardCert = 'No';
                          }
                          
                            specialityObj.cancelDate = ChangeDateFormat(practiceInformationLst[index].cancelDate);
                            providerDetail.specialities.add(specialityObj);
                        }
                    }
                    
                    //End of Specialty snippet
                    
                    //Start of Credentialing section
                    List<ACETGetHCPAdapterJSON2Apex.Degree> degreeLst = new List<ACETGetHCPAdapterJSON2Apex.Degree>();
                    degreeLst = ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResult.getMedicalHealthcareProfessionalResponseType.medicalHealthcareProfessional.Degree;   
                    system.debug('degreeLst :: ' + degreeLst.size());
                    if(degreeLst != null){
                        for(Integer index =0; index < degreeLst.size(); index++){
                            ACETProviderDetailController.Degree degreeObj = new ACETProviderDetailController.Degree();
                            if(String.isNotBlank(degreeLst[index].code)){
                                degreeObj.code = degreeLst[index].code;
                            }
                            if(String.isNotBlank(degreeLst[index].schoolName)){
                                degreeObj.schoolName = degreeLst[index].schoolName;
                            }
                            providerDetail.degrees.add(degreeObj);
                        }
                    }
                    
                    //End of Credentialing section
                    
                    //Code Snippet for TPSM
                    List<ACETGetHCPAdapterJSON2Apex.Tpsm> tpsmLst = new List<ACETGetHCPAdapterJSON2Apex.Tpsm>();
                    tpsmLst = ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResult.getMedicalHealthcareProfessionalResponseType.medicalHealthcareProfessional.Tpsm;
                    if(tpsmLst!=null){                             
                        for(ACETGetHCPAdapterJSON2Apex.Tpsm platinum :tpsmLst) {
                            if(platinum != null){
                                if(platinum.code == '99Z'){
                                    providerDetail.generalInfo.platinumProvider = 'No';                                        
                                }else if(String.isBlank(platinum.code)){
                                    providerDetail.generalInfo.platinumProvider = '';
                                }else{
                                    providerDetail.generalInfo.platinumProvider = 'Yes - ' +  platinum.code;   
                                }
                            }
                        }    
                    }
                    //End of TPSM Code Snippet
                    
                    
                    //Start of Langauge Snippet 
                        List<ACETGetHCPAdapterJSON2Apex.language> languageLst = new List<ACETGetHCPAdapterJSON2Apex.language>();
                        languageLst = ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResult.getMedicalHealthcareProfessionalResponseType.medicalHealthcareProfessional.Language;    
                                        
                        if(languageLst != null && String.isNotBlank(languageLst[0].languageCode)){
                            system.debug('languageLst111 :: ' + languageLst.size() + ' *** ' + languageLst);   
                            for(Integer index =0; index < languageLst.size(); index++){ 
                                ACETProviderDetailController.Language langaugeObj = new ACETProviderDetailController.Language();
                                if(String.isNotBlank(languageLst[index].languageCode)){
                                    langaugeObj.language = languageLst[index].languageCode;
                                }
                               providerDetail.languages.add(langaugeObj);
                                    
                            }    
                        } /* else{
                            Response1.setBody(ACETTestDataUtility.getHCPAdapterJSON());
                            Response1.setStatusCode(200);
                            system.debug('Response1 *** ' + Response1);
                            ACTGetHCPJSON2Apex1 = (ACETGetHCPAdapterJSON2Apex)JSON.deserialize(Response1.getBody(), ACETGetHCPAdapterJSON2Apex.class);
                            languageLst = ACTGetHCPJSON2Apex1.GetResult.medicalHealthcareProfessional.language;  
                            system.debug('languageLst :: ' + languageLst.size() + ' *** ' + languageLst);
                            for(Integer index =0; index < languageLst.size(); index++){ 
                                ACETProviderDetailController.Language langaugeObj = new ACETProviderDetailController.Language();
                                if(String.isNotBlank(languageLst[index].languageCode)){
                                    langaugeObj.languageCode = languageLst[index].languageCode;
                                }
                               providerDetail.languages.add(langaugeObj);                                    
                            }  
                        }  */     
                                              
                    //End Of Langauge Snippet
                    
                    //Start of Hours Of Operations snippet
                        List<ACETGetHCPAdapterJSON2Apex.HoursOfOperation> hoursOfOperationLst = new List<ACETGetHCPAdapterJSON2Apex.HoursOfOperation>();
                        hoursOfOperationLst = ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResult.getMedicalHealthcareProfessionalResponseType.medicalHealthcareProfessional.hoursOfOperation;   
                        system.debug('hoursOfOperationLst :: ' + hoursOfOperationLst.size() + ' *** ' + hoursOfOperationLst[0]);
                       
                        if(hoursOfOperationLst != null && String.isNotBlank(hoursOfOperationLst[0].weekcode)){
                                                                                        
                            for(Integer index =0; index < hoursOfOperationLst.size(); index++){ 
                                ACETProviderDetailController.HoursOfOperation hrsOfOperationObj = new ACETProviderDetailController.HoursOfOperation();
                                    if(String.isNotBlank(hoursOfOperationLst[index].weekCode)){
                                        hrsOfOperationObj.weekCode = hoursOfOperationLst[index].weekCode;
                                    }
                                    if(String.isNotBlank(hoursOfOperationLst[index].startTime1)){
                                        hrsOfOperationObj.startTime1 =  hoursOfOperationLst[index].startTime1.substring(0,5);
                                    }
                                    if(String.isNotBlank(hoursOfOperationLst[index].startTime1)){
                                        hrsOfOperationObj.endTime1 = hoursOfOperationLst[index].endTime1.substring(0,5);
                                    }
                                    providerDetail.hoursOfOperations.add(hrsOfOperationObj);                                    
                            }
                            
                        }
                      /*  else{
                            HttpResponse Response1 = new HttpResponse();
                            Response1.setBody(ACETTestDataUtility.getHCPAdapterJSONHrsOper());
                            Response1.setStatusCode(200);
                            system.debug('Response1 *** ' + Response1);
                            ACTGetHCPJSON2Apex1 = (ACETGetHCPAdapterJSON2Apex)JSON.deserialize(Response1.getBody(), ACETGetHCPAdapterJSON2Apex.class);
                            hoursOfOperationLst = ACTGetHCPJSON2Apex1.GetResult.MedicalHealthcareProfessional.HoursOfOperation;                        
                            system.debug('Hardcoded hoursOfOperationLst :: ' + hoursOfOperationLst.size() + ' ** ' + hoursOfOperationLst);
                            for(Integer index =0; index < hoursOfOperationLst.size(); index++){ 
                                 ACETProviderDetailController.HoursOfOperation hrsOfOperationObj = new ACETProviderDetailController.HoursOfOperation();                            
                                if(String.isNotBlank(hoursOfOperationLst[index].weekCode)){
                                    hrsOfOperationObj.weekCode = hoursOfOperationLst[index].weekCode;
                                }
                                if(String.isNotBlank(hoursOfOperationLst[index].startTime1)){
                                 //   hrsOfOperationObj.startTime1 =  hoursOfOperationLst[index].startTime1.substring(0,5);
                                     hrsOfOperationObj.startTime1 =  format24HrsTo12Hrs(hoursOfOperationLst[index].startTime1.substring(0,5));
                                }
                                if(String.isNotBlank(hoursOfOperationLst[index].startTime1)){
                                //    hrsOfOperationObj.endTime1 = hoursOfOperationLst[index].endTime1.substring(0,5);
                                    hrsOfOperationObj.endTime1 = format24HrsTo12Hrs(hoursOfOperationLst[index].endTime1.substring(0,5));
                                }
                                providerDetail.hoursOfOperations.add(hrsOfOperationObj);
                           } 
                           system.debug('providerDetail.hoursOfOperations :: ' + providerDetail.hoursOfOperations.size() + ' ** ' + providerDetail.hoursOfOperations);
                        }     */          
                    
                    //End of Hours Of Operations snippet
                    
                    //Start of  Premium Designation section
                    List<ACETGetHCPAdapterJSON2Apex.PremiumDesignation> premiumDesignLst = new List<ACETGetHCPAdapterJSON2Apex.PremiumDesignation>();
                    premiumDesignLst = ACTGetHCPJSON2Apex.getMedicalHealthcareProfessionalResult.getMedicalHealthcareProfessionalResponseType.medicalHealthcareProfessional.PremiumDesignation;                 
                    system.debug('premiumDesignLst :: ' + premiumDesignLst.size());
                    if(premiumDesignLst != null){
                        for(Integer index =0; index < premiumDesignLst.size(); index++){   
                            ACETProviderDetailController.ACETProviderUnitedPremium aCETProUniPremium = new ACETProviderDetailController.ACETProviderUnitedPremium();
                            if(String.isNotBlank(premiumDesignLst[index].qualityTypeCode)){
                                aCETProUniPremium.premiumDesignation = premiumDesignLst[index].qualityTypeCode;
                            }
                            if(String.isNotBlank(premiumDesignLst[index].diseaseGroupTypeCode)){
                                aCETProUniPremium.premiumSpeciality = premiumDesignLst[index].diseaseGroupTypeCode;
                            }
                            if(String.isNotBlank(premiumDesignLst[index].effectiveDate)){
                                aCETProUniPremium.effectiveDate = ChangeDateFormat(premiumDesignLst[index].effectiveDate);
                            }
                            if(String.isNotBlank(premiumDesignLst[index].cancelDate)){
                                aCETProUniPremium.premiumCancelDate = ChangeDateFormat(premiumDesignLst[index].cancelDate);
                            }
                            ProviderDetail.unitedPremiums.add(ACETProUniPremium);
                        }  
                    }                             
                    //End of  Premium Designation section
                }
            }
        }                               
        return providerDetail;
    }
    
    public Continuation StartRequest(String ProviderId, String TaxID, String providerTINTypeCode, String addressId, String addressTypeCode, 
                String returningFrom, String CallbackMethodName, Continuation oContinuation)
    {
       
        this.returningFromService = returningFrom;
        GetEndpoint();
        GetRequestBody(ProviderId, TaxID, providerTINTypeCode, addressId, addressTypeCode);
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        return oContinuation;         
    }
    
    public ACETWSCalloutResult ProcessResponse(String returningFrom, String HttpRequestLabel) {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETProviderDetailController.ACETProviderDetail providerDetail = new ACETProviderDetailController.ACETProviderDetail();
        this.returningFromService = returningFrom;
       system.debug(LoggingLevel.INFO, 'returningFrom*** ' + returningFrom + ' >> HttpRequestLabel *** ' + HttpRequestLabel);
        try {
            HttpResponse Response = GetHttpResponse(HttpRequestLabel);
            if (Response.getStatusCode() == 200) {
                ProviderDetail = ParseSuccessResponse(Response.getBody());
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = ProviderDetail; 
            } else {
                oACETWSCalloutResult = ParseFailureResponse(Response);  
            }    
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex);
            system.debug(ex.getlinenumber());
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);        
        return oACETWSCalloutResult;
    }
     @TestVisible
    private String format24HrsTo12Hrs(String timeToFormat){
        System.debug('timeToFormat *** ' + timeToFormat);
        Integer formatHour = (Integer.valueOf(timeToFormat.subString(0,2)) - ((Integer.valueOf(timeToFormat.subString(0,2)) == 0)? -12 : (Integer.valueOf(timeToFormat.subString(0,2)) <= 12)? 0 : 12));
        String AMtoPM = (Integer.valueOf(timeToFormat.subString(0,2)) < 12 ? ' AM' : ' PM');
        String FormattedTime = String.valueOf(formatHour)+ ':'+timeToFormat.subString(3,5) + AMtoPM;
        
        return FormattedTime;
    }
}