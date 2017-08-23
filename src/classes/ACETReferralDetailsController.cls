public with sharing class ACETReferralDetailsController {
    
    public String notes{get;set;}
    public Interaction__c Interaction {get;set;}
    public Contact subject{get;set;}
    public String SourceOriginator {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String referralID{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public List<ACETReferralSearchResult> refsearchvalues{get;set;}
    public ACETReferralSearchResult wrapperresults1 {get;set;}	
	public  ACETReferralDetailsController(){
       referralID= ApexPages.currentPage().getParameters().get('id');
       Interaction = new Interaction__c();
       String response = ApexPages.currentPage().getParameters().get('wrapperresultsStr');
       system.debug('response-->'+response);
       wrapperresults1 = (ACETReferralSearchResult)JSON.deserialize(response,ACETReferralSearchResult.class); //06-Dec
       
       AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
       String interactionId = ApexPages.currentPage().getParameters().get('interactionId');    
       if (!String.isEmpty(interactionId)){                        
          Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
          SourceOriginator = Interaction.Interaction_Type__c;
       }
       String contactId = ApexPages.currentPage().getParameters().get('contactId');
       if (!String.isEmpty(contactId)){ 
            subject = ACETProviderUtility.GetContactByID(contactId);
       }
       String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');
       if (!String.isEmpty(additionalInfostr)){        
            AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(additionalInfostr , ACETHighlightsPanelAdditionalInfo.class);
       }
       wrapper = new ACETCallTopicsDataWrapper();
       wrapper.init();
       wrapper.CaseObj.Topic__c = 'View PCP Referrals';
    }
}