public class ACETGetAuthorizationWebservice extends ACETWebservice
{
    public override void GetEndpoint()
    {
        GetEndpointDetail('GetHealthSvrAuthorizationEndpoint');
    }
    
    public static string displayDateTimeFormat(string strDatetimeFormat){
        list<string> lstSplit = strDatetimeFormat.split('-');
        list<string> lstSplitFormat = lstSplit[2].split('T'); 
        list<string> lsttimeformat = lstSplitFormat[1].split(':');
        integer myHour = Integer.valueOf(lsttimeformat[0]);
        string strAMPM = myHour>=12?'PM':'AM';
        Integer myClockHour = 12;
        Integer myTime = myHour>12?myHour-myClockHour:myHour;
        
        string strDateFormat = lstSplit[1]+'/'+lstSplitFormat[0]+'/'+lstSplit[0]+' '+myTime+':'+lsttimeformat[1]+' '+strAMPM;
        return strDateFormat;
    } 
    
    public static string strDateFormat(string strDateFormat){
        list<string> lstDateformat = strDateFormat.split('-');
        if(lstDateformat.size()==3){
            return lstDateformat[1]+'/'+lstDateformat[2]+'/'+lstDateformat[0];
        }
        else
            return '';
    }
    public static string convertToDateFormat(string str2DatetimeFormat){
        list<string> lstSplit = str2DatetimeFormat.split('-');
        list<string> lstSplitFormat = lstSplit[2].split('T'); 
        list<string> lsttimeformat = lstSplitFormat[1].split(':');
                
        string finalDateFormat = lstSplit[1]+'/'+lstSplitFormat[0]+'/'+lstSplit[0];
        return finalDateFormat;
    }    
    
    private void GetRequestBody(String AuthId, String SRK, String federationID)
    {
        List<String> SearchParameters = new String[] {federationID,AuthId, SRK};
            RequestBody = GetRequestBody('GetAuthorizationsRequestJSON',SearchParameters);
    }
    
    /*private List<ACETGetAuthorizationJSON2APEX.authorization> ParseSuccessResponse(String ResponseBody)
    {
        ACETFindAuthorizationJSON2Apex ACTGAJSON2Apex = (ACETFindAuthorizationJSON2Apex)JSON.deserialize(ResponseBody, ACETFindAuthorizationJSON2Apex.class);
        system.debug('ACTGAJSON2Apex : ' + ACTGAJSON2Apex);
        return null;
    }*/ 
    
    public ACETWSCalloutResult GetAuthorizationDetail(String AuthId, String SRK, String Type,String federationID,List<String> SystemLabels)
    {
       // XRefId='18668917';
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETAuthorizationDetailResult Authorization = new ACETAuthorizationDetailResult();        
        ACETGetAuthorizationJSON2Apex.parentAuthorization DRAuthorization =new ACETGetAuthorizationJSON2Apex.parentAuthorization();
        
        try
        {
            GetEndpoint();
            GetRequestBody(AuthId, SRK,federationID);
            HttpResponse Response = Send(OAuthConfig);
            //Start of Hardcode response -- Comment this block when webservice is up
           // Response.setStatusCode(200);
           // Response.setBody(ACETTestDataUtility.GetInpatientDetailResponseJSON());
            //End of Hardcode response -- Comment this block when webservice is up */
            if (Response.getStatusCode() == 200){
                ACETGetAuthorizationJSON2APEX ACTGAJSON2Apex = (ACETGetAuthorizationJSON2APEX)JSON.deserialize(ReplaceKeywords(Response.getBody()), ACETGetAuthorizationJSON2APEX.class);
                system.debug('ACTGAJSON2Apex : ' + ACTGAJSON2Apex);
                
                DRAuthorization = ACTGAJSON2Apex.GetMedicalHealthServiceCaseAuthorizationResult.getAuthorizationResponseBaseType.getAuthorizationResponse.authorization;
                if (DRAuthorization != null){
                    system.debug(' DRAuthorization : ' + DRAuthorization);
                    oACETWSCalloutResult.Success = true;
                    oACETWSCalloutResult.Message = '';    
                    
                    //Start:: Authorization Details section Mapping
                    //Common for IP, OP and OPS
                    if(DRAuthorization.authorization!=null){
                        if(DRAuthorization.authorization.serviceSettingTypeCode!=null){
                            Authorization.Authorization_Type = DRAuthorization.authorization.serviceSettingTypeCode.descr==null?'':DRAuthorization.authorization.serviceSettingTypeCode.descr;
                        }
                        if(DRAuthorization.authorization.authStatusCode!=null){
                            Authorization.Case_Status = DRAuthorization.authorization.authStatusCode.descr==null?'':DRAuthorization.authorization.authStatusCode.descr;
                        }
                        if(DRAuthorization.authorization.authStatusReasonCode!=null){
                            Authorization.Case_Reason_Desc = DRAuthorization.authorization.authStatusReasonCode.descr==null?'':DRAuthorization.authorization.authStatusReasonCode.descr;
                        }
                        if(DRAuthorization.authorization.reviewPriority!=null){
                            Authorization.Review_Priority = DRAuthorization.authorization.reviewPriority.descr==null?'':DRAuthorization.authorization.reviewPriority.descr;
                        }
                        if(DRAuthorization.authorization.serviceCategoryTypeCode!=null){
                            Authorization.Coverage_Type = DRAuthorization.authorization.serviceCategoryTypeCode.descr==null?'':DRAuthorization.authorization.serviceCategoryTypeCode.descr;
                        }
                    }       
                    //Providers section Mapping::authProvider
                    //Common for IP, OP and OPS
                    if(DRAuthorization.authProvider!=null){
                        Authorization.authProviderDetails = new list<ACETAuthorizationDetailResult.authProviderDetail>();
                        
                        for(ACETGetAuthorizationJSON2APEX.authProvider authProv: DRAuthorization.authProvider){
                            ACETAuthorizationDetailResult.authProviderDetail aPD = new ACETAuthorizationDetailResult.authProviderDetail();
                            if(authProv.Id!=null) {
                                for(ACETGetAuthorizationJSON2APEX.authProviderId aPDId:authProv.Id){
                                    if(aPDId.typeCode!=null) {
                                        if(aPDId.typeCode.descr=='Provider Lifetime ID'){
                                            aPD.Provider_ID =  aPDId.Id;  
                                        }
                                       else if(aPDId.typeCode.descr=='NDBMpin'){
                                            aPD.Provider_ID =  aPDId.Id;  
                                        }
                                        if(aPDId.typeCode.descr=='Federal Tax ID'){
                                            aPD.TIN =  aPDId.Id;  
                                        }
                                    } 
                                }
                            }
                            
                            if(authProv.providerRole!=null) {
                                Boolean isOnlyFacilitycheck= true;
                                for(ACETGetAuthorizationJSON2APEX.providerRole aPR:authProv.providerRole){
                                    if(aPR.roleTypeId!=null) {
                                        if(aPR.roleTypeId.sourceSysCode!=null){
                                           // if(!(aPR.roleTypeId.sourceSysCode.containsIgnoreCase('Facility')) && !(aPR.roleTypeId.sourceSysCode.containsIgnoreCase('Association')))
                                            //    isOnlyFacilitycheck=false;
                                            
                                            if(aPD.Provider_Facility_Role !=null){
                                                aPD.Provider_Facility_Role = aPD.Provider_Facility_Role + ',' +aPR.roleTypeId.sourceSysCode;
                                            } 
                                            else{
                                                aPD.Provider_Facility_Role = aPR.roleTypeId.sourceSysCode;
                                            }
                                        }
                                    }
                                }
                                
                                if(authProv.providerCategory!=null){
                                    if(authProv.providerCategory.code!=null && ((authProv.providerCategory.code=='H')||(authProv.providerCategory.code=='A'))){
                                        aPD.Facility_Service_Provider_Status = authProv.businessName==null?'':authProv.businessName;
                                        if(authProv.businessName==null){
                                            if(authProv.contactName!=null){
                                                aPD.Facility_Service_Provider_Status = ((authProv.contactName.lastName==null?'':authProv.contactName.lastName)+(authProv.contactName.middleName==null?'':','+authProv.contactName.middleName)+(authProv.contactName.firstName==null?'':','+authProv.contactName.firstName));
                                            }   
                                        }
                                    }                                                
                                    else{
                                    if(authProv.contactName!=null){
                                        aPD.Facility_Service_Provider_Status =((authProv.contactName.lastName==null?'':authProv.contactName.lastName)+(authProv.contactName.middleName==null?'':','+authProv.contactName.middleName)+(authProv.contactName.firstName==null?'':','+authProv.contactName.firstName));
                                    }
                                    else{
                                        aPD.Facility_Service_Provider_Status = authProv.businessName==null?'':authProv.businessName; 
                                    }
                                }
                                }
                                else{
                                    aPD.Facility_Service_Provider_Status='';
                                }
                                
                                if(aPD.Facility_Service_Provider_Status==null || aPD.Facility_Service_Provider_Status=='')
                                    aPD.Facility_Service_Provider_Status='NA';
                                
                                aPD.Facility_Service_Provider_Status +='/';  
                                if(authProv.networkStatusType!=null){
                                    aPD.Facility_Service_Provider_Status += authProv.networkStatusType.descr==null?'NA':authProv.networkStatusType.descr;   
                                }
                            }
                            
                            
                            if(authProv.organization!=null){
                                if(authProv.organization.correspondence!=null){
                                    if(authProv.organization.correspondence[0].address!=null){
                                        aPD.Address_1 = authProv.organization.correspondence[0].address.line1==null?'':authProv.organization.correspondence[0].address.line1;
                                        aPD.city = authProv.organization.correspondence[0].address.City==null?'':authProv.organization.correspondence[0].address.City;
                                        if(authProv.organization.correspondence[0].address.State!=null){                 
                                            aPD.state = authProv.organization.correspondence[0].address.State.code==null?'':authProv.organization.correspondence[0].address.State.code;
                                        }
                                        if(authProv.organization.correspondence[0].address.postalCode[0]!=null){                    
                                            aPD.ZIP = authProv.organization.correspondence[0].address.postalCode[0].part1==null?'':authProv.organization.correspondence[0].address.postalCode[0].part1;
                                        }
                                    }
                                }
                            }
                            if(authProv.specialty!=null){
                                if(authProv.specialty[0].typeCode!=null){                   
                                    aPD.Speciality = authProv.specialty[0].typeCode.descr==null?'':authProv.specialty[0].typeCode.descr;
                                }
                            }
                            Authorization.authProviderDetails.add(aPD);
                        }  
                    } 
                    //Notification Type mapping for facility
                    //Common for IP, OP and OPS
                    if(DRAuthorization.authFacility!=null){
                        Authorization.notifications = new list<ACETAuthorizationDetailResult.notification>();
                        if(DRAuthorization.authFacility.admissionNotificationTimestamp!=null){
                            ACETAuthorizationDetailResult.notification noti  = new ACETAuthorizationDetailResult.notification();
                            noti.Notification_Type = 'Admission';
                            noti.Notified_Date_Time = displayDateTimeFormat(DRAuthorization.authFacility.admissionNotificationTimestamp==null?'':DRAuthorization.authFacility.admissionNotificationTimestamp);
                            Authorization.notifications.add(noti);
                        }
                        if(DRAuthorization.authFacility.dischargeNotificationTimestamp!=null){
                            ACETAuthorizationDetailResult.notification noti  = new ACETAuthorizationDetailResult.notification();
                            noti.Notification_Type = 'Discharge';
                            noti.Notified_Date_Time = displayDateTimeFormat(DRAuthorization.authFacility.dischargeNotificationTimestamp==null?'':DRAuthorization.authFacility.dischargeNotificationTimestamp);
                            Authorization.notifications.add(noti);
                        }
                        if(DRAuthorization.authFacility.advanceNotificationTimestamp!=null){
                            ACETAuthorizationDetailResult.notification noti  = new ACETAuthorizationDetailResult.notification();
                            noti.Notification_Type = 'Advance';
                            noti.Notified_Date_Time = displayDateTimeFormat(DRAuthorization.authFacility.advanceNotificationTimestamp==null?'':DRAuthorization.authFacility.advanceNotificationTimestamp);
                            Authorization.notifications.add(noti);
                        }
                    }
                    //Facility Line Mapping : authFacility
                    //Common for IP and OPS
                    if(DRAuthorization.authFacility!=null){
                        Authorization.Facility_Authorization_Number = DRAuthorization.authFacility.serviceReferenceNbr==null?'':DRAuthorization.authFacility.serviceReferenceNbr;
                        if(DRAuthorization.authFacility.expectedAdmissionDate!=null){
                            Authorization.Expected_Admission_Date = DRAuthorization.authFacility.expectedAdmissionDate==null?'':Date.valueOf(DRAuthorization.authFacility.expectedAdmissionDate).format();
                        }
                        if(DRAuthorization.authFacility.expectedDischargeDate!=null){
                            Authorization.Expected_Discharge_Date = DRAuthorization.authFacility.expectedDischargeDate==null?'':Date.valueOf(DRAuthorization.authFacility.expectedDischargeDate).format();
                      }
                        if(DRAuthorization.authFacility.actualAdmitDate!=null){
                            Authorization.Actual_Admission_Date = displayDateTimeFormat(DRAuthorization.authFacility.actualAdmitDate==null?'':DRAuthorization.authFacility.actualAdmitDate);
                        }
                        if(DRAuthorization.authFacility.actualDischargeDate!=null){
                            Authorization.Actual_Discharge_Date = displayDateTimeFormat(DRAuthorization.authFacility.actualDischargeDate==null?'':DRAuthorization.authFacility.actualDischargeDate);
                        }
                        if(DRAuthorization.authFacility.placeOfServiceCode!=null){
                            Authorization.POS = ((DRAuthorization.authFacility.placeOfServiceCode.code==null?'':DRAuthorization.authFacility.placeOfServiceCode.code) +'-'+(DRAuthorization.authFacility.placeOfServiceCode.descr==null?'':DRAuthorization.authFacility.placeOfServiceCode.descr));
                        }
                        if(DRAuthorization.authFacility.serviceDetailCategoryCode!=null){
                            Authorization.Service_Detail = DRAuthorization.authFacility.serviceDetailCategoryCode.descr==null?'':DRAuthorization.authFacility.serviceDetailCategoryCode.descr;
                        }
                        if(DRAuthorization.authFacility.inPatient!=null){
                            if(DRAuthorization.authFacility.inPatient.dischargeDispositionCode!=null){
                                Authorization.Discharge_Location = DRAuthorization.authFacility.inPatient.dischargeDispositionCode.descr==null?'':DRAuthorization.authFacility.inPatient.dischargeDispositionCode.descr;
                            }
                        }
                        if(DRAuthorization.authFacility.servicedescUrgencyCode!=null){
                            Authorization.Service_Desc = DRAuthorization.authFacility.servicedescUrgencyCode.descr==null?'':DRAuthorization.authFacility.servicedescUrgencyCode.descr;
                        }
                        if(DRAuthorization.authFacility.facilityDecision!=null){
                            if(DRAuthorization.authFacility.facilityDecision.decisionOutcomeCode!=null){
                                Authorization.Facility_Decision_Outcome = DRAuthorization.authFacility.facilityDecision.decisionOutcomeCode.descr==null?'':DRAuthorization.authFacility.facilityDecision.decisionOutcomeCode.descr;
                            }
                            if(DRAuthorization.authFacility.facilityDecision.decisionSubTypeCode!=null){
                                Authorization.Facility_Decision_Sub_Type = DRAuthorization.authFacility.facilityDecision.decisionSubTypeCode.descr==null?'':DRAuthorization.authFacility.facilityDecision.decisionSubTypeCode.descr;
                            }
                            if(DRAuthorization.authFacility.facilityDecision.derivedClaimRemarkCode!=null){
                                Authorization.Facility_Claim_Remark_Code = ((DRAuthorization.authFacility.facilityDecision.derivedClaimRemarkCode.code==null?'':DRAuthorization.authFacility.facilityDecision.derivedClaimRemarkCode.code) + ' - ' +(DRAuthorization.authFacility.facilityDecision.derivedClaimRemarkCode.descr==null?'':DRAuthorization.authFacility.facilityDecision.derivedClaimRemarkCode.descr));
                            }
                            if(DRAuthorization.authFacility.facilityDecision.gapReviewOutcomeCode!=null){
                                Authorization.Facility_Gap_Outcome = DRAuthorization.authFacility.facilityDecision.gapReviewOutcomeCode.descr==null?'':DRAuthorization.authFacility.facilityDecision.gapReviewOutcomeCode.descr;
                            }
                            if(DRAuthorization.authFacility.facilityDecision.claimNote!=null){
                                Authorization.Facility_Decision_Comment = DRAuthorization.authFacility.facilityDecision.claimNote.text==null?'':DRAuthorization.authFacility.facilityDecision.claimNote.text;
                            }
                            if(DRAuthorization.authFacility.facilityDecision.decisionReasonCode!=null){
                                Authorization.Facility_Decision_Reason = DRAuthorization.authFacility.facilityDecision.decisionReasonCode.descr==null?'':DRAuthorization.authFacility.facilityDecision.decisionReasonCode.descr;
                            }
                            if(DRAuthorization.authFacility.facilityDecision.decisionRenderedDatetime!=null){
                                Authorization.Facility_Decision_Rendered_Date = displayDateTimeFormat(DRAuthorization.authFacility.facilityDecision.decisionRenderedDatetime==null?'':DRAuthorization.authFacility.facilityDecision.decisionRenderedDatetime);
                            }
                        }
                    }
                    if(Authorization.authProviderDetails!=null){
                        for(ACETAuthorizationDetailResult.authProviderDetail a:Authorization.authProviderDetails){
                            if(a.Provider_Facility_Role.containsIgnoreCase('Facility')|| a.Provider_Facility_Role.containsIgnoreCase('Association')){
                                Authorization.Facility_Provider_Status = a.Facility_Service_Provider_Status;
                            }
                        }
                    }
                    // Service Line Mapping : AuthServices
                    // Common for IP, OP and OPS
                    if(DRAuthorization.authServices!=null){
                        Authorization.authServiceDetails = new list<ACETAuthorizationDetailResult.authServiceDetail>();
                        for(ACETGetAuthorizationJSON2APEX.authServices authServ: DRAuthorization.authServices){
                            ACETAuthorizationDetailResult.authServiceDetail aSD = new ACETAuthorizationDetailResult.authServiceDetail();
                            aSD.Service_Authorization_Number = authServ.serviceReferenceNbr==null?'':authServ.serviceReferenceNbr;   
                            for(ACETGetAuthorizationJSON2APEX.authProvider a:DRAuthorization.authProvider){  
                                if(a.providerSeqNum==authServ.serviceProviderSeqNum){
                                    if(a.contactName.lastName!=null || a.contactName.middleName!=null || a.contactName.firstName!=null ){
                                        aSD.Service_Provider_Status = ((a.contactName.lastName==null?'':a.contactName.lastName)+(a.contactName.middleName==null?'':','+a.contactName.middleName)+(a.contactName.firstName==null?'':+','+a.contactName.firstName));
                                    } 
                                    else{
                                        aSD.Service_Provider_Status = a.businessName==null?'':a.businessName; 
                                    }
                                    if(aSD.Service_Provider_Status==null || aSD.Service_Provider_Status=='')
                                    aSD.Service_Provider_Status='NA';
                                    aSD.Service_Provider_Status +='/';  
                                    if(a.networkStatusType!=null){
                                        aSD.Service_Provider_Status += a.networkStatusType.descr==null?'NA':a.networkStatusType.descr;                                                
                                    }
                                }
                            }
                            if(authServ.procedureCode!=null){
                                aSD.Procedure_Code = authServ.procedureCode.code==null?'':authServ.procedureCode.code;
                                aSD.Procedure_Description = authServ.procedureCode.descr==null?'':authServ.procedureCode.descr;
                            }
                            if(authServ.facilityProcedure!=null){
                                if(authServ.facilityProcedure.expectedProcedureDate!=null){
                                    aSD.Expected_Procedure_Date = authServ.facilityProcedure.expectedProcedureDate==null?'':Date.valueOf(authServ.facilityProcedure.expectedProcedureDate).format();
                                }
                                if(authServ.facilityProcedure.actualProcedureDate!=null){
                                    aSD.Actual_Procedure_Date = authServ.facilityProcedure.actualProcedureDate==null?'':Date.valueOf(authServ.facilityProcedure.actualProcedureDate).format();
                                }
                            }
                            if(authServ.nonFacilityProcedure!=null){
                                if(authServ.nonFacilityProcedure.serviceEffDates!=null){
                                    aSD.Service_StartDate = strDateFormat(authServ.nonFacilityProcedure.serviceEffDates.startDate==null?'':authServ.nonFacilityProcedure.serviceEffDates.startDate);
                                }
                            }
                            
                            
                            //Non Facility Procedure mapping
                            // nonFacilityProcedure/serviceEffDates/startDate
                            /*if(authServ.facilityProcedure!=null){
if(authServ.nonFacilityProcedure.serviceEffDates!=null){
aSD.Service_Start_Date = strDateFormat(authServ.nonFacilityProcedure.serviceEffDates.startDate==null?'':authServ.nonFacilityProcedure.serviceEffDates.startDate);
aSD.Service_End_Date = strDateFormat(authServ.nonFacilityProcedure.serviceEffDates.stopDate==null?'':authServ.nonFacilityProcedure.serviceEffDates.stopDate==null);
}
} */
                            
                            if(authServ.procedureDecision!=null){
                                if(authServ.procedureDecision.decisionOutcomeCode!=null){
                                    aSD.Service_Decision_Outcome = authServ.procedureDecision.decisionOutcomeCode.descr==null?'':authServ.procedureDecision.decisionOutcomeCode.descr;
                                }
                                if(authServ.procedureDecision.decisionSubTypeCode!=null){
                                    aSD.Service_Decision_Sub_Type = authServ.procedureDecision.decisionSubTypeCode.descr==null?'':authServ.procedureDecision.decisionSubTypeCode.descr;
                                }
                                if(authServ.procedureDecision.derivedClaimRemarkCode!=null){
                                    aSD.Service_Claim_Remark_Code = ((authServ.procedureDecision.derivedClaimRemarkCode.code==null?'':authServ.procedureDecision.derivedClaimRemarkCode.code) + ' - ' +(authServ.procedureDecision.derivedClaimRemarkCode.descr==null?'':authServ.procedureDecision.derivedClaimRemarkCode.descr));
                                }
                                if(authServ.procedureDecision.gapReviewOutcomeCode!=null){
                                    aSD.Service_Gap_Outcome = authServ.procedureDecision.gapReviewOutcomeCode.descr==null?'':authServ.procedureDecision.gapReviewOutcomeCode.descr;
                                }
                                if(authServ.procedureDecision.decisionReasonCode!=null){
                                    aSD.Service_Decision_Reason = authServ.procedureDecision.decisionReasonCode.descr==null?'':authServ.procedureDecision.decisionReasonCode.descr;
                                }
                                if(authServ.procedureDecision.decisionRenderedDatetime!=null){
                                    aSD.Service_Decision_Rendered_Date = displayDateTimeFormat(authServ.procedureDecision.decisionRenderedDatetime==null?'':authServ.procedureDecision.decisionRenderedDatetime);
                                }
                                if(authServ.procedureDecision.claimNote!=null){
                                    aSD.Service_Decision_Comment = authServ.procedureDecision.claimNote.text==null?'':authServ.procedureDecision.claimNote.text;
                                }
                            }
                            if(authServ.procedureOtherText!=null){
                                aSD.Proc_Text = authServ.procedureOtherText.text==null?'':authServ.procedureOtherText.text;
                            }
                            Authorization.authServiceDetails.add(aSD); 
                        }
                    }
                    //Diagnosis Mapping
                    //Common for IP, OP and OPS
                    if(DRAuthorization.authDiagnosis!=null){
                        Authorization.diagnosisList = new list<ACETAuthorizationDetailResult.diagnosis>();
                        for(ACETGetAuthorizationJSON2APEX.authDiagnosis authDiag: DRAuthorization.authDiagnosis){
                            
                            if(authDiag.diagnosisCode!=null){
                                ACETAuthorizationDetailResult.diagnosis diag  = new ACETAuthorizationDetailResult.diagnosis();
                                diag.Dx_Code = authDiag.diagnosisCode.code==null?'':authDiag.diagnosisCode.code;
                                diag.Dx_Description = authDiag.diagnosisCode.descr==null?'':authDiag.diagnosisCode.descr;
                                Authorization.diagnosisList.add(diag);
                            }
                        }
                    }
                    //Notes mapping
                    //Common for IP, OP and OPS
                    if(DRAuthorization.notes!=null){
                        Authorization.notesList = new list<ACETAuthorizationDetailResult.notes>();
                        for(ACETGetAuthorizationJSON2APEX.notes authNote: DRAuthorization.notes){
                            ACETAuthorizationDetailResult.notes nte  = new ACETAuthorizationDetailResult.notes();
                            if(authNote.createdByUserid!=null){
                                nte.Created_By = authNote.createdByUserid.id==null?'':authNote.createdByUserid.id;
                            }
                            if(authNote.noteCategoryCode!=null){
                                //nte.Note_Type = authNote.noteCategoryCode.descr==null?'':authNote.noteCategoryCode.descr;
                                nte.Note_Type = '';
                                nte.Subject_Type = authNote.noteCategoryCode.descr==null?'':authNote.noteCategoryCode.descr;
                                
                               //nte.Subject_Type = authNote.noteCategoryCode.code==null?'':authNote.noteCategoryCode.code;
                            }
                            if(authNote.noteText!=null){
                                nte.Note_details = authNote.noteText.text==null?'':authNote.noteText.text;
                            }
                            if(authNote.createDatetime!=null){
                                nte.Create_Date = displayDateTimeFormat(String.isBlank(authNote.createDatetime)?'':authNote.createDatetime);
                            }
                            nte.Department='';
                            Authorization.notesList.add(nte);
                        }
                    }
                    //Follow Up Contact Mapping
                    //Common for IP, OP and OPS
                    if(DRAuthorization.authFollowupContact!=null){
                        if(DRAuthorization.authFollowupContact.contactName!=null){
                            Authorization.Name= DRAuthorization.authFollowupContact.contactName.fullName==null?'':DRAuthorization.authFollowupContact.contactName.fullName;
                        }
                        if(DRAuthorization.authFollowupContact.communicationContactRoleCode!=null){
                            Authorization.Role = DRAuthorization.authFollowupContact.communicationContactRoleCode.descr==null?'':DRAuthorization.authFollowupContact.communicationContactRoleCode.descr;
                        }
                        if(DRAuthorization.authFollowupContact.departmentTypeCode!=null){
                            Authorization.Contact_Department = DRAuthorization.authFollowupContact.departmentTypeCode.descr==null?'':DRAuthorization.authFollowupContact.departmentTypeCode.descr;
                        }
                        if(DRAuthorization.authFollowupContact.emailAddressText!=null){
                            Authorization.Email_Address = DRAuthorization.authFollowupContact.emailAddressText.text==null?'':DRAuthorization.authFollowupContact.emailAddressText.text;
                        }
                        Authorization.Medical_Record_Number = DRAuthorization.authFollowupContact.medicalRecordNumber==null?'':DRAuthorization.authFollowupContact.medicalRecordNumber;
                        if(DRAuthorization.authFollowupContact.phoneNumber!=null){
                            For(ACETGetAuthorizationJSON2APEX.phoneNumber phn: DRAuthorization.authFollowupContact.phoneNumber){
                                if(phn.phoneTypeCode!=null){
                                    if(phn.phoneTypeCode.code!=null && phn.phoneTypeCode.code=='14'){
                                        Authorization.Primary_Phone = phn.telephoneNumber;
                                    } 
                                    if(phn.phoneTypeCode.code!=null && phn.phoneTypeCode.code=='3'){
                                        Authorization.Fax = phn.telephoneNumber;
                                    }
                                } 
                            }
                        }
                    }
                    system.debug('AuthorizationDetail:' + Authorization);
                    
                }
                if (Authorization!=null){
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = Authorization;
            }
                else{
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = 'No Record found for this Authorization';
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO; 
            }
        }
            else{
                    oACETWSCalloutResult.Success = false;
                    oACETWSCalloutResult.Message = 'Service Failure. Please try again';
                    oACETWSCalloutResult = ParseFailureResponse(Response);
                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
                }
        } 
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in GetAuthorizationDetail. Details: ' + ex); 
            system.debug('getStackTraceString' + ex.getStackTraceString());
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        } 
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);         
        return oACETWSCalloutResult;
    }
}