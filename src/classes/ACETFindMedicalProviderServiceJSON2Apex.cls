public class ACETFindMedicalProviderServiceJSON2Apex{
    public findProvidersResponse findProvidersResponse {get;set;}
    public class findProvidersResponse {
        public findMedicalProvidersResponseType findMedicalProvidersResponseType {get;set;}
    }
    public class findMedicalProvidersResponseType {
        public List<errors> errors {get;set;}
        public List<medicalProviders> medicalProviders {get;set;}
        public pagination pagination {get;set;}
    }
    public class errors {
        public String code {get;set;} 
        public String name {get;set;} 
        public String severity {get;set;} 
        public String origin {get;set;}   
        public String description {get;set;}  
    }
    public class medicalProviders {
        public key key {get;set;}
        public healthcareProvider healthcareProvider {get;set;}
        public role role {get;set;}
        public providerTIN providerTIN {get;set;}
        public List<tpsm> tpsm {get;set;}
        public List<npi> npi {get;set;}
        public List<contract> contract {get;set;}
        public List<specialty> specialty {get;set;}
        public address address {get;set;}
        public List<phone> phone {get;set;}
        public List<electronicCommunication> electronicCommunication {get;set;}
        public List<medicare> medicare {get;set;}
        public List<medicaid> medicaid {get;set;}
        public List<premiumDesignation> premiumDesignation {get;set;}
        public List<degree> degree {get;set;}
    }
    public class key {
        public List<nameValue> nameValue {get;set;}
    }
    public class nameValue {
        public String name {get;set;} 
        public String value {get;set;}    
    }
    public class healthcareProvider {
        public String providerId {get;set;}   
        public String professionalLastNameOrOrganizationName {get;set;}   
        public String providerFirstName {get;set;}    
        public String professionalMiddleName {get;set;}   
        public String professionalNameSuffix {get;set;}   
        public String dateOfBirth {get;set;}  
        public String genderCode {get;set;}   
        public String providerStatusCode {get;set;}   
        public String providerStatusEffectiveDate {get;set;}  
        public String providerStatusCancelDate {get;set;} 
        public String providerTypeCode {get;set;} 
    }
    public class role {
        public String statusCode {get;set;}   
        public String effectiveDate {get;set;}    
        public String cancelDate {get;set;}   
        public String code {get;set;} 
        public String description {get;set;}  
    }
    public class providerTIN {
        public String typeCode {get;set;} 
        public String effectiveDate {get;set;}    
        public String cancelDate {get;set;}   
        public String owner {get;set;}    
        public String id {get;set;}   
        public String statusCode {get;set;}   
    }
    public class tpsm {
        public List<String> statusCode {get;set;}
        public List<String> statusEffectiveDate {get;set;}
        public List<String> statusCancelDate {get;set;}
        public List<String> code {get;set;}
        public List<String> description {get;set;}
    }
       public class npi {
        public List<String> providerNPI {get;set;}
        public List<String> npiStatusCode {get;set;}
        public List<String> effectiveDate {get;set;}
        public List<String> cancelDate {get;set;}
        public List<String> validationDate {get;set;}
    }
        public class contract {
        public List<String> businessSegmentCode {get;set;}
        public List<String> contractStatusCode {get;set;}
    }
    public class businessSegmentCode {
      /*public String 0 {get;set;}    
        public String 1 {get;set;}    
        public String 2 {get;set;}    */
    } 
    public class contractStatusCode {
      /*public String 0 {get;set;}    
        public String 1 {get;set;}    
        public String 2 {get;set;}    */
    }
    public class specialty {
        public List<String> typeCode {get;set;}
        public List<String> typeDescription {get;set;}
        public List<String> effectiveDate {get;set;}
        public List<String> cancelDate {get;set;}
        public String primarySpecialtyIndicator {get;set;}
        public String statusCode {get;set;}   
    }
       public class address {
        public String addressLine1 {get;set;} 
        public String addressLine2 {get;set;} 
        public String city {get;set;} 
        public String postalPrefixCode {get;set;} 
        public String postalSuffixCode {get;set;} 
        public String countryCode {get;set;}  
        public String countryDescription {get;set;}   
        public String countyCode {get;set;}   
        public String countyDescription {get;set;}    
        public String stateCode {get;set;}    
        public String addressId {get;set;}    
        public String typeCode {get;set;} 
        public String effectiveDate {get;set;}    
        public String cancelDate {get;set;}   
        public String statusCode {get;set;}   
        public String primaryIndicator {get;set;} 
        public String distance {get;set;} 
        public String handicapAccessibleIndicator {get;set;}  
    }
    public class phone {
        public String phoneTypeCode {get;set;}    
        public String phoneCountryCode {get;set;} 
        public String areaCode {get;set;} 
        public String phoneNumber {get;set;}  
        public String phoneExtensionNumber {get;set;} 
        public String primaryPhoneIndicator {get;set;}    
        public String statusCode {get;set;}   
    }
    public class electronicCommunication {
        public String communicationTypeCode {get;set;}    
        public String message {get;set;}  
        public String statusCode {get;set;}   
    }
    public class medicare {
        public String statusCode {get;set;}   
        public String medicareIdEffectiveDate {get;set;}  
        public String medicareIdCancelDate {get;set;} 
        public String medicareId {get;set;}   
    }
    public class medicaid {
        public String statusCode {get;set;}   
        public String medicaidId {get;set;}   
        public String medicaidIdEffectiveDate {get;set;}  
        public String medicaidIdCancelDate {get;set;} 
    }
    public class premiumDesignation {
        public String diseaseGroupTypeCode {get;set;} 
        public String qualityTypeCode {get;set;}  
        public String efficiencyTypeCode {get;set;}   
    }
    public class degree {
        public String primaryIndicator {get;set;} 
        public String code {get;set;} 
    }
    public class pagination {
        public String pageNumber {get;set;}   
        public String pageSize {get;set;} 
        public String recordCount {get;set;}  
        public String totalCount {get;set;}   
        public String totalPages {get;set;}   
    }
 }