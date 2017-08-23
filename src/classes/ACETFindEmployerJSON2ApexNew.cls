public class ACETFindEmployerJSON2ApexNew {
    
    public findEmployerGroupResponse findEmployerGroupResponse{get;set;} 
    
    public class findEmployerGroupResponse{
        public findEmployerGroupResponseMsgType findEmployerGroupResponseMsgType{get;set;}    
        
    }
    
    
    public class findEmployerGroupResponseMsgType{
        public header header {get;set;}
        public body body {get;set;}
    }
    public class header{
        
    }
    
    public class body{
        public employerGroupSummary employerGroupSummary{get;set;}
        
    }
    public class employerGroupSummary{
        public organization organization {get;set;}
        public organizationPopulationGroupAddress organizationPopulationGroupAddress{get;set;}
        public supportTeamContactTelephone supportTeamContactTelephone{get;set;}
        public organizationPopulationGroupStatusCode organizationPopulationGroupStatusCode{get;set;}
        public list<organizationPopulationGroupRenewalDate> organizationPopulationGroupRenewalDate{get;set;} 
        public string organizationPopulationGroupNumber{get;set;} 
        public string organizationPopulationGroupName{get;set;}
        public organizationPopulationGroupEffectiveStartDate organizationPopulationGroupEffectiveStartDate{get;set;}
    }
     public class organization{
        public string[] organizationTaxIdentifier{get;set;}
    } 
    public class organizationPopulationGroupEffectiveStartDate{
        public date date2{get;set;}
    }
    public class organizationPopulationGroupRenewalDate{
        public date date2{get;set;}
    }
    public class organizationPopulationGroupAddress{
        public string addressLine1Text{get;set;}
        public string addressLine2Text{get;set;}
        public string addressLine3Text{get;set;}
        public string addressTownName{get;set;}
        public string postalCode{get;set;}
        public string stateProvinceCode{get;set;}
        
    }
    public class supportTeamContactTelephone{
        public string telephoneNumber{get;set;}
    }
    public class organizationPopulationGroupStatusCode{
        public string code{get;set;}
        public string desc1{get;set;}
    }
}