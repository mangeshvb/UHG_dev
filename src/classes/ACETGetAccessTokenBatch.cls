public class ACETGetAccessTokenBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {

	public List<ISL_Webservice_Config__c> start(Database.BatchableContext BC) {
		List<ISL_Webservice_Config__c> lstWSConfig = new List<ISL_Webservice_Config__c>([SELECT Id, Name, Value__c 
								FROM ISL_Webservice_Config__c WHERE Name = 'ISLConAccessToken']);
		system.debug(LoggingLevel.INFO, 'lstWSConfig.size: ' + lstWSConfig.size());
		
		if (lstWSConfig.size() == 0) {
			lstWSConfig = new List<ISL_Webservice_Config__c>();
			lstWSConfig.add(new ISL_Webservice_Config__c(Name='ISLConAccessToken'));
		}	
		system.debug(LoggingLevel.INFO, 'lstWSConfig.size: ' + lstWSConfig.size());
		
		return lstWSConfig;					
	}
	
	public void execute(Database.BatchableContext BC, List<ISL_Webservice_Config__c> scope) {
		system.debug(LoggingLevel.INFO, 'ACETGetAccessTokenBatch Scope: ' + scope);
		
		ISL_Webservice_Config__c AccessTokenConfig = scope.get(0);
		ACETOAuthWebservice OAuthWS = new ACETOAuthWebservice();
        AccessTokenConfig.Value__c = OAuthWS.GetAccessToken();
        Database.UpsertResult AccessTokenUR = Database.upsert(AccessTokenConfig);
        if (!AccessTokenUR.isSuccess()) {
        	for(Database.Error DbError :AccessTokenUR.getErrors()) {
        		system.debug(LoggingLevel.INFO, 'Save Access Token Error. StatusCode: ' + DbError.getStatusCode() + ', Message: ' + DbError.getMessage());
        	}
        }
        else {
        	system.debug(LoggingLevel.INFO, 'Access token saved successfully in custom setting');
        }
	}
	
	public void finish(Database.BatchableContext BC) {
		//Do nothing
	}
}