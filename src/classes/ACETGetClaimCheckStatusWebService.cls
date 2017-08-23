/**
* @name         :   ACETGetClaimCheckStatusWebservice
* @description  :   Custom Class to perform the Claim Payment Summary Weservice Callout
* @author       :   Khoushik Selvaraj
* @userstories  :
* @createddate  :   04-11-2016
* @lastmodifiedby:
*
**/
public class ACETGetClaimCheckStatusWebService extends ACETWebService{
    
    public override void GetEndpoint()
    {
        GetEndpointDetail('CheckClaimStatusEndpoint');
    }
    
    private void getRequestBody(String strCheckNumber, string strSeriesDesignator){
        //TODO : as per the actual request structure
        system.debug('strCheckNumber'+strCheckNumber+'strSeriesDesignator'+strSeriesDesignator);
        String strstaticfilename = 'checkstatusRequest';        
        StaticResource sr = [SELECT Id,NamespacePrefix,SystemModstamp FROM StaticResource WHERE Name = :strstaticfilename LIMIT 1];
        String prefix = sr.NamespacePrefix;
        if( String.isEmpty(prefix) ) {
            prefix = '';
        } else {
            //If has NamespacePrefix
            prefix += '__';
        }
        String srPath = '/resource/' + sr.SystemModstamp.getTime() + '/' + prefix + strstaticfilename; 
        system.debug('**PATH**'+srPath);
        PageReference pg = new PageReference(srPath); 
       
        if(!Test.isRunningTest())
        {        
         RequestBody = pg.getContent().toString();
        }
        else 
        {
          RequestBody = 'UNIT.TEST';
        }
        if(RequestBody != null && RequestBody != ''){
        RequestBody = ((strCheckNumber != null && strCheckNumber != '') ? RequestBody.replace('@@CheckNumber@@',strCheckNumber) : RequestBody.replace('@@CheckNumber@@', '')); 
     //   RequestBody = strCheckNumber != null && strCheckNumber != '' ? RequestBody.replace('@@checkNumberId@@',strCheckNumber) : RequestBody.replace('@@checkNumberId@@', '');
        RequestBody = (strSeriesDesignator != '' ? RequestBody.replace('@@SeriesDesignator@@',strSeriesDesignator) : RequestBody.replace('@@SeriesDesignator@@', '')); 
      //   RequestBody = strSeriesDesignator != '' ? RequestBody.replace('@@checkSeriesDesignatorId@@',strSeriesDesignator) : RequestBody.replace('@@checkSeriesDesignatorId@@', '');
        }
        system.debug('*** my json' + RequestBody );
  
    }
    
     public ACETWSCalloutResult getCheckstatus(String strcheckNumber,string strSeriesDesignator){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETGetClaimCheckStatusResult> checks = new List<ACETGetClaimCheckStatusResult>();
        ACETGetClaimCheckStatusResult check;
        List<ACETGetClaimCheckStatusJSON2Apex.checkStatusResponse> checkStatusResponse;
        try{
            GetEndpoint();
            GetRequestBody(strCheckNumber, strSeriesDesignator);
            HttpResponse Response = Send(OAuthConfig);
            if (Response.getStatusCode() == 200){            
                                      string jsonfullstring = Response.getBody();system.debug('jsonfullstring232323'+jsonfullstring);
                                      jsonfullstring = jsonfullstring.replace('"date"','"voiddate"');
                                      Type resultType = Type.forName('ACETGetClaimCheckStatusJSON2Apex');
                                                ACETGetClaimCheckStatusJSON2Apex searchresults = (ACETGetClaimCheckStatusJSON2Apex)JSON.deserialize(jsonfullstring , resultType);                                             
                                                checkStatusResponse = searchresults.Result.GetCheckStatusResponseMsg.body.checkStatusResponse;system.debug('checkStatusResponse232323'+checkStatusResponse);
                                                if (checkStatusResponse != null && checkStatusResponse.size() > 0){
                                                        for (ACETGetClaimCheckStatusJSON2Apex.checkStatusResponse checkstatus: checkStatusResponse){
                                                            system.debug('checkstatus232323'+checkstatus);
                                                            if(checkstatus != null){ 
                                                            check = new ACETGetClaimCheckStatusResult();
                                                            Date CashedDate = null;
                                                           // system.debug('funddate'+checkstatus.paymentFundDate.voiddate);
                                                            if(checkstatus.paymentFundDate != null){
                                                                if(checkstatus.paymentFundDate.voiddate != ''){
                                                                    CashedDate  = Date.valueOf(checkstatus.paymentFundDate.voiddate);
                                                                }
                                                            }
                                                            check.CashedDate =  CashedDate;         
                                                            Date voidDate = null;
                                                            //system.debug('voiddate'+checkstatus.voidDate.voiddate);
                                                            if(checkstatus.voidDate != null){
                                                                if(checkstatus.voidDate.voiddate != ''){
                                                                    voidDate  = Date.valueOf(checkstatus.voidDate.voiddate);
                                                                }
                                                            } 
                                                            check.VoidStopDate =  voidDate;  
                                                            checks.add(check);
                                                            }
                                                        }
                                                            
                                                }
                                                else{
                                                    oACETWSCalloutResult.Success = false;
                                                    oACETWSCalloutResult.Message = 'No Checks Found';
                                                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
                                                }
            }
            else{
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
            }
      
            if (checks.size() > 0){
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = checks;
            }
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in Check Status. Details: ' + ex + ex.getStackTraceString()); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
        }
        
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);         
        return oACETWSCalloutResult;
    }
}