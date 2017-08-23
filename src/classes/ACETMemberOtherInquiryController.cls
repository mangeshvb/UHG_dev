public with sharing class ACETMemberOtherInquiryController {    
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public String Topic {get;set;}
    public string surrogateKey {get; set;}
    
    public boolean isCancelCaseCreation{get;set;}
    public ACETMemberOtherInquiryController() {
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'Member Other Inquiry';
        system.debug('construc >>> '+JSON.serialize(wrapper));
        
        initHighlightPanelAdditionalInfo();

       surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
         if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }        
    }
    
    public void init(){     
        //initInteractionAndSubject(); 
        //initHighlightPanelAdditionalInfo();  
    } 
    
    private void initInteractionAndSubject(){
       /* //init interaction
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');  
        wrapper.Interaction = ACETProviderUtility.GetInteractionByID(interactionId);                 
        
        //init subject
        String subjectId = Apexpages.currentPage().getParameters().get('contactId');
        wrapper.Subject = ACETProviderUtility.GetContactByID(subjectId); 
        
        //init originator        
        wrapper.Originator = ACETProviderUtility.GetContactByID(wrapper.Interaction.Originator__c);
        
        //setup source originator
        wrapper.SourceOriginator = ApexPages.currentPage().getParameters().get('sourceOriginator'); */
        
        //wrapper.init();                                                                           
    }
              
    //public PageReference save(){        
        /*wrapper.CaseObj.Interaction__c = wrapper.Interaction.Id;
        wrapper.caseObj.ContactId = wrapper.Subject.Id;
        wrapper.caseObj.Originator_Relationship__c = wrapper.AdditionalInfo.Relationship;
        
        if(wrapper.isSystemUnavailable){
            wrapper.CaseObj.Status = 'Closed';
            wrapper.CaseObj.New_Closed_Reason__c = 'System Unavailable';
        }        

        wrapper.CaseObj.Topic__c ='Member Other Inquiry';
        wrapper.CaseObj.origin = wrapper.SourceOriginator; 
        upsert wrapper.CaseObj;*/
        
        //system.debug(JSON.serialize(wrapper));
        //wrapper.CaseObj.Topic__c ='Member Other Inquiry';
        //wrapper.CaseObj.AutoDoc__c = AutoDoc;
        //wrapper.createCase();
        //PageReference caseDetailsReference = new PageReference('/' + wrapper.CaseObj.Id);
        //return caseDetailsReference;        
    //}
    
    //public PageReference SaveAndClose(){
        //wrapper.caseObj.Topic__c ='Member Other Inquiry';
        //wrapper.caseObj.Status='Closed';
        //wrapper.caseObj.AutoDoc__c = AutoDoc;
        //wrapper.createCase();            
        //PageReference caseDetailsReference = new PageReference('/apex/ACETCallTopicSaveAndClose?caseId=' + wrapper.CaseObj.Id);
        //system.debug('wrapper.CaseObj.Id  >>>  '+wrapper.CaseObj.Id);
        //return caseDetailsReference;
    //} 
    
       
    //public void renderCancelCaseSection(){
        //isCancelCaseCreation=true;  
    //}
    
    private void initHighlightPanelAdditionalInfo(){
        String additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(additionalInfoStr,ACETHighlightsPanelAdditionalInfo.class);            
    }
    
    public PageReference routeCase(){
        wrapper.caseObj.Topic__c ='Member Other Inquiry';
        wrapper.createCase();            
        PageReference caseDetailsReference = new PageReference('/' + wrapper.CaseObj.Id);
        return caseDetailsReference;
    }    
    /* public List<SelectOption> getTopics(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Password Reset','Password Reset'));
        options.add(new SelectOption('Self Service','Self Service'));
        options.add(new SelectOption('Other Member Inquiry','Other Member Inquiry'));
        return options;        
    }*/ 
   
}