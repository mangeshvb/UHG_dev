public class ACETUpdateIndividualWebService extends ACETWebService {
    
    public override void getEndpoint(){
        //GetEndpointDetail('UpdateIndividualMemberEndpoint'); 
        RelativeURL='/api/alpha/eisl/individuals/membership/v1.0/update';          
    }
     public override void GetMethod(){
       Method = 'PUT';          
    }
    public void getRequestBody(String memberId, String scrId, String groupNumber, String lastName,string firstname,string middleName, string nameSuffix,string ssn,string gender,string dob,string relationshipcode, String emlindicator, String emailId,String commCode, List<ACETMemberDetail.Phone> PhoneList,String pcpId,String pcptype,String pcpAssignmentType,String pcpStartDate,String pcpEffectiveEndDate){
        if(phoneList != null && phoneList.size() > 0){
                RequestBody =   '{"updateIndividualMembershipRequest": {'
                                        +'"individualMembership": {'
                                            +'"groupNumber":'+ groupNumber +' ,'
                                            +'"subscriberIDCardSerialNumber": "'+ scrId+'",'
                                            +'"memberIDCardSerialNumber":'+ memberId +' ,'
                                            +'"name": {'
                                                +'"lastName": "'+ lastName +'",'
                                                +'"firstName": "'+ firstname +'",'
                                                +'"middleName": "'+ middleName +'",'
                                                +'"nameSuffix": "'+ nameSuffix +'"'
                                            +'},'
                                            +'"socialSecurityNumber":'+ ssn +' ,'                                            
                                            +'"gender": "'+ gender +'",'
                                            +'"birthDate": "'+ formatDate(dob) +'",'                                            
                                            +'"phone": [';
                 for(ACETMemberDetail.Phone phn : phoneList) {                          
                     RequestBody =             RequestBody +'{'
                                                    +'"phoneType": "'+ phn.PhoneNumberType +'",'
                                                    +'"phoneNumber": "'+ phn.PhoneNumber +'",'
                                                    +'"phoneExt": "",'
                                                    +'"primaryIndicator": "'+ phn.primaryIndicator +'"'
                                                +'},' ;
                 } 
                 RequestBody = RequestBody.substring(0,RequestBody.length()-1);                          
                 
                 RequestBody =              RequestBody +'],'
                                            +'"email": [{'
                                                +'"communicationTypeCode": "'+ commCode +'",'
                                                +'"electronicAddress": "'+ emailId +'",'
                                                +'"primaryIndicator": "'+ emlindicator +'"'
                                            +'}],'
                                            +'"relationShipCode":'+ relationshipcode
                                        +' }'
                                    +'}'
                                +'}';           
            
        }
        else if(!String.isEmpty(pcpId)){
                RequestBody =   '{"updateIndividualMembershipRequest": {'
                                        +'"individualMembership": {'
                                            +'"groupNumber":'+ groupNumber +' ,'
                                            +'"subscriberIDCardSerialNumber": "'+ scrId+'",'
                                            +'"memberIDCardSerialNumber":'+ memberId +' ,'
                                            +'"name": {'
                                                +'"lastName": "'+ lastName +'",'
                                                +'"firstName": "'+ firstname +'",'
                                                +'"middleName": "'+ middleName +'",'
                                                +'"nameSuffix": "'+ nameSuffix +'"'
                                            +'},'
                                            +'"socialSecurityNumber":'+ ssn +' ,'                                            
                                            +'"gender": "'+ gender +'",'
                                            +'"birthDate": "'+ formatdate(dob) +'",'                                            
                                           /* +'"email": [{'
                                                +'"communicationTypeCode": "'+ commCode +'",'
                                                +'"electronicAddress": "'+ emailId +'",'
                                                +'"primaryIndicator": "'+ emlindicator +'"'
                                            +'}],'*/
                                            +'"relationShipCode":'+ relationshipcode +','
                                            +'"providers": [{'
                                                +'"providerIdentifiers":[ {'
                                                    +'"id":'+ pcpId +','
                                                    +'"type":"'+ pcptype +'"'
                                                +'}],'
                                                +'"assignmentType": "'+ pcpAssignmentType +'",'
                                                +'"effectiveStartDate": "'+ pcpStartDate +'",'
                                                +'"effectiveEndDate": "'+ pcpEffectiveEndDate +'"'
                                            +'}]'
                                        +' }'
                                    +'}'
                                +'}'; 
        }
       system.debug('2323 request body' + RequestBody);                                     
    }    
    
    public ACETWSCalloutResult updateMembers(String memberId,String scrId, String groupNumber, String lastName,string firstname,string middleName, string nameSuffix,string ssn,string gender,string dob,string relationshipcode, String emlindicator, String emailId,String commCode, List<ACETMemberDetail.Phone> PhoneList,String pcpId,String pcptype,String pcpAssignmentType,String pcpStartDate,String pcpEffectiveEndDate){
        
        ACETWSCalloutResult UpdateResult = new ACETWSCalloutResult();
           
        try {
            ServiceName = 'updateIndividualMembershipService';
            GetEndpoint();                       
            GetRequestBody( memberId,  scrId, groupNumber, lastName, firstname, middleName, nameSuffix, ssn, gender, dob, relationshipcode, emlindicator, emailId, commCode, PhoneList, pcpId, pcptype, pcpAssignmentType, pcpStartDate, pcpEffectiveEndDate);
            GetMethod();
            HttpResponse response;  
            if(RequestBody != null)
                response = Send(OAuthConfig);                        
            system.debug('----------->'+ response);          
            if(response.getStatusCode() == 200){
                if(response.getBody() != null){
                    
                    //replace date with date2 as date is preserved keyword
                        String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                        system.debug('responseBody'+ responseBody);
                        responseBody = response.getBody().replace('\"type\":', '\"type_Z\":');  
                        Type resultType = Type.forName('ACETUpdIndividualMemResJSON2Apex');
                        ACETUpdIndividualMemResJSON2Apex memberUpdateResult = (ACETUpdIndividualMemResJSON2Apex)JSON.deserialize(responseBody , resultType);                      
                        UpdateResult.Success = true;
                        UpdateResult.Message = '';
                        UpdateResult.Response = memberUpdateResult;                     
                }                                      
            }else if(response.getStatusCode() == 500){
                //currently servce returns 500 if no records found
                UpdateResult.MessageSeverity = ApexPages.Severity.INFO;
                UpdateResult.message = 'Internal Server Error';  
                UpdateResult.Success = false;                
             //   UpdateResult.Response = new List<ACETMemberSearchResult>();
                              
            }else if(response.getStatusCode() == 404){
                
                //currently servce returns 404 if no records found (Adapters)
                UpdateResult.MessageSeverity = ApexPages.Severity.INFO;
                UpdateResult.Success = false;
                UpdateResult.message = 'Member not Found';                
              //  UpdateResult.Response = new List<ACETMemberSearchResult>();
               // system.debug(UpdateResult);                
            }
            else if(response.getStatusCode() == 400){
                
                UpdateResult.MessageSeverity = ApexPages.Severity.INFO;
                UpdateResult.Success = false;
                UpdateResult.message = 'Bad Request';                
              //  UpdateResult.Response = new List<ACETMemberSearchResult>();
               // system.debug(UpdateResult);                
            }
            }catch(Exception e){
                    system.debug(e);
                    UpdateResult.MessageSeverity = ApexPages.Severity.ERROR;
                    UpdateResult.Success = false;
                    UpdateResult.Message = 'Web Service or External System is temporarily unavailable.';
                    //UpdateResult.Message = e.getMessage() ;
           }
        
        return UpdateResult;    
    }
 
    public String formatDate(String dateString){
        if(dateString == null) return null;
        
        List<String> dateParts = dateString.split('/');
        if(dateParts.size() == 3){
            String mm = dateParts[0];
            String dd = dateParts[1];
            String yyyy = dateParts[2];
            
            mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','') : mm ; 
            dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','') : dd; 
                                   
            return yyyy  + '-' + mm + '-' + dd;
        }else{
            return dateString;
        }
    }
    /*public void getRequestBody(String memberId, String groupNumber, String indicator, String emailId,String commCode, String PhoneExt,String PhoneNum,String phoneTyp,String pcpId,String pcptype,String pcpAssignmentType,String pcpStartDate,String pcpEffectiveEndDate){
    
        String strstaticfilename = 'UpdateIndividualMembership';
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
        
        //Added by Harish for covering in the test class  
        if(!Test.isRunningTest())
        {        
            RequestBody = pg.getContent().toString();
            system.debug('----RB---->'+RequestBody);
        }
        else 
        {
            RequestBody = 'UNIT.TEST';
        }
        system.debug(RequestBody);
    }*/
}