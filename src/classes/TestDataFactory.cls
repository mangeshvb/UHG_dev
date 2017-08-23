@isTest
public class TestDataFactory{
    //Test Data//
    public static Contact createContact(){
        Contact con = new Contact();
        con.FirstName = 'TestFname';
        con.lastname = 'TestLName';
        con.Tax_ID__c = '123456';
        con.NPI__c = '123457';
        //con.EID__c = ''+randomWithLimit(4000);
        insert con;
        
        return con;
    }
    public static Contact createContactwithEID(){
        Contact con = new Contact();
        con.FirstName = 'Test Fname';
        con.lastname = 'Test LName';
        con.Tax_ID__c = '123456';
        con.NPI__c = '123457';
        con.EID__c = ''+randomWithLimit(4000);
        insert con;
        
        return con;
    }
    public static Interaction__c createInteraction () {
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"Support","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Interaction__c inte = new Interaction__c();
        inte.Contact_Name__c = 'Text Iname';
        inte.Originator__c = createContact().id;
        inte.Originator_Type__c = 'Member';
        inte.Highlight_Panel_GroupInfo__c = JSONStr;
        insert inte;
        
        return inte;
    }
    public static string createACETHighlightsPanelAdditionalInfo(){
        ACETHighlightsPanelAdditionalInfo jsonReq = new ACETHighlightsPanelAdditionalInfo();
        jsonReq.Relationship='Test';   
        jsonReq.SitusState='Test';
        jsonReq.DOB='09/28/2016';
        jsonReq.EndDate='09/28/2016';
        jsonReq.EffectiveDate='09/28/2016';
        jsonReq.PolicyNumber='12345';
        jsonReq.GroupName='Test';
        jsonReq.Product='Test';
        jsonReq.ProductType='Test';
        jsonReq.Network='Test';
        jsonReq.ConsumerAccountIndicator='Test';
        
        String additionalInfoStr  = JSON.serialize(jsonReq);
        return additionalInfoStr;
    }
     public static ISL_Webservice_Config__c CreateISLWebserviceCS(String name,String value) {
        ISL_Webservice_Config__c cs = new ISL_Webservice_Config__c();
        cs.name = name;
        cs.value__c = value;
        return cs;
    }
    public static User getUser(String profile){
        Profile p = [SELECT Id FROM Profile WHERE Name=:profile]; 
      User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName= profile.deleteWhitespace()+'@testorg.com');
      
      return u;     
    }
    
    public static Integer randomWithLimit(Integer upperLimit){
        Integer rand = Math.round(Math.random()*1000);
        return Math.mod(rand, upperLimit);
    }
  public static List<Case> createCases(Integer numCase) {
        List<Case> caseList = new List<Case>();
        for(Integer iCnt =0; icnt<numCase; iCnt++){
            Case cas = new Case();
            caseList.add(cas);
        }

        return caseList;
    }
    
     public static Case createCase(){
        Case cas = new Case();
        cas.Status = 'Open';
        insert cas;
        return cas;
    }
    
}