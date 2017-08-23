public with sharing class ACETCobController {

   public List<wrapperCommercial> commercial{get;set;}
   public List<wrapperMedicare> medicare{get;set;}
   public String response{get;set;}
   public List<ACETMemberDetail.COB> cobList{get;set;}
   public List<ACETMemberDetail.COB> commercialcobList{get;set;}
   public List<ACETMemberDetail.COB> governmentcobList{get;set;}
   public ACETMemberDetail MemberDetail{get;set;}
   public Interaction__c Interaction {get;set;}
   public Contact Subject {get;set;}
   public String SourceOriginator {get;set;}
   public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
   public Boolean isClaim {get;set;}
   public boolean isCancelCaseCreation{get;set;}
   public ACETCallTopicsDataWrapper wrapper {get;set;}
   //public ACETCaseItemWrapper caseItem{get;set;}
   public string surrogateKey {get; set;}
   public boolean showUpdateSection{get;set;}
   
    //Commercial section info
    public boolean isCommercialActive{get;set;}
    public string selectCommericial{get;set;}
    public case caseEffectiveDate{get;set;}
    public case caseEndDate{get;set;}
    public string custodialSelect{get;set;}
    public void updateCommercial(){
        showUpdateSection = True;
    }
 public void childconsolefunction(){
        
        response = ApexPages.currentPage().getParameters().get('param1');
        system.debug('2323response'+response);
     if(response != null && response != '')
     {
       system.debug('2323response'+response );
       MemberDetail=(ACETMemberDetail)json.deserialize(response,ACETMemberDetail.class);
       system.debug('2323MemberDetail'+MemberDetail);
       cobList = MemberDetail.lstCOB;
       commercialcobList =  new List<ACETMemberDetail.COB>();
       governmentcobList =  new List<ACETMemberDetail.COB>();
       for(ACETMemberDetail.COB cobItem : cobList){
       	if(cobItem.CoverageTypeCode == '1' || cobItem.CoverageTypeCode == '3' || cobItem.CoverageTypeCode == '4' || cobItem.CoverageTypeCode == '5'){
       		commercialcobList.add(cobItem);
       	}else if(cobItem.CoverageTypeCode == '2'){
       		governmentcobList.add(cobItem);
       	}
       }
       system.debug('cobList '+ JSON.serialize(cobList) );
    }
       }
 public void renderCancelCaseSection(){
        isCancelCaseCreation=true;  
    }

public ACETCobController(){
        caseEffectiveDate = new Case();
        caseEndDate = new Case();
        showUpdateSection = False;
        
      /*  commercial= new list<wrapperCommercial>();
        wrapperCommercial com1= new wrapperCommercial();
        com1.comName='John Martin';
        com1.comRelationship='Subscriber';
        com1.comMemberOtherInsurance='Yes';
        com1.comInsuranceType='Yes';
        com1.comPrimary='Yes';
        com1.comComemricalEffectiveEnd='02/02/2019';
        com1.comCustodialParent='Both';
        com1.comLastDate='01/02/2019';
        
        commercial.add(com1);*/
        /*
        wrapperCommercial com2= new wrapperCommercial();
        com2.comRelationship='Spouse';
        com2.comMemberOtherInsurance='';
        com2.comInsuranceType='';
        com2.comPrimary='Yes';
        com2.comComemricalEffectiveEnd='';
        com2.comCustodialParent='Former Spouse';
        com2.comLastDate='';
        
        commercial.add(com2);
       */
       
        
      /*  medicare= new list<wrapperMedicare>();
        
        wrapperMedicare md1= new wrapperMedicare();
        md1.Name='John Martin';
        md1.Relationship='Subscriber';
        md1.MedicareType='A=Medicare A Only';
        md1.EstimationApplies='Yes';
        
        medicare.add(md1);*/
        
         wrapper = new ACETCallTopicsDataWrapper();
         wrapper.CallTopic ='Coordination Of Benefits';
         wrapper.init(); 
         wrapper.CaseObj.Topic__c = 'Coordination Of Benefits';    
         AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        /*String providerId = ApexPages.currentPage().getParameters().get('id');
        if(!String.isEmpty(providerId)){
            Provider = [select FirstName, LastName, Tax_ID__c, NPI__c from Contact where Id = :providerId];
        }
        */
        //Get Provider Interaction SFDC Id
       String interactionId = ApexPages.currentPage().getParameters().get('interactionId');    
        //Check if User is redirected to Member Search page from Provider detail page         
        if (!String.isEmpty(interactionId)){                        
            system.debug('InteractionId: ' + InteractionId);            
            //Query Provider Interaction details
            Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            SourceOriginator = Interaction.Interaction_Type__c;
            system.debug('Interaction: ' + Interaction + ', SourceOriginator: ' + SourceOriginator);
        }
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        if (!String.isEmpty(contactId)){ 
            subject = ACETProviderUtility.GetContactByID(contactId);
        }
        String stradditionalInfo= ApexPages.currentPage().getParameters().get('additionalInfo');
        if (!String.isEmpty(contactId)){ 
        AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(stradditionalInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        } 
 }
 public void rerenderPB(){
 }
 public PageReference Save(){
        wrapper.caseObj.Topic__c ='Coordination Of Benefits';
        wrapper.createCase();            
        PageReference caseDetailsReference = new PageReference('/' + wrapper.CaseObj.Id);
        return caseDetailsReference;
    }
 public PageReference SaveAndClose(){
        wrapper.caseObj.Topic__c ='Coordination Of Benefits';
        wrapper.caseObj.Status='Closed';
        //wrapper.caseObj.AutoDoc__c = AutoDoc;
        wrapper.createCase();            
        PageReference caseDetailsReference = new PageReference('/apex/ACETCallTopicSaveAndClose?caseId=' + wrapper.CaseObj.Id);
        system.debug('wrapper.CaseObj.Id  >>>  '+wrapper.CaseObj.Id);
        return caseDetailsReference;
    } 
@TestVisible    
private class wrapperCommercial{
        public String comName{get;set;}
        public String comRelationship{get;set;}
        public String comDob{get;set;}
        public String comAge{get;set;}
        public String comMemberOtherInsurance{get;set;}
        public String comInsuranceType{get;set;}
        public String comPrimary{get;set;}
        public String comComemricalEffectivestart{get;set;}
        public String comComemricalEffectiveEnd{get;set;}
        public String comCustodialParent{get;set;}
        public String comLastDate{get;set;}
        public String comSource{get;set;}
        public String comComments{get;set;}
        public wrapperCommercial()
        {
        
        }
}
  @TestVisible
private class wrapperMedicare{

        public String Name{get;set;}
        public String Relationship{get;set;}
        public String MedicareType{get;set;}
        public String Dob{get;set;}
        public String Age{get;set;}
        public String MedicarePrimary{get;set;}
        public String CrossoverIndicator{get;set;}
        public String EntitleReason{get;set;}
        public String EstimationApplies{get;set;}
        public String EffectiveStartA{get;set;}
        public String EffectiveEndA{get;set;}
        public String EffectiveStartB{get;set;}
        public String EffectiveEndB{get;set;}
        public String EffectiveStartD{get;set;}
        public String EffectiveEndD{get;set;}
        public String LastUpdate{get;set;}
        public String Source{get;set;}
        public String Comments{get;set;}

    public wrapperMedicare(){
    
    }
 }


}