public class ACETClaimDetailResult
{
    //Claim Totals - Summary
    
    
    public String  ClaimId{ set; get; }
    public String  PolicyNumber{ set; get; }
    public String  AuthorizationNumber{ set; get; }
    public Date    ReceivedDate{ set; get; }
    public String  PatientAccountNumber{ set; get; }
    public String  BillType{ set; get; }
    public String  ReferralNumber{ set; get; }
    
    //Claim Totals - UHC
    
    public String Status{ set; get; }
    public Decimal TotalCharged{ set; get; }
    public Decimal TotalNotCovered{ set; get; }
    public Decimal   TotalAllowed{ set; get; }
    public Decimal InterestPaid{ set; get; }
    public Decimal NYSurchargePaid{ set; get; }
    public Decimal TotalHealthPlanPaid{ set; get; }
    
    
    //Claim Totals - UHC Member Responsibility
    
        public Decimal MRNotCovered{ set; get; }
        public Decimal MRDeductible{ set; get; }
        public Decimal MRCopay{ set; get; }
        public Decimal MRReimbursementReduction { set; get; }
        public Decimal MRCoinsurance{ set; get; }
        public Decimal MRTotalPatientResponsibility{ set; get; }
        
     //Claim Totals - UHC Provider Responsibility
        public Decimal PRNotCovered{ set; get; }
        public Decimal PROverpaymentWithheld{ set; get; }
        public String  PRTotalProviderWriteOff{ set; get; }
        public Decimal PRReimbursementReduction { set; get; }
    
    //Claim Details - In/Out Patient Information
        public Date SurgeryDate{ set; get; }
        public Date DischargeDate{ set; get; }
        public Decimal SemiPrivateRoom{ set; get; }
        public String DRGNumber{ set; get; }
        public String DRGGrouper{ set; get; }
    
    //Claim Details - Medical Payment Details
    
        public String SeriesDesignator{ set; get; }
        public String CheckEpayment{ set; get; }
        public String CheckStatus{ set; get; }
        public String PaymentType{ set; get; }
        public Date ProcessedDate{ set; get; }
        public Date IssuedDate{ set; get; }
        public Date CashedDate{ set; get; }
        public Date VoidStopDate{ set; get; }
        public Date ReturnedDate{ set; get; }
        public Date RemailedDate{ set; get; }
        public Decimal TotalCheckAmount{ set; get; }
        
        //Claim Details - Payee Information
        
        public String PayeeName{ set; get; }
        public ACETGetMedicalClaimsJSON2Apex.PayeeAddress PayeeAddress{ set; get; }
        public String PTIIndicator{ set; get; }
    
        //Claim Details - Consumer Account Payment Details
        
        public Date HRAProcessedDate{ set; get; }
        public Date FSAProcessedDate{ set; get; }
        public Decimal HRAPayment{ set; get; }
        public Decimal FSAPayment{ set; get; } 
        

        
    // Service Lines
    public List<ServiceLines> lstwrpServiceLines{get;set;}
    
    //Claim Diagnosis
    
     public List<ClaimDiagnosis> lstwrpClaimDiagnosis{get;set;}
     
     //RemarkCodes
     
     public List<RemarkCodes> lstwrpRemarkCodes{get;set;}
     
    
public class ServiceLines
    {
        public String BenefitLevel { set; get; }
        public String  PlaceofService{ set; get; }
        public String  Procedure{ set; get; }
        public String  Modifier{ set; get; }
        public String  RemarkCode{ set; get; }
        public String  DxPointer{ set; get; }
        public String  Units{ set; get; }
        public Date StartDate{ set; get; }
        public Date  EndDate{ set; get; }
        public String  strOverride { set; get; }
        public Decimal Charged{ set; get; }
        public Decimal Allowed{ set; get; }
        public Decimal NotCovered{ set; get; }
        public Decimal Deductible{ set; get; }
        public Decimal Paid{ set; get; }
        public String  Percent{ set; get; }
        public String  Authorization{ set; get; }

    }
 public class ClaimDiagnosis
{
     public String  DiagnosisCode{ set; get; }
    public String  DiagnosisDescription{ set; get; }
    public String  POA{ set; get; }
   
}
 public class RemarkCodes
    {
            public String Procedure { set; get; }
            public String RemarkCode { set; get; }
            public String RemarkCodeDesc { set; get; }
    }

}