public with sharing class ACETCallTopicsPicklistUtility {	
	
	public static String getTTSFilter(String callTopic){
		return JSON.serialize(getTTSFilterMap(callTopic)).replace('\'', '&#x27;');		
	}
	
	//get the limited type and subtype list based on profile and role
	public static Map<String, String> getTTSFilterMap(String callTopic){
		Map<String, string> accMap = new Map<String, String>();
		
		String userRoleName = ACETUtility.GetUserRoleName();
		String userProfileName = ACETUtility.GetUserProfileName();
						
		List<TTS_Access__c> acceses = (List<TTS_Access__c>)ACETQueryUtil.query(null,'TTS_Access__c', 'Topic__c = \'' + callTopic + '\'', null);
		for(TTS_Access__c acc : acceses){
			Boolean hasAccess = false;
			//do not have role filter for now
			//if(String.isEmpty(acc.Limit_To_Roles__c) || (userRoleName != null && acc.Limit_To_Roles__c.contains(userRoleName))){
				//hasAccess = true;	
			//}
			
			//if(String.isEmpty(acc.Except_To_Roles__c) || (userRoleName == null || acc.Except_To_Roles__c.contains(userRoleName))){
				//hasAccess = true;	
			//}
									
			if(acc.Limit_To_Profiles__c != null && acc.Limit_To_Profiles__c.contains(userProfileName)){
				hasAccess = true;	
			}
			
			//if(!String.isEmpty(acc.Except_To_Profiles__c) && (acc.Except_To_Profiles__c.contains(userProfileName))){
				//hasAccess = false;	
			//}
			
			if(!String.isEmpty(acc.Type__c) && hasAccess){			
				if(accMap.get(acc.Type__c) == null){
					accMap.put(acc.Type__c, (acc.Subtype__c == null? '*' : acc.Subtype__c));
				}else{
					//if 2 configuration with sampe type are found, one with sub type empty and one with sub type populated
					//the first configuration overwrites the second one as first one means type level access is sepcified					
					if(accMap.get(acc.Type__c) == '*' || String.isEmpty(acc.Subtype__c)){
						//access control on type level
						accMap.put(acc.Type__c, '*');	
					}else{
						//access control on sub type level
						accMap.put(acc.Type__c, accMap.get(acc.Type__c) + ';' + acc.Subtype__c);		
					}										
				}	
			}			
		}
						
		return accMap;
	}
	
	
	public static List<String> getCallTopics(String detailPageName, String originatorType){
		List<Call_Topic_Access__c> accesses = (List<Call_Topic_Access__c>)ACETQueryUtil.query(null,'Call_Topic_Access__c', 'Detail_Page__c INCLUDES(' + '\'' + detailPageName + '\')', null);
		
		String userRoleName = ACETUtility.GetUserRoleName();
		
		List<String> result = new List<String>();
		for(Call_Topic_Access__c acc : accesses){
			if(!String.isEmpty(acc.Limit_To_Roles__c) && (userRoleName == null || !acc.Limit_To_Roles__c.contains(userRoleName))){
				continue;	
			}
			
			if(!String.isEmpty(acc.Except_To_Roles__c) && (userRoleName != null && acc.Except_To_Roles__c.contains(userRoleName))){
				continue;	
			}
			
			if(!String.isEmpty(acc.Originator_Type__c) && (originatorType == null || !acc.Originator_Type__c.contains(originatorType))){
				continue;	
			}
														
			result.add(acc.Call_Topic__c);			
		}
		
		return result;	
	}
	
	public static List<SelectOption> getCallTopicOptions(String detailPageName, String originatorType){
		List<String> callTopics = getCallTopics(detailPageName, originatorType);
		
		callTopics.sort();
		List<SelectOption> options = new List<SelectOption>();
		for(String callTopic : callTopics){
			options.add(new SelectOption(callTopic, callTopic));
		}
		return options;	
	}
	
	public static List<String> getCallTopics(String detailPageName){
		List<Call_Topic_Access__c> accesses = (List<Call_Topic_Access__c>)ACETQueryUtil.query(null,'Call_Topic_Access__c', 'Detail_Page__c INCLUDES(' + '\'' + detailPageName + '\')', null);
		
		List<String> result = new List<String>();
		for(Call_Topic_Access__c acc : accesses){
			result.add(acc.Call_Topic__c);
		}
		
		return result;	
	}
	
	public static List<SelectOption> getCallTopicOptions(String detailPageName){
		List<String> callTopics = getCallTopics(detailPageName);
		
		callTopics.sort();
		List<SelectOption> options = new List<SelectOption>();
		for(String callTopic : callTopics){
			options.add(new SelectOption(callTopic, callTopic));
		}
		return options;	
	}		   
      
}