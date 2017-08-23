public with sharing class ECMCaseTriggerHandler {
    
    //method to assign enetilement to case using Entitlement Assignment rules
    public static void handleBeforeInsert(List<Case> caseList){
        for(Case cas:caseList ) {
            if(cas.Status != 'Canceled' && cas.Status != 'Cancelled'){
                ECMEntitlementAssignmentHelper.assignEntitlementId(cas);                
            }
        }        
    }
    
   //Initial Target Date from available milestones
   public static void calcInitialTargetDate(List<Case> caseList, Map<Id, Case> oldCaseMap){
        list<case> listofCasesForInitialTargetDate = new List<Case>();
        if(caseList != null && !caseList.isEmpty() && oldCaseMap != null && !oldCaseMap.isEmpty()){ 
            for(case cas :caseList){
                //validating change of Trigger_Initial_MP_Record__c
                if( oldCaseMap.get(cas.Id) != null){
                    if(cas.Trigger_Initial_MP_Record__c != oldCaseMap.get(cas.id).Trigger_Initial_MP_Record__c){
                        listofCasesForInitialTargetDate.add(cas);                        
                    }
                }
            }               
            if(listofCasesForInitialTargetDate!= null && !listofCasesForInitialTargetDate.isEmpty()){
                ECMMilestonePerformance.calcInitialTargetDate(listofCasesForInitialTargetDate);
           }            
        }   
   }
   
    //method to createMilestone performance based on action 1) change of case owner 2) Close of Milestone
    public static void recordMilestonePerformance(List<Case> caseList, Map<Id, Case> oldCaseMap){
        
        list<case> listofCases = new List<Case>();        
        Map<id, String> mapofIdandevent = new Map<id,String>();
        set<string> oldCaseStatus = new set<string>();
        
            
                    if(caseList != null && !caseList.isEmpty() && oldCaseMap != null && !oldCaseMap.isEmpty()){                     
                        //system.debug('%%%%2 size of oldCaseMap' + oldCaseMap);
                        for(case cas :caseList){
                            //validating change of owner
                            if( oldCaseMap.get(cas.Id) != null){
                               // system.debug('%%%%3 size of oldCaseMap.get(cas.Id)' + OldCaseMap.get(cas.Id)); 
                                
                                
                                if(cas.OwnerId != oldCaseMap.get(cas.Id).OwnerId){                              
                                  //  listofCases.add(cas);
                                    
                                    oldCaseStatus.add(cas.id+'~'+oldcaseMap.get(cas.id).status);
                                    if(!mapofIdandevent.containsKey(cas.id)){
                                        system.debug('%%%%4 in change owner event');
                                        //mapofIdandevent.put(cas.id, 'Changed Owner');
                                    }
                                }
                                if(cas.Milestone_Updated__c != oldCaseMap.get(cas.id).Milestone_Updated__c){
                                    listofCases.add(cas);
                                    if(!mapofIdandevent.containsKey(cas.id)){                                       
                                        mapofIdandevent.put(cas.id, 'Completed Milestone');
                                    }
                                }
 
                            }
                        }
                        system.debug('mapofIdandevent  '+mapofIdandevent);

                        if(!mapofIdandevent.isEmpty()){
                            ECMMilestonePerformance.recordMilestoneClose( listofCases,  oldCaseMap,  mapofIdandevent, null,null);     
                        }
                        
                    } 

        
    }

     
    //method to evaluate the criteria for closing case and auto closing milestones
    //public static void autocloseMilestones(List<Case> caseList){}
    public static void autocloseMilestones(List<Case> caseList,  Map<Id, Case> oldCaseMap){
         Map<id, String> mapofIdandevent = new Map<id,String>();
         list<case> listofClosedCases = new List<Case>();
        
        if(caseList != Null && caseList.isEmpty() == False){
            DateTime completionDate = System.now();
            List<Id> updateCases = new List<Id>();
            for (Case c : caseList ){
                if (((c.isClosed == true)||(c.Status == 'Closed'))&&((c.SlaStartDate<= completionDate)&&(c.SlaExitDate == null))){
                    updateCases.add(c.Id);
                    //for Milestone Performance 
                    mapofIdandevent.put(c.Id, 'Closed Case');
                    listofClosedCases.add(c) ;
                }
            }
            /*  calling Method to insert Milestone performance records for open milestons before closing them . 
                Creating MP records before closing the miletone will help in easier distinction of milestones that were already closed 
            */
            if(listofClosedCases.isEmpty() == False){               
                ECMMilestonePerformance.recordMilestoneClose( listofClosedCases,  oldCaseMap,  mapofIdandevent, completionDate,null);     
            }  
            /* 
                calling method to closed all open milestones
            */
            if(updateCases.isEmpty() == False){                              
                ECMMilestoneutils.completeMilestone(updateCases, completionDate);
            }            
                  
        }
    
    }
  
   
    //method to call route on update- priority routing only if the current owner of the case is a Queue
  public static void pushCasetoUrgentQ(List<Case> caseList, Map<Id, Case> oldCaseMap){  
        if(caseList!= Null && !caseList.isEmpty() && oldCaseMap != null && !oldCaseMap.isEmpty()){
            

                //getting owner types for each case 
                Map<Id,String>  mapOfCaseIDAndOwnerType = new Map<Id, String>();
                Map<Id, String> mapOfQueueIdandName = new Map<Id, String>();
                Map<id, String> mapOfCaseAndCurrentQueue = new  Map<id, String> ();
                Set<id> setofQueueIds= new Set<Id>();
                for (Case cas :caseList){                  
                     if(!mapOfCaseIDAndOwnerType.containsKey(cas.ID) &&  oldCaseMap.get(cas.ID) != null && oldCaseMap.get(cas.ID).OwnerId != null){       
                            if(String.ValueOf(oldCaseMap.get(cas.ID).OwnerId).startswith('005')){                       
                                mapOfCaseIDAndOwnerType.put(cas.ID, 'User');
                            }
                            else{
                                mapOfCaseIDAndOwnerType.put(cas.ID, 'Queue');
                                setofQueueIds.add(oldCaseMap.get(cas.ID).OwnerId);
                            }
                     }
                     
                }                                  
             
                if(setofQueueIds != Null && !setofQueueIds.isEmpty()){
                    for(Group queue :[Select Id, Name, type from Group where Type = 'Queue' and Id In   :setofQueueIds]){
                        
                        mapOfQueueIdandName.put(queue.Id, queue.Name);
                    }
                
                }
            
            //Forming a list of cases that match criteria for priority routing
            List<case> priorityCases = new List<case>(); 
          
          
          //need to add the whole block back                       
            for(Case cas : caseList){   
                                  
                if(cas.Priority_Routing__c == 'Yes'  && mapOfCaseIDAndOwnerType.get(cas.id) != 'User' &&
                   oldCaseMap.get(cas.Id) != null && oldCaseMap.get(cas.Id).Priority_Routing__c == 'No') {                     
                        
                        priorityCases.add(cas);                          
                        mapOfCaseAndCurrentQueue.put(cas.id, mapOfQueueIdandName.get(oldCaseMap.get(cas.ID).OwnerId));                              
                }
            }
                       
                        
            // Calling CAse routing class to route the priority cases
            if(priorityCases!= Null && priorityCases.isEmpty() ==false && mapOfCaseAndCurrentQueue != null){                
                
                //Map<id, string> caseIDNQueue = CaseRoutingHelper.getQueueName(priorityCases); 
                Map<id, string> caseIDNQueue = ECMCaseRoutingHelper.getQueueName(priorityCases, mapOfCaseAndCurrentQueue , Null);              
             
             
                Set<String> uniqueQueueNames = new Set<String>();        
                if(caseIDNQueue!= null ){
                    for(Id caseId : caseIDNQueue.KeySet()){
                        if(!uniqueQueueNames.contains(caseIDNQueue.get(caseId))){
                            uniqueQueueNames.add(caseIDNQueue.get(caseId));
                        }
                    }
                                        
                    //forming map of queue name and queue id
                    Map<String, Id> mapOfQNameAndQId = new Map<String, Id>();
                    List<Group> groups = [Select Id, Name, DeveloperName, Type from Group where Type = 'Queue' And Name in :uniqueQueueNames];
                    if(groups.size() >0) {
                        for(Group que :groups){
                            if(!mapOfQNameAndQId.containsKey(que.Name)){                        
                                mapOfQNameAndQId.put(que.Name, que.Id);
                            }
                        }
                       
                    }
    
                    //ITERATING THRU CASELIST to assign it with case owner
                    for(Case cas :priorityCases){
                        String  queString= null;
                        if(caseIDNQueue.get(cas.id)!= null){
                            queString = caseIDNQueue.get(cas.id);
                        }               
    
                         if(queString != null && mapOfQNameAndQId.get(queString) != null) {                         
                               cas.ownerId = mapOfQNameAndQId.get(queString);                      
                         }       
                               
                    }
                     
                 }               
            }         
   
        }
    }  
    
    
    
    public static void handleOWnerShipChangesForMp(list<Case> triggerNew, map<id, Case> triggerOldMap){
        set<id> ownerIDChangedCaseIds = new set<id>();
        
        for(Case newCase : triggerNew){
            Case oldCase = triggerOldMap.get(newCase.id);
            
            if(newCase.ownerId != oldCase.OwnerId){
                ownerIDChangedCaseIds.add(newCase.id);
            }
        }
        if(!ownerIDChangedCaseIds.isEmpty()){
            ECMMilestonePerformance.createOwnerShipChanges( ownerIDChangedCaseIds);     
        }
    }
   
    
}