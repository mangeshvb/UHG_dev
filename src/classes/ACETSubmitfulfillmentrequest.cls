public class ACETSubmitfulfillmentrequest extends ACETWebService{

    public override void getEndpoint(){
        GetEndpointDetail('SubmitfulfillmentrequestEndPoint');
    }
    
    public void getRequestBody(String memberId,string groupId, string bundleId){
        RequestBody = '{"type": "MEMBERCARD","values": {'+
                      '"memberGroupID": "'+groupId+'",'+
                      '"memberID": "'+memberId+'",'+
                      '"benefitBundleOptionID": "'+bundleId+'"}}';                  
    }
    
    public ACETWSCalloutResult submitFulfillmentRequest(String memberId, string groupId, string bundleId){
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        getEndpoint();
        GetRequestBody(memberId,groupId,bundleId);
        
        HttpResponse response = Send(OAuthConfig);
        system.debug('response ---->'+response.getBody());
        if(response.getStatusCode() == 201){
            CorrelationIDWrapper correlationWrapper = (CorrelationIDWrapper)JSON.deserialize(response.getBody(), CorrelationIDWrapper.class);
            calloutResult.Success = true;
            calloutResult.Message = '';
            calloutResult.Response = correlationWrapper.externalCorrelationID;
        }else
        {
            calloutResult.Success = false;
            calloutResult.Message = '';
            calloutResult.Response = 'Web Service or External System is temporarily unavailable.';
        }
        
        return calloutResult;   
    
    } 
    
    public class CorrelationIDWrapper
    {
        public string externalCorrelationID{get;set;}
    }
    
}