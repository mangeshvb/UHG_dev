public with sharing class ACETFindMembershipJSON2Apex {
    public class EnrolleeEID {
        public String id;
    }

    public class Organization {
        public EnrolleeEID organizationId;
        public Code typeCode;
    }

    public FindMembershipResponse findMembershipResponse;

    public class FindMembershipResponse {
        public FindMembershipResponseType findMembershipResponseType;
    }

    public class DivisionTypeCode {
        public Code divisionCode;
    }

    public class CustomerAccount {
        public List<BusinessArrangement> businessArrangement;
        public List<CustomerPurchase> customerPurchase;
        public EnrolleeEID migratedLegacyPolicyNumberId;
        public Code obligorCode;
        public EnrolleeEID customerAccountId;
    }

    public class Coverage {
        public EffectiveDateRange effectiveDateRange;
        public Code eligibilityRelationshipCode;
        public Code coverageLevelCode;
        public EnrolleeEID organizationPopulationGroupId;
        public Code claimSystemTypeCode;
        public Code eligibilitySystemTypeCode;
        public EnrolleeEID migratedLegacySourceId;
        public EligibilityGracePeriodThroughDate eligibilityGracePeriodThroughDate;
        public Code healthCoverageTypeCode;
        public DivisionTypeCode divisionTypeCode;
        public EnrolleeEID pnlNumberId;
    }

    public class Plan {
        public List<BusinessSegment> businessSegment;
        public Code planCode;
        public Code productCode;
        public Code legacyProductCode;
        public Code planTypeCode;
    }

    public class Code {
        public String code;
    }
    
    public class SourceSystemCode {
        public String code;
    }
    
    public class CustomerPurchase {
        public Code situsStateCode;
    }

    public class MarketSegment {
        public Code code;
    }

    public class BusinessSegment {
        public List<MarketSegment> marketSegment;
    }

    public class Individual {
        public List<EnrolleeEID> EnrolleeEID;
        public List<Membership> membership;
    }

    public class OtherIdentifiers {
        public String code;
        public String sourceSysCode;
        public String id;
    }

    public class EligibilityGracePeriodThroughDate {
        public String date2;
    }

    public class EffectiveDateRange {
        public String startDate;
        public String stopDate;
    }

    public class Membership {
        public Plan plan;
        public CustomerAccount customerAccount;
        public Organization organization;
        public String onshoreRestricted;
        public List<OtherIdentifiers> otherIdentifiers;
        public SubscriberIndividualId subscriberIndividualId;
        public SubscriberIndividualId subscriberEntityId;
        public EnrolleeEID memberSequenceNbr;
        public SubscriberIndividualId enrolleeIndividualId;
        public SubscriberIndividualId enrolleeEntityId;
        public SourceSystemCode sourceSystemCode;
        public String phiIndicator;
        public List<Coverage> coverage;
        public SubscriberIndividualId subscriberSurrogateKey;
        public SubscriberIndividualId enrolleeSurrogateKey;
    }

    public class BusinessArrangement {
        public List<EnrolleeEID> id;
    }

    public class SubscriberIndividualId {
        public String sourceSysCode;
        public String id;
    }

    public class FindMembershipResponseType {
        public List<Individual> individual;
    }

    
    public static ACETFindMembershipJSON2Apex parse(String json) {
        return (ACETFindMembershipJSON2Apex) System.JSON.deserialize(json, ACETFindMembershipJSON2Apex.class);
    }    
}