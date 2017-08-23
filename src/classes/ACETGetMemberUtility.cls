public class ACETGetMemberUtility{
    
    //fields from OIL services
    public static ACETMemberDetail MemberDetail {get;set;}
    public static String MemberDetailResultJson{get;set;}
    
    public static ACETMemberDetail queryMemberDetail(String memberId){
        MemberDetail = new ACETMemberDetail();
        queryIndividual(memberId);         
        queryMemberships(memberId);
        queryFamilyMembers(memberId);
        system.debug('Id print>>>>>>>> '+ ApexPages.currentPage().getParameters().get('Id'));
        //added by Khoushik on 09/28/2016 for User Story - US378010                   
        if(MemberDetail != null){       
            MemberDetailResultJson =   json.serialize(MemberDetail); 
        }
        return MemberDetail;
    }
    
    public static void queryFamilyMembers(String memberId){
       // MemberDetail = new ACETMemberDetail();
        if(!String.isEmpty(memberId)){
            ACETGetFamilyMemberWebService stub = new ACETGetFamilyMemberWebService();
            ACETWSCalloutResult calloutResult = stub.getFamilyMembers(memberId, MemberDetail);
        }
       // return MemberDetail;
    }   
    
    public static void queryMemberships(String memberId){
       // MemberDetail = new ACETMemberDetail();
        if(!String.isEmpty(memberId)){ 
            //call findMembership service first                
            ACETfindMembershipWebService stub = new ACETfindMembershipWebService();
            ACETWSCalloutResult calloutResult = stub.findMembership(memberId, MemberDetail); 
                      
            //some fields for coverage lines depends on getMembership service         
            ACETGetMembershipWebService stub2 = new ACETGetMembershipWebService();
            ACETWSCalloutResult calloutResult2 = stub2.getMembership(memberId,'',MemberDetail);                                                         
        } 
      //  return MemberDetail;  
    }
    
    public static void queryIndividual(String memberId){                        
        if(!String.isEmpty(memberId)){
            ACETGetIndividualWebService stub = new ACETGetIndividualWebService();
            ACETWSCalloutResult calloutResult = stub.getIndividual(memberId, MemberDetail);               
        } 
        else {
            ACETGetIndividualWebService stub = new ACETGetIndividualWebService();
            ACETWSCalloutResult calloutResult = stub.getIndividual(memberId, MemberDetail);
        }     
    }
    
    
}