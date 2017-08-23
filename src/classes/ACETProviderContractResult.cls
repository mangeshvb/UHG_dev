public class ACETProviderContractResult {
    public String Product { set; get; }
    public String Network_ID { set; get; }
    public String Network_Name { set; get; }
    public String Network_Status { set; get; }
    public string Effective { set; get; }
    public string Cancel { set; get; }
    public string IPA { set; get; }
    public String Pricing_Set_ID {get;set;}
    public string Capitation { set; get; }
    public String Accepting_New_Patients { set; get; }
    public String Accepting_Existing_Patients { set; get; }
    public String AgreementStatusCode {set; get;}
    public String ProviderAssignmentType {set; get;}
    public Boolean isActive { set; get; }
    public String ContractHeaderId { set; get; }
    public String ContractDetailId { set; get; }
    public String NetworkSchedule { set; get; }
    public String BenefitPlanId { set; get; }
    Public String GUID {get;set;} //manually generated
    Public ACETProviderContractResult(){
    GUID = ACETGUIDUtil.newGuid();
    }
}