public with sharing class ACETDataTableController { 
    
    @RemoteAction
    public static ACETWSCalloutResult queryPaginatedData(String serviceName,String service, Integer pageNumber, Integer pageSize, Integer startRecord){
        Type t = Type.forname(serviceName); 
        System.debug('Print Page Number::::'+pageNumber+pageSize);    
        ACETWebservice serviceObj = (ACETWebservice)JSON.deserialize(service, t);  
        ACETWSCalloutResult result =serviceObj.queryPaginatedData(pageNumber, pageSize, startRecord);
        system.debug(result);
        return result;                        
    }     
}