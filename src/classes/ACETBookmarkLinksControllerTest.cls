@istest
private class ACETBookmarkLinksControllerTest{

static testMethod void testACETBookmarkLinksController (){

       User u = [select id,profile.name from user where profile.name = 'System Administrator' and isactive = true limit 1];
       PageReference pageRef = Page.ACETBookmarkLinks;
       Test.setCurrentPage(pageRef);
    
     
      
      List<Bookmark_Links__c > lstbookmark= new List<Bookmark_Links__c >();
        
        for(Integer i=0;i<5;i++) {
            Bookmark_Links__c a = new Bookmark_Links__c (Display_Name__c = 'test' + i,Profiles__c = 'System Administrator',URL__c = 'www.test.com',Active__c=true);
            lstbookmark.add(a);
        }
        insert lstbookmark;
      Test.startTest();
       System.runAs(u) {
       ACETBookmarkLinksController bookmark  = new ACETBookmarkLinksController();
       System.assertEquals(bookmark.lstBookmarkLinks.size(),lstbookmark.size());
       }
       Test.stopTest();
      
}

}