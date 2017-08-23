public with sharing class ECMAutoRouteCaseController {

         public Case cas  {get;set;}
         public String topic  {get;set;}
         ApexPages.StandardController controller = null;
         public boolean isSucess  {get{
                                        if(isSucess == null){
                                                isSucess = false;
                                        }
                                        return isSucess;
                                        }set;}
                                        
        public Boolean isEditable{get;set;}
        public String accessMessage{get;set;}                               
        
        
                                        
        /*
         Constructor for standard controller
        */                               
        public ECMAutoRouteCaseController(ApexPages.StandardController controller){
                this.controller = controller;
                Id caseId =ApexPages.currentPage().getParameters().get('id');
                if(caseId != null){
                List<Case> cases = ECMCaseRoutingHelper.fetchCase(new List<id>{caseId});
                cas = cases[0];
                    if(cas != null) {
                        topic = cas.Topic__c;
                        isEditable= validateCasePermission();
                    }      
                }
                
        }
        
        /*
          TO BE USED IN FUTURE - Invoke route case using bulk method 
         */
        public PageReference invokeRoute() {
                 PageReference redirectPage = null;
                 String queString= null;
                if(cas != null){
                    list<Case>caseList= new List<Case>();                    
                    Map<id, String> mapOfCaseAndCurrentQueue;
                    Map<Id, User> MapOfCaseIdandOwner;
                    
                    caselist.add(cas);
                    
                    //check if Case is owned by queue or user
                    if(String.ValueOf(cas.OwnerId).startswith('005')){
	                    List<User> owners = [Select Department,UserRole.Name,Profile.Name from User where id = : cas.OwnerId limit 1 ];
	                    if(owners.size()>0){
	                    	MapOfCaseIdandOwner = new Map<Id, User>();
	                    	MapOfCaseIdandOwner.put(cas.Id, owners[0]);
	                    }
                    }
                    else{
                    	 mapOfCaseAndCurrentQueue = new Map<id, String>();
                    	 
                    	 mapOfCaseAndCurrentQueue.put(cas.Id, cas.owner.name);
                    
                    }
                    //Below for loop will process only one case record. Hence SOQL is allowed inside for loop
                    string assignedQueue;
                    for(Case cs : caselist){
                        if(cs.Priority_routing__c != null && cs.Priority_Routing__c == 'Yes' && string.ValueOf(cs.OwnerId).startswith('005')){
                            Map<id, string> caseNQueue = ECMCaseRoutingHelper.getQueueName(caselist,mapOfCaseAndCurrentQueue,MapOfCaseIdandOwner); 
                            system.debug('caseNQueue === '+caseNQueue);
                            if(caseNQueue != null && caseNQueue.get(cs.id)!= null){
                                queString = caseNQueue.get(cs.id);
                            }
                            if(queString != null){
                                assignedQueue = queString; // To Avoid SOQL query in next macthig logic, if queue not found in next iteration
                                system.debug('queString === '+queString);
                                List<Group> groups = [Select Id, Name, DeveloperName, Type from Group where Type = 'Queue' and name  = :queString];
                                if(groups.size() >0) {
                                    cs.ownerId = groups[0].id;
                                }
                                mapOfCaseAndCurrentQueue = new Map<id, String>();
                                mapOfCaseAndCurrentQueue.put(cs.Id, queString);
                            }
                            break;
                        }
                    }
                    
                    //Map<id, string> caseNQueue = CaseRoutingHelper.getQueueName(caselist);
                    Map<id, string> caseNQueue = ECMCaseRoutingHelper.getQueueName(caselist,mapOfCaseAndCurrentQueue,MapOfCaseIdandOwner); 
                        system.debug('caseNQueue === '+caseNQueue);
                        if(caseNQueue != null && caseNQueue.get(cas.id)!= null){
                            queString = caseNQueue.get(cas.id);
                        }
                        
                        if(queString == null) {
                                cas.addError('Based on the criteria, this case cannot be automatically routed. Verify the routing criteria or route manually using the change owner link.');
                        } else {
                               if(assignedQueue == null || (assignedQueue != null && assignedQueue != queString)){
                                   List<Group> groups = [Select Id, Name, DeveloperName, Type from Group where Type = 'Queue' and name  = :queString];
                                   if(groups.size() >0) {
                                       cas.ownerId = groups[0].id;
                                   }                                   
                               }
                        try{
                               upsert cas;
                              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Case routed successfully to  ' +queString + '.');
                              ApexPages.addMessage(myMsg);
                              isSucess = true;
                       
                        }catch( DMLException dmlex) {
                        	 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,dmlex.getdmlMessage(0));
                            ApexPages.addMessage(myMsg);
                     	}
                        catch( Exception ex) {
                             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage());
                            ApexPages.addMessage(myMsg);
                     }
     }
     }
        return redirectPage;
   }

        //method to chec if the logged in user has access to modify the case
        public Boolean validateCasePermission(){
           Boolean result = false;
           List<UserRecordAccess > loggedInUserAccessDetails= [SELECT RecordId,HasEditAccess, HasReadAccess, HasTransferAccess, MaxAccessLevel FROM UserRecordAccess WHERE UserId = : Userinfo.getUserId()
            AND RecordId = :cas.id];
            
            
            if(loggedInUserAccessDetails != Null && !loggedInUserAccessDetails.isEmpty()){
                for(UserRecordAccess  accessDetails :loggedInUserAccessDetails){
                     if(accessDetails.HasEditAccess ){
                        result = True;
                        break;
                     }                     
                }                    
            }
            
            return result ;
        
        }
                
        //get limited type and subtype based on profile and role, so these values will be filtered out on route page    
    	public String getTTSFilterStr(){
    		return ACETCallTopicsPicklistUtility.getTTSFilter(Cas.Topic__c);
    	}          
}