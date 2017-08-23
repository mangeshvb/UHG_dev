public class ACETMemberQueryUtil {
    
    public static Interaction__c queryInteraction(String interactionId){        
       Interaction__c Interaction = new Interaction__c();
        if (InteractionId != null && InteractionId !='')
        {
        
        
        Interaction = [SELECT Id, Name, Interaction_Type__c, Originator_Type__c, Contact_Name__c, Caller_Type__c, Highlight_Panel_GroupInfo__c,Originator__c, Originator__r.EID__c, Originator__r.Tax_ID__c, Originator__r.NPI__c, 
            Originator__r.Name,Id__c, Originator__r.LastName, Originator__r.FirstName, Originator__r.AccountId,Originator__r.Account.Name,Originator__r.Birthdate,Originator__r.mailingState,Originator__r.mailingPostalCode,Originator__r.Phone, Third_Party__c, Third_Party__r.Tax_ID__c, Third_Party__r.NPI__c, 
            Third_Party__r.FullName__c, Third_Party__r.Name, Third_Party__r.First_Name__c, Third_Party__r.Phone_Number__c, Third_Party__r.Email__c
            FROM Interaction__c WHERE Id =:InteractionId];
}        
        return Interaction;

    }
    public static Interaction__c queryInteraction(String InteractionType, String OriginatorType,String EmployerName, String LastName, String FirstName, String PhoneNumber,Date dob,String State,String Zip,String GroupNum)
    {
        try{
        Account acc =  new Account();
        if(EmployerName != null && EmployerName != '' ){
            acc.Name = EmployerName;
            insert acc;
        }
        
        Contact con = new Contact();
        if(acc != null){
            con.accountId = acc.id;
        }
        con.FirstName = FirstName;
        con.LastName = LastName;
        con.Phone = PhoneNumber;
        con.Birthdate = dob;
        con.MailingState = state;
        con.MailingPostalCode = zip;
        insert con;
        
        system.debug('con->'+con);
                
        Interaction__c interaction = new Interaction__c();
        Interaction.Interaction_Type__c = InteractionType;
        Interaction.Originator_Type__c = OriginatorType;
        Interaction.Contact_Name__c = con.FirstName +' '+con.LastName; 
        Interaction.Originator__c = con.Id;
        Interaction.Id__c = GroupNum;
        Interaction.Member_Date_of_Birth__c = con.Birthdate;
        return interaction;
        }
        catch(exception e){
        return null;
        }
        
    }    
    public static Contact queryContact(String conId){
        return (Contact)ACETQueryUtil.query(conId, 'Contact');  
    }  
}