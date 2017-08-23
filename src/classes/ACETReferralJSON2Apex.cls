public class ACETReferralJSON2Apex {
    public class ProviderList {
        public List<Provider> provider {get;set;} 
    }
    
    public class Organization {
        public List<CanonicalResponseHeader> tinOwner {get;set;} 
        public List<ProviderAgreement> providerAgreement {get;set;} 
        public List<Correspondence> correspondence {get;set;} 
    }
    
    public class FindReferralResponseBaseType {
        //public ResponseHeader responseHeader {get;set;} 
        public FindReferralsResponse findReferralsResponse {get;set;}
        public Pagination pagination {get;set;} 
    }
    
    public class Pagination {
		public String pageSize {get;set;} 
		public String totalCount {get;set;} 
		public String moreRecords {get;set;} 
		public String startRecord {get;set;} 
    }
    
    public class Telephone {
        //public TelephoneNumber telephoneNumber {get;set;} 
    }
    
    public class diagnosisCode {
        public String code {get;set;} 
        public String desc_Z {get;set;} // in json: desc
    }
    
    public class Correspondence_Z {
        //public List<Contact_Z> contact {get;set;} 
    }
    
    public class NoteText {
        public String text {get;set;} 
    }
    
    
    public class StatusCode {
        public String code {get;set;}
        public String desc_z{get;set;} 
    }
    
    public class ReferralData {
        public ReferralExternalID referralExternalID {get;set;} 
        public ReferralExternalID referralTypeID {get;set;} 
        public referralDescription referralDescription {get;set;} 
        public String numberOfVisits {get;set;} 
        public ReferralDateRange referralDateRange {get;set;} 
        public StatusCode statusCode {get;set;} 
        //public CanonicalResponseHeader sourceApplicationCode {get;set;} 
        public noteText noteText {get;set;} 
        public String createDateTime {get;set;} 
    }
    
    public class FindReferralsResponse {
        public ReferralList referralList {get;set;} 
    }
    
    public class Name {
        public String firstName {get;set;} 
        //public String middleName {get;set;} 
        public String lastName {get;set;} 
    }
    
    public class PaymentModel {
        public List<ProviderAgreementNetworkSpecialtyRate> providerAgreementNetworkSpecialtyRate {get;set;} 
    }
    
   
    
    public class ReferralExternalID {
        public String id {get;set;} 
    }
    public Class referralDescription{
    	public string desc_z{get;set;}
    }
    
    public class Diagnosis {
        //public Preference preference {get;set;} 
        //public CanonicalResponseHeader diagnosisOtherText {get;set;} 
        public diagnosisCode diagnosisCode {get;set;} 
        //public DiagnosisTypeCode diagnosisTypeCode {get;set;} 
    }
    
    public class Member {
        //public List<MemberId> id {get;set;} 
        //public List<IndividualId> individualId {get;set;} 
        public Name name {get;set;} 
        //public BirthDate birthDate {get;set;} 
        //public StatusCode genderCode {get;set;} 
        //public List<Relationship> relationship {get;set;} 
    }
    
    public class IndividualId {
        public String sourceSysCode {get;set;} 
        public String id {get;set;} 
    }
    
    /*public class ResponseHeader {
        public CanonicalResponseHeader canonicalResponseHeader {get;set;} 
        public List<CanonicalResponseHeader> statusMessage {get;set;} 
    }*/
    
    public FindReferralsServiceResult findReferralsServiceResult {get;set;} 
    
    public class ReferralDateRange {
        public String startDate {get;set;} 
        public String stopDate {get;set;} 
    }
    
    public class ServiceList {
        public List<Service> service {get;set;} 
    }
    
    public class ProviderAgreementNetworkSpecialtyRate {
        public StatusCode specialtyTypeCode {get;set;} 
    }
    
    public class ProviderRole {
        public List<MemberId> Id {get;set;} 
    }
    
    public class Service {
        //public String serviceSeqNum {get;set;} 
        public StatusCode procedureCode {get;set;} 
        public StatusCode procedureCodeTypeCode {get;set;} 
        //public CanonicalResponseHeader procedureOtherText {get;set;} 
        //public String serviceProviderSeqNum {get;set;} 
    }
    
    
    /*public class Contact_Z {
        public List<Telephone> telephone {get;set;} 
        public ContactName_Z contactName {get;set;} 
    }*/
    
    public class Organization_Z {
        public List<CanonicalResponseHeader> tinOwner {get;set;} 
        //public List<ProviderAgreement> providerAgreement {get;set;} 
        //public List<Correspondence_Z> correspondence {get;set;} 
    }
    
    public class ProviderAgreement {
        public PaymentModel paymentModel {get;set;} 
    }
    
    public class CanonicalResponseHeader {
    	public Address address{get;set;}
       
    }
    public class Address{
    	public string city;
    	public string line1;
    	public string line2;
    	public state state{get;set;}
    	public list<postalCode> postalCode{get;set;}
    }
    
    public class state{
    	public string code{get;set;}
    	public string desc_Z{get;set;}
    	
    }
    
    public class postalcode{
    	public string part1;
    	public string part2;
    }
    
    public class CorrContact {
        //public List<Telephone> telephone {get;set;} 
        public ContactName contactName {get;set;} 
    }
    
    public class Provider {
        //public MarketNumber marketNumber {get;set;} 
        public List<MemberId> id {get;set;} 
        public Organization organization {get;set;} 
        public List<ProviderRole> providerRole {get;set;} 
    }
    
    public class DiagnosisList {
        public List<Diagnosis> diagnosis {get;set;} 
    }
    
    public class Preference {
        //public String sequence {get;set;} 
    }
    
    public class Referral {
        public ReferralData referralData {get;set;} 
        public Member member {get;set;} 
        public ProviderList providerList {get;set;} 
        public ServiceList serviceList {get;set;} 
        public DiagnosisList diagnosisList {get;set;} 
    }
    
    public class Relationship {
        //public StatusCode relationshipCode {get;set;} 
    }
    
    public class ReferralList {
        public List<Referral> referral {get;set;} 
    }
    
    public class Correspondence {
        public List<CorrContact> contact {get;set;} 
    }
    
    public class DiagnosisTypeCode {
        public String code {get;set;} 
        public String desc_Z {get;set;} 
        
    }
    
    public class MemberId {
        public StatusCode typeCode {get;set;} 
        public String sourceSysCode {get;set;} 
        public String id {get;set;} 
    }
    
    public class FindReferralsServiceResult {
        public FindReferralResponseBaseType findReferralResponseBaseType {get;set;} 
    }
    
    public class ContactName {
        public String firstName {get;set;} 
        public String lastName {get;set;}
        public String middleName{get;set;} 
        //public CanonicalResponseHeader suffixCode {get;set;} 
    }
    
    /*public class BirthDate {
        public String dater {get;set;} 
    }*/
    
    
    
}