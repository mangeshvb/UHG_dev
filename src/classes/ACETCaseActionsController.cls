public with sharing class ACETCaseActionsController {
    public String InteractionId {get;set;}
    public String SurrogateKey {get;set;}
    public boolean noCasesFlag {get;set;}
    public boolean noCompleteCaseFlag {get;set;}
    public String RedirectToPage { get; set; }
    public String CallTopic { get; set; }
    public ACETCallTopicsDataWrapper callTopicDataWrapper{get; set;}
    public ACETCaseActionsController(){
        noCasesFlag  = true;
        noCompleteCaseFlag = true; 
    }
    public void wrapInteraction(){
        system.debug('callTopicDataWrapper in wrapInteraction :: '+callTopicDataWrapper);
        String SubjectId = ApexPages.currentPage().getParameters().get('subjectId');
        String SubjectTabsStr = ApexPages.currentPage().getParameters().get('subjectTabs');
        system.debug('SubjectId in wrapInteraction :: '+SubjectId);
        system.debug('SubjectTabs in wrapInteraction :: '+SubjectTabsStr);
        List<String> subjectTabArray;
        if(!String.isEmpty(SubjectTabsStr)){
            subjectTabArray = (List<String>)JSON.deserialize(SubjectTabsStr,List<String>.class);
        }
        
        system.debug('subjectArray in wrap interaction '+subjectTabArray);
        noCasesFlag  = true;
        noCompleteCaseFlag = true;
        Map<String, List<Case>> subjectVsCaseListMap =  new Map<String, List<Case>>();
        List<Case> providerCaseList = new List<Case>();
        
        List<Case> caseList = [select id,iscomplete__c,isclosed,contactId from case where interaction__c =:InteractionId];

        if(caseList.size() > 0){
            for(Case caseObj : caseList){
                if(caseObj.contactId == null){
                    //belongs to provider call topic
                    providerCaseList.add(caseObj);
                }
                if(! subjectVsCaseListMap.containsKey(caseObj.contactId)){
                    subjectVsCaseListMap.put(caseObj.contactId,new List<Case>());
                }
                subjectVsCaseListMap.get(caseObj.contactId).add(caseObj);
            }
        }

        if(!String.isEmpty(SubjectId)){
            //Member detail wrap button clicked
            List<Case> currentSubjectCaseList = subjectVsCaseListMap.get(SubjectId);
            wrap(currentSubjectCaseList);
            system.debug('Member detail wrap button clicked');

        }else{
            //provider detail wrap button clicked
            system.debug('provider detail wrap button clicked');
            //system.debug('total subject under the provider '+ (subjectVsCaseListMap.size()));
            //system.debug('subject under the provider are ::: '+subjectVsCaseListMap.keySet());
            if(subjectVsCaseListMap.size() == 0 && subjectTabArray == null){
                system.debug('No Subject tab is opened yet');
            }
            if(subjectVsCaseListMap.size() == 0 && subjectTabArray != null && subjectTabArray.size() > 0){
                system.debug('Subject tab is opened but no cases are created under any subject');
            }
            if(subjectVsCaseListMap.size() > 0 && subjectTabArray != null && subjectTabArray.size() > 0 && subjectTabArray.size() > subjectVsCaseListMap.size()) {
                system.debug('Subject tab is opened and for few subject cases are not created');
            }           
            if(subjectVsCaseListMap.size() > 0){
                //few subjects detail tab has been opened
                for(String subId : subjectVsCaseListMap.keySet()){
                    system.debug('checkking subject '+subId);
                    wrap(subjectVsCaseListMap.get(subId));
                    if(noCasesFlag || noCompleteCaseFlag){
                        system.debug('subId '+subId +' cannot be wrapped');
                        break;
                    }
                }
            }
            
            
            if(!noCasesFlag && !noCompleteCaseFlag){
                if(providerCaseList.size() == 0){
                    system.debug('No call topics opened for provider');
                }else{
                    system.debug('Few call topics opened for provider');
                }
                wrap(providerCaseList);
            }
        }

        system.debug('noCasesFlag :: '+noCasesFlag + '  || noCompleteCaseFlag :: '+noCompleteCaseFlag);
    }
    private void wrap(List<Case> caseList){
        if(caseList != null && caseList.size() > 0){
            noCasesFlag = false;
            for(Case caseObj : caseList){
                if(caseObj.isComplete__c){ 
                    noCompleteCaseFlag = false;
                }else{
                    noCompleteCaseFlag = true;
                    break;
                }
            }
        }       
    }
    public pageReference Cancel() {
        if(CallTopic  == 'Enroll Subscriber' || CallTopic  == 'Enroll Family Member' || CallTopic  == 'Reinstate Subscriber/Family Member' || CallTopic  =='Terminate Subscriber/Family Member')
        {
            callTopicDataWrapper.saveAndClose();
        }
        return new pageReference('/apex/' + RedirectToPage);
    }
    /*   public void closeWindowReseacrh(){
        List<Interaction__c> delInteraction = [Select Id from Interaction__c where Id =: InteractionId];
        delete delInteraction;
    }*/
    public Boolean getIsComponentVisible(){
        User logUser = [Select Profile.Name from User where ID =: UserInfo.getUserID()];
        if(logUser.profile.name.contains('Research User')){
            return false;
        }
        else{
            return true;
        }

    }
}