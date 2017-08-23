public class ACETGetMembershipJSON2ApexADP{
    public cls_getMembershipResponse getMembershipResponse;
    public class cls_getMembershipResponse {
        public cls_membership membership;
    }
    public class cls_membership {
        public String sourceSysCode;    //CR
        public cls_coverages[] coverages;
        public cls_cob[] cob;
        public cls_providers[] providers;
        public cls_identifiers[] identifiers;
    }
    public class cls_coverages {
        public String groupNumber;  //1118478
        public String groupName;    //Membership_services_MG33
        public String eligibilitySystemTypeCode;    //CR
        public String claimSystemTypeCode;  //CR
        public cls_bundleOptions[] bundleOptions;
    }
    public class cls_bundleOptions {
        public cls_benefits[] benefits;
    }
    public class cls_benefits {
        public String benefitBundleOptionId;    //0
        public String benefitBundleOptionDescription;   //MNRP PlanOptionDesc
        public String benefitEffectiveDate; //2015-01-01
        public String benefitExpirationDate;    //9999-12-31
        public String benefitPlanId;    //M000000015
        public String benefitPlanName;  //CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C
        public String benefitType;  //MD
        public String coverageLevelCode;    //FAM
        public String relationshipCode; //18
        public String relationshipDescription;  //18
        public String memberIdCardSerialNumber; //69688001800
        public String subscriberIdCardSerialNumber; //69688001800
        public String eligibilityStatusCode;    //
        public String stateOfIssueCode; //situs state
        public String fundingArrangementDescription;
        public String fundingArrangementCode;
        public String cancelReasonTypeCode; //
        public String planType; //02
    }
    public class cls_cob {
    }
    public class cls_providers {
        public cls_providerIdentifiers[] providerIdentifiers;
        public String assignmentType;   //PCP
        public String effectiveDate;    //2017-01-01
        public String expirationDate;   //2020-12-31
        public String firstName;    //LINDA
        public String lastName; //TAO
        public String networkId;    //7
    }
    public class cls_providerIdentifiers {
        public String id;   //212226509
        public String type; //SY
    }
    public class cls_identifiers {
        public String id;   //890504596
        public String type; //enrolleeSurrogateKey
    }
}