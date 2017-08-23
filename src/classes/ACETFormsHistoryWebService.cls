public class ACETFormsHistoryWebService extends ACETWebService{

    public String searchSourceID{get;set;}
    public Integer fulfillmentType{get;set;}
    public String rangeStartEventReceivedDate{get;set;}
    public String rangeEndEventReceivedDate{get;set;}
    public String recipientID{get;set;}
    public String idQualifier{get;set;}
    //
    public override void getEndpoint(){
        GetEndpointDetail('FindFulfillmentHistory');
               
    }
    
    public void getEndpoint(Boolean isCallableService,Boolean isAdaptor){
        if(isCallableService){
            RelativeUrl = '/api/bravo/eisl/individuals/v2.0/search';
        }else if(isAdaptor){
            RelativeUrl = '/api/alpha/eisl/individuals/v2.0/search';
        }else{
            GetEndpointDetail('FindFulfillmentHistory'); 
        }
    }
    
    //init service query params
    public void init(){
        
        queryPaginatedData(1,1,1);
    }
    public void init(String searchSourceID, Integer fulfillmentType, String rangeStartEventReceivedDate, String rangeEndEventReceivedDate,String recipientID, String idQualifier){ 
         
         this.searchSourceID = searchSourceID;
         this.fulfillmentType = fulfillmentType;
         this.rangeStartEventReceivedDate = rangeStartEventReceivedDate;
         this.rangeEndEventReceivedDate = rangeEndEventReceivedDate;
         //this.recipientID = 'member';
         //this.idQualifier = 'MemberID';
         //recipientID = recipientID.replaceAll('\"[^\"]*\":null','');
         //String recipientID = 'ACET'+String.valueof(system.now()).replaceAll( '\\s+', '')
         this.recipientID = recipientID;
         this.idQualifier = idQualifier;
        //  queryPaginatedData(1,1,1);
    }
    
    //to remove to global util class
   public String formatDatetime(String dateTimeString){        
        if(!String.isEmpty(dateTimeString)){
            List<String> dtParts = dateTimeString.split('T');
            if(dtParts.size() == 2){
                String dateString = dtParts[0];
                String timeString = dtParts[1];
                
                List<String> dateParts = dateString.split('-');               
                if(dateParts.size() == 3){
                    String mm = dateParts[1];
                    String dd = dateParts[2];
                    String yyyy = dateParts[0];
                    
                    mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','') : mm ; 
                    dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','') : dd; 
                    
                    if(timeString.length() > = 8){                       
                        return mm  + '/' + dd + '/' + yyyy + ' ' + timeString.substring(0,8);
                    }
                }
                
            }
        }
        return dateTimeString;
    }
    
    public String FormatRecpt (String  recipient){
    
       if(!String.isEmpty(recipient)){
       
       recipient= recipient.replaceAll('\"[^\"]*\":null',''); //basic removeal of null values
        

       }
     return recipient;
    }
    
    //to remove to global util class
    public String formatDate(String dateString){
        if(dateString == null) return null;
        
        List<String> dateParts = dateString.split('-');
        if(dateParts.size() == 3){
            String mm = dateParts[1];
            String dd = dateParts[2];
            String yyyy = dateParts[0];
            
            mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','') : mm ; 
            dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','') : dd; 
                                   
            return mm  + '/' + dd + '/' + yyyy;
        }else{
            return dateString;
        }
    }
    
    //implement pagianted data service
    public override ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord){                    
        
        ACETWSCalloutResult searchResult = new ACETWSCalloutResult();
        List<ACETFormsHistoryResult> fulfillmentSearchResult;
        
        try{
            ServiceName = 'FindFulfillmentHistory';
            getEndpoint();                        
            
            RequestBody='{"findFulfillmentHistory": {'
                    +'"findFulfillmentHistoryRequest": {'
                    +'"searchSourceID": "'+ this.searchSourceID +'",'
                    +'"fulfillmentType": "'+ this.fulfillmentType+'",'// 10700,'
                    +'"rangeStartEventReceivedDate": "'+ formatDate(this.rangeStartEventReceivedDate) +'",'
                    +'"rangeEndEventReceivedDate": "'+ formatDate(this.rangeEndEventReceivedDate) +'",'
                    +'"recipientID": "'+ this.recipientID +'",'
                    +'"idQualifier": "'+ this.idQualifier +'"'
                    +'}'
                +'}'
            +'}';
            
            system.debug('RequestBody----------------'+RequestBody);
            
            HttpResponse response;  
            
            response = Send(OAuthConfig); 
            system.debug('response>>>>72>>>>'+response);
            system.debug(response.getStatusCode());          
        
            if(response.getStatusCode() == 200){ 
                system.debug('response>>>>>>>>'+response.getBody());                            
                
                
                
               if(response.getBody() != null){
                
                    //replace date with date2 as date is preserved keyword
                    String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                    ACETFindFulfillmentHistoryJSON2Apex ACTFMJSON2Apex = (ACETFindFulfillmentHistoryJSON2Apex)JSON.deserialize(responseBody, ACETFindFulfillmentHistoryJSON2Apex.class);
                    system.debug('ACETFindFulfillmentHistoryJSON2Apex : ' + ACTFMJSON2Apex );
    
                    fulfillmentSearchResult = new List<ACETFormsHistoryResult>();
                  
                    if(ACTFMJSON2Apex.FindFulfillmentHistoryResult.findFulfillmentHistoryResponse.searchResultSet != null){
                        
                        for(ACETFindFulfillmentHistoryJSON2Apex.SearchResultSet objSearchResultSet : ACTFMJSON2Apex.FindFulfillmentHistoryResult.findFulfillmentHistoryResponse.searchResultSet){
                            
                            ACETFormsHistoryResult objACETFormsHistoryResult = new ACETFormsHistoryResult();
                            
                            objACETFormsHistoryResult.Address = (objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].MailToAddress.Address1 
                                                                + ',' +objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].MailToAddress.Address2
                                                                + ',' +objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].MailToAddress.city
                                                                + ' ' +objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].MailToAddress.state
                                                                + ' ' +objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].MailToAddress.zip).remove('null');
                                                                
                            objACETFormsHistoryResult.documentname = objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseTemplate.templateName;
                            //objACETFormsHistoryResult.documenttype = objSearchResultSet.responseCurrentEventLog.processorName;
                            objACETFormsHistoryResult.documenttype = objSearchResultSet.responseRequestHeader.fulfillmentTypeBusName;
                            if(objSearchResultSet.responseCurrentEventLog.dispatchedDate!=null){
                            objACETFormsHistoryResult.maileddate = formatDatetime(objSearchResultSet.responseCurrentEventLog.dispatchedDate);
                            }
                            system.debug('response>>>>>>>>objACETFormsHistoryResult.maileddate>>>>'+objACETFormsHistoryResult.maileddate); 
                            objACETFormsHistoryResult.quantity = objSearchResultSet.responseRequestHeader.requestTrailer.requestItemCount;
                            if(objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].person != null){
                            objACETFormsHistoryResult.recipient = (objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].person.prefix
                                                                  +' '+objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].person.firstName
                                                                  +' '+objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].person.middleName
                                                                  +' '+objSearchResultSet.responseRequestDetail.responseTransactionalRequestDetail.responseRecipient[0].person.lastName).remove('null');
                            }
                            else
                              objACETFormsHistoryResult.recipient = '';
                            //objACETFormsHistoryResult.requestdate = datetime.valueof(objSearchResultSet.responseRequestHeader.requestDate.substring(0,10) + ' ' + objSearchResultSet.responseRequestHeader.requestDate.substring(12,18) );
                            objACETFormsHistoryResult.requestdate = formatDatetime(objSearchResultSet.responseRequestHeader.requestDate);
                            //objACETFormsHistoryResult.requestdate = (DateTime)JSON.deserialize(objSearchResultSet.responseRequestHeader.requestDate,DateTime.class);
                            objACETFormsHistoryResult.source = objSearchResultSet.responseRequestHeader.sourceIDName;
                            objACETFormsHistoryResult.status = objSearchResultSet.responseCurrentEventLog.statusCode;
                            
                            fulfillmentSearchResult.add(objACETFormsHistoryResult); 
                        }
                    }
                   
                    searchResult.Success = true;
                    searchResult.Message = '';
                    searchResult.Response = fulfillmentSearchResult;
                } 
            }else if(response.getStatusCode() == 404 || response.getStatusCode() == 500){                
                searchResult.MessageSeverity = ApexPages.Severity.INFO;
                searchResult.Success = true;                
                searchResult.Response = new List<ACETFormsHistoryResult>();
                searchResult.Message = 'Search criteria returned no matches.';                
                searchResult.recordCount = '0';                
                system.debug(searchResult);                
            }
            }catch(Exception e){
                    system.debug(e);
                    searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                    searchResult.Success = false;
                    searchResult.Message = 'Web Service or External System is temporarily unavailable.';
                    searchResult.recordCount = '0';
           }
        
        return searchResult;        
    }
}