/**
 * @name         :  ACETThirdPartyContactsController
 * @description  :  Controller for ACETThirdPartyComponent. this component is responsible for fetching, updating and creating third parties.
 * @author       :  Bhanu Jain
 * @createddate  :  20/11/2016
 **/

public class  ACETThirdPartyContactsController {
    
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public List<Third_Party_Originator__c> TPOriginatorList {get;set;}
    public Third_Party_Originator__c TPOriginator {get;set;}
    public Contact TPOriginatortRelContact {get;set;}
    public String SubjectId{get;set;}
    public boolean showNoThirdPartyError {get;set;}
    public ACETHighlightsPanelAdditionalInfo additionalInfo {get;set;}
    public String additionalInfoStr {get;set;} 
    public String SourceOriginator{get;set;}
    public Interaction__c interaction {get;set;}
    public Map<String,Third_Party_Originator__c> MaptpoIDvstpo {get;set;}
    public String tpliststr {get;set;}
    public ACETThirdPartyContactsController (){
        showNoThirdPartyError = false;
        TPOriginatortRelContact = new Contact();
        TPOriginator = new Third_Party_Originator__c();
        TPOriginator.third_party__r = new Third_Party__c(); 
            
    }
/**
* @name         :   getThirdPartyList
* @description  :   This method/action function is responsible getting the third party list associated to current subject
* @param        :   void   
* @return       :   void
* @author       :   Bhanu Jain
* @createddate  :   20/11/2016
* @lastmodifiedby:  
**/     
    public void getThirdPartyList(){
        TPOriginatorList = [select id,Third_Party__r.First_Name__c,Third_Party__r.FullName__c,Third_Party__r.Phone_Number__c ,Third_Party__r.Name, Name, Third_Party__r.Group_Name__c, other_originator__c from Third_Party_Originator__c where Subject__c =:SubjectId ORDER BY Third_Party__r.Name ASC];
        
        if(TPOriginatorList.isEmpty()){
            showNoThirdPartyError =true;
            TPOriginator = new Third_Party_Originator__c();
            TPOriginator.Third_Party__r = new Third_Party__c();
        }else{
                    tpliststr = JSON.serialize(TPOriginatorList);
            showNoThirdPartyError = false;
        }        
        
    }
/**
* @name         :   updatehighlightPanelStr
* @description  :   This method/action function will be called from UI to variable to with selected third party. So that it can be used to display in highlisht panel.
* @param        :   void   
* @return       :   void
* @author       :   Bhanu Jain
* @createddate  :   20/11/2016
* @lastmodifiedby:  
**/    
    public void updatehighlightPanelStr(){
        //ACETHighlightsPanelAdditionalInfo hpInfo = (ACETHighlightsPanelAdditionalInfo )JSON.deserialize(highlightPanelStr,ACETHighlightsPanelAdditionalInfo.class);
        String selectedTPId = ApexPages.currentPage().getParameters().get('selectedRow');
        system.debug('row id >> '+TPOriginatorList);
        for(Third_Party_Originator__c tpo : TPOriginatorList){

            if(tpo.third_party__c == selectedTPId ){
                additionalInfo.OriginatorRelationship = tpo.Name;
                additionalInfo.RelationshipType = tpo.Name;
                
                SourceOriginator = tpo.third_party__r.First_Name__c;
                //update Interaction obj
                interaction.Third_Party__r= tpo.third_party__r;
                interaction.Third_Party__c= tpo.third_party__c;
                Interaction.Contact_Name__c = tpo.third_party__r.FullName__c;
                
            }
        }
        additionalInfoStr = JSON.serialize(additionalInfo);
        upsert interaction;
//        interaction = ACETMemberQueryUtil.queryInteraction(interaction.Id);
        system.debug('interaction after updateHighlightPanel'+interaction);
        //additionalInfo.OriginatorRelationship = 'testing';
        
    }
        /**
* @name         :   addNewThirdParty
* @description  :   This method/action function will create new  the third party record and its junction. Also will refresh the third party list which is displayed on UI.
* @param        :   void   
* @return       :   void
* @author       :   Bhanu Jain
* @createddate  :   20/11/2016
* @lastmodifiedby:  
**/
    public void addNewThirdParty(){
        //create new third party
        if(TPOriginatorList == Null)
        {
            TPOriginatorList = new List<Third_Party_Originator__c>();
        }
        system.debug('TPOriginator >> '+TPOriginator);
        Third_Party__c newThirdParty = new Third_Party__c();
         newThirdParty.first_name__c = TPOriginator.third_party__r.first_name__c;
        newThirdParty.name = TPOriginator.third_party__r.name;
        newThirdParty.Phone_Number__c  = TPOriginator.third_party__r.Phone_Number__c ;
        newThirdParty.Group_Name__c = TPOriginator.third_party__r.Group_Name__c;
        insert newThirdParty;
        
        
        
        TPOriginator= new Third_Party_Originator__c();
        TPOriginator.subject__c =SubjectId;
        TPOriginator.third_party__c = newThirdParty.Id;
        TPOriginator.third_party__r = newThirdParty;
        TPOriginator.name = TPOriginatortRelContact.other_originator__c;
        insert TPOriginator;
        
        showNoThirdPartyError =false;
        TPOriginatorList.add(TPOriginator);
        
        getThirdPartyList();
                
    }
/**
* @name         :   updateThirdParty
* @description  :   This method/action function will update the third party objectand its junction. Also will refresh the third party list which is displayed on UI.
* @param        :   void   
* @return       :   void
* @author       :   Bhanu Jain
* @createddate  :   20/11/2016
* @lastmodifiedby:  
**/    
    public void updateThirdParty(){
        system.debug('TPOriginator >> '+TPOriginator);
        TPOriginator.name= TPOriginatortRelContact.other_originator__c;
        Third_Party__c thirdPartyObj = TPOriginator.third_party__r;
        
        upsert TPOriginator.third_party__r;
        upsert TPOriginator;
           for(Third_Party_Originator__c tpo : TPOriginatorList){
        
                    if(tpo.third_party__c == TPOriginator.third_party__c){
                        tpo = TPOriginator;
                    }
                }
           getThirdPartyList();             
           tpliststr = JSON.serialize(TPOriginatorList);    
            
    }
/**
* @name         :   updateUI
* @description  :   This method/action function is responsible getting the third party list associated to current subject
* @param        :   void   
* @return       :   void
* @author       :   Bhanu Jain
* @createddate  :   20/11/2016
* @lastmodifiedby:  
**/    
    public void updateUI(){
    
    }
/**
* @name         :   updateInteraction
* @description  :   This method/action function will update current interaction with selected third party contact.
* @param        :   void   
* @return       :   void
* @author       :   Bhanu Jain
* @createddate  :   20/11/2016
* @lastmodifiedby:  
**/    
    public void updateInteraction(){
        upsert interaction;
    }
/**
* @name         :   populateEditPopup
* @description  :   This method/action function is responsible for setting selected third party object which will be populated in edit pop up.
* @param        :   void   
* @return       :   void
* @author       :   Bhanu Jain
* @createddate  :   20/11/2016
* @lastmodifiedby:  
**/    
    public void populateEditPopup(){
        String selectedTPId = ApexPages.currentPage().getParameters().get('selectedEditRow');
        system.debug(JSON.serialize(TPOriginatorList));
        system.debug(JSON.serialize(TPOriginatorList));
        for(Third_Party_Originator__c tpo : TPOriginatorList){
            if(tpo.third_party__c == selectedTPId ){
                TPOriginator = tpo;
                TPOriginator.third_party__r = tpo.third_party__r;                
                TPOriginator.third_party__c = tpo.third_party__c;                
                TPOriginatortRelContact.Other_Originator__c = tpo.name;
            }
        }

    }
}