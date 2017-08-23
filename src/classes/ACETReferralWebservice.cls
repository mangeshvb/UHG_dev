public Class ACETReferralWebservice extends ACETWebservice{
    
    public List<String> searchParameters ;
    public override void GetEndpoint(){
    	GetEndpointDetail('SearchClinicalReferralsEndpoint');
    }
    
    private void GetRequestBody(){
        RequestBody = GetRequestBody('FindReferralsRequestMember',SearchParameters);
    }
    
    public String setStringToDateFormat(String OILDate) {
        String FormattedDate = '';
        
        if (String.isNotBlank(OILDate)) {
            List<String> OILDateSplit = OILDate.split('/');
            if(OILDateSplit.size() == 3) {
                FormattedDate = OILDateSplit[2] + '-' + OILDateSplit[0] + '-' + OILDateSplit[1];
            }
        }
            
        return FormattedDate;
    }
    
    public String formattedDate(String exisDate){
    	String FormattedDate = '';
    	List<String> exisDateList = exisDate.split('/');
    	if(exisDateList[0].indexof('0') == 0){
    		exisDateList[0] = exisDateList[0].remove('0') ;
    	}
    	if(exisDateList[1].indexof('0') == 0){
    		exisDateList[1] = exisDateList[0].remove('0');	
    	}
    	FormattedDate = exisDateList[0] + '/' + exisDateList[1] + '/' + exisDateList[2];
    	
    	return FormattedDate;
    }
    
    public ACETWSCalloutResult findReferrals(String firstName , String lastName, String birthDate, String SRKNumber){
    	//Date dob = setStringToDateFormat(birthDate);
        //searchParameters = new String[] {firstName, lastName,String.valueof(birthDate), SRKNumber, String.valueof(birthDate)};
        searchParameters = new String[] {firstName, lastName,setStringToDateFormat(birthDate), SRKNumber, setStringToDateFormat(birthDate)};	
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETReferralSearchResult> lstReferrals = new List<ACETReferralSearchResult>();
        ACETReferralSearchResult referral;
        List<ACETReferralJSON2Apex.referral> SRReferrals;
        
        try{
            GetEndpoint();
            GetRequestBody();
            
            HttpResponse Response = Send(OAuthConfig);
            system.debug('Respone--->'+Response.getBody());
            if (Response.getStatusCode() == 200){
            	String ResponseBody = Response.getBody().replace('Id', 'MemberId').replace('Contact','CorrContact').replace('desc','desc_z');
            	system.debug('ResponseBody: ' + ResponseBody);    
            	
            	ACETReferralJSON2Apex ACTRefJSON2Apex = (ACETReferralJSON2Apex)JSON.deserialize(ResponseBody, ACETReferralJSON2Apex.class);
            	system.debug('ACTRefJSON2Apex****'+ ACTRefJSON2Apex);
            	
            	SRReferrals = ACTRefJSON2Apex.FindReferralsServiceResult.findReferralResponseBaseType.findReferralsResponse.referralList.referral;
            	system.debug('SRReferrals ***'+SRReferrals );
            	if (SRReferrals != null && SRReferrals.size() > 0){
            		for (ACETReferralJSON2Apex.referral SRReferral : SRReferrals){
            			referral = new ACETReferralSearchResult();
            			referral.resultreferralExternalID = SRReferral.referralData.referralExternalID.id;
            			referral.resultReferaltype = SRReferral.referralData.referralDescription.desc_z;
            			referral.resultStartdate = formattedDate(ChangeDateFormat(SRReferral.referralData.referralDateRange.startDate));
            			referral.resultEnddate = formattedDate(ChangeDateFormat(SRReferral.referralData.referralDateRange.stopDate));
            			referral.resultReferralstatus = SRReferral.referralData.statusCode.desc_z;
            			
            			String dateTimeString = SRReferral.referralData.createDateTime;
            			dateTimeString = dateTimeString.substring(0, dateTimeString.indexOf('.'));
						dateTimeString = dateTimeString.replace('T', ' ');
						dateTimeString = DateTime.valueOf(dateTimeString).format('MM/dd/yyyy hh:mm:ss a');
						system.debug('datetime-->'+dateTimeString);
            			
            			
            			
            			
            			referral.resultCreatedDate = dateTimeString;
            			referral.numberofvisit = SRReferral.referralData.numberofvisits;
            			referral.noteText = SRReferral.referralData.notetext.text;
            			
            			referral.servicelst = new List<ACETReferralSearchResult.Service>();
            			List<ACETReferralJSON2Apex.Service>  serVar = new List<ACETReferralJSON2Apex.Service>();
            			serVar = SRReferral.serviceList.service;
            			
            			for(Integer i=0;I<serVar.size();i++){
            				ACETReferralSearchResult.Service servList = new ACETReferralSearchResult.Service();
            				servList.resultProcedureType = serVar[i].procedureCodeTypeCode.desc_z;
            				servList.resultProcedureCode = serVar[i].procedureCode.code;
            				servList.resultDescription = serVar[i].procedureCode.desc_z;
            				referral.servicelst.add(servList);
            			}
            			
            			if(SRReferral.diagnosisList.diagnosis != null){
            				referral.resultDxcode = SRReferral.diagnosisList.diagnosis[0].diagnosisCode.Code; 
            				referral.resultDXDescription = SRReferral.diagnosisList.diagnosis[0].diagnosisCode.desc_z;
            				//referral.Provider.resultName = SRReferral.providerList.provider[0].organization.correspondence[0].contact[0].contactName.firstName;
            			}
            			 
            			referral.providerlst = new List<ACETReferralSearchResult.Provider>();
            			List<ACETReferralJSON2Apex.Provider>  provVar = new List<ACETReferralJSON2Apex.Provider>();
            			provVar = SRReferral.providerList.Provider;
            			for(Integer i=0; i < provVar.size();i++){
            				ACETReferralSearchResult.Provider provList = new ACETReferralSearchResult.Provider();
            				provList.resultProviderRole = ProvVar[i].providerRole[0].Id[0].sourceSysCode;
            				List<ACETReferralJSON2Apex.MemberId>  provCodeDesc = new List<ACETReferralJSON2Apex.MemberId>();
            				provCodeDesc = ProvVar[i].ID;
            				if(provList.resultProviderRole == 'Servicing'){
            					
            					for(Integer j=0;j<provCodeDesc.size();j++){
            						if(ProvVar[i].Id[j].typeCode.code == '03'){
            							provList.resultTIN = referral.resultServicingtin = ProvVar[i].Id[j].Id;
            						}
            						if(ProvVar[i].Id[j].typeCode.code == '14'){
            							provList.resultMPIN = ProvVar[i].Id[j].Id;
            						}
            						
        						}
        						
            					//provList.resultTIN = referral.resultServicingtin = ProvVar[i].Id[0].Id;
            					provList.resultName = referral.resultServicingprovider = ProvVar[i].organization.correspondence[0].contact[0].contactName.firstName + ' ' + (ProvVar[i].organization.correspondence[0].contact[0].contactName.middleName != null ? ProvVar[i].organization.correspondence[0].contact[0].contactName.middleName + ' ' : '')+ProvVar[i].organization.correspondence[0].contact[0].contactName.lastName;
            					provList.resultCity = ProvVar[i].organization.tinOwner[0].address.city;
            					provList.resultState = ProvVar[i].organization.tinOwner[0].address.state.code;
            					provList.resultAddress = ProvVar[i].organization.tinOwner[0].address.Line1 ;
            					provList.resultZip = ProvVar[i].organization.tinOwner[0].address.postalCode[0].part1 != null ? ProvVar[i].organization.tinOwner[0].address.postalCode[0].part1 : ProvVar[i].organization.tinOwner[0].address.postalCode[0].part2;
            					provList.speciality = ProvVar[i].organization.providerAgreement != null ? ProvVar[i].organization.providerAgreement[0].paymentModel.providerAgreementNetworkSpecialtyRate[0].specialtyTypeCode.desc_z : '';
            					
            				}
            				if(provList.resultProviderRole == 'Requesting Provider'){
            					for(Integer j=0;j<provCodeDesc.size();j++){
            						if(ProvVar[i].Id[j].typeCode.code == '03'){
            							provList.resultTIN = referral.resultRequestingtin = ProvVar[i].Id[j].Id;
            						}
            						if(ProvVar[i].Id[j].typeCode.code == '14'){
            							provList.resultMPIN = ProvVar[i].Id[j].Id;
            						}
            						
        						}
            					provList.resultName = referral.resultRequestingprovider = ProvVar[i].organization.correspondence[0].contact[0].contactName.firstName + ' ' + (ProvVar[i].organization.correspondence[0].contact[0].contactName.middleName != null ? ProvVar[i].organization.correspondence[0].contact[0].contactName.middleName + ' ' : '')+ProvVar[i].organization.correspondence[0].contact[0].contactName.lastName;
	        					provList.resultCity = ProvVar[i].organization.tinOwner[0].address.city;
	        					provList.resultState = ProvVar[i].organization.tinOwner[0].address.state.code;
	        					provList.resultAddress = ProvVar[i].organization.tinOwner[0].address.Line1 ;
	        					provList.resultZip = ProvVar[i].organization.tinOwner[0].address.postalCode[0].part1 != null ? ProvVar[i].organization.tinOwner[0].address.postalCode[0].part1 : ProvVar[i].organization.tinOwner[0].address.postalCode[0].part2;
	            				provList.speciality = ProvVar[i].organization.providerAgreement != null ? ProvVar[i].organization.providerAgreement[0].paymentModel.providerAgreementNetworkSpecialtyRate[0].specialtyTypeCode.desc_z : '';
            				}
            			referral.providerlst.add(provList);
            			}
            			lstReferrals.add(referral);
            		}
            		if (lstReferrals.size() > 0){
            			oACETWSCalloutResult.Success = true;
                		oACETWSCalloutResult.Message = '';
                		oACETWSCalloutResult.Response = lstReferrals;
                	}
            	}
            	
            }
        }
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in Find Referrals. Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug('**oACETWSCalloutResult**'+oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
}