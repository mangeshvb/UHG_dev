public class ACETGetEmployerGroupAdapterJSON2Apex{

    public GetEmployerGroup getEmployerGroup{get;set;}
    
    public class GetEmployerGroup {
        public GetEmployerGroupResponse getEmployerGroupResponse{get;set;}
    }

    public class GetEmployerGroupResponse {
        public EmployerGroup employerGroup{get;set;}
    }

    public class Email {
        public String communicationTypeCode{get;set;}
        public String electronicAddress{get;set;}
    }
    public class Address {
        public String addressTypeCode{get;set;}
        public String addressTypeDescription{get;set;}
        public String addressLine1{get;set;}
        public String addressLine2{get;set;}
        public String addressLine3{get;set;}
        public String addressCity{get;set;}
        public String addressPostalCode{get;set;}
        public String addressStateCode{get;set;}
        public String addressCountryCode{get;set;}
        public String addressCountryDescription{get;set;}
    }
    public class CustomerPurchase {
        public String memberGroupContractPlanOptionID{get;set;}
        public String stateOfIssueCode{get;set;}
        public String stateOfIssueDescription{get;set;}
        public String fundingArrangementCode{get;set;}
        public String fundingArrangementDescription{get;set;}
        public String coverageStartDate{get;set;}
        public String coverageExpirationDate{get;set;}
        public String benefitBundleOptionID{get;set;}
        public String openEnrollmentStartDate{get;set;}
        public String openEnrollmentEndDate{get;set;}
        public String timePeriodQualifier{get;set;}
        public String benefitBasePlan{get;set;}
        public String benefitPlanDescription{get;set;}
        public String gatedProductIndicator{get;set;}
        public String planMetallicLevel{get;set;}
        public List<LineOfBusiness> lineOfBusiness{get;set;}
        public List<String> networkScheduleId{get;set;}
        public List<BillingSchedule> billingSchedule{get;set;}
    }
    

    public class CustomerAccount {
        public String planBillingGroupNumber{get;set;}
        public String statusCode{get;set;}
        public String statusDescription{get;set;}
        public String startDate{get;set;}
        public String renewalDate{get;set;}
        public String terminationDate{get;set;}
        public String terminationReasonCode{get;set;}
        public String terminationReasonDescription{get;set;}
        public List<CustomerAccountInsuringRules> customerAccountInsuringRules{get;set;}
        public List<CustomerPurchase> customerPurchase{get;set;}
    }

    public class PopulationGroupEnsuringRules {
        public String earlyRetirementIndicator{get;set;}
        public String earlyRetirementMinimumAge{get;set;}
        public String workingRetirementIndicator{get;set;}
        public String workingRetirementMinimumAge{get;set;}
    }

    public class GroupPopulation {
        public String classesCode{get;set;}
        public String classesDescription{get;set;}
        public String openEnrollmentPopulationClassStartDate{get;set;}
        public String openEnrollmentPopulationClassEndDate{get;set;}
        public List<PopulationGroupEnsuringRules> populationGroupEnsuringRules{get;set;}
    }

    

    public class GroupContact {
        public String roleType{get;set;}
        public String roleDescription{get;set;}
        public String primaryIndicatorCode{get;set;}
        public String primaryIndicatorDescription{get;set;}
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String middleName{get;set;}
        public String nameSuffix{get;set;}
        public String startDate{get;set;}
        public String endDate{get;set;}
        public List<Phone_Z> phone{get;set;}
        public List<Email> email{get;set;}
        public List<Address> address{get;set;}
    }

    public class EmployerGroup {
        public String groupNumber{get;set;}
        public String groupName{get;set;}
        public String sourceSysCode{get;set;}
        public List<String> taxIdentificationNumber{get;set;}
        public String cobraAdministrativeIndicator{get;set;}
        public String onshoreRestriction{get;set;}
        public String sizeDefinitionCode{get;set;}
        public String sizeDefinitionDescription{get;set;}
        public String riskManagementIndicator{get;set;}
        public List<EmployeeCounts> employeeCounts{get;set;}
        public List<GroupAddress> groupAddress{get;set;}
        public List<GroupContact> groupContact{get;set;}
        public List<GroupSupportTeamContact> groupSupportTeamContact{get;set;}
        public List<GroupPopulation> groupPopulation{get;set;}
        public List<CustomerAccount> customerAccount{get;set;}
    }

    public class Phone_Y {
        public String phoneType{get;set;}
        public String phoneTypeDescription{get;set;}
        public String telephoneNumber{get;set;}
        public String phoneExtension{get;set;}
    }

    public class Phone_Z {
        public String phoneType{get;set;}
        public String telephoneNumber{get;set;}
        public String phoneExtension{get;set;}
    }

    public class BillingSchedule {
        public String ratingMethodology{get;set;}
        public String contractTypeCode{get;set;}
        public String contractTypeDescription{get;set;}
        public String amount{get;set;}
        public String genderLimit{get;set;}
        public String ageBandFromValue{get;set;}
        public String ageBandToValue{get;set;}
    }

    public class Phone {
        public String phoneType{get;set;}
        public String phoneTypeDescription{get;set;}
        public String telephoneNumber{get;set;}
        public String phoneExtension{get;set;}
        public String phonePrimaryIndicator{get;set;}
    }

    public class GroupSupportTeamContact {
        public String serviceTeam{get;set;}
        public String roleType{get;set;}
        public String roleDescription{get;set;}
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String middleName{get;set;}
        public String nameSuffix{get;set;}
        public String startDate{get;set;}
        public String endDate{get;set;}
        public List<Phone_Y> phone{get;set;}
        public List<Email> email{get;set;}
    }

    public class LineOfBusiness {
        public String name{get;set;}
        public String description{get;set;}
    }

    public class GroupAddress {
        public String addressTypeCode{get;set;}
        public String addressTypeDescription{get;set;}
        public String addressLine1{get;set;}
        public String addressLine2{get;set;}
        public String addressLine3{get;set;}
        public String addressCity{get;set;}
        public String addressPostalCode{get;set;}
        public String addressStateCode{get;set;}
        public String addressCountryCode{get;set;}
        public String addressCountryDescription{get;set;}
        public List<Phone> phone{get;set;}
        public String salesOfficeCode{get;set;}
        public String salesOfficeDescription{get;set;}
    }

    public class EmployeeCounts {
        public String employeeCountDescription{get;set;}
        public String employeeCount{get;set;}
    }

    public class CustomerAccountInsuringRules {
        public String dependentCutOff{get;set;}
        public String dependentCutOffStartDate{get;set;}
        public String dependentCutOffEndDate{get;set;}
        public String waiveRehiredIndefiniteIndicator{get;set;}
        public String waiveRehiredWithinCount{get;set;}
        public String waiveRehiredWithinType{get;set;}
        public String terminationLagType{get;set;}
        public String terminationLagDescription{get;set;}
        public String terminationLagStartDate{get;set;}
        public String terminationLagEndDate{get;set;}
        public String newHireWaitingPeriodType{get;set;}
        public String newHireWaitingStartDate{get;set;}
        public String newHireWaitingEndDate{get;set;}
    }
    
}