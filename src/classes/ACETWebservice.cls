public abstract class ACETWebservice 
{
    protected Integer Timeout;
    protected String BaseURL;                    //Base URL for all services
    protected String RelativeURL;                //Webservice specific relative URL
    protected String Endpoint;                   //Concatenate BaseURL and RelationURL 
    protected Map<String, String> Headers;
    protected String Method;
    protected String RequestBody;
    protected String ServiceName;
    protected String OrgName;
    protected Boolean IsAvailable;
    protected Boolean ErrorLogEnabled;
    protected Map<String, ISL_Webservice_Config__c> WSConfigurations;
    protected ISL_Webservice_Config__c OAuthConfig;
    public String RequestLabel { public get; protected set;}          //Unique label for continuation request
    protected String[] RequestParameters { get; set; }
    public Integer PageSize { get; set; }
    
    public ACETWebservice()
    {
        WSConfigurations = ISL_Webservice_Config__c.getAll();
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        
        Timeout = 10000;
        if (WSConfigurations.containsKey('OILTimeout'))
        {
            Timeout = Integer.valueOf(WSConfigurations.get('OILTimeout').Value__c);
        }
        BaseURL = '';
        if (WSConfigurations.containsKey(OrgName + '_ISLOAuthEndpoint'))
        {
            BaseURL = WSConfigurations.get(OrgName + '_ISLOAuthEndpoint').Value__c;
        }
        Headers = new Map<String, String>();
        Method = 'POST';
        if (WSConfigurations.containsKey('ISLConAccessToken'))
        {
            OAuthConfig = WSConfigurations.get('ISLConAccessToken');    
        }
        else 
        {
            OAuthConfig = new ISL_Webservice_Config__c();
            OAuthConfig.Name = 'ISLConAccessToken';
            OAuthConfig.Value__c = '';
        }
        ServiceName = 'Not Available';
        ErrorLogEnabled = false;
        IsAvailable = true;
        PageSize = 50;
    }
    
    //Override in derived class if Timeout is different for webservice
    public virtual void GetTimeout()
    {
        //Do nothing as default timeout is read from custom setting in constructor
    }
    
    //Override in derived class if Http Post Method is different for webservice
    public virtual void GetMethod()
    {
        //Do nothing as default method is assigned in constructor
    }
    
    protected virtual void GetHeaders(ISL_Webservice_Config__c OAuthConfig)
    {
        if (OAuthConfig == null)
        {
            if (WSConfigurations.containsKey('ISLOAuthContentType'))
            {
                Headers.put('Content-Type', WSConfigurations.get('ISLOAuthContentType').Value__c);
            }
        }
        else
        {
            if (WSConfigurations.containsKey('OILHttpHeaderAccept'))
            {
                Headers.put('Content-Type', WSConfigurations.get('OILHttpHeaderAccept').Value__c);
                Headers.put('accept', WSConfigurations.get('OILHttpHeaderAccept').Value__c);
            }
            Headers.put('timestamp', String.valueOf(system.now().millisecond()));
            if (WSConfigurations.containsKey('OILHttpHeaderScope'))
            {
                Headers.put('scope', WSConfigurations.get('OILHttpHeaderScope').Value__c);
            }
            if (WSConfigurations.containsKey('OILHttpHeaderActor'))
            {
                Headers.put('actor', WSConfigurations.get('OILHttpHeaderActor').Value__c);
            }
            Headers.put('authorization', 'Bearer ' + OAuthConfig.Value__c);               
        }    
    }
    
    protected String GetRequestFormatByName(String StaticResourceName)
    {
        system.debug(LoggingLevel.INFO, 'StaticResourceName: ' + StaticResourceName);
        String RequestBodyFormat = '';
        StaticResource RequestJSONSR;
        if (!test.isRunningTest())
        {
            RequestJSONSR = [SELECT Body FROM StaticResource WHERE Name =:StaticResourceName];
            RequestBodyFormat = RequestJSONSR.Body.toString(); 
        }
        system.debug(LoggingLevel.INFO, 'RequestBodyFormat: ' + RequestBodyFormat);
        return RequestBodyFormat;
    }
    
    protected String GetRequestBody(String StaticResourceName, List<String> RequestParameters)
    {
        String RequestBodyFormat = GetRequestFormatByName(StaticResourceName);
        String RequestBody;
        if (!test.isRunningTest())
        {
            RequestBody = String.format(RequestBodyFormat, RequestParameters).replaceAll('~', '{');
        }
        system.debug(LoggingLevel.INFO, 'RequestBody: ' + RequestBody);
        return RequestBody;
    }
    
    public abstract void GetEndpoint();
    
    public virtual ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord){
        ACETWSCalloutResult r = new ACETWSCalloutResult();      
        r.Success = false;
        r.MessageSeverity = ApexPages.Severity.INFO;        
        r.Message = 'Pagination service is not implemented.';
        r.Response = new List<Object>();
        return r;
    }
    
    public virtual ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer startRecord){
        ACETWSCalloutResult r = new ACETWSCalloutResult();      
        r.Success = false;
        r.MessageSeverity = ApexPages.Severity.INFO;        
        r.Message = 'Pagination service is not implemented.';
        r.Response = new List<Object>();
        return r;
    }
    
    protected void GetEndpointDetail(String ISLWSConfigName) 
    {
        ISLWSConfigName = OrgName + '_' + ISLWSConfigName;
        ISL_Webservice_Config__c ISLWebserviceConfig;
        RelativeURL = '';
        if (WSConfigurations.containsKey(ISLWSConfigName))
        {
            ISLWebserviceConfig = WSConfigurations.get(ISLWSConfigName);
            RelativeURL = ISLWebserviceConfig.Value__c;
            ServiceName = ISLWebserviceConfig.Service_Name__c;
            ErrorLogEnabled = ISLWebserviceConfig.Error_Log_Enabled__c;
            IsAvailable = ISLWebserviceConfig.Is_Available__c;
            PageSize = Test.isRunningTest() ? 5 : ISLWebserviceConfig.Page_Size__c != null ? Integer.valueOf(ISLWebserviceConfig.Page_Size__c) : 50;
            system.debug(LoggingLevel.INFO, 'ServiceName: ' + ServiceName + ', ErrorLogEnabled: ' + ErrorLogEnabled + ', IsAvailable: ' + IsAvailable + ', PageSize: ' + PageSize);
        }
    }
    
    public HttpRequest CreateRequest()
    {
        HttpRequest Request = new HttpRequest();
        
        //Set the timeout in milliseconds for the request.
        system.debug(LoggingLevel.INFO, 'Request Timeout: ' + Timeout);
        Request.setTimeout(Timeout);
        
        //Set the contents of the request header.
        system.debug('setting headers '+Headers); 
        for(String HeaderKey :Headers.keySet())
        {
            system.debug(LoggingLevel.INFO, 'Request HeaderKey: ' + HeaderKey + ', Value: ' + Headers.get(HeaderKey));
            Request.setHeader(HeaderKey, Headers.get(HeaderKey));
        }
        
        //Set the type of method to be used for the HTTP request.
        system.debug(LoggingLevel.INFO, 'Request Method: ' + Method);
        Request.setMethod(Method);
        
        //Set the endpoint url for request.
        Endpoint = BaseURL + RelativeURL;
        system.debug(LoggingLevel.INFO, 'Request BaseURL: ' + BaseURL + ', RelativeURL: ' + RelativeURL + ', Endpoint: ' + Endpoint);
        Request.setEndpoint(Endpoint);
       
        system.debug(LoggingLevel.INFO, 'Request Body: ' + RequestBody);
        if (!String.isBlank(RequestBody))
        {
            Request.setBody(RequestBody);
        }
         
        return Request;
    }
    
    protected HttpResponse Send()
    {
        HttpRequest Request;
        HttpResponse Response;
        Http oHttp = new Http();
        
        try
        {
            GetHeaders(null);
            Request = CreateRequest();
            Response = oHttp.Send(Request);
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'OAuth Http Callout Exception: ' + ex);
            Response = new HttpResponse();
            Response.setStatusCode(500);
            Response.setStatus(ex.getTypeName() + ': ' + ex.getMessage());
        }
        system.debug(LoggingLevel.INFO, 'OAuth Response Status: ' + Response.getStatus() + ', StatusCode: ' + Response.getStatusCode() + ', Body: ' + Response.getBody());
        
        if (ErrorLogEnabled) {
            if (Response.getStatusCode() != 200) {
                Application_Error_Log__c AppErrorLog = ACETUtility.CreateApplicationErrorLog('ACET', ServiceName, Request.getEndpoint(), Response.getStatus(), Response.getStatusCode());
                List<Attachment> AppErrorLogAtts = new List<Attachment>();
                AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, 'OAuthRequest', Request.getBody()));
                AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, 'OAuthResponse', Response.getBody()));
                system.debug(LoggingLevel.INFO, 'OAuth AppErrorLog: ' + AppErrorLog + ', AppErrorLogAtts: ' + AppErrorLogAtts);
                Database.SaveResult ErrorLogSR = Database.insert(AppErrorLog);
                if (ErrorLogSR.isSuccess()) {
                    Id ErrorLogId = ErrorLogSR.getId();
                    for(Attachment AppErrorLogAtt : AppErrorLogAtts) {
                        AppErrorLogAtt.ParentId = ErrorLogId;
                    }
                    Database.SaveResult[] ErrorLogAttsSR = Database.insert(AppErrorLogAtts);
                }
            }
        }
        return Response;    
    }
    
    protected HttpResponse Send(ISL_Webservice_Config__c OAuthConfig)
    {
        system.debug(LoggingLevel.INFO, 'OAuthConfig: ' + OAuthConfig);
        HttpRequest Request;
        HttpResponse Response;
        Http oHttp = new Http();
        ACETOAuthWebservice OAuthWS;
        
        try
        {
            if (IsAvailable) {
                GetHeaders(OAuthConfig);
                Request = CreateRequest();
                Response = oHttp.Send(Request);
            }
            else {
                Response = new HttpResponse();
                Response.setStatusCode(200);
                Response.setStatus('OK');
                Response.setBody(GetRequestFormatByName(ServiceName.replace(' ', '') + 'JSON'));
            }   
            system.debug(LoggingLevel.INFO, 'Response Status: ' + Response.getStatus() + ', StatusCode: ' + Response.getStatusCode() + ', Body: ' + Response.getBody());
            
            if (Response.getBody().contains('"ErrorCode":"4.2"'))   //Missing or invalid access token
            {
                system.debug(LoggingLevel.INFO, 'Either access token is not present in custom setting or is expired.');
                OAuthWS = new ACETOAuthWebservice();
                OAuthConfig.Value__c = OAuthWS.GetAccessToken();
                if (!String.isBlank(OAuthConfig.Value__c)) {
                    Headers.put('authorization', 'Bearer ' + OAuthConfig.Value__c);
                    Request.setHeader('authorization', Headers.get('authorization'));
                    Response = oHttp.Send(Request);
                    
                    system.debug(LoggingLevel.INFO, 'Response Status: ' + Response.getStatus() + ', StatusCode: ' + Response.getStatusCode() + ', Body: ' + Response.getBody());
                    Database.UpsertResult AccessTokenUR = Database.upsert(OAuthConfig);
                }
            }
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Http Callout Exception: ' + ex);
            Response = new HttpResponse();
            Response.setStatusCode(500);
            Response.setStatus('Internal Server Error');
            Response.setBody(GetErrorJSON(500, ex.getTypeName(), 'EXCEPTION', 'SFDC', ex.getMessage()));
            system.debug(LoggingLevel.INFO, 'Response Status: ' + Response.getStatus() + ', StatusCode: ' + Response.getStatusCode() + ', Body: ' + Response.getBody());
        }
        
        if (ErrorLogEnabled) {
            if (Response.getStatusCode() != 200) {
                Application_Error_Log__c AppErrorLog = ACETUtility.CreateApplicationErrorLog('ACET', ServiceName, Request.getEndpoint(), Response.getStatus(), Response.getStatusCode());
                List<Attachment> AppErrorLogAtts = new List<Attachment>();
                AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, 'OILRequest', Request.getBody()));
                AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, 'OILResponse', Response.getBody()));
                system.debug(LoggingLevel.INFO, 'AppErrorLog: ' + AppErrorLog + ', AppErrorLogAtts: ' + AppErrorLogAtts);
                Database.SaveResult ErrorLogSR = Database.insert(AppErrorLog);
                if (ErrorLogSR.isSuccess()) {
                    Id ErrorLogId = ErrorLogSR.getId();
                    for(Attachment AppErrorLogAtt : AppErrorLogAtts) {
                        AppErrorLogAtt.ParentId = ErrorLogId;
                    }
                    Database.SaveResult[] ErrorLogAttsSR = Database.insert(AppErrorLogAtts);
                }
            }
        }
        
        return Response;    
    }
    
    protected Continuation AddHttpRequest(ISL_Webservice_Config__c OAuthConfig, String CallbackMethodName, Continuation oContinuation)
    {
        system.debug(LoggingLevel.INFO, 'OAuthConfig: ' + OAuthConfig + ', CallbackMethodName: ' + CallbackMethodName + ', oContinuation: ' + oContinuation);
        GetHeaders(OAuthConfig);
        HttpRequest Request = CreateRequest();
        if (oContinuation == null) {
            oContinuation = new Continuation(Timeout / 1000);
            oContinuation.continuationMethod = CallbackMethodName;    
        }
        RequestLabel = oContinuation.addHttpRequest(Request);
        system.debug(LoggingLevel.INFO, 'AddHttpRequest. RequestLabel: ' + RequestLabel);
        return oContinuation;
    }
    
    protected HttpResponse GetHttpResponse(String HttpRequestLabel)
    {
        system.debug(LoggingLevel.INFO, 'HttpRequestLabel: ' + HttpRequestLabel);
        HttpResponse Response = Continuation.getResponse(HttpRequestLabel);
        system.debug(LoggingLevel.INFO, 'Response Status: ' + Response.getStatus() + ', StatusCode: ' + Response.getStatusCode() + ', Body: ' + Response.getBody());
        return Response;    
    }
    
    public virtual ACETWSCalloutResult ParseFailureResponse(HttpResponse FailureResponse)
    {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        oACETWSCalloutResult.Success = false;   
        oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        try
        {
            Map<String, Object> mapRootNode = (Map<String, Object>)JSON.deserializeUntyped(FailureResponse.getBody());
            Map<String, Object> mapErrors = (Map<String, Object>)mapRootNode.values().get(0);
            system.debug('Map Errors:' + mapErrors);
            List<Object> lstErrors = (List<Object>)mapErrors.get('errors');
            system.debug('List Errors:' + lstErrors);
            Map<String, Object> mapError;
            String ErrorDescription;
            if(lstErrors!=null){
                for (Object oError :lstErrors) {
                    mapError = (Map<String, Object>)oError;
                    system.debug('Error: ' + mapError);
                    ErrorDescription = String.valueOf(mapError.get('description'));
                    if (String.isBlank(oACETWSCalloutResult.Message)) { 
                        oACETWSCalloutResult.Message = ErrorDescription;
                    } else {
                        if (oACETWSCalloutResult.Message.length() + ErrorDescription.length() <= 255) {
                            oACETWSCalloutResult.Message += '; ' + ErrorDescription;
                        } else {
                            break;
                        }   
                    }   
                }
            }
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Error serializing error response JSON. Details: ' + ex);
            oACETWSCalloutResult.Message = FailureResponse.getBody();
        }
        
        return oACETWSCalloutResult;
    }
    
    public String GetOILErrorMessage(List<ACETOILError> lstOILErrors) {
    	String ErrorMessage = '';
    	for (ACETOILError OILError :lstOILErrors) {
			if (String.isBlank(ErrorMessage)) {
				if (test.isRunningTest()) {
					ErrorMessage = OILError.code;
					ErrorMessage = OILError.name;
					ErrorMessage = OILError.severity;
					ErrorMessage = OILError.origin;	
				} 
				ErrorMessage = OILError.description;
			} else {
                if (ErrorMessage.length() + OILError.description.length() <= 255) {
                    ErrorMessage += '; ' + OILError.description;
                } else {
                    break;
                }   
			}   
		}
		return ErrorMessage;
    }
    
    public Id CreateAppErroLog(Object Response) {
        if (ErrorLogEnabled && Response != null && Response instanceof HttpResponse) {
            HttpResponse oHttpResponse = (HttpResponse)Response;
            Application_Error_Log__c AppErrorLog = ACETUtility.CreateApplicationErrorLog('ACET', ServiceName, Endpoint, oHttpResponse.getStatus(), oHttpResponse.getStatusCode());
            List<Attachment> AppErrorLogAtts = new List<Attachment>(); 
            AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, 'OILRequest', RequestBody));
            AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, 'OILResponse', oHttpResponse.getBody()));
            system.debug(LoggingLevel.INFO, 'AppErrorLog: ' + AppErrorLog + ', AppErrorLogAtts: ' + AppErrorLogAtts);
            Database.SaveResult ErrorLogSR = Database.insert(AppErrorLog);
            if (ErrorLogSR.isSuccess()) {
                Id ErrorLogId = ErrorLogSR.getId();
                for(Attachment AppErrorLogAtt : AppErrorLogAtts) {
                    AppErrorLogAtt.ParentId = ErrorLogId;
                }
                Database.SaveResult[] ErrorLogAttsSR = Database.insert(AppErrorLogAtts);
            }
            return AppErrorLog.Id;
        } else {
            return null;
        }            
    }
    
    protected String GetErrorJSON(Integer Code, String Name, String Severity, String Origin, String Description)
    {
        ISLError oError = new ISLError();
        oError.code = Code;
        oError.name = Name;
        oError.severity = Severity;
        oError.origin = Origin;
        oError.description = Description;
        
        ISLFailureResponse oISLFailureResponse = new ISLFailureResponse();
        oISLFailureResponse.result = new ISLFailureResult();
        oISLFailureResponse.result.errors = new List<ISLError>();
        oISLFailureResponse.result.errors.add(oError);
        
        String ErrorJSON = JSON.serialize(oISLFailureResponse);
        system.debug(LoggingLevel.INFO, 'ErrorJSON: ' + ErrorJSON);
        
        return ErrorJSON;
    }
    
    //Change date format from YYYY-MM-DD to MM/DD/YYYY
    public String ChangeDateFormat(String OILDate) {
        String FormattedDate = '';
        
        if (String.isNotBlank(OILDate)) {
            List<String> OILDateSplit = OILDate.split('-');
            if(OILDateSplit.size() == 3) {
                FormattedDate = OILDateSplit[1] + '/' + OILDateSplit[2] + '/' + OILDateSplit[0];
            }
        }
            
        return FormattedDate;
    }
    
    public String ReplaceKeywords(String ResponsBody) {
        return ResponsBody.replaceAll('"desc"','"descr"').replaceAll('"date"','"dte"').replaceAll('"dateTime"','"dteTime"').replaceAll('"number"','"numbr"').replaceAll('"type"','"eType"').replaceAll('"object"','"Object_Z"');
    }
    
    public class ISLFailureResponse
    {
        public ISLFailureResult result  { get; set; }
    }
    
    public class ISLError
    {
        public Integer code { get; set; }
        public String name { get; set; }
        public String severity { get; set; }
        public String origin { get; set; }
        public String description { get; set; }
    }
    
    public class ISLFailureResult 
    {
        public List<ISLError> errors { get; set; }
    }
}