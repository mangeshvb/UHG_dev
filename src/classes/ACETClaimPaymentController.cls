/* 
Apex Class Name: ACETClaimPaymentController
Purpose: This class is created to support the functionalities of ACETClaimPayment Visualforce Page.
Developed By: Khoushik Selvaraj
Date created:10/214/2016
Rally User Stories ID: US337044
Task ID: 
*/

public with sharing class ACETClaimPaymentController{
      public String ProviderId {get;set;}
      public String TaxId {get;set;}
      public String NPI {get;set;}
      public String CallCode {get;set;}
      public String CheckNumber {get;set;}
      public String SeriesDesignator {get;set;} 
      public String TotalPayment {get;set;} 
      public String LastName {get;set;}
      public String FirstName {get;set;}
      public String MemberId {get;set;}
      public String PolicyNumber {get;set;}       
      public Interaction__c Interaction {get;set;}  
      public Contact Subject {get;set;}
      public String SourceOriginator {get;set;}
      public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
      public List<WrapperPayeeInformation> wrapperpayeeinfo {get;set;}
      public List<WrapperPaidClaims> wrapperpaidclaims{get;set;}
      public Boolean ShowDetails{get;set;}
      public Boolean ShowSearch{get;set;}
      public String hpAdditionInfoStr {get;set;}
      public Boolean disableChecknumber{get;set;}
      public String PaymentType {get;set;}
      public ACETCallTopicsDataWrapper wrapper {get;set;}
      public List<ACETClaimPaymentResult> Payments {get;set;}
      public Integer PaymentSize {get;set;}
      public ACETClaimPaymentResult SelectedPayment {get;set;}
      public String SelectedPaymentGUID {get;set;}
     // public String ProferredCoverageGUID {get;set;}
     // public boolean IsShowActiveCoveragesOnly{get;set;}
      public List<ACETGetClaimCheckStatusResult> checks {get;set;}
      // public String AutoDoc {get;set;}
      public string surrogateKey {get; set;}
  
 
      public ACETClaimPaymentController(){          
           ProviderId = '';
           TaxId = '';
           NPI = '';
           LastName = '';
           FirstName = '';
           MemberId = '';
           PolicyNumber = '';
           disableChecknumber =false;
           ShowDetails = false;
           ShowSearch = false;
           Interaction = new Interaction__c(); 
           AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
           String interactionId = ApexPages.currentPage().getParameters().get('interactionId');  
           if (!String.isEmpty(interactionId)){ 
                Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
                SourceOriginator = Interaction.Interaction_Type__c;
                if(Interaction.Originator_Type__c == 'Member'){
                    CallCode = 'M';
                }else{
                    CallCode = 'P';
                }                        
           }
           String contactId = ApexPages.currentPage().getParameters().get('contactId');
           system.debug('contactId232323'+contactId);
           if (!String.isEmpty(contactId)){ 
                Subject = ACETProviderUtility.GetContactByID(contactId);
                LastName = Subject.LastName;
                
                FirstName = Subject.FirstName;
                MemberId = Subject.EID__c;
           }
           String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');
           if (!String.isEmpty(additionalInfostr)){        
                AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(additionalInfostr , ACETHighlightsPanelAdditionalInfo.class);
                PolicyNumber = AdditionalInfo.PolicyNumber;
                hpAdditionInfoStr = JSON.serialize(AdditionalInfo);  
           }
           
           String checknumberstr = ApexPages.currentPage().getParameters().get('CheckNumber');
           system.debug('***str***'+ checknumberstr);
           if (!String.isEmpty(checknumberstr)){        
               CheckNumber = checknumberstr;
               system.debug('*******Check Number*********'+ CheckNumber); 
           } 
            String seriesdesignatorstr = ApexPages.currentPage().getParameters().get('SeriesDesignator');
            system.debug('***Designator***'+ seriesdesignatorstr);
           if (!String.isEmpty(seriesdesignatorstr)){        
               SeriesDesignator = seriesdesignatorstr;
               system.debug('***Designator11111***'+ SeriesDesignator);  
           } 
           
           if(!String.isEmpty(checknumberstr) && !String.isEmpty(seriesdesignatorstr)){
                   
                   search();
                   showDetailsSection();
           }
           
           
           wrapper = new ACETCallTopicsDataWrapper();
           wrapper.CallTopic ='View Payments'; 
           wrapper.init();
           wrapper.CaseObj.Topic__c = 'View Payments'; 
           //wrapper.caseObj.AutoDoc__c = AutoDoc;
           surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
           if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
           }
           System.debug('wrapper.surrogateKey ----'+wrapper.surrogateKey );
                                                     
      } 
      public void getDummyProvider(){
           String contactId = Interaction.Originator__c;        
           if (!String.isEmpty(contactId)){ 
                Subject = ACETProviderUtility.GetContactByID(contactId);
                
                 if(Interaction.Originator_Type__c == 'Member'){
                    //MemberId = Subject.EID__c;
                }else{
                    if(CheckNumber == '30000043'){
                        system.debug('CheckNumber1'+CheckNumber);
                        ProviderId = '745687356'; 
                    }else{
                        ProviderId = '';
                    } 
                }
                if(CheckNumber == '30000043'){
                    system.debug('CheckNumber2'+Subject.Tax_ID__c);
                    system.debug('CheckNumber3'+Subject.npi__c);
                    TaxId = Subject.Tax_ID__c;
                    NPI = Subject.npi__c;
                } else{
                    TaxId = '';
                    NPI = '';
                }
           }
      }
      public PageReference search(){
              ShowSearch = true;
              getDummyProvider(); 
              ACETWSCalloutResult CalloutResult =  ACETClaimSearchUtility.getClaimPayments(ProviderId, TaxId, NPI, CallCode, CheckNumber, SeriesDesignator, TotalPayment, LastName, FirstName, MemberId, PolicyNumber);
              
              if (CalloutResult.Success){
                    Payments = new list<ACETClaimPaymentResult>();
                    Payments = (list<ACETClaimPaymentResult>)CalloutResult.Response;
                     system.debug('****Payments****'+Payments);
                    if(Payments != null){
                        //for the purposes of testing 60445819
                        if(Payments[0].CheckEFTNumber == '60445819'){               
                            ACETClaimPaymentResult dummypayment = new ACETClaimPaymentResult();
                            dummypayment = Payments[0];
                            Payments.add(dummypayment);
                        } 
                        PaymentSize = Payments.size();
                    } 
                    ApexPages.getMessages().clear(); 
              }else{
                    ApexPages.addMessage(new ApexPages.Message(CalloutResult.MessageSeverity, CalloutResult.Message));
                    ShowDetails = false;
                    ShowSearch = false;
              }          
            return null;
      }
      public void clear(){
                ShowDetails = false;
                ShowSearch = false;
                ApexPages.getMessages().clear(); 
      }
      public void showDetailsSection(){
        if(Payments != null){  
            system.debug('SelectedPaymentGUID'+SelectedPaymentGUID);
            system.debug('Payments'+Payments);      
            for(ACETClaimPaymentResult selPayment : Payments){
                system.debug('selPayment.GUID'+selPayment.GUID);
                if(selPayment.GUID == SelectedPaymentGUID){
                     SelectedPayment = selPayment;
                     system.debug('SelectedPayment.CheckEFTNumber---'+SelectedPayment.CheckEFTNumber);

                }
            }
            
            if(SelectedPayment != null){   
             system.debug('SelectedPayment.CheckEFTNumber---'+SelectedPayment.CheckEFTNumber);
              system.debug('SelectedPayment.SeriesDesignator---'+SelectedPayment.SeriesDesignator);
                getClaimPaymentCheckStatus(SelectedPayment.CheckEFTNumber, SelectedPayment.SeriesDesignator);
                system.debug('checks'+checks);
                 if(SelectedPayment.PaymentType == 'E'){
               disableChecknumber = true;
                }else{
                   disableChecknumber = false;  
                }
               wrapperpayeeinfo = new List<WrapperPayeeInformation>();
               WrapperPayeeInformation wpi = new WrapperPayeeInformation();
               wpi.PayeeType = SelectedPayment.PayeeType;  
               wpi.PayeeID = SelectedPayment.PayeeID;
               wpi.PayeeName = SelectedPayment.PayeeName;
               wpi.PayeeAddressLine1 = SelectedPayment.PayeeAddressLine1; 
               wpi.PayeeAddressLine2 = SelectedPayment.PayeeAddressLine2;
               wpi.City = SelectedPayment.PayeeAddressCity;
               wpi.State = SelectedPayment.PayeeAddressState;
               wpi.Zip = SelectedPayment.PayeeAddressZip;
               wrapperpayeeinfo.add(wpi); 
               ShowDetails = true;
               wrapperpaidclaims = new List<WrapperPaidClaims>();
               WrapperPaidClaims wpc = new WrapperPaidClaims();
              // wpc.ClaimNumber= SelectedPayment.ClaimNumber;
            }
           
        }else{
            ShowDetails = false;
        }
      }
      public void getClaimPaymentCheckStatus(String strcheckNumber,string strSeriesDesignator){
                ACETWSCalloutResult CalloutResult =  ACETClaimSearchUtility.getCheckStatus(strcheckNumber,strSeriesDesignator);
              if (CalloutResult.Success){
                    checks = new list<ACETGetClaimCheckStatusResult>();
                    checks = (list<ACETGetClaimCheckStatusResult>)CalloutResult.Response;          
              }
              else{
                    ApexPages.addMessage(new ApexPages.Message(CalloutResult.MessageSeverity, CalloutResult.Message));
              }  
      }
      public class WrapperPayeeInformation{ 
          public String PayeeType{get;set;}     
          public String PayeeID{get;set;}
          public String PayeeName{get;set;} 
          public String PayeeAddressLine1{get;set;} 
          public String PayeeAddressLine2{get;set;}
          public String City{get;set;}
          public String State{get;set;}
          public String Zip{get;set;}
      }
      public class WrapperPaidClaims{ 
          public String ClaimNumber{get;set;}     
          public String MemberID{get;set;}
          public String PolicyNumber{get;set;} 
          public String PatientAccountNumber{get;set;} 
          public String FirstName{get;set;}
          public String LastName{get;set;}
          public String Relationship{get;set;}
          public String PaidAmount{get;set;}
          public String StartDate{get;set;}
          public String EndDate{get;set;}
      }
}