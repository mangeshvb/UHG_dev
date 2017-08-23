trigger ECMAgentWorkTrigger on AgentWork (after insert, after update) {
    if(trigger.isAfter){
        if(trigger.isUpdate){
           ECMAgentWorkTriggerHandler.handleAfterUpdate(trigger.new, trigger.oldMap); 
        }
    }      
}