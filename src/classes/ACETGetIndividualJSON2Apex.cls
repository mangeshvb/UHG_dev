public class ACETGetIndividualJSON2Apex {
    public GetIndividualResult getIndividualResult {get;set;}
    
    public class GetIndividualResult {
        public GetIndividualResponseMsgType getIndividualResponseMsgType {get;set;}
    }       
    
    public class GetIndividualResponseMsgType {
        public Individual individual {get;set;}     
    } 
    
    public class Individual {
        public List<IndividualId> individualId {get;set;}
        public Name name {get;set;}
        public BirthDate birthDate {get;set;}
        public GenderCode genderCode {get;set;}
        public List<MaritalStatus> maritalStatus {get;set;}
        public List<Ethnicity> ethnicity {get;set;}
        public List<Race> race {get;set;}
        public DeceasedDate deceasedDate {get;set;} 
        public String tabaccoUseIndicator {get;set;}
        public String vipIndicator {get;set;}
        public String researchAuthorizationIndicator {get;set;}
        public SocialSecurityNumberId socialSecurityNumberId {get;set;}
        public List<OtherIdentifiers> otherIdentifiers {get;set;}
        public List<Language> language {get;set;}
        public List<Relationship> relationship {get;set;}
        public List<Address> address {get;set;}
        public List<Telephone> telephone {get;set;}
        public List<ElectronicContact> electronicContact {get;set;}
        public List<Employment> employment {get;set;}
        
        
    }  
    
    public class IndividualId {
        public String id {get;set;} 
    }
    
    public class Name {
        public String firstName {get;set;}
        public String middleName {get;set;}
        public String middleInitialName {get;set;}
        public String lastName {get;set;}
        public SuffixCode suffixCode {get;set;}     
    }
    
    public class SuffixCode {
        public String code {get;set;}
    }
    
    public Class BirthDate {
        public String date2 {get;set;}
    }
    
    public Class GenderCode {
        public String code {get;set;}
        public String desc2 {get;set;}
            
    }
    
    public class MaritalStatus {
        public String code {get;set;}   
    }
    
    public class Ethnicity {
        public String code {get;set;}
        public String desc2 {get;set;}
    }
    
    public class Race {
        public String code {get;set;}
        public String desc2 {get;set;}
    }
    
    public class DeceasedDate {
        public String date2 {get;set;}
    }
    
    public class SocialSecurityNumberId {
        public String id {get;set;} 
    }
    
    public class OtherIdentifiers {
        public String code {get;set;}
        public String id {get;set;} 
    }
    
    public class Language {
       /* public String spokenIndicator {get;set;}
        public String writtenIndicator {get;set;}
        public Primary primary {get;set;}   
        public String code {get;set;}
        public String desc2 {get;set;}*/
        public String languageCode {get;set;} 		    
		public String languageUsedTypeCode {get;set;} 		    
		public String languageUsedTypeDescription {get;set;} 
    }
    
    public class Primary {
        public String code {get;set;}   
    }
    
    public class Relationship {
        public List<RelatedIndividualAddress> relatedIndividualAddress {get;set;}
        public List<RelatedIndividualElectronicContact> relatedIndividualElectronicContact {get;set;}   
        public RelationshipCode relationshipCode {get;set;} 
        public RelatedIndividualName relatedIndividualName {get;set;}
        public RelatedIndividualSocialSecurityNumberId relatedIndividualSocialSecurityNumberId {get;set;}
    }
    
    public class RelatedIndividualAddress {
        public PostalAddress postalAddress {get;set;}       
    }
    
    public class Address {
        public PostalAddress postalAddress {get;set;}       
    }
    
    public class PostalAddress {
        public AddressType code {get;set;}
        public String line1 {get;set;}
        public String line2 {get;set;}
        public String city {get;set;}
        public State state {get;set;}
        public List<PostalCode> postalCode {get;set;}
        public IsoCountryCode isoCountryCode {get;set;} 
    }
    
    public class AddressType {
        public String code {get;set;}
    }
    
    public class PostalCode {
        public String part1 {get;set;}
        public String part2 {get;set;}          
    }
    
    public class IsoCountryCode {
        public String code {get;set;}   
    }
    
    public class RelatedIndividualElectronicContact {
        public ElectronicAddressId electronicAddressId {get;set;}       
    }
    
    public class ElectronicAddressId {
        public String id {get;set;} 
    }
    
    public class RelationshipCode {
        public String code {get;set;}   
    }
    
    public class RelatedIndividualName {
        public String firstName {get;set;}
        public String middleName {get;set;}
        public String lastName {get;set;}
        public SuffixCode suffixCode {get;set;} 
    }
    
    public class RelatedIndividualSocialSecurityNumberId {
        public String id {get;set;}
    }
    
    public class State {
        public String code {get;set;}   
    }
    
    public class Telephone {
        public Primary primary {get;set;} 
        public String telephoneNumber {get;set;}        
    }
    
    public class ElectronicContact {
        public CommunicationTypeCode communicationTypeCode {get;set;}   
        public ElectronicAddressId electronicAddressId {get;set;}   
        public Primary primary {get;set;}
    }
    
    public class CommunicationTypeCode {
        public String code {get;set;}   
    }
        
    public class employment {
        public List<Status> status {get;set;}   
        public EmployeeId employeeId {get;set;}
        public SalaryFrequencyTypeCode salaryFrequencyTypeCode {get;set;}
        public RetirementDate retirementDate {get;set;}
        public salaryAmount salaryAmount {get;set;}
        public String workHourCountValue {get;set;}
    }
    
    public class status {
        public TypeCode typeCode {get;set;}
        public EmploymentDateRange employmentDateRange {get;set;}
                
    }
    
    public class TypeCode {
        public String code {get;set;}   
    }
    
    public class EmploymentDateRange {
        public String startDate {get;set;}  
    }
    
    public class EmployeeId {
        public String id {get;set;} 
    }
    
    public class SalaryFrequencyTypeCode {
        public String code {get;set;}   
    }
    
    public class RetirementDate {
        public String date2 {get;set;}  
    }
    
    public class SalaryAmount {
        public String value {get;set;}  
    }       
}