trigger ECMCaseITemTrigger on Case_Item__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    if(trigger.isBefore){
    	if(trigger.isInsert){
    		ECMCaseITemTriggerHelper.handleBeforeInsert(trigger.new);
    	}
    }
}