public class ACETMemberExceptionWrapper
 {
   public String selectedrequestor{get;set;}
  public String phone{get;set;}
  public String selectedExceptionType{get;set;}
  public String selectedRootCauseException{get;set;}
  public String selectedServiceTerm{get;set;}
  public String selectedBatchCode{get;set;}
  public String broekrId{get;set;}
  public String broekrName{get;set;}
  public String accManager{get;set;}
  public String salesRep{get;set;}
  public String Comments{get;set;}
  public list<ACETMemberLevelExceptionFormController.memberDetailWrap> memberDetailList{get;set;}
    
    public ACETMemberExceptionWrapper(String selectedrequestor,String phone,String selectedExceptionType,String selectedRootCauseException,String selectedServiceTerm,String selectedBatchCode,String broekrId,String broekrName,String accManager,String salesRep,String Comments,list<ACETMemberLevelExceptionFormController.memberDetailWrap> memberDetailList)
    {
       this.selectedrequestor = selectedrequestor;
       this.phone = phone;
       this.selectedExceptionType = selectedExceptionType;
       this.selectedRootCauseException = selectedRootCauseException;
       this.selectedServiceTerm= selectedServiceTerm;
       this.selectedBatchCode = selectedBatchCode;
       this.broekrId = broekrId;
       this.broekrName = broekrName;
       this.accManager = accManager;
       this.salesRep = salesRep;
       this.Comments = Comments;
       this.memberDetailList = memberDetailList;       
    }
    
    
 }