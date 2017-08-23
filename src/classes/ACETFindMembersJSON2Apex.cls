public class ACETFindMembersJSON2Apex{
    public FindIndividualsResult findIndividualsResult{get;set;} 
    
    public class FindIndividualsResult{
        public FindIndividualsResponseMsgType findIndividualsResponseMsgType{get;set;}    
        
    }
    
    public class FindIndividualsResponseMsgType{
        public Pagination pagination{get;set;}
        public List<Individual> individual{get;set;}    
    }
    
    public class Pagination{
        public Integer pageNumber{get;set;}
        public Integer pageSize{get;set;}
        public Integer recordCount{get;set;}
        public Integer totalCount{get;set;}
        public Integer totalPages{get;set;}            
    }
    
    public class Individual{
        public IndividualId individualId {get;set;}  
        public Name name{get;set;}
        public BirthDate birthDate{get;set;}
        public GenderCode genderCode{get;set;}
        public SocialSecurityNumberId socialSecurityNumberId{get;set;}
        public List<OtherIdentifiers> otherIdentifiers{get;set;}
        public List<Relationship> relationship{get;set;}
        public List<Address> address{get;set;}
          
    }
    
    public class IndividualId{
        public String id{get;set;}
    }
    
    public class Name{
        public String firstName{get;set;}
        public String middleInitialName{get;set;}
        public String lastName{get;set;}
        public SuffixCode suffixCode{get;set;}
    }
    
    public class SuffixCode{
        public String code{get;set;}
    }
    
    public class Address{
        public PostalAddress postalAddress{get;set;}
    }
    
    public class PostalAddress{
        public Code code{get;set;}
        public String line1{get;set;}
        public String city{get;set;}
        public State state{get;set;}
        public List<PostalCode> postalCode{get;set;}
        public IsoCountryCode isoCountryCode{get;set;}
    }
    
    public class Code{
        public String code{get;set;}
    }
            
    public class State{
       public String code{get;set;} 
    }
    
    public class PostalCode{
        public String part1{get;set;}
        public String part2{get;set;}
    }
    
    public class IsoCountryCode{
        public String code{get;set;}
    }
    
    /** replace date with date2 since date is reserved keywork */
    public class BirthDate{
        public String date2{get;set;}     
    }
    
    public class GenderCode{
        public String code{get;set;}
    }
    
    public class SocialSecurityNumberId{
        public String id{get;set;}    
    }
    
    public class OtherIdentifiers{
        public String code{get;set;}
        public String id{get;set;}
    }
    
    public class Relationship{
        public RelationshipCode relationshipCode{get;set;}
    }
    
    public class RelationshipCode{
        public String code{get;set;}
    }
    
    
    
    
    
    


}