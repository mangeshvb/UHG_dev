public with sharing class ACETBookmarkLinksController {
    
   
    public List<Bookmark_Links__c> lstBookmarkLinks{get;set;}
    
    
    
    public ACETBookmarkLinksController()
    {
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
            system.debug('ProfileName'+profileName);
            
            lstBookmarkLinks = [select name,Display_Name__c,Profiles__c,URL__c,Active__c from Bookmark_Links__c where Active__c = true and Profiles__c includes (:profileName) order by Display_Name__c];  
    } 
    
    
 }