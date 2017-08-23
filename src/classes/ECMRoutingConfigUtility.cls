public with sharing class ECMRoutingConfigUtility{

    /* Method to Validate  if data in Routing Configuration Table matches with the 
    existing profile names, user deptatment, role name and  Case Queues   */ 
    public static void validateData(List<Routing_Configuration__c> routinConfigRecords){
           
        Set<String> setOfTriggerProfiles = new Set<String>();
        Set<String> setOfTriggerRoles = new Set<String>(); 
        Set<String> setOfTriggerQueues = new Set<String>();
        Set<String> setOfExistingProfiles = new Set<String>();
        Set<String> setOfExistingRoles = new Set<String>();
        Set<String> setOfExistingQueues = new Set<String>();
               
        // populate the sets with values from incoming trigger
        if(routinConfigRecords!= null && !routinConfigRecords.isEmpty()){
            for(Routing_Configuration__c rConfig : routinConfigRecords){               
               if(rConfig.ProfileName__c != Null && !setOfTriggerProfiles.contains(rConfig.ProfileName__c )){
                   setOfTriggerProfiles.add(rConfig.ProfileName__c);
               }                
               if(rConfig.RoleName__c != Null && !setOfTriggerRoles.contains(rConfig.RoleName__c)){
                   setOfTriggerRoles.add(rConfig.RoleName__c);
               }
               if(rConfig.Queue_Name__c!= Null &&  !setOfTriggerQueues.contains(rConfig.Queue_Name__c)){
                   setOfTriggerQueues.add(rConfig.Queue_Name__c);
               }        
               if(rConfig.CurrentQueue__c!= Null &&  !setOfTriggerQueues.contains(rConfig.CurrentQueue__c)){
                   setOfTriggerQueues.add(rConfig.CurrentQueue__c);
               }                               
            }       
        }         
       

        //get list of all the Profile, ROles from org and form a unique value set    
        if(setOfTriggerProfiles != null && setOfTriggerProfiles.size() > 0){
            for(Profile prof : [Select Name From Profile Where Name In :(setOfTriggerProfiles)]){           
                if(!setOfExistingProfiles.contains(prof.Name)){
                       setOfExistingProfiles.add(prof.Name);
                   }
            }
        }      
                
                    
                
        if(setOfTriggerRoles != null && setOfTriggerRoles.size() > 0){
            for(UserRole role : [Select Name From UserRole Where Name In :(setOfTriggerRoles)]){           
               if(!setOfExistingRoles.contains(role.Name)){
                   setOfExistingRoles.add(role.Name);
               } 
           }  
        } 
             
       
       if(setOfTriggerQueues != null && setOfTriggerQueues.size() > 0){
            for(QueueSobject caseQ: [Select Id, SobjectType, Queue.Name from QueueSobject where SobjectType = 'Case' AND Queue.Name In :(setOfTriggerQueues)]){           
               if(!setOfExistingQueues.contains(caseQ.Queue.Name)){
                   setOfExistingQueues.add(caseQ.Queue.Name);
               } 
           }    
        } 
             
       
       
       // Compare values in Entitlement Assignment Record with values in the set and display error if match is not found                         
      if(routinConfigRecords!= null && !routinConfigRecords.isEmpty()){
            for(Routing_Configuration__c rConfig: routinConfigRecords){            
                String errorMsg ='Enter a valid value';
                if(rConfig.ProfileName__c != Null && !setOfExistingProfiles.contains(rConfig.ProfileName__c) ){
                    rConfig.ProfileName__c.addError(errorMsg ); 
                }    
                
                if(rConfig.RoleName__c != Null && !setOfExistingRoles.contains(rConfig.RoleName__c ) ){
                   rConfig.RoleName__c.addError(errorMsg ); 
                }
                if(rConfig.Queue_Name__c!= Null && !setOfExistingQueues.contains(rConfig.Queue_Name__c) ){
                   rConfig.Queue_Name__c.addError(errorMsg ); 
                }  
                if(rConfig.CurrentQueue__c!= Null && !setOfExistingQueues.contains(rConfig.CurrentQueue__c) ){
                   rConfig.CurrentQueue__c.addError(errorMsg ); 
                }                                                                          
            }       
        }
        
        
    }
    
}