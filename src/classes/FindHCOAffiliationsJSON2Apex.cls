public class FindHCOAffiliationsJSON2Apex {
    public class Pagination {
        public String pageNumber { get; set; }
        public String pageSize { get; set; }
        public String recordCount { get; set; }
        public String totalCount { get; set; }
        public String totalPages { get; set; }
    }

    public class Speciality {
     //   public String statusCode { get; set; }
     //   public String effectiveDate { get; set; }
     //   public String cancelDate { get; set; }
        public String primarySpecialtyIndicator { get; set; }
     //   public String typeCode { get; set; }
        public String typeDescription { get; set; }
    }

    public class FindMedicalHealthcareOrganizationAffiliationsResponseType {
        public List<MedicalHealthcareOrganizationAffiliations> medicalHealthcareOrganizationAffiliations { get; set; }
        public Pagination pagination { get; set; }
        public Error[] errors { get; set; }
    }

    public FindMedicalHealthcareOrganizationAffiliationsResult findMedicalHealthcareOrganizationAffiliationsResult { get; set; }
    
    public class Hcp {
     //   public String statusCode { get; set; }
        public String id { get; set; }
     //   public String effectiveDate { get; set; }
    //    public String cancelDate { get; set; }
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String middleName { get; set; }
    }

    public class MedicalHealthcareOrganizationAffiliations {
     //   public Key key { get; set; }
        public Hcp hcp { get; set; }
        public Affiliation affiliation { get; set; }
        public List<Speciality> speciality { get; set; }
    }

    public class FindMedicalHealthcareOrganizationAffiliationsResult {
        public FindMedicalHealthcareOrganizationAffiliationsResponseType findMedicalHealthcareOrganizationAffiliationsResponseType { get; set; }
    }

/*    public class Key {
        public String healthcareOrganizationId { get; set; }
        public String healthcareProfessionalId { get; set; }
    }   */

    public class Affiliation {
      //  public String statusCode { get; set; }
        public String effectiveDate { get; set; }
      //  public String cancelDate { get; set; }
      //  public String admittingPrivilegeTypeCode { get; set; }
     //   public String admittingPrivilegeTypeDescription { get; set; }
    }
    
    public class Error {
        public String code { get; set; }
        public String name { get; set; }
        public String severity { get; set; }
        public String origin { get; set; }
        public String description { get; set; }
    }
}