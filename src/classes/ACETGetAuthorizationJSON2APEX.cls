public class ACETGetAuthorizationJSON2APEX{
    public GetMedicalHealthServiceCaseAuthorizationResult GetMedicalHealthServiceCaseAuthorizationResult {get;set;}
    public class GetMedicalHealthServiceCaseAuthorizationResult {
        public getAuthorizationResponseBaseType getAuthorizationResponseBaseType {get;set;}
    }
    public class getAuthorizationResponseBaseType {
      //  public responseHeader responseHeader {get;set;}
        public getAuthorizationResponse getAuthorizationResponse {get;set;}
    }
  /*  public class responseHeader {
        public String applicationName {get;set;}  
        public String serviceCallStatus {get;set;}    
        public String serviceName {get;set;}  
        public serviceVersion serviceVersion {get;set;}
        public logID logID {get;set;}
    } 
    public class serviceVersion {
        public String numbr {get;set;}   
    } 
    public class logID {
        public String id {get;set;}   
    } */
    public class getAuthorizationResponse {
        public parentAuthorization authorization {get;set;}
    }
    public class parentAuthorization{
        public authorization authorization {get;set;}
        public List<authDiagnosis> authDiagnosis {get;set;}
        public List<authProvider> authProvider {get;set;}
        public List<notes> notes {get;set;}
        public authFollowupContact authFollowupContact {get;set;}
       // public member member {get;set;}
        public List<authServices> authServices {get;set;}
        public authFacility authFacility {get;set;}
    }
    public class authorization {
      //  public authId authId {get;set;}
     //   public String createDatetime {get;set;}
        public authStatusReasonCode authStatusReasonCode {get;set;}
        public authStatusCode authStatusCode {get;set;}
        public serviceSettingTypeCode serviceSettingTypeCode {get;set;}
      //  public globalId globalId {get;set;}
        public reviewPriority reviewPriority {get;set;}
        public serviceCategoryTypeCode serviceCategoryTypeCode {get;set;}
        
    }
  /*  public class authId {
        public String id {get;set;}   
    }
    public class createDatetime {
        public String dteTime {get;set;} 
    } */
    public class authStatusReasonCode {
     //   public String code {get;set;} 
        public String descr {get;set;} 
    }
    public class authStatusCode {
     //   public String code {get;set;} 
        public String descr {get;set;} 
    }
    public class serviceSettingTypeCode {
     //  public String code {get;set;} 
        public String descr {get;set;} 
    }
 /*   public class globalId {
        public String id {get;set;}   
    } */
    public class reviewPriority {
      //  public String code {get;set;} 
        public String descr {get;set;} 
    }
    public class serviceCategoryTypeCode {
     //   public String code {get;set;} 
        public String descr {get;set;} 
    }
    public class authDiagnosis {
      //  public preference preference {get;set;}
      //  public diagnosisOtherText diagnosisOtherText {get;set;}
     //   public String admitInd {get;set;} 
        public diagnosisCode diagnosisCode {get;set;}
     //   public diagnosisTypeCode diagnosisTypeCode {get;set;}
    }
  /*  public class preference {
        public String indicator {get;set;}    
        public String sequence {get;set;} 
    } */
    public class diagnosisOtherText {
    }
    public class diagnosisCode {
        public String code {get;set;} 
        public String descr {get;set;} 
    }
 /*   public class diagnosisTypeCode {
        public String name {get;set;} 
        public String declaredType {get;set;} 
        public String scope {get;set;}    
        public value value {get;set;}
        public boolean nil {get;set;}
        public boolean globalScope {get;set;}
        public boolean typeSubstituted {get;set;}
    } */
   /* public class value {
        public String code {get;set;} 
        public String descr {get;set;} 
    } */
    public class authProvider {
        public networkStatusType networkStatusType {get;set;}
   //     public productType productType {get;set;}
        public String providerSeqNum {get;set;}   
        public List<authProviderId> id {get;set;}
        public organization organization {get;set;}
        public List<providerRole> providerRole {get;set;}
        public List<specialty> specialty {get;set;}
        public providerCategory providerCategory {get;set;}
        public String businessName {get;set;} 
        public authProviderContactName contactName {get;set;}
    }
    public class networkStatusType {
    //    public String code {get;set;} 
        public String descr {get;set;} 
    }
    public class productType {
    }
    public class authProviderId {
        public typeCode typeCode {get;set;}
        public String id {get;set;}   
    }
    public class typeCode {
      //  public String code {get;set;} 
        public String descr {get;set;} 
    }
    public class organization {
        public List<correspondence> correspondence {get;set;}
    }
    public class correspondence {
     //   public List<telephone> telephone {get;set;}
        public authProviderOrganizationAddress address {get;set;}
    }
   /* public class telephone {
        public telephoneNumber telephoneNumber {get;set;}
    }
    public class telephoneNumber {
        public isoCountryCode isoCountryCode {get;set;}
        public List<telephoneNumberId> id {get;set;}
    }
    public class telephoneNumberId{
        public String id {get;set;}
    } 
    public class isoCountryCode {
        public String code {get;set;} 
        public String descr {get;set;} 
    } */
    public class authProviderOrganizationAddress {
        public String line1 {get;set;}
        public String city {get;set;}
        public state state {get;set;}
        public List<postalCode> postalCode {get;set;}
    }
/*    public class address {
        public postalAddress postalAddress {get;set;}
        public typeCode typeCode {get;set;}
        public effectiveDateRange effectiveDateRange {get;set;}
    } */
    public class state {
        public String code {get;set;} 
    //    public String descr {get;set;} 
    }
    public class postalCode {
        public String part1 {get;set;}    
     //   public String suffix {get;set;}   
    }
    public class providerRole {
        public roleTypeId roleTypeId {get;set;}
    }
    public class roleTypeId {
        public String sourceSysCode {get;set;}    
     ///   public String id {get;set;}   
    }
    public class specialty {
        public typeCode typeCode {get;set;}
    }
    public class providerCategory {
        public String code {get;set;} 
    }
    public class authProviderContactName {
        public String lastName {get;set;}
        public String firstName {get;set;}
        public String middleName {get;set;}
     //   public suffixCode suffixCode {get;set;}
        
    }
    public class contactName {
        public String fullName {get;set;} 
    }
    public class suffixCode {
    }
    public class notes {
        public String createDatetime {get;set;}
     //   public createdByPerson createdByPerson {get;set;}
        public createdByUserid createdByUserid {get;set;}
        public noteCategoryCode noteCategoryCode {get;set;}
        public noteText noteText {get;set;}
    }
/*    public class createdByPerson {
        public String firstName {get;set;}    
        public String lastName {get;set;} 
    } */
    public class createdByUserid {
        public String id {get;set;}   
    }
    public class noteCategoryCode {
        public String code {get;set;} 
        public String descr {get;set;} 
    }
    public class noteText {
        public String text {get;set;} 
    }
    public class authFollowupContact {
     //   public String availabilityEffStartDate {get;set;}
     //   public String availabilityEffStopDate {get;set;}
        public communicationContactRoleCode communicationContactRoleCode {get;set;}
        public contactName contactName {get;set;}
        public departmentTypeCode departmentTypeCode {get;set;}
        public emailAddressText emailAddressText {get;set;}
     //   public List<faxNumber> faxNumber {get;set;}
        public String medicalRecordNumber {get;set;}  
        public List<phoneNumber> phoneNumber {get;set;}
     //   public channelSourceType channelSourceType {get;set;}
    }
    public class availabilityEffStartDate {
    }
    public class availabilityEffStopDate {
    }
    public class communicationContactRoleCode {
     //   public String code {get;set;} 
        public String descr {get;set;} 
    }
    public class departmentTypeCode {
      //  public String code {get;set;} 
        public String descr {get;set;} 
    }
    public class emailAddressText {
        public String text {get;set;}
    }
    public class faxNumber {
    }
    public class phoneNumber {
        public phoneTypeCode phoneTypeCode {get;set;}
    //    public isoCountryCode isoCountryCode {get;set;}
        public String telephoneNumber {get;set;}  
    //    public primary primary {get;set;}
    }
    public class phoneTypeCode {
        public String code {get;set;} 
    }
    public class primary {
        public String indicator {get;set;}    
    }
  /*  public class channelSourceType {
     }
    public class member {
        public List<individualId> individualId {get;set;}
        public name name {get;set;}
        public birthDate birthDate {get;set;}
        public genderCode genderCode {get;set;}
        public List<relationship> relationship {get;set;}
        public List<address> address {get;set;}
    } 
    public class individualId {
        public String sourceSysCode {get;set;}    
        public String id {get;set;}   
    } 
    public class name {
        public String firstName {get;set;}    
        public String middleName {get;set;}   
        public String lastName {get;set;} 
        public suffixCode suffixCode {get;set;}
    }
    public class birthDate {
        public String dte {get;set;} 
    }
    public class genderCode {
        public String code {get;set;} 
        public String descr {get;set;} 
    }
    public class relationship {
        public relationshipCode relationshipCode {get;set;}
    }
    public class relationshipCode {
        public String code {get;set;} 
    }
    public class postalAddress {
        public String line1 {get;set;}    
        public String city {get;set;} 
        public state state {get;set;}
        public List<postalCode> postalCode {get;set;}
        public isoCountryCode isoCountryCode {get;set;}
    }
    public class effectiveDateRange {
        public String stopDate {get;set;} 
    } */
    public class authServices {
        public facilityProcedure facilityProcedure {get;set;}
        public nonFacilityProcedure nonFacilityProcedure {get;set;}
        public procedureDecision procedureDecision {get;set;}
        public procedureCode procedureCode {get;set;}
      //  public procedureCodeTypeCode procedureCodeTypeCode {get;set;}
        public procedureOtherText procedureOtherText {get;set;}
        public String serviceReferenceNbr {get;set;}  
     //   public String serviceSequenceNbr {get;set;}   
        public String serviceProviderSeqNum {get;set;}    
    }
    public class facilityProcedure {
        public String actualProcedureDate {get;set;}
        public String expectedProcedureDate {get;set;}
    }
    public class nonFacilityProcedure {
        public serviceEffDates serviceEffDates {get;set;}
    }
    public class serviceEffDates {
        public String startDate {get;set;}
      //  public String endDate {get;set;}
    }
/*    public class actualProcedureDate {
        public String dte {get;set;} 
    }
    public class expectedProcedureDate {
        public String dte {get;set;} 
    } */
    public class procedureDecision {
        public claimNote claimNote {get;set;}
        public decisionOutcomeCode decisionOutcomeCode {get;set;}
        public decisionReasonCode decisionReasonCode {get;set;}
        public String decisionRenderedDatetime {get;set;}
     //   public String decisionSequenceNbr {get;set;}
        public decisionSubTypeCode decisionSubTypeCode {get;set;}
        public gapReviewOutcomeCode gapReviewOutcomeCode {get;set;}
    //    public overrideClaimRemarkCode overrideClaimRemarkCode {get;set;}
    //    public decisionMadeByUserId decisionMadeByUserId {get;set;}
        public derivedClaimRemarkCode derivedClaimRemarkCode {get;set;}
    }
    public class claimNote {
        public String text {get;set;} 
    }
    public class decisionOutcomeCode {
    //    public String code {get;set;} 
        public String descr {get;set;} 
    }
    public class decisionReasonCode {
      //  public String code {get;set;}
        public String descr {get;set;}
    }
  /*  public class decisionRenderedDatetime {
        public String dteTime {get;set;} 
    } */
    public class decisionSubTypeCode {
    //    public String code {get;set;}
        public String descr {get;set;}
    }
    public class gapReviewOutcomeCode {
      //  public String code {get;set;}
        public String descr {get;set;}
    }
   /* public class overrideClaimRemarkCode {
        public String code {get;set;}
        public String descr {get;set;}
    } */
  /*  public class decisionMadeByUserId {
        public String id {get;set;}
    } */
    public class derivedClaimRemarkCode {
        public String code {get;set;}
        public String descr {get;set;}
    }
    public class procedureCode {
        public String code {get;set;} 
        public String descr {get;set;}
    }
  /*  public class procedureCodeTypeCode {
        public String code {get;set;}
        public String descr {get;set;}
    } */
    public class procedureOtherText {
        public String text {get;set;}
    }
    public class authFacility {
        public String admissionNotificationTimestamp {get;set;}
        public String advanceNotificationTimestamp {get;set;}
        public String dischargeNotificationTimestamp {get;set;}
        public facilityDecision facilityDecision {get;set;}
        public inPatient inPatient {get;set;}
       // public String notificationLateInd {get;set;}
      //  public String notificationRetroInd {get;set;}
        public placeOfServiceCode placeOfServiceCode {get;set;}
        public servicedescUrgencyCode servicedescUrgencyCode {get;set;}
        public serviceDetailCategoryCode serviceDetailCategoryCode {get;set;}
        public String serviceReferenceNbr {get;set;}
        public String actualDischargeDate {get;set;}
        public String expectedDischargeDate {get;set;}
        public String actualAdmitDate {get;set;}
        public String expectedAdmissionDate {get;set;}
      //  public icmSystemTypeCode icmSystemTypeCode {get;set;}
    }
 /*   public class admissionNotificationTimestamp {
        public String dteTime {get;set;}
    } 
    public class advanceNotificationTimestamp {
        public String dteTime {get;set;}
    } 
    public class dischargeNotificationTimestamp {
        public String dteTime {get;set;}
    } */
    public class facilityDecision {
     //   public List<facilityDecisionSource> facilityDecisionSource {get;set;}
        public claimNote claimNote {get;set;}
        public decisionOutcomeCode decisionOutcomeCode {get;set;}
        public decisionReasonCode decisionReasonCode {get;set;}
        public String decisionRenderedDatetime {get;set;}
    //    public String decisionSequenceNbr {get;set;}
        public decisionSubTypeCode decisionSubTypeCode {get;set;}
        public gapReviewOutcomeCode gapReviewOutcomeCode {get;set;}
    //    public overrideClaimRemarkCode overrideClaimRemarkCode {get;set;}
    //    public decisionSourceComment decisionSourceComment {get;set;}
     //   public decisionMadeByUserId decisionMadeByUserId {get;set;}
        public derivedClaimRemarkCode derivedClaimRemarkCode {get;set;}
    }
  /*  public class facilityDecisionSource {
        public String sourceSeqNum {get;set;}
        public decisionSourceTypeCode decisionSourceTypeCode {get;set;}
        public criteriaID criteriaID {get;set;}
    } 
    public class decisionSourceTypeCode {
        public String code {get;set;}
        public String descr {get;set;}
    } 
    
    public class criteriaID {
        public String id {get;set;}
    }
    public class decisionSourceComment {
        public String text {get;set;}
    } */
    public class inPatient {
        public dischargeDispositionCode dischargeDispositionCode {get;set;}
    //    public List<BedDayDecision> BedDayDecision {get;set;}
     //   public String icmAvailableInd {get;set;}
    }
    public class dischargeDispositionCode {
     //   public String code {get;set;} 
        public String descr {get;set;}
    }
 /*   public class BedDayDecision {
        public bedDates bedDates {get;set;}
        public bedDayDecisionOutcomeTypeCode bedDayDecisionOutcomeTypeCode {get;set;}
        public bedTypeCode bedTypeCode {get;set;}
        public claimNote claimNote {get;set;}
        public decisionReasonTypeIdCode decisionReasonTypeIdCode {get;set;}
//        public overrideClaimRemarkCode overrideClaimRemarkCode {get;set;}
        public revenueCode revenueCode {get;set;}
        public systemClaimRemarkCode systemClaimRemarkCode {get;set;}
    }
    public class bedDates {
        public String startDate {get;set;}
        public String stopDate {get;set;}
    }
    public class bedDayDecisionOutcomeTypeCode {
        public String code {get;set;} 
        public String descr {get;set;}
    }
    public class bedTypeCode {
        public String code {get;set;} 
        public String descr {get;set;} 
    }
    public class decisionReasonTypeIdCode {
        public String code {get;set;} 
        public String descr {get;set;}
    }
    public class revenueCode {
        public String code {get;set;} 
        public String descr {get;set;}
    }
    public class systemClaimRemarkCode {
        public String code {get;set;}
        public String descr {get;set;} 
    } */
    public class placeOfServiceCode {
        public String code {get;set;} 
        public String descr {get;set;} 
    }
    public class servicedescUrgencyCode {
    //    public String code {get;set;}
        public String descr {get;set;}
    }
    public class serviceDetailCategoryCode {
   //     public String code {get;set;}
        public String descr {get;set;} 
    }
/*    public class actualDischargeDate {
        public String dteTime {get;set;}
    }
    public class expectedDischargeDate {
        public String dte {get;set;}
    }
    public class actualAdmitDate {
        public String dteTime {get;set;} 
    }
    public class expectedAdmissionDate {
        public String dte {get;set;}
    }
    public class icmSystemTypeCode {
        public String code {get;set;}
        public String descr {get;set;}
    } */
}