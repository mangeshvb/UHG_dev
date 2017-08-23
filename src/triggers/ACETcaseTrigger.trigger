trigger ACETcaseTrigger on Case (before update,before insert, after update, after insert) {
 if(trigger.isBefore){                
        
        if(trigger.isInsert){           
           ECMCaseTriggerHandler.handleBeforeInsert(trigger.new);
        }        
                
        if(trigger.isUpdate ){                      
            //calculating initial target date 
            ECMCaseTriggerHandler.calcInitialTargetDate(trigger.new, trigger.oldMap);              
            if(RecursiveTriggerHandler.isFirstTime || test.isRunningTest()){ 
                
                //  method to call route on update- priority routing
                ECMCaseTriggerHandler.pushCasetoUrgentQ(trigger.new, trigger.oldMap);  
                ECMCaseTriggerHandler.recordMilestonePerformance(trigger.new, trigger.oldMap);
            }                  
        }             
    }
   
    if(trigger.isAfter){
        if(trigger.isUpdate){    
            if(RecursiveTriggerHandler.isFirstTime || test.isRunningTest()){ 
                  RecursiveTriggerHandler.isFirstTime= false;    
                  //Added to autoclose case Milestones if case is closed.  
                  ECMCaseTriggerHandler.autocloseMilestones(trigger.new,  trigger.oldMap);
                  // Create milestone performance creation on Change of owner
                  ECMCaseTriggerHandler.handleOWnerShipChangesForMp(trigger.new,  trigger.oldMap);
                  
                  //Whenver case is inserted populating Case's type and subtype on case Item 
                  //Whenver case is updated and type and subtype values are changed, updating values on Unresolved case items
                  ECMCaseTriggerHelper.updateTypeAndSubTypeOnCaseItem(trigger.new, trigger.oldMap);
                  //Change owner of Open Activities
                  ECMCaseTriggerHelper.prepareOwnerChangedCaseIds(trigger.newMap, trigger.oldMap);
            }         
        }        
    }    
}