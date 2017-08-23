public class ACETFindAuthorizationJSON2Apex{
    public findMedicalHealthServiceCaseAuthorizationsResult findMedicalHealthServiceCaseAuthorizationsResult {get;set;}
    public class findMedicalHealthServiceCaseAuthorizationsResult {
        public findAuthorizationsResponseBaseType findAuthorizationsResponseBaseType {get;set;}
    }
    public class findAuthorizationsResponseBaseType {
      //  public responseHeader responseHeader {get;set;}
        public findAuthorizationsByMemberResponse findAuthorizationsByMemberResponse {get;set;}
        public pagination pagination {get;set;}
    }
 /*   public class responseHeader {
        public String applicationName {get;set;}
        public String serviceCallStatus {get;set;}
        public String serviceName {get;set;}
        public logID logID {get;set;}
    }
    public class logID {
        public String id {get;set;}
    } */
    public class findAuthorizationsByMemberResponse {
        public List<authorization> authorization {get;set;}
    }
    public class authorization {
        public statusCode statusCode {get;set;}
        public statusReasonCode statusReasonCode {get;set;}
        public String createDatetime {get;set;}
        public facilityStay facilityStay {get;set;}
    //    public globalId globalId {get;set;}
        public List<authService> authService {get;set;}
        public List<authDiagnosis> authDiagnosis {get;set;}
        public authId authId {get;set;}
        public List<authProvider> authProvider {get;set;}
        public String primaryServiceRefNbr {get;set;}
        public serviceSettingTypeCode serviceSettingTypeCode {get;set;}
    }
    public class statusCode {
      //  public String code {get;set;}
        public String descr {get;set;}
    }
    public class statusReasonCode {
    //    public String code {get;set;}
        public String descr {get;set;}
    }
/*    public class createDatetime {
        public String dteTime {get;set;}
    } */
    public class facilityStay {
        public outPatient outPatient {get;set;}
        public inPatient inPatient {get;set;}
        public placeOfServiceCode placeOfServiceCode {get;set;}
        public servicedescUrgencyCode servicedescUrgencyCode {get;set;}
        public serviceDetailCategoryCode serviceDetailCategoryCode {get;set;}
        public String advanceNotificationIndicator {get;set;}
    }
    public class outPatient {
        public findPatientFacilityStay findPatientFacilityStay {get;set;}
        public outpatientStayEffDates outpatientStayEffDates {get;set;}
    }
    public class outpatientStayEffDates {
        public String startDate {get;set;}
        public String stopDate {get;set;}
    }
    public class inPatient {
        public findPatientFacilityStay findPatientFacilityStay {get;set;}
    }
    public class findPatientFacilityStay {
        public String actualAdmitDate {get;set;}
        public String actualDischargeDate {get;set;}
        public String expectedAdmissionDate {get;set;}
        public String expectedDischargeDate {get;set;}
        public String lengthOfStay {get;set;}
    }
    public class placeOfServiceCode {
     //   public String code {get;set;}
        public String descr {get;set;}
    }
    public class servicedescUrgencyCode {
    //    public String code {get;set;}
        public String descr {get;set;}
    }
    public class serviceDetailCategoryCode {
     //   public String code {get;set;}
        public String descr {get;set;}
    }
  /*  public class globalId {
        public String id {get;set;}
    }*/
    public class authService {
        public procedureCode procedureCode {get;set;}
        public procedureOtherText procedureOtherText {get;set;}
        
    }
    public class procedureCode {
        public encodingCode encodingCode {get;set;}
     //   public String codingScheme {get;set;}
     //   public String codingSchemedescr {get;set;}
    }
    public class encodingCode {
        public String code {get;set;}
        public String descr {get;set;}
    }
    public class procedureOtherText {
      //  public String procedureUnitCount {get;set;}
        public procedureUnitOfMeasureType procedureUnitOfMeasureType {get;set;}
    }
    public class procedureUnitOfMeasureType {
        public String code {get;set;}
        public String descr {get;set;}
    }
    public class authDiagnosis {
    //    public diagnosisOtherText diagnosisOtherText {get;set;}
        public diagnosisEncoding diagnosisEncoding {get;set;}
    }
    public class diagnosisEncoding{
        public diagnosisCodeCode diagnosisCodeCode {get;set;}
   //     public classificationSchemeCode classificationSchemeCode {get;set;}
    }
 /*   public class classificationSchemeCode{
        public String code {get;set;}
        public String descr {get;set;}
    } */
    public class diagnosisCodeCode{
        public String code {get;set;}
        public String descr {get;set;}
    }
    public class diagnosisOtherText {
    }
    public class authId {
        public String id {get;set;}
    }
    public class authProvider {
        public organization organization {get;set;}
        public professional professional {get;set;}
        public List<network1> network1 {get;set;}
    }
    public class organization {
        public String name {get;set;}
    }
    public class professional {
        public String lastName {get;set;}
        public String firstName {get;set;}
    }
    public class network1 {
        public networkTypeCode networkTypeCode {get;set;}
    }
    public class networkTypeCode {
    //    public String code {get;set;}
        public String descr {get;set;}
    }
    public class serviceSettingTypeCode {
        public String code {get;set;}
        public String descr {get;set;}
    } 
    public class pagination {
    	public String pageSize {get;set;}
    	public String totalCount {get;set;}
    	public String moreRecords {get;set;}
    	public String startRecord {get;set;}
   }
  
}