global class ACETDeleteResearchInteractionBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('Select Id From Interaction__c WHERE Interaction_Type__c = \'Research Only\'');    
    }
   
    global void execute(Database.BatchableContext BC, List<Interaction__c> scope) {
       Database.Delete(scope,false);
    }   
    
    global void finish(Database.BatchableContext BC) {
    }



}