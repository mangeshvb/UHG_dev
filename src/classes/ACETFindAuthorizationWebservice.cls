public class ACETFindAuthorizationWebservice extends ACETWebservice{
    public override void GetEndpoint()
    {
        GetEndpointDetail('SearchHlhSvrAuthorizationsEndpoint');
    }
        
    private void GetRequestBody(String MemberId, String DOB, String FirstName, String LastName, String StartDate, String EndDate, String FederationID)
    {
        List<String> SearchParameters = new String[] {FederationID, MemberId, DOB, FirstName, LastName, StartDate, EndDate};
        RequestBody = GetRequestBody('FindAuthorizationsRequestJSON',SearchParameters);
        /*Comment the line above and Uncomment the line below to set hardcoded request*/ 
        //RequestBody = GetRequestFormatByName('FindAuthorizationsRequestJSON_HardcodedRequest');
    }
    
    private List<ACETFindAuthorizationJSON2Apex.authorization> ParseSuccessResponse(String ResponseBody)
    {
        ACETFindAuthorizationJSON2Apex ACTFPJSON2Apex = (ACETFindAuthorizationJSON2Apex)JSON.deserialize(ResponseBody, ACETFindAuthorizationJSON2Apex.class);
        system.debug('ACTFPJSON2Apex : ' + ACTFPJSON2Apex);
        return null;
    }
    
    public ACETWSCalloutResult FindAuthorizations(String MemberId, String DOB, String FirstName, String LastName, String StartDate, String EndDate, String FederationID, List<String> SystemLabels)
    {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETAuthorizationSearchResult> Authorizations = new List<ACETAuthorizationSearchResult>();
        ACETAuthorizationSearchResult Authorization;        
        List<ACETFindAuthorizationJSON2Apex.authorization> SRAuthorizations =new List<ACETFindAuthorizationJSON2Apex.authorization>();
        
        try{
            GetEndpoint();
            GetRequestBody(MemberId, DOB, FirstName,  LastName,  StartDate,  EndDate,FederationID);
            HttpResponse Response = Send(OAuthConfig);
            //Start of Hardcode response -- Comment this block when webservice is up
            //Response.setStatusCode(200);
            //Response.setBody(ACETTestDataUtility.GetFindAuthorizationResponseJSON());
            //End of Hardcode response -- Comment this block when webservice is up */
            Response.setBody(Response.getBody().replaceAll('"desc"','"descr"').replaceAll('"dateTime"','"dteTime"').replaceAll('"date"','"dte"'));
            if (Response.getStatusCode() == 200){
                ACETFindAuthorizationJSON2Apex ACTFPJSON2Apex = (ACETFindAuthorizationJSON2Apex)JSON.deserialize(Response.getBody(), ACETFindAuthorizationJSON2Apex.class);
                system.debug('ACTFPJSON2Apex : ' + ACTFPJSON2Apex);
                SRAuthorizations = ACTFPJSON2Apex.findMedicalHealthServiceCaseAuthorizationsResult.findAuthorizationsResponseBaseType.findAuthorizationsByMemberResponse.authorization;
                if (SRAuthorizations != null){
                    system.debug(' # SRAuthorizations : ' + SRAuthorizations.size());
                    if (SRAuthorizations.size() > 0 ){
                        for (ACETFindAuthorizationJSON2Apex.authorization SRAuthorization: SRAuthorizations){
                            Authorization = new ACETAuthorizationSearchResult();
                            if(SRAuthorization.serviceSettingTypeCode!=null){
                                Authorization.Case_Type_Code = SRAuthorization.serviceSettingTypeCode.code==null?'':SRAuthorization.serviceSettingTypeCode.code;
                                Authorization.Case_Type_Desc = SRAuthorization.serviceSettingTypeCode.descr==null?'':SRAuthorization.serviceSettingTypeCode.descr;
                            }
                            if(Authorization.Case_Type_Code == '1' || Authorization.Case_Type_Code == '2' || Authorization.Case_Type_Code == '3'){
                                Authorization.Authorization_Number = SRAuthorization.primaryServiceRefNbr==null?'':SRAuthorization.primaryServiceRefNbr;
                                String statusCodeDescr='';
                                String statusReasonCodeDescr='';
                                if(SRAuthorization.statusCode!=null){
                                    statusCodeDescr = SRAuthorization.statusCode.descr==null?'':SRAuthorization.statusCode.descr;
                                }
                                if(SRAuthorization.statusReasonCode!=null){
                                    statusReasonCodeDescr = SRAuthorization.statusReasonCode.descr==null?'':SRAuthorization.statusReasonCode.descr;
                                }
                                if(SRAuthorization.authID!=null){
                                    Authorization.authID = SRAuthorization.authId.id==null?'':SRAuthorization.authId.id;
                                }
                                Authorization.Case_Status= statusCodeDescr+'-'+statusReasonCodeDescr;
                                if(SRAuthorization.authDiagnosis!=null){
                                    for(ACETFindAuthorizationJSON2Apex.authDiagnosis authD:SRAuthorization.authDiagnosis){
                                        if(authD.diagnosisEncoding!=null){
                                            if(authD.diagnosisEncoding.diagnosisCodeCode!=null){
                                                Authorization.Primary_Diagnosis = (authD.diagnosisEncoding.diagnosisCodeCode.code==null?'':authD.diagnosisEncoding.diagnosisCodeCode.code)+' - '+(authD.diagnosisEncoding.diagnosisCodeCode.descr==null?'':authD.diagnosisEncoding.diagnosisCodeCode.descr);    
                                            }
                                        }
                                    }
                                }
                                if(SRAuthorization.createDatetime!=null){
                                    //Authorization.Create_Date = SRAuthorization.createDatetime.dteTime==null?'':Date.valueOf(SRAuthorization.createDatetime.dteTime).format();
                                    Authorization.Create_Date = SRAuthorization.createDatetime==null?'':Date.valueOf(SRAuthorization.createDatetime).format();
                                }
                                if(SRAuthorization.facilityStay.placeOfServiceCode!=null){
                                    Authorization.POS= SRAuthorization.facilityStay.placeOfServiceCode.descr==null?'':SRAuthorization.facilityStay.placeOfServiceCode.descr;   
                                }
                                String ServiceDesc= '';
                                String ServiceDetail= '';
                                if(SRAuthorization.facilityStay.servicedescUrgencyCode!=null){
                                    ServiceDesc= SRAuthorization.facilityStay.servicedescUrgencyCode.descr==null?'':SRAuthorization.facilityStay.servicedescUrgencyCode.descr;   
                                }
                               if(SRAuthorization.facilityStay.serviceDetailCategoryCode!=null){
                                    ServiceDetail= SRAuthorization.facilityStay.serviceDetailCategoryCode.descr==null?'':SRAuthorization.facilityStay.serviceDetailCategoryCode.descr;   
                                }
                                Authorization.ServiceDescDetail=ServiceDesc+' / '+ServiceDetail;
                            }
                            if(Authorization.Case_Type_Code == '1'){
                                if(SRAuthorization.facilityStay!=null){
                                    if(SRAuthorization.facilityStay.advanceNotificationIndicator!=null){
                                        Authorization.Pre_Determination = (SRAuthorization.facilityStay.advanceNotificationIndicator=='false')?'No':'Yes';
                                    }
                                    if(SRAuthorization.facilityStay.inPatient!=null){
                                        if(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay!=null){
                                            if(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.actualAdmitDate!=null){
                                                Authorization.Actual_Admit_Date = SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.actualAdmitDate==null?'':Date.valueOf(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.actualAdmitDate).format();
                                            }
                                            if(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.actualDischargeDate!=null){
                                                Authorization.Actual_Dscharg_Date = SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.actualDischargeDate==null?'':Date.valueOf(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.actualDischargeDate).format();
                                            }
                                            if(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.expectedAdmissionDate!=null){
                                                Authorization.Expected_Admit_Date = SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.expectedAdmissionDate==null?'':Date.valueOf(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.expectedAdmissionDate).format();
                                            }
                                            if(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.expectedDischargeDate!=null){
                                                Authorization.Expected_Dscharg_Date = SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.expectedDischargeDate==null?'':Date.valueOf(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.expectedDischargeDate).format();
                                            }
                                            Authorization.LOS = SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.lengthOfStay==null?'':SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.lengthOfStay;
                                        }   
                                    }                                  
                                }
                                
                                if(SRAuthorization.authProvider!=null){
                                    for(ACETFindAuthorizationJSON2Apex.authProvider authP:SRAuthorization.authProvider){
                                        String orgName='';
                                        String network1Descr='';
                                        if(authP.organization!=null){
                                            orgName = authP.organization.name==null?'':authP.organization.name;
                                        }
                                        if(authP.network1!=null){
                                            for(ACETFindAuthorizationJSON2Apex.network1 net1:authP.network1){   
                                                if(net1.networkTypeCode!=null){
                                                    network1Descr = net1.networkTypeCode.descr==null?'':net1.networkTypeCode.descr;
                                                }
                                            }
                                        }
                                        Authorization.Facility_Status = orgName+' / '+network1Descr;
                                    }
                                    
                                }
                            }
                            else if(Authorization.Case_Type_Code == '2'){
                                if(SRAuthorization.facilityStay!=null){
                                    if(SRAuthorization.facilityStay.advanceNotificationIndicator!=null){
                                        Authorization.Pre_Determination = (SRAuthorization.facilityStay.advanceNotificationIndicator=='false')?'No':'Yes';
                                    }
                                    else {
                                        Authorization.Pre_Determination = '';
                                    }  
                                    if(SRAuthorization.facilityStay.outPatient!=null){
                                        if(SRAuthorization.facilityStay.outPatient.outpatientStayEffDates!=null){
                                            Authorization.Start_Date = SRAuthorization.facilityStay.outPatient.outpatientStayEffDates.startDate==null?'':Date.valueOf(SRAuthorization.facilityStay.outPatient.outpatientStayEffDates.startDate).format();
                                            Authorization.End_Date = SRAuthorization.facilityStay.outPatient.outpatientStayEffDates.stopDate==null?'':Date.valueOf(SRAuthorization.facilityStay.outPatient.outpatientStayEffDates.stopDate).format();
                                        }
                                    }   
                                }
                                if(SRAuthorization.authService!=null){
                                    for(ACETFindAuthorizationJSON2Apex.authService authS:SRAuthorization.authService){
                                        if(authS.procedureCode!=null){
                                            if(authS.procedureCode.encodingCode!=null){
                                                Authorization.Procedure_Code = (authS.procedureCode.encodingCode.code==null?'':authS.procedureCode.encodingCode.code)+' - '+(authS.procedureCode.encodingCode.descr==null?'':authS.procedureCode.encodingCode.descr);    
                                            }
                                        }
                                        if(authS.procedureOtherText!=null){
                                            if(authS.procedureOtherText.procedureUnitOfMeasureType!=null){
                                                Authorization.Count = (authS.procedureOtherText.procedureUnitOfMeasureType.code==null?'':authS.procedureOtherText.procedureUnitOfMeasureType.code)+' - '+(authS.procedureOtherText.procedureUnitOfMeasureType.descr==null?'':authS.procedureOtherText.procedureUnitOfMeasureType.descr);    
                                            }
                                        }
                                    }
                                }                              
                                if(SRAuthorization.authProvider!=null){
                                    for(ACETFindAuthorizationJSON2Apex.authProvider authP:SRAuthorization.authProvider){
                                        String fName='';
                                        String lName='';
                                        String network1Descr='';
                                        if(authP.professional!=null){
                                            fName = authP.professional.firstname==null?'':authP.professional.firstname;
                                            lName = authP.professional.lastname==null?'':authP.professional.lastname;
                                        }
                                        if(authP.network1!=null){
                                            for(ACETFindAuthorizationJSON2Apex.network1 net1:authP.network1){   
                                                if(net1.networkTypeCode!=null){
                                                    network1Descr = net1.networkTypeCode.descr==null?'':net1.networkTypeCode.descr;
                                                }
                                            }
                                        }
                                        Authorization.ServiceProviderStatus = fName+' '+lName+' / '+network1Descr;
                                    }
                                    
                                }
                            }
                            else if(Authorization.Case_Type_Code == '3'){
                                if(SRAuthorization.facilityStay!=null){
                                    if(SRAuthorization.facilityStay.advanceNotificationIndicator!=null){
                                        Authorization.Pre_Determination = (SRAuthorization.facilityStay.advanceNotificationIndicator=='false')?'No':'Yes';
                                    }
                                   /* if(SRAuthorization.facilityStay.inPatient!=null){
                                        if(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay!=null){
                                            System.debug(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay);
                                            if(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.actualAdmitDate!=null){
                                                Authorization.Actual_Start_Date = SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.actualAdmitDate.dteTime==null?'':Date.valueOf(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.actualAdmitDate.dteTime).format();
                                            }
                                            if(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.actualDischargeDate!=null){
                                                Authorization.Actual_End_Date = SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.actualDischargeDate.dteTime==null?'':Date.valueOf(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.actualDischargeDate.dteTime).format();
                                            }
                                            if(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.expectedAdmissionDate!=null){
                                                Authorization.Expected_Start_Date = SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.expectedAdmissionDate.dte==null?'':Date.valueOf(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.expectedAdmissionDate.dte).format();
                                            }
                                            if(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.expectedDischargeDate!=null){
                                                Authorization.Expected_End_Date = SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.expectedDischargeDate.dte==null?'':Date.valueOf(SRAuthorization.facilityStay.inPatient.findPatientFacilityStay.expectedDischargeDate.dte).format();
                                            }
                                        }   
                                    }*/
                                    if(SRAuthorization.facilityStay.outPatient!=null){
                                        if(SRAuthorization.facilityStay.outPatient.findPatientFacilityStay!=null){
                                            System.debug(SRAuthorization.facilityStay.outPatient.findPatientFacilityStay);
                                           if(SRAuthorization.facilityStay.outPatient.findPatientFacilityStay.actualAdmitDate!=null){
                                                Authorization.Actual_Start_Date = SRAuthorization.facilityStay.outPatient.findPatientFacilityStay.actualAdmitDate==null?'':Date.valueOf(SRAuthorization.facilityStay.outPatient.findPatientFacilityStay.actualAdmitDate).format();
                                            }
                                            if(SRAuthorization.facilityStay.outPatient.findPatientFacilityStay.actualDischargeDate!=null){
                                                Authorization.Actual_End_Date = SRAuthorization.facilityStay.outPatient.findPatientFacilityStay.actualDischargeDate==null?'':Date.valueOf(SRAuthorization.facilityStay.outPatient.findPatientFacilityStay.actualDischargeDate).format();
                                            }
                                            if(SRAuthorization.facilityStay.outPatient.findPatientFacilityStay.expectedAdmissionDate!=null){
                                                Authorization.Expected_Start_Date = SRAuthorization.facilityStay.outPatient.findPatientFacilityStay.expectedAdmissionDate==null?'':Date.valueOf(SRAuthorization.facilityStay.outPatient.findPatientFacilityStay.expectedAdmissionDate).format();
                                            }
                                            if(SRAuthorization.facilityStay.outPatient.findPatientFacilityStay.expectedDischargeDate!=null){
                                                Authorization.Expected_End_Date = SRAuthorization.facilityStay.outPatient.findPatientFacilityStay.expectedDischargeDate==null?'':Date.valueOf(SRAuthorization.facilityStay.outPatient.findPatientFacilityStay.expectedDischargeDate).format();
                                            }
                                        }   
                                    }
                                }
                                if(SRAuthorization.authService!=null){
                                    for(ACETFindAuthorizationJSON2Apex.authService authS:SRAuthorization.authService){
                                        if(authS.procedureCode!=null){
                                            if(authS.procedureCode.encodingCode!=null){
                                                Authorization.Procedure_Code = (authS.procedureCode.encodingCode.code==null?'':authS.procedureCode.encodingCode.code)+' - '+(authS.procedureCode.encodingCode.descr==null?'':authS.procedureCode.encodingCode.descr);    
                                            }
                                        }
                                    }
                                }
                                if(SRAuthorization.authProvider!=null){
                                    for(ACETFindAuthorizationJSON2Apex.authProvider authP:SRAuthorization.authProvider){
                                        String orgName='';
                                        String network1Descr='';
                                        String fName='';
                                        String lName='';
                                        if(authP.organization!=null){
                                            orgName = authP.organization.name==null?'':authP.organization.name;
                                        }
                                        if(authP.network1!=null){
                                            for(ACETFindAuthorizationJSON2Apex.network1 net1:authP.network1){   
                                                if(net1.networkTypeCode!=null){
                                                    network1Descr = net1.networkTypeCode.descr==null?'':net1.networkTypeCode.descr;
                                                }
                                            }
                                        }
                                        if(authP.professional!=null){
                                            fName = authP.professional.firstname==null?'':authP.professional.firstname;
                                            lName = authP.professional.lastname==null?'':authP.professional.lastname;
                                        }
                                        Authorization.Facility_Status = orgName+' / '+network1Descr;
                                        Authorization.ServiceProvider = fName+' '+lName+' / '+network1Descr;
                                    }
                                    
                                }
                            }
                            else{
                                continue;
                            }
                            System.debug('Authorization'+Authorization);
                            Authorizations.add(Authorization);
                        }
                        if (Authorizations.size() > 0){
                            oACETWSCalloutResult.Success = true;
                            oACETWSCalloutResult.Message = '';
                            oACETWSCalloutResult.Response = Authorizations;
                        }
                        else{
                            oACETWSCalloutResult.Success = true;
                            oACETWSCalloutResult.Message = 'No Authorization Present for this Member';
                            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO; 
                        }
                    }
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
            system.debug(LoggingLevel.INFO, 'Exception in FindAuthorizations. Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);         
        return oACETWSCalloutResult;
    }
}