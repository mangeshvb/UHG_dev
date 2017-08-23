public with sharing class ECMEntitlementAssignmentUtility{

    //Method to Validate  if Queue Name in the Routing Configuration Table matches with the existing Case QUeues
    public static void validateData(List<EntitlementAssignment__c> entitlementAssignmentRecords){
           
        Set<String> setOfTriggerProfiles = new Set<String>();
        Set<String> setOfTriggerRoles = new Set<String>(); 
        Set<String> setOfExistingProfiles= new Set<String>();
        Set<String> setOfExistingDepartments= new Set<String>();
        Set<String> setOfExistingRoles= new Set<String>();
               
        // populate the sets with values from incoming trigger
        if(entitlementAssignmentRecords!= null && !entitlementAssignmentRecords.isEmpty()){
            for(EntitlementAssignment__c entAssign : entitlementAssignmentRecords){        
           
               if(entAssign.ProfileName__c != Null && !setOfTriggerProfiles.contains(entAssign.ProfileName__c )){
                   setOfTriggerProfiles.add(entAssign.ProfileName__c);
               }  
               if(entAssign.RoleName__c != Null && !setOfTriggerRoles.contains(entAssign.RoleName__c)){
                   setOfTriggerRoles.add(entAssign.RoleName__c);
               }                            
            }       
        }         
       

        //get list of all the Profile and Roles from org and form a unique value set   
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
       
       // Compare values in Entitlement Assignment Record with values in the set and display error if match is not found                         
      if(entitlementAssignmentRecords!= null && !entitlementAssignmentRecords.isEmpty()){
            for(EntitlementAssignment__c entAssign : entitlementAssignmentRecords){            
                String errorMsg ='Enter a valid value.';
                if(entAssign.ProfileName__c != Null && !setOfExistingProfiles.contains(entAssign.ProfileName__c) ){
                    entAssign.ProfileName__c.addError(errorMsg ); 
                }    
                 
                if(entAssign.RoleName__c != Null && !setOfExistingRoles.contains(entAssign.RoleName__c ) ){
                   entAssign.RoleName__c.addError(errorMsg ); 
                }                                          
            }       
        }
        
        
    }
}