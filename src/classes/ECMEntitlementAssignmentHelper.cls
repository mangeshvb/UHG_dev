public with sharing class ECMEntitlementAssignmentHelper {
    
    public static final String ObjectName = 'EntitlementAssignment__c';

    private static List<String> assignmentFiledList;
    private static List<String> exculdeList = new List<String> {'CaseOrigin__c','IsActive__c','ProfileName__c','EntitlementName__c',
                                                                'RoleName__c','Topic1__c','SortOrder__c'       
                                                                };
    private static String assignmentFiled;
    static {
       //if(assignmentFiled == null){
                assignmentFiledList = new List<String>();
                assignmentFiled = ACETQueryUtil.consructCustomFieldQuery(ObjectName,exculdeList,assignmentFiledList);
            //}
        }

   
   /*
    Assign entitlement  id into case object
   */
    public static void assignEntitlementId(Case cas){
        ID entitlementId = null;
        String topic = '\''+ cas.Topic__c + '\'';

        String query = assignmentFiled + ' where IsActive__c = true and Topic1__c =  '+ topic +'order by SortOrder__c asc' ;
       
    
        
        for(EntitlementAssignment__c entitlement:Database.query(query)){
            
           if(isBasicCriteriaMatch(cas,entitlement) && isStandrdCaseFieldMatch(cas,entitlement)){
                 List<String> valueCheckList = getNotNulValuesForEntitlement(entitlement);
                 Integer index = 0;
                 for(String consField:valueCheckList) {
                  
                        if(IsFieldAvliable(cas,consField) && entitlement.get(consField) == cas.get(consField)){
                            index++;
                        }else{
                            break;
                        }
                    }

                    if(valueCheckList.size() == index) {
                        cas.EntitlementId  = entitlement.EntitlementName__c;
                        return;
                    }
            }
            
        }
        
    }

  /*
   
    To Match the case owner basic information
  */
  public static boolean isBasicCriteriaMatch(Case cas,EntitlementAssignment__c entitlement) {
     List<User> owners = [Select UserRole.Name,Profile.Name from User where id = : cas.OwnerId ];
     boolean isMatched = false;
     if(owners.size() > 0) {
        User owner = owners[0];
        if ((entitlement.ProfileName__c == null  ||  entitlement.ProfileName__c == owner.Profile.Name) && 
             (entitlement.RoleName__c == null  ||  entitlement.RoleName__c == owner.UserRole.Name)){
                isMatched = true;
        }else if(entitlement.ProfileName__c == null && entitlement.RoleName__c == null  ){
            isMatched = true;
        }
     }
      return isMatched;
  }
 
 /*
  To Match the standard case field match
 */
  public static boolean isStandrdCaseFieldMatch(Case cas,EntitlementAssignment__c entitlement) {
     boolean isMatched = false;
        if ((entitlement.CaseOrigin__c == null || entitlement.CaseOrigin__c == cas.Origin)){
             isMatched = true;
     }
      return isMatched;
  }
 
 
 /*
  Find the list of field need to check in EntitlementAssignment__c
  */ 
  private static List<String> getNotNulValuesForEntitlement(EntitlementAssignment__c entitlement) {
    List<String> valueCheckList = new List<String>();
    for(String consField:assignmentFiledList) {

            if(entitlement.get(consField) != null){
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

    
}