public with sharing class ACETWebserviceHelper {
    public static ACETMemberDetail queryIndividuals(ACETMemberDetail MemberDetail){ 
    	if(MemberDetail == null){
    		MemberDetail = new ACETMemberDetail(); 
    	}
        String Id = ApexPages.currentPage().getParameters().get('Id');
        MemberDetail.SurrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        system.debug(' ACETWebserviceHelper :queryIndividuals : MemberDetail.SurrogateKey '+MemberDetail.SurrogateKey);    	
        if(!String.isEmpty(MemberDetail.SurrogateKey) && MemberDetail.SurrogateKey != 'undefined'){
            system.debug('For Adaptar');
            ACETGetIndividualWebService stub = new ACETGetIndividualWebService();
            ACETWSCalloutResult calloutResult = stub.getIndividual(MemberDetail.SurrogateKey, MemberDetail);     
        } 
        else {
            system.debug('For Bravo');
            MemberDetail.SurrogateKey = '';
            ACETGetIndividualWebService stub = new ACETGetIndividualWebService();
            ACETWSCalloutResult calloutResult = stub.getIndividual(Id, MemberDetail);
        }

    	return memberDetail; 
    }
    
    public static ACETMemberDetail queryMembership(ACETMemberDetail MemberDetail){
    	if(MemberDetail == null){
    		MemberDetail = new ACETMemberDetail(); 
    	}    	
        String Id = ApexPages.currentPage().getParameters().get('Id');
        MemberDetail.SurrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        system.debug(' ACETWebserviceHelper :queryMembership : MemberDetail.SurrogateKey '+MemberDetail.SurrogateKey); 
        if(!String.isEmpty(MemberDetail.SurrogateKey) && MemberDetail.SurrogateKey != 'undefined'){
            //call findMembership service first                
            ACETfindMembershipWebService stub = new ACETfindMembershipWebService();
            ACETWSCalloutResult calloutResult = stub.findMembership(MemberDetail.SurrogateKey, MemberDetail); 
            //some fields for coverage lines depends on getMembership service
            if(MemberDetail.PreferredCoverage != null){
                ACETGetMembershipWebService stub2 = new ACETGetMembershipWebService();
                ACETWSCalloutResult calloutResult2 = stub2.getMembership(MemberDetail.SurrogateKey,MemberDetail.PreferredCoverage.groupNumber,MemberDetail);
            }         
        } 
        else{
        	MemberDetail.SurrogateKey = '';
             //call findMembership service first                
            ACETfindMembershipWebService stub = new ACETfindMembershipWebService();
            ACETWSCalloutResult calloutResult = stub.findMembership(Id, MemberDetail); 
                      
            //some fields for coverage lines depends on getMembership service         
            ACETGetMembershipWebService stub2 = new ACETGetMembershipWebService();
            ACETWSCalloutResult calloutResult2 = stub2.getMembership(Id,'',MemberDetail); 
            //system.debug('**calloutResult.Response**' + calloutResult.Response );     
        } 
        return memberDetail;  
    }
    
    public static Object callMemberServices(){
    	Map<String,String> serviceRequestLabels = new Map<String,String>();
    	Continuation PageLoadContinuation;
    		ACETMemberDetail MemberDetail = new ACETMemberDetail(); 
            //GetIndividual webservice callout
            ACETGetIndividualWebService ACETGetIndWebservice = new ACETGetIndividualWebService();
            PageLoadContinuation = ACETGetIndWebservice.StartRequest(MemberDetail.SurrogateKey, MemberDetail,'memberServicesCallback',null);  
			serviceRequestLabels.put('GetIndividualService',ACETGetIndWebservice.RequestLabel);
			
            //FindMembership webservice callout
            ACETFindMembershipWebservice ACETFindMemWebservice = new ACETFindMembershipWebservice();
            PageLoadContinuation = ACETFindMemWebservice.StartRequest(MemberDetail.SurrogateKey, MemberDetail,'memberServicesCallback',PageLoadContinuation); 
 			serviceRequestLabels.put('FindMembershipService',ACETFindMemWebservice.RequestLabel);
 			
             //GetFamilyMembership webservice callout
            ACETGetFamilyMemberWebService ACETGetFamMemWebservice = new ACETGetFamilyMemberWebService();
            PageLoadContinuation = ACETGetFamMemWebservice.StartRequest('11801753', MemberDetail,'memberServicesCallback',PageLoadContinuation);
			serviceRequestLabels.put('GetFamilyMembershipService',ACETGetFamMemWebservice.RequestLabel);            
         
          return PageLoadContinuation; 
    }
    public static PageReference memberServicesCallback(){
    	return null;
    }
    public static String formatToYYYYMMDD(String dateWithSlash){
        List<String> dateList = dateWithSlash.split('/');
        String temp = dateList[2];//2003
        dateList[2] = dateList[1];//02
        dateList[1] = dateList[0];
        dateList[0] = temp;
        
        String dateWithDash = dateList[0] +'-'+dateList[1] + '-' + dateList[2];
        return dateWithDash;    
    }
}