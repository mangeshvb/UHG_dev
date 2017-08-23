public  with sharing  class ECMCaseRoutingHelper {


    public static final String ObjectName = 'Routing_Configuration__c'; 
    private static List<String> assignmentFiledList;
    /*
     Add execulded field in Routing configuration
    */
    private static List<String> exculdeList = new List<String> {'IsActive__c','ProfileName__c','Queue_Name__c',
                                                                'RoleName__c','Topic1__c','Priority__c', 'Status__c' , 'SortOrder__c' , 'CurrentQueue__c'
                                                                }; 
    /*
     Load all the coloumn required for to match from cases and user information
    */
    private static String assignmentFiled;
    static {
            if(assignmentFiled == null){
                assignmentFiledList = new List<String>();
                assignmentFiled = ACETQueryUtil.consructCustomFieldQuery(ObjectName,exculdeList,assignmentFiledList);
            }
        }

    
 /*
  To check any standard case field values are match routing configuration valeus
 */
 public static boolean isStandrdCaseFieldMatch(Case cas,Routing_Configuration__c routingConfig , String currenQueueName) {
       boolean isMatched = false;
       
       if((routingConfig.Priority__c == null || routingConfig.Priority__c == cas.Priority) && 
          (routingConfig.Status__c == null || routingConfig.Status__c == cas.status) &&
          (routingConfig.CurrentQueue__c == null || routingConfig.CurrentQueue__c == currenQueueName)
          ) {
             isMatched = true;
        } 
    return isMatched;
  }
  
  /*
  To check case owner information match routing configuration  if case owner is other than queue then we can consider is matched 
 */
  public static boolean isBasicCriteriaMatch(Case cas,Routing_Configuration__c routingConfig , user caseOwner) {
     boolean isMatched = false;
     if(caseOwner != null) {

        
        if   ((routingConfig.ProfileName__c == null  ||  routingConfig.ProfileName__c == caseOwner.Profile.Name) && 
             (routingConfig.RoleName__c == null  ||  routingConfig.RoleName__c == caseOwner.UserRole.Name)){
                isMatched = true;
        }
     }else if(routingConfig.ProfileName__c == null && routingConfig.RoleName__c == null ){
            isMatched = true;
        }
     return isMatched;
  }
 

 
 // Method to get Queue names for list of cases from routing configuration object
  public static map<id,String> getQueueName(List<Case> cases , Map<id, String> mapOfCaseAndCurrentQueue , Map<Id, User>MapOfCaseIdandOwner){

    //rc data  variables
    Set<String> setOfCallTopics = new Set<String>();
    Map<String, List<Routing_Configuration__c>> mapOfTopicNRoutingConfigList = new Map<String, List<Routing_Configuration__c>>();
    List<Routing_Configuration__c> rcListForMap ;
    List<Routing_Configuration__c> routingConfigsWithoutTopic = new List<Routing_Configuration__c>();    
    
    //results variable
    String queueName = null;
    Map<id,String> caseandQueueResultMap = new Map<id,String>();
    Map<id,Routing_Configuration__c> routeLogMapforSuccess = new Map<id,Routing_Configuration__c>();
    List<case> routeLogcaseListforFailue = new List<case>();
    Routing_Configuration__c matchedRouteConfig;
    boolean excludePriorityRoutingField = false;// If case owner is user and Priority_Routing__c = Yes, then not considering Priority_Routing__c for in mapping, also skips Routing log creation
    
    
    if(cases != null && cases.isempty() == False){
    
        //getting a set of all topics and owner Ids
        for (Case caseR :cases){
            if(!setOfCallTopics.contains(caseR.Topic__c)){         
                setOfCallTopics.add(caseR.Topic__c);
            } 
        }
        
        
        //query all the routing config records that will be required to route the cases,  and form a map
        String query = assignmentFiled +  ' where IsActive__c = true and (Topic1__c IN  :setOfCallTopics OR  Topic1__c = null )order by SortOrder__c asc' ;
        
        
        for(Routing_Configuration__c routingConfig: database.query(query)){ 
            if(routingConfig.Topic1__c == null){
                routingConfigsWithoutTopic.add(routingConfig);    
            }else{
                if(!mapOfTopicNRoutingConfigList.containsKey(routingConfig.Topic1__c)){
                
                    rcListForMap = new List<Routing_Configuration__c>();
                }
                else{
                    rcListForMap = mapOfTopicNRoutingConfigList.get(routingConfig.Topic1__c);
                }
                rcListForMap.add(routingConfig);  
                mapOfTopicNRoutingConfigList.put(routingConfig.Topic1__c, rcListForMap) ;                
            }
        }
        
      
        //iterate over cases
        for(Case cas :cases){
           
            String currentQueue = null;
            User currentOwner ;
            
            if(MapOfCaseIdandOwner!= Null && MapOfCaseIdandOwner.get(cas.Id)!= null){
            
                currentOwner = MapOfCaseIdandOwner.get(cas.Id);
            }
            
            if((mapOfCaseAndCurrentQueue!= Null && mapOfCaseAndCurrentQueue.get(cas.Id)!= null)){
                currentQueue = mapOfCaseAndCurrentQueue.get(cas.Id);
            }
            //get the RC list from Map
            List<Routing_Configuration__c> rcListForCase = new List<Routing_Configuration__c>();
            
            if(cas.Priority_Routing__c == 'Yes' && currentQueue == null){
                excludePriorityRoutingField = true;
            }
            
            
			//adding Rc records only if its a priority routing  owned by a queue
            if(cas.Priority_Routing__c == 'Yes' && currentQueue != null &&
            	routingConfigsWithoutTopic != null && !routingConfigsWithoutTopic.isEmpty()){
                rcListForCase.addAll(routingConfigsWithoutTopic);
            }
            if(mapOfTopicNRoutingConfigList.get(cas.Topic__c) != null){
                rcListForCase.addAll(mapOfTopicNRoutingConfigList.get(cas.Topic__c));
            }             
            
            if(rcListForCase!= Null && rcListForCase.isEmpty() == False){
                for(Routing_Configuration__c routingConfig: rcListForCase){
               
                    if(isBasicCriteriaMatch(cas,routingConfig, currentOwner) && isStandrdCaseFieldMatch(cas,routingConfig, currentQueue )){
                            
                        List<String> valueCheckList = getNotNulValuesForQueueName(routingConfig);
                        if(excludePriorityRoutingField && valueCheckList != null && !valueCheckList.isEmpty()){
                            for(integer i=0;i<valueCheckList.size() ; i++){
                                if(valueCheckList[i].equalsIgnorecase('priority_routing__c')){
                                    valueCheckList.remove(i);
                                }
                            }
                        }
                         Integer index = 0;
        
                            for(String consField:valueCheckList) {
                              /*  if(consField.equalsIgnorecase('Priority_Routing__c')){
                                    if( (routingConfig.Priority_Routing__c == 'Yes' && cas.Priority_Routing__c )|| (routingConfig.Priority_Routing__c == 'No' && !cas.Priority_Routing__c) ){
                                        index++;
                                    }else{
                                        break;
                                    }
                                }else 
                                { */
                                    if(IsFieldAvliable(cas,consField) && routingConfig.get(consField) == cas.get(consField)){
                                        index++;
                                    }
                                    else{
                                        break;
                                    }   
                               // }                                       
                               
                            }
                            if(valueCheckList.size() == index) {
                                queueName = routingConfig.Queue_Name__c;                            
                                matchedRouteConfig = routingConfig;
                               
                                break;                           
                            }   
                    }
                }
                
            }
            
             //Adding case to result
             caseandQueueResultMap.put(cas.id,queueName);
             if(excludePriorityRoutingField == false){
                 //Logging route
                if(queueName != null){
                  //logmap for success
                  routeLogMapforSuccess.put(cas.id,matchedRouteConfig);
                }
                else{
                  //list of cases that failed to route
                  routeLogcaseListforFailue.add(cas);                       
                }
             }
            
            
        
        }
    }
    //Creates Success and Failure Route_Log__c log records
    if(!routeLogMapforSuccess.isEmpty() || !routeLogcaseListforFailue.isEmpty()){
        System.enqueueJob(new ECMRouteLogJob(routeLogMapforSuccess,routeLogcaseListforFailue));
    }
    
    return caseandQueueResultMap;
  }
 
/*
  Find the list of field need to check in Routing_Configuration__c
  */ 
  private static List<String> getNotNulValuesForQueueName(Routing_Configuration__c routingConfig) {
    List<String> valueCheckList = new List<String>();
    for(String consField:assignmentFiledList) {

            if(routingConfig.get(consField) != null){
                valueCheckList.add(consField);
            }
        }
        return valueCheckList;
  }

 /*
  Make sure Case object have field is avliable
 */
 public static boolean IsFieldAvliable(SObject sobj,String consColoumn) {
    String objName = String.valueOf(sobj.getsObjectType());
    return Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(consColoumn)!=null;
 }

 
     /*
      Fetch case object info
      */
    public static List<Case> fetchCase(List<ID> casIds){
      String queryString = ACETQueryUtil.getCustomFieldQuery('Case') ;
              queryString +=' where id in ('+ ACETQueryUtil.getQueryValue(casIds) + ' )';
       //List<Case> cases = 
        return  Database.query(queryString);

    }

}