public with sharing class ACETUpdateMemberInfoController {
    
    public Contact Subject { get; set; }
    public Interaction__c Interaction { get; set; }    
    public Case dummycaseObj {get;set;}
    public String memberID { get; set; }
    public string comments{get;set;} 
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public string surrogateKey {get; set;}        
    //public List<ACETMemberSearchResult> Results{get;set;}
    public ACETMemberDetail MemberDetail {get;set;}
    public Integer phoneNumber{get; set;}
    public ACETMemberDetail MemberDetailRequest {get;set;}
    public List<PhoneWrapper> phoneWrprList{get;set;}
    public List<emailWrapper> emailWrpr{get;set;}
    
    public String scrId { get; set; }
    public String ssn { get; set; }
    public String groupId { get; set; }
    public String relationshipCode { get; set; }
    public String firstName { get; set; }
    public String LastName { get; set; }
    public String MiddleName { get; set; }
    public String nameSuffix { get; set; }
    public String gender { get; set; }
    public String dob { get; set; } 
    public List<ACETMemberDetail.Phone> phoneList   ;     
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    //public String ErrorMessage {get;set;}
    public Boolean isClickedUpdate {get;set;} 
    public Boolean updated {get;set;}
    public Boolean isSubscriber {get;set;}
    public boolean notResearchUser {get;set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}
    public boolean isSuccess{get;set;}
    public boolean isFailed{get;set;}
    public boolean isPhoneChecked{get;set;}
    public boolean isEmailChecked{get;set;}
    public string phones{get;set;}
    public string email{get;set;}
    public ACETUpdateMemberInfoController()
    {
        updated =  False;
        memberId = ApexPages.currentPage().getParameters().get('Id');
        phoneList = new List<ACETMemberDetail.Phone>();
        scrId = ApexPages.currentPage().getParameters().get('scrId');
        ssn = ApexPages.currentPage().getParameters().get('ssnId');
        groupId = ApexPages.currentPage().getParameters().get('grpno');
        relationshipCode  = ApexPages.currentPage().getParameters().get('rl');
        firstName = ApexPages.currentPage().getParameters().get('fn');
        LastName = ApexPages.currentPage().getParameters().get('ln');
        nameSuffix = '';
        MiddleName = '';
        gender = ApexPages.currentPage().getParameters().get('gn');
        dob = ApexPages.currentPage().getParameters().get('dob');
        //added by bhanu : It was giving null pointer at line 248 for Member flow : From where this is getting populated??
        isSubscriber = false;

        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = label.ACETCallTopicUpdateMemberDetail;
        wrapper.AutodocComment = comments;
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }
        //String additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        //wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(additionalInfoStr,ACETHighlightsPanelAdditionalInfo.class);        
        //AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();    
    }  
    
    public pagereference updateMember(){
        isClickedUpdate = true; 
        phoneList = new List<ACETMemberDetail.Phone>();
        system.debug('-----------phoneWrprList---->'+phoneWrprList);
        list<PhoneWrapper> pwList = new list<PhoneWrapper>();
        pwList.addAll(phoneWrprList);
 
        for(PhoneWrapper pw:phoneWrprList){
            ACETMemberDetail.Phone phnew = new ACETMemberDetail.Phone(); 
            if(pw.phone.PhoneNumberType == 'Home')
                phnew.PhoneNumberType = 'H';            
            if(pw.phone.PhoneNumberType == 'Work')
                phnew.PhoneNumberType = 'W';
            if(pw.phone.PhoneNumberType == 'Mobile')
                phnew.PhoneNumberType = 'M';
            if(pw.phone.PhoneNumberType == 'Fax')
                phnew.PhoneNumberType = 'F';
            if(pw.phone.primaryIndicator == 'Yes')
                phnew.primaryIndicator = 'true';
            if(pw.phone.primaryIndicator == 'No')
                phnew.primaryIndicator = 'false';
            
            phnew.phoneNumber = pw.phone.phoneNumber;
            //pw.phone.PrimaryIndicator = pw.PrimaryIndicator;
            phoneList.add(phnew);
        }

        system.debug('-----------phoneList---->'+phoneList);
        system.debug('-----------emailWrpr---->'+emailWrpr);
        ACETUpdateIndividualWebService updIndividual = new ACETUpdateIndividualWebService();
        
        //ACETWSCalloutResult callOutResult = updIndividual.updateMembers('98090568000','' ,'2268479', 'Smyth','Christine','', '','827228793','F','1964-10-14','18', '', '','', null,'','','','','');
        
        ACETWSCalloutResult callOutResult = updIndividual.updateMembers(memberID,scrId ,groupId, lastname,firstName,middleName, nameSuffix, ssn, gender, dob,relationshipCode, emailWrpr[0].emailTypeStr , emailWrpr[0].Email, 'EML' , phoneList,'','','','','');
        system.debug('-----------callOutResult---->'+callOutResult);
        /*       
        List<ACETMemberDetail.Phone> phoneList = new List<ACETMemberDetail.Phone>();
        for(PhoneWrapper pwObj: phoneWrprList){
            if(pwObj.selected){
                 phoneList.add(pwObj.phone);
                 isPhoneChecked = true;
                 
            }
        }
        if(!phoneList.isEmpty())
        {
            MemberDetailRequest.Phones = phoneList;            
        }
        
        system.debug('####MemberDetailRequestAfter'+MemberDetailRequest);
        */
        
        // Calling Webservice  twice to update Member Information and fetch the details  
        if(callOutResult.success == true)
        {
            isSuccess = true;
            isFailed = false;
            phoneWrprList  = pwList ;
            updated = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Details updated Successfully!'));

        }
        else
        {
            isSuccess = false;
            isFailed = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Details not updated'));


        }
        dummyCaseObj = new Case();
        
        return null;
           
    }
    
    //Service call to OIL to fetch enrolled member data
    //This function calls FindMemberservice to obtain EID / membership key and then GetMembership to retrieve demographics data
    public void memberData(){
        system.debug('####Inside getmemberdata ' );
        
        string interactionId = ApexPages.currentPage().getParameters().get('interactionId');
        string memberId = ApexPages.currentPage().getParameters().get('Id');
        phones = ApexPages.currentPage().getParameters().get('phn');
        
        email = ApexPages.currentPage().getParameters().get('email');
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        
        MemberDetail = new ACETMemberDetail();
        
        //MemberDetail = ACETGetMemberUtility.queryMemberDetail(memberId );
        
        //system.debug('@@@MemberDetail '+MemberDetail );
        
        system.debug('@@@email '+email );
        phoneWrprList = new List<PhoneWrapper>();
        phones = '{ "phone" :'+phones+'}';
        system.debug('@@@Phones '+phones );
        /*
        List<ACETMemberDetail.Phone> phoneInfo = (List<ACETMemberDetail.Phone>)JSON.deserialize(phones, List<ACETMemberDetail.Phone>.class);
        system.debug('@@@phoneInfo : '+ phoneInfo );
        if(Phones != null){
            for(ACETMemberDetail.Phone p : MemberDetail.Phones){
                if(p.phoneNumberType == 'Home'){
                    phoneWrprList.add(new PhoneWrapper(p));
                }
            }
        }
        */
        JSONParser parser = JSON.createParser(phones);
        
        ACETMemberDetail.Phone phoneRec = new ACETMemberDetail.Phone();
        while (parser.nextToken() != null) {
            
            system.debug('------------->'+parser +'<---------->'+ parser.getText());
            system.debug('------------->'+phoneWrprList+'------>'+phoneRec);
             
            boolean check ;
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'PrimaryIndicator')) {
                // Get the value.
                parser.nextToken();
                // Compute the grand total price for all invoices.
                //phoneRec.primaryIndicator = parser.getText();
                if(parser.getText() == 'Primary')
                    phoneRec.primaryIndicator = 'Yes';
                else
                    phoneRec.primaryIndicator = 'No';  
                              
            }
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'PhoneNumberType')) {
                // Get the value.
                parser.nextToken();
                // Compute the grand total price for all invoices.
                phoneRec.PhoneNumberType = parser.getText();                
            }
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'PhoneNumber')) {
                // Get the value.
                parser.nextToken();
                // Compute the grand total price for all invoices.
                phoneRec.PhoneNumber = parser.getText();  
                phoneWrprList.add(new PhoneWrapper(phoneRec,False,False));                
                phoneRec = new ACETMemberDetail.Phone();    
                             
            }          
        }
        Boolean check = False;
        for(PhoneWrapper pw : phoneWrprList){
            if(pw.phone.PhoneNumberType != '' && pw.phone.PhoneNumberType != null){                
                if(phoneWrprList.size()== 1 ){
                    pw.makeReadOnly = true;
                    
                    pw.makePrimaryIndiReadOnly = true;
                }else{
                    if(!Check){
                        pw.makeReadOnly = True;
                        pw.makePrimaryIndiReadOnly = False;
                        check = true ; 
                    }else{
                        pw.makeReadOnly = true ;
                        pw.makePrimaryIndiReadOnly = False;
                    }
                }
                pw.makeReadOnly = true;
            }
            
        }
                 
        email = email.replaceAll('"','');
        emailWrpr = new List<emailWrapper>();
        emailWrpr.add(new emailWrapper(email));
        
        system.debug('------------READY----->'+phoneWrprList);
        
        
    }
    public List<SelectOption> getPhoneNumberType(){
        List<SelectOption> phoneNumberType= new List<SelectOption>();
        phoneNumberType.add(new SelectOption('Fax','Fax')); 
        phoneNumberType.add(new SelectOption('Home','Home')); 
        phoneNumberType.add(new SelectOption('Mobile','Mobile'));              
        phoneNumberType.add(new SelectOption('Work','Work'));       
        return phoneNumberType;
    
    }    
    
    public List<SelectOption> getEmailType()
    {
        List<SelectOption> EmailType= new List<SelectOption>();
        EmailType.add(new SelectOption('true','Primary'));        
        return EmailType;
    
    }   
    
    public void addPhRow(){
         ACETMemberDetail.Phone obj = new ACETMemberDetail.Phone();
         PhoneWrapper pWrap = new PhoneWrapper(obj,False,False);
         for(PhoneWrapper pw :phoneWrprList){
             pw.makePrimaryIndiReadOnly = False;
         }
         phoneWrprList.add(pWrap);
     }
     
     public void addEmailRow(){
         String eml='';
         String emlTypStr='';
         emailWrapper eWrap = new emailWrapper(eml);
         emailWrpr.add(eWrap);
     }
     
      
     public class PhoneWrapper{
     
         public ACETMemberDetail.Phone Phone{get;set;}
         //public Boolean selected{get;set;}
         public Boolean makeReadOnly{get;set;}
         public Boolean makePrimaryIndiReadOnly{get;set;}
         public string PhoneNumberType{get;set;}
         //public string PrimaryIndicator{get;set;}
         public List<SelectOption> getPrimaryIndicator()
            {
                List<SelectOption> PrimaryIndicator = new List<SelectOption>();
                PrimaryIndicator.add(new SelectOption('No','No'));
                PrimaryIndicator.add(new SelectOption('Yes','Yes'));
                        
                return PrimaryIndicator;
            
            }
         
         public PhoneWrapper(ACETMemberDetail.Phone phonedetail,Boolean RdOnly,Boolean indi){
             Phone = phonedetail;
             makeReadOnly = RdOnly;
             //selected = False;
             PhoneNumberType = phonedetail.PhoneNumberType;
             //primaryIndicator = phonedetail.primaryIndicator;
             makePrimaryIndiReadOnly = indi;
         }
     
     }  
     public class emailWrapper{
         public string email{get;set;}
         public string emailTypeStr{get;set;}              
         public Boolean selected{get;set;}
         
         public emailWrapper(string eml){
             email= eml;
             emailTypeStr = 'true';
             selected = false;              
         }
     
     } 
}