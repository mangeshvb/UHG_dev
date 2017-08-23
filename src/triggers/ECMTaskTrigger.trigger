trigger ECMTaskTrigger on Task (before insert, before update) {

    if(trigger.isBefore){
        for(task tsk :trigger.new){
            if(trigger.isInsert ||( tsk.OwnerId != Null && trigger.oldMap != null && tsk.OwnerId != trigger.oldMap.get(tsk.id).OwnerId)  ){
                
                tsk.HiddenOwnerID__c= tsk.OwnerId;
            
            }
            
        }
    
    }

}