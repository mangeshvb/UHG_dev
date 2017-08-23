public with sharing class ACETGroupPlanBenefitDetailController {
    public string policyNo {get; set;}
    public string serviceTeam {get; set;}
    public Boolean ageBandedBool {get; set;}
    public List<ACETGroupDetail.GroupPlanWrapper> GroupPlanSearchResults {get; set;}
    public List<ACETGroupPlanBenefitWrapper.BenefitWrapper> GroupPlanRiderResults {get; set;}
    public List<ACETGroupDetail.AgeBandWrap> ageBandBelow30List {get; set;}
    public List<ACETGroupDetail.AgeBandWrap> ageBandBelow20List {get; set;}
    public List<ACETGroupDetail.AgeBandWrap> ageBandBelow40List {get; set;}
    public List<ACETGroupDetail.AgeBandWrap> ageBandBelow50List {get; set;}
    public List<ACETGroupDetail.AgeBandWrap> ageBandBelow60List {get; set;}
    public ACETGroupDetail ACETGroupPlanBenefitDetail {get; set;}
    public ACETGroupDetail ACETGroupPlanDetail {get; set;}
    public ACETGroupPlanBenefitWrapper ACETGroupPlanBenefitRiderWrapper {get; set;}
    public List<ACETGroupPlanBenefitWrapper.BenefitWrapper> riderList {get; set;}
    public List<ACETGroupDetail.RiderWrapper> riderWrapperList {get; set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public boolean panelType{get; set;}
    public Interaction__c Interaction { get; set; } 
    public Contact Subject { get; set; }
    public String InteractionId {get; set;}
    public String contactId {get; set;}
    public String callTopic {get; set;}
    public string comments {get;set;}
    public String groupNumber {get; set;}
    public Boolean isFlag {get; set;}
    public List<ACETGroupPlanBenefitWrapper.coPayWrapper> coPayList {get; set;}
    public List<ACETGroupPlanBenefitWrapper.individualBenefitWrapper> individualFinalList {get; set;}
    public List<ACETGroupPlanBenefitWrapper.familyBenefitWrapper> familyFinalList {get; set;}
    
     public List<ACETGroupPlanBenefitWrapper.individualBenefitWrapper> individualList {get; set;}
    public List<ACETGroupPlanBenefitWrapper.familyBenefitWrapper> familyList {get; set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;} 
   
    public ACETGroupPlanBenefitDetailController () {
        individualFinalList = new List<ACETGroupPlanBenefitWrapper.individualBenefitWrapper>();
        familyFinalList = new List<ACETGroupPlanBenefitWrapper.familyBenefitWrapper>();    
        InteractionId = apexpages.currentpage().getparameters().get('interactionId');
        contactId = apexpages.currentpage().getparameters().get('contactId');
        callTopic = apexpages.currentpage().getparameters().get('callTopic');
        groupNumber = apexpages.currentpage().getparameters().get('groupId');
        System.debug('Griuo'+groupNumber);
        //getloggedinProfileName();
        isFlag = false;
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        System.debug('Entering'+Interaction);
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = callTopic;
        wrapper.AutodocComment = comments;
        initHighlightPanelAdditionalInfo();
        policyNo = ApexPages.currentPage().getParameters().get('policyNo');
        serviceTeam = ApexPages.currentPage().getParameters().get('serviceTeam1');
        
        if(serviceTeam != null) {
            System.debug('Entering New'+serviceTeam.containsAny('NJ'));
            if(serviceTeam.containsAny('NJ')) {
                ageBandedBool = true;
            }
            else if(serviceTeam.containsAny('CT')) {
                ageBandedBool = true;
            }
        }
       
    }
    public void init() {
        getGroupPlanDetailList('1');
    }
    public void benefitDetailsTabClick() {
        System.debug('Tab Click::::::::::::');
        getGroupPlanDetailList('2');
        isFlag = true;
    }
    public void getGroupPlanDetailList(String network) {
        //policyNo = label.ACETDummyBundleID;label.ACETDummyBenefitBundleOptionId
        
        ACETWSCalloutResult responseGroupPlanBenefitData;
        ACETWSCalloutResult responseRiderData;
        if(network == '1') {
            //individualList = new List<ACETGroupPlanBenefitWrapper.individualBenefitWrapper>();
            //FamilyList = new List<ACETGroupPlanBenefitWrapper.familyBenefitWrapper>();
            responseGroupPlanBenefitData = ACETGroupPlanBenefitController.callwebservice(groupNumber);
            responseRiderData = callRiderwebservice(label.ACETDummyBenefitBundleOptionId,network);//To-do Divya
        }
        else if(network == '2' && isFlag == false) {
            responseRiderData = callRiderwebservice(label.ACETDummyBenefitBundleOptionId,network);
        }
       
            //ACETWSCalloutResult responseRiderData = callRiderwebservice(policyNo);//added by harish to replace the hardcoded value on 6/2/2017 
        ACETGroupPlanBenefitDetail = new ACETGroupDetail();
        ACETGroupPlanDetail = new ACETGroupDetail();
        
        System.debug('Entering>>>>>>'+responseGroupPlanBenefitData+responseRiderData);

        if(responseGroupPlanBenefitData != null && responseGroupPlanBenefitData.Success) {
            GroupPlanSearchResults = new List<ACETGroupDetail.GroupPlanWrapper>();
            ACETGroupPlanBenefitDetail = (ACETGroupDetail)responseGroupPlanBenefitData.response;
            GroupPlanSearchResults = ACETGroupPlanBenefitDetail.GroupPlanBenefitList;
            System.debug('callout result for Groupdetails'+GroupPlanSearchResults);  
            if(GroupPlanSearchResults != null) {
                for(ACETGroupDetail.GroupPlanWrapper gpw:GroupPlanSearchResults) {
                    //ACETGroupDetail.GroupPlanWrapper groupPlanCustomerAcc = new ACETGroupDetail.GroupPlanWrapper();
                    System.debug('Entering>>>>>>'+policyNo);
                    if(gpw.bundleID == policyNo ) {
                        System.debug('Entering If Loop>>>'+gpw);
                        //Plan Summary Info
                        //ACETGroupPlanDetail.CSP = gpw.csp;
                        ACETGroupPlanDetail.policyNo= gpw.bundleID;
                        ACETGroupPlanDetail.planId= gpw.planId;
                        ACETGroupPlanDetail.Gated = gpw.Gated;
                        ACETGroupPlanDetail.Accumulator = gpw.Accumulator;
                        ACETGroupPlanDetail.PlanClass = gpw.PlanClass;
                        ACETGroupPlanDetail.Product = gpw.Product;
                        ACETGroupPlanDetail.Gated = gpw.Gated;
                        ACETGroupPlanDetail.PCPRequired = gpw.PCPRequired;
                        ACETGroupPlanDetail.PlanMettalicLevel = gpw.PlanMettalicLevel;
                        ACETGroupPlanDetail.Network = gpw.Network;
                        ACETGroupPlanDetail.Tier = gpw.Tier;
                        ACETGroupPlanDetail.effecDate= gpw.effecDate;
                        ACETGroupPlanDetail.endDate = gpw.endDate;
                        
                    }
                    ageBandBelow20List = new List<ACETGroupDetail.AgeBandWrap>();
                    ageBandBelow30List = new List<ACETGroupDetail.AgeBandWrap>();
                    ageBandBelow40List = new List<ACETGroupDetail.AgeBandWrap>();
                    ageBandBelow50List = new List<ACETGroupDetail.AgeBandWrap>();
                    ageBandBelow60List = new List<ACETGroupDetail.AgeBandWrap>();
                   
                    System.debug('Entering AgeBand......'+gpw.ageBandGroupPlanList);
                    if(gpw.ageBandGroupPlanList != null) {
                        for(ACETGroupDetail.AgeBandWrap ageBandgpw: gpw.ageBandGroupPlanList) {
                            
                            Integer ageBand = Integer.valueOf(ageBandgpw.AgeBand);
                            if(ageBand < 21) {
                                System.debug('<21++++++'+ageBand);
                                ACETGroupDetail.AgeBandWrap ageWrap  = new ACETGroupDetail.AgeBandWrap();
                                ageWrap.AgeBand = '<21';
                                ageWrap.Premium = ageBandgpw.premium;
                                if(ageBandBelow20List.isEmpty()) {
                                    ageBandBelow20List.add(ageWrap);
                                    //ageBandBelow20List.sort();
                                } 
                                //break;
                            }
                            
                            if(ageBand >= 21 && ageBand <= 30) {
                                ageBandBelow20List.add(ageBandgpw);
                                ageBandBelow20List.sort();
                            }
                            if(ageBand >= 31 && ageBand <= 40) {
                                ageBandBelow30List.add(ageBandgpw);
                                ageBandBelow30List.sort();
                            }
                            if(ageBand >= 41 && ageBand <= 50) {
                                ageBandBelow40List.add(ageBandgpw);
                                ageBandBelow40List.sort();
                            }
                            if(ageBand >= 51 && ageBand <= 60) {
                                ageBandBelow50List.add(ageBandgpw);
                                ageBandBelow50List.sort();
                            }
                            if(ageBand >= 61 && ageBand <= 63) {
                                ageBandBelow60List.add(ageBandgpw);
                                ageBandBelow60List.sort();
                            }
                            if(ageBand >= 64) {
                                ACETGroupDetail.AgeBandWrap ageWrap  = new ACETGroupDetail.AgeBandWrap();
                                ageWrap.AgeBand = '64+';
                                ageWrap.Premium = ageBandgpw.premium;
                                ageBandBelow60List.add(ageWrap);
                                ageBandBelow60List.sort();
                                break;
                            }
                        }
                    }
                }
            }
        }

        System.debug('Entering..........................1'+responseRiderData);
        
        if(responseRiderData != null && responseRiderData.success) {
            riderList = new List<ACETGroupPlanBenefitWrapper.BenefitWrapper>();
            
            GroupPlanRiderResults = new List<ACETGroupPlanBenefitWrapper.BenefitWrapper>();
            ACETGroupPlanBenefitRiderWrapper = (ACETGroupPlanBenefitWrapper)responseRiderData.response;
            System.debug('Entering..........................'+ACETGroupPlanBenefitRiderWrapper);
            riderList = ACETGroupPlanBenefitRiderWrapper.benefitWrapperList;
            System.debug('Entering..............................'+ACETGroupPlanBenefitRiderWrapper.individualBenefitWrapperList);
            individualFinalList.addAll(ACETGroupPlanBenefitRiderWrapper.individualBenefitWrapperList);
            //individualFinalList = individualList;
            familyFinalList.addAll(ACETGroupPlanBenefitRiderWrapper.familyBenefitWrapperList);
        }
    } 
    
    private void initHighlightPanelAdditionalInfo(){
        if(AdditionalInfo == null){
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        }        
        string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if(addInfo != null)
        {
            AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
        /******added by sourabh ****/
        if(Interaction != Null && Interaction.Highlight_Panel_GroupInfo__c != null)
        {
            ACETGroupDetailsWrapper deserializedExceptionData = (ACETGroupDetailsWrapper)JSON.deserialize(Interaction.Highlight_Panel_GroupInfo__c, ACETGroupDetailsWrapper.class);
            AdditionalInfo.UHCBS = deserializedExceptionData.UHCBS;    
            AdditionalInfo.GroupN = deserializedExceptionData.GroupName ;
            AdditionalInfo.GroupStatus = deserializedExceptionData.GroupStatus;
            AdditionalInfo.ServiceTeam = deserializedExceptionData.ServiceTeam;
            AdditionalInfo.EffectiveStartDate = deserializedExceptionData.EffectiveStartDate;
            AdditionalInfo.RiskManagement = deserializedExceptionData.RiskManagement;
            AdditionalInfo.RatingMethod = '';
            AdditionalInfo.RenewalDate= deserializedExceptionData.RenewalDate; 
            AdditionalInfo.RelationshipType = deserializedExceptionData.RelationshipType ;
            AdditionalInfo.groupSName = deserializedExceptionData.groupSName;    
        }  
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
    }
    

    public static ACETWSCalloutResult callRiderwebservice(string BundleID,string network)
    {
        ACETGetSubscriptionBenefitWebservice stubData = new ACETGetSubscriptionBenefitWebservice();
        ACETWSCalloutResult responseData = stubData.getSubscriptionBenefitSearch(BundleID,network);
        System.debug('Allowing.................'+responseData);
        return responseData;
    }
    
    public List<ACETGroupPlanBenefitWrapper.coPayWrapper> getcoPayListDummy() {
        List<ACETGroupPlanBenefitWrapper.coPayWrapper> coPayDummyList = new List<ACETGroupPlanBenefitWrapper.coPayWrapper>();
        ACETGroupPlanBenefitWrapper.coPayWrapper coPay = new ACETGroupPlanBenefitWrapper.coPayWrapper();
        coPay.Label = 'PCP';
        coPay.value = '$20';
        coPayDummyList.add(coPay);
        ACETGroupPlanBenefitWrapper.coPayWrapper coPay1 = new ACETGroupPlanBenefitWrapper.coPayWrapper();
        coPay1.Label = 'Specialist';
        coPay1.value = '$30';
        coPayDummyList.add(coPay1);
        ACETGroupPlanBenefitWrapper.coPayWrapper coPay2 = new ACETGroupPlanBenefitWrapper.coPayWrapper();
        coPay2.Label = 'ER';
        coPay2.value = '$300';
        coPayDummyList.add(coPay2);
        return coPayDummyList;
        
    }   
}