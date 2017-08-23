public class FindHCPAffiliationsJSON2Apex {

    public class Error {
        public String code { get; set; }
        public String name { get; set; }
        public String severity { get; set; }
        public String origin { get; set; }
        public String description { get; set; }
    }

    public class Pagination {
        public String pageNumber { get; set; }       
         public String pageSize { get; set; }
        public String recordCount { get; set; }
        public String totalCount { get; set; }
        public String totalPages { get; set; }
    }   

    public class FindMedicalHealthcareProfessionalAffiliationsResult {
        public FindMedicalHealthcareProfessionalAffiliationsResponseType findMedicalHealthcareProfessionalAffiliationsResponseType { get; set; }
    }

    public FindMedicalHealthcareProfessionalAffiliationsResult findMedicalHealthcareProfessionalAffiliationsResult { get; set; }

    public class MedicalHealthcareOrganization {
    //    public Key key { get; set; }
        public Hco hco { get; set; }
        public Affiliation affiliation { get; set; }
    }

    public class Hco {
      //  public String statusCode { get; set; }        
     //   public String effectiveDate { get; set; }
     //   public String cancelDate { get; set; }
        public String name { get; set; }
        public String id { get; set; }
    }

    public class FindMedicalHealthcareProfessionalAffiliationsResponseType {
        public List<MedicalHealthcareOrganization> medicalHealthcareOrganization { get; set; }
   		public Pagination pagination { get; set; }
        public Error[] errors { get; set; }
    }

/*    public class Key {
        public String healthcareProfessionalId { get; set; }
        public String healthcareOrganizationId { get; set; }
    }   */

    public class Affiliation {
      //  public String statusCode { get; set; }
        public String effectiveDate { get; set; }
      //  public String cancelDate { get; set; }
     //   public String admittingPrivilegeTypeCode { get; set; }
     //   public String admittingPrivilegeTypeDescription { get; set; }
    }
}