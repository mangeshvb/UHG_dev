public with sharing class ACETReferralSearchController {
    
    public Case StartDate{get;set;}
    public Case EndDate{get;set;}
    public Interaction__c Interaction {get;set;}
    public string strReferralNumber{get;set;}
    public String ReferralType {get;set;}
    public string RefrStatus{get;set;}
    public Contact subject{get;set;}
    public String SourceOriginator {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    
    public string wrapperresultsStr{get;set;}
    public String hpAdditionInfoStr {get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public list<ACETReferralSearchResult> lstReferrals{get;set;}
    public List<ACETReferralSearchResult> referralsresult{get;set;}
    public map<String,ACETReferralSearchResult> referralselMap{get;set;}
    public Boolean IsfilterApply {get;set;}
    public String selectedRefNumber{get;set;}
    public string surrogateKey {get; set;} 
    
    public ACETReferralWebservice ACETRW ;
   
    public void init(){
    	IsfilterApply = false;
    	AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
    	String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');
    	String SRK = ApexPages.currentPage().getParameters().get('SRK');
        if (!String.isEmpty(additionalInfostr)){        
            AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(additionalInfostr , ACETHighlightsPanelAdditionalInfo.class);
        }
        ACETWSCalloutResult findReferralServiceCalloutResult = new ACETWSCalloutResult();
        ACETRW = new ACETReferralWebservice();
        //findReferralServiceCalloutResult = ACETRW.findReferrals('Jacqueline','Henry','1969-06-17','890504607');
        findReferralServiceCalloutResult = ACETRW.findReferrals(AdditionalInfo.FirstName,AdditionalInfo.LastName,AdditionalInfo.DOB,SRK);
        referralselMap = new Map<String,ACETReferralSearchResult>();
        lstReferrals = new list<ACETReferralSearchResult>();
        system.debug('findReferralServiceCalloutResult is '+findReferralServiceCalloutResult);
        if (findReferralServiceCalloutResult .Success != null && findReferralServiceCalloutResult .Success) {   
           lstReferrals = (list<ACETReferralSearchResult>)findReferralServiceCalloutResult .Response;
          if(lstReferrals != null){
               for(ACETReferralSearchResult ac : lstReferrals){
               referralselMap.put(ac.resultreferralExternalID, ac);    
             }
           } 
       }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.ACETUnexpectedErrorMessage));
        }
    }
    public ACETReferralSearchController(){
        
        IsfilterApply = false;
        StartDate = new Case();
        EndDate = new Case();
        Interaction = new Interaction__c();
        
        //Get Provider Interaction SFDC Id
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId'); 
          
        //Check if User is redirected to Member Search page from Provider detail page          
        if (!String.isEmpty(interactionId)){                        
            system.debug('InteractionId: ' + InteractionId);
            
        
            Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            SourceOriginator = Interaction.Interaction_Type__c;
            system.debug('Interaction: ' + Interaction + ', SourceOriginator: ' + SourceOriginator);
        }
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        if (!String.isEmpty(contactId)){ 
            subject = ACETProviderUtility.GetContactByID(contactId);
        }
       
        String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');
        if (!String.isEmpty(additionalInfostr)){        
            AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(additionalInfostr , ACETHighlightsPanelAdditionalInfo.class);
        }
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CallTopic ='View PCP Referrals';
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'View PCP Referrals';
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
         if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }
            
    }
    public void navigateTodetail(){
    	
        selectedRefNumber = ApexPages.currentPage().getParameters().get('ReferalNumber');
        wrapperresultsStr = json.serialize(referralselMap.get(selectedRefNumber));
        system.debug('inside the method'+selectedRefNumber+'-----'+wrapperresultsStr);    
        
    }
     public void applyfilter(){
        system.debug('lstReferrals is '+lstReferrals);
        referralsresult = new list<ACETReferralSearchResult>();
        IsfilterApply = false;
        system.debug('default values-->'+strReferralNumber + '***' +ReferralType + '***' +RefrStatus + '***' +StartDate.tst_Date_Field__c + '***' +EndDate.tst_Date_Field__c);
        if(strReferralNumber == '' && ReferralType == null && RefrStatus == null && StartDate.tst_Date_Field__c == null && EndDate.tst_Date_Field__c == null ){
            IsfilterApply = false;
            return;
        }
        if(strReferralNumber != ''){
            IsfilterApply = true;
            for(ACETReferralSearchResult ac: lstReferrals){
                if(ac.resultreferralExternalID == strReferralNumber){
                    referralsresult.add(ac);
                    break;
                }
            }
        }
        else{
            IsfilterApply = true;
            boolean tempCheck = false;
            if(ReferralType != null){
               referralsresult =  filtrReferralList('ReferralType', ReferralType , lstReferrals);
               tempCheck = true;
            }
            if(RefrStatus != null){
                system.debug('Insert 1 block'+RefrStatus);
                if(tempCheck){
                    referralsresult =  filtrReferralList('RefrStatus', RefrStatus , referralsresult);
                }
                else{
                    referralsresult =  filtrReferralList('RefrStatus', RefrStatus , lstReferrals);
                }
                tempCheck = true;
            }
            if(StartDate.tst_Date_Field__c != null){
                if(tempCheck){
                    referralsresult =  filtrReferralList('StartDate.tst_Date_Field__c',ACETRW.formattedDate(ACETRW.ChangeDateFormat(String.valueof(StartDate.tst_Date_Field__c))), referralsresult);
                }
                else{
                    referralsresult =  filtrReferralList('StartDate.tst_Date_Field__c',ACETRW.formattedDate(ACETRW.ChangeDateFormat(String.valueof(StartDate.tst_Date_Field__c))), lstReferrals);
                    system.debug('test date'+startDate.tst_Date_Field__c.month());
                }
                tempCheck = true;
            }
            if(EndDate.tst_Date_Field__c != null){
                if(tempCheck){
                    referralsresult =  filtrReferralList('EndDate.tst_Date_Field__c', ACETRW.formattedDate(ACETRW.ChangeDateFormat(String.valueof(EndDate.tst_Date_Field__c))), referralsresult);
                }
                else{
                    referralsresult =  filtrReferralList('EndDate.tst_Date_Field__c', ACETRW.formattedDate(ACETRW.ChangeDateFormat(String.valueof(EndDate.tst_Date_Field__c))), lstReferrals);
                }
                tempCheck = true;
            }
        }
        if(referralsresult != null){
            referralselMap = new Map<String,ACETReferralSearchResult>();
            for(ACETReferralSearchResult ac :referralsresult){
                referralselMap.put(ac.resultreferralExternalID , ac);
            }
        }
        system.debug('referralselMap-->'+referralselMap+'referralsresult-->'+referralsresult);
 
     }
     
     private list<ACETReferralSearchResult> filtrReferralList(String fieldName ,String varRef , list<ACETReferralSearchResult> listselectedRef){
         
         list<ACETReferralSearchResult> tempList = new list<ACETReferralSearchResult>();
         if(fieldName == 'ReferralType'){
             for(ACETReferralSearchResult ac: listselectedRef){
                if(ac.resultReferaltype == varRef){
                    tempList.add(ac);
                    //break;
                }
            }
         } 
         if(fieldName == 'RefrStatus'){
             for(ACETReferralSearchResult ac: listselectedRef){
                if(ac.resultReferralStatus == varRef){
                    tempList.add(ac);
                    system.debug('tempList***'+tempList);
                    //break;
                }
            }
        }
        if(fieldName == 'StartDate.tst_Date_Field__c'){
        	system.debug('varRef***'+varRef);
        	for(ACETReferralSearchResult ac: listselectedRef){
        		system.debug('ac***'+ac.resultStartdate);
                if(ac.resultStartdate == varRef){
                    tempList .add(ac);
                    system.debug('tempList***'+tempList);
                   // break;
                }
            }
        }
        if(fieldName == 'EndDate.tst_Date_Field__c'){
            for(ACETReferralSearchResult ac: listselectedRef){
                if(ac.resultEnddate == varRef){
                    tempList .add(ac);
                    //break;
                }
            }
        }
        return tempList; 
    }
 
    public PageReference clearfilter(){
        startdate.tst_Date_Field__c = null;
        enddate.tst_Date_Field__c = null;
        strReferralNumber = null;
        ReferralType = null;
        RefrStatus = null;
        return null;
    }
 
    public list<SelectOption> getReferralTypeValues(){
        List<SelectOption> options = new List<SelectOption>();
        map<String,String> mapTempRef = new map<String,string>();
        for(ACETReferralSearchResult wrapRef : lstReferrals){
            mapTempRef.put(wrapRef.resultReferaltype ,wrapRef.resultReferaltype ); 
        }
        options.add(new SelectOption('','--None--'));
        if(mapTempRef.keySet() != null){
            for(String temp : mapTempRef.keySet()){
                options.add(new SelectOption(temp ,temp));    
            } 
        }
     
        return options; 
        return null;
    }
    

}