public with sharing class ACETCreateLetterController {
    
    public string templateTest{get;set;}
    public string deliveryType{get;set;}
    public string recipientfacilityName{get;set;}
    public string recipientFirstName{get;set;}
    public string recipientMiddleName{get;set;}
    public string recipientLastName{get;set;}
    public string recipientsuffix{get;set;}
    
    //public string recipientAddress1{get;set;}
    //public string recipientAddress2{get;set;}
    //public string recipientCity{get;set;}
    //public string recipientState{get;set;}
    //public string recipientZip{get;set;}
    public string strModifiedBy {get; set;}
    public string strSubmittedBy {get; set;}
    //public string strSubmittedDt {get; set;}
    
    public string deliverystatus1{get;set;}
    public string deliverystatus2{get;set;}
    public string CCstatus{get;set;}
    public string letterNumber{get;set;}
    //public string imageNumber{get;set;}
    public Datetime submittedBy{get;set;}
    public Datetime submittedDt{get;set;}
    public Datetime modifiedBy{get;set;}
    public Datetime createdBy{get;set;}
    public string createdByUserRole{get;set;}
    
    public string emailAddress{get;set;}
    public integer faxNumber{get;set;}
    public string CC{get;set;}
    public string selectedTemplate{get;set;}
    public string selectedRecipientType{get;set;}
    public string selectedRecipientSubType{get;set;}
    public string selectedDeliveryOption{get;set;}
    public string selectedDeliveryOption2{get;set;}
    public string selectedType{get;set;}
    Public Case cases{get;set;}
    Public boolean ispagevisible{get;set;}
    Public boolean rendercreateletter{get;set;}
    Public boolean rendersubmitletter{get;set;}
    Public boolean renderreviewletter{get;set;}
    Public boolean rendercancelletter{get;set;}
    Public boolean renderreadonlyfields{get;set;}
    Public boolean rendereditfields{get;set;}
    public String getActiveXUrl{get;set;}
    public String engageoneworkitemid{get;set;}
    public String receipentVal {get; set;}
    public List<Selectoption> RecipientSubTypee{get;set;}
    public List<SelectOption> recipientTypee{get;set;}
    public List<Selectoption> templates{get;set;}
    
    Public String func{set;get;}
    
    public Create_Letter__c newletter{get;set;}
    
    public ACETCreateLetterResult CLResult{get;set;}
    
    public String RequestBodyFormat{get;set;}
    
    public ACETCreateLetterController(ApexPages.StandardController controller)
    {
        ispagevisible = true;
        rendercreateletter = true;
        rendersubmitletter = false;
        renderreviewletter = false;
        rendercancelletter = false;
        //renderreadonlyfields = false;
        rendereditfields = false;
        faxNumber = null;
        strModifiedBy = '';
        strSubmittedBy = '';
        receipentVal = '--None--';
        system.debug('Id is '+Apexpages.currentpage().getparameters().get('letterid'));
        
        templates = new List<SelectOption>();
        templates.add(new SelectOption('--None--','--None--'));
        Map<String,ACETLetterTemplates__c> lettermap = ACETLetterTemplates__c.getall();
        /*for(string s :letters)
{
templates.add(new SelectOption(s,s));
}*/
        system.debug('lettermap.keySet() is '+lettermap.keySet());
        for(string s:lettermap.keySet())
        {
            templates.add(new SelectOption(ACETLetterTemplates__c.getvalues(s).Value__c,s));
        }
        templates.sort();
        system.debug('templates is '+templates);
        if(Apexpages.currentpage().getparameters().get('letterid') != null)
        {
            renderreadonlyfields = true;
            //Create_Letter__c newletter = [select Review_on_ActiveX__c,Letter_Status__c,Work_Item_Id__c from Create_Letter__c where id=:Apexpages.currentpage().getparameters().get('letterid')];
            
            newletter = [SELECT Delivery_Date__c,Delivery_Method_1__c,Delivery_Method_2__c,Email__c,Fax__c,Letter_Name__c,Image_Number__c,Letter_Status__c,
                         Recipient_Address_1__c,Recipient_Address_2__c,Recipient_City__c,Recipient_Last_Name__c,Recipient_MI__c,Recipient_Name__c,Recipient_State__c,Recipient_Suffix__c,Recipient_Type__c,Recipient_Zip__c,Submit_Date_Time__c,
                         Submitted_By__c,Work_Item_Id__c,LastModifiedDate,LastModifiedby.Name,CreatedDate,Createdby.Name,Recipient_Sub_Type__c,Recipient_Facility_Name__c,
                         Review_on_ActiveX__c,Delivery_Method_2_Status__c ,CC_Status__c 
                         FROM Create_Letter__c
                         WHERE Id =: Apexpages.currentpage().getparameters().get('letterid')];
            
            system.debug('NewLetter---'+newLetter);
            String baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
            String Engageoneurl;
            String orginstance ;
            for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
                
                if(baseURL.contains(orgname.Name)) {
                    system.debug('tname '+orgname.name);
                    orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
                }
            }
            if(orginstance != null){
                system.debug('orginstance is '+orginstance);
                Engageoneurl = ACETURLEncryptionUtility.getICUEURL(orginstance+'_EngageOne');
            }
            String urlparam1 = 'workitemid='+newletter.Work_Item_Id__c;
            blob urlparam2 = blob.valueOf('&appname=ACET');
            Blob data = Blob.valueOf(urlparam1);
            Blob EncryptKey = Blob.valueOf(ACETWrapEncryptionKey__c.getValues(orginstance+'_Engageonekey').Key__c);
            Blob encryptedworkitem = Crypto.encryptWithManagedIV('AES256', EncryptKey , data);
            String combinedDataAsHex = EncodingUtil.convertToHex(encryptedworkitem) + EncodingUtil.convertToHex(urlparam2);
            blob urlparams = EncodingUtil.convertFromHex(combinedDataAsHex);
            String encodedurlparams = EncodingUtil.base64Encode(urlparams);
            encodedurlparams = EncodingUtil.urlEncode(encodedurlparams, 'UTF-8');
            getActiveXUrl = Engageoneurl+'id='+encodedurlparams;
            if(newletter.Review_on_ActiveX__c == true){
                
                rendersubmitletter = true;
            }
            if(newletter.Letter_Status__c == 'Pending Submission'){
                
                rendercreateletter = false;
                //rendersubmitletter = true;
                renderreviewletter = true;
                rendercancelletter = true;
                engageoneworkitemid = newletter.Work_Item_Id__c ;
                deliverystatus1= newLetter.Letter_Status__c ;
                deliverystatus2= newLetter.Delivery_Method_2_Status__c;
                ccStatus= newLetter.CC_Status__c;
                strModifiedBy = '';
                
                //strModifiedBy = newletter.LastModifiedBy.Name+ ''+newletter.LastModifiedDate;
                
                system.debug('rendercreateletter is '+rendercreateletter);
            }
            else if(newletter.Letter_Status__c == 'Submitted')
            {
                rendercreateletter = false;
                rendersubmitletter = false;
                //strModifiedBy = newletter.LastModifiedBy.Name+ ' '+newletter.LastModifiedDate;
                strSubmittedBy = newletter.Submitted_By__c+' '+newletter.Submit_Date_Time__c;
                //submittedDt = newLetter.Submitted_Date_Time__c;
                //system.debug('Submitted_Date_Time__c');
                //strSubmittedDt = newletter.Submitted_By__c+' '+newletter.Submit_Date_Time__c;
            }
            else if(newletter.Letter_Status__c == 'Canceled')
            {
                rendercreateletter = false;
                //rendersubmitletter = true;
                renderreviewletter = true;
                rendercancelletter = true;
            }
            //Added by Krishna for User story US600908
            else if(newletter.Letter_Status__c == 'Pending Fulfillment'){
                Datetime modifiedDate=newletter.LastModifiedDate;
                Time modifedTime=modifiedDate.time();
                String formatedDate=modifiedDate.date().format();
                String formatedtime=modifedTime.hour()+':'+modifedTime.minute()+':'+modifedTime.second();
                strModifiedBy = newletter.LastModifiedBy.Name+', '+formatedDate+', '+formatedtime;
                rendercreateletter = false;
                renderreviewletter = true;
                rendercancelletter = true;
            }
        }
        
        
        else{
            rendereditfields = true;
            newletter = new Create_Letter__c();
        }
        
        CC = 'Mail';
        Case cs = (Case)controller.getrecord();
        //Id cs = Apexpages.currentpage().getparameters().get('Id');
        system.debug('cs is '+cs);
        cases = [select id,Member_ID__c,Topic__c,caseNumber,Originator_name__c,Status,Subject_Name__c from Case where id=:cs.Id];
        system.debug('cases is '+cases);
        
        //getTemplates();
        
        CLResult = new ACETCreateLetterResult(); 
    }
    
    
    
    //public List<SelectOption> getTemplates() {
    /*String memberprofile;
String EBProfiles;
if(ACETLetterVisiblebyCalltopicandProfile__c.getvalues(cases.Topic__c).Member_Profiles__c!=null){
memberprofile = ACETLetterVisiblebyCalltopicandProfile__c.getvalues(cases.Topic__c).Member_Profiles__c;
}
if(ACETLetterVisiblebyCalltopicandProfile__c.getvalues(cases.Topic__c).Employee_Broker_Profiles__c!=null){
EBProfiles = ACETLetterVisiblebyCalltopicandProfile__c.getvalues(cases.Topic__c).Employee_Broker_Profiles__c;
}
List<SelectOption> templates = new List<SelectOption>();
templates.add(new SelectOption('--None--','--None--'));
Profile profilename = [select name from profile where id=:userinfo.getProfileId()];
if(memberprofile!=null && memberprofile.containsIgnoreCase(profilename.name))
{
String [] Memberletters = ACETLetterVisiblebyCalltopicandProfile__c.getvalues(cases.Topic__c).Member_Letters_Visible__c.split(',');
for(String mem:Memberletters)
{
templates.add(new SelectOption(mem,mem));
}
}
else if(EBProfiles != null && EBProfiles.containsIgnoreCase(profilename.Name))
{
system.debug('EBProfiles is '+EBProfiles);
String [] EBletters = ACETLetterVisiblebyCalltopicandProfile__c.getvalues(cases.Topic__c).Employee_Broker_Letters_Visible__c.split(',');
for(String EB:EBletters)
{
templates.add(new SelectOption(EB,EB));
}
}
else
{
ispagevisible = false;
Apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,'You are not Authorized to Create letter'));
}*/
    //String [] letters=ACETLetterTemplates__c.getvalues('ACET Templates').Templates__c.split(',');
    /*List<SelectOption> templates = new List<SelectOption>();
templates.add(new SelectOption('--None--','--None--'));
Map<String,ACETLetterTemplates__c> lettermap = ACETLetterTemplates__c.getall();*/
    /*for(string s :letters)
{
templates.add(new SelectOption(s,s));
}*/
    /*system.debug('lettermap.keySet() is '+lettermap.keySet());
for(string s:lettermap.keySet())
{
templates.add(new SelectOption(ACETLetterTemplates__c.getvalues(s).Value__c,s));
}
system.debug('templates is '+templates);
return templates;
}*/
    
    public List<SelectOption> getDeliveryOptions() {
        List<SelectOption> deliveryOptions = new List<SelectOption>();
        deliveryOptions.add(new SelectOption('--None--','--None--'));
        deliveryOptions.add(new SelectOption('Mail','US Mail'));
        deliveryOptions.add(new SelectOption('Email','Email'));
        deliveryOptions.add(new SelectOption('Fax','Fax'));
        deliveryOptions.add(new SelectOption('Overnight','Overnight'));
        return deliveryOptions;
    }
    
    public void onchangetemplate()
    {
        getRecipientType();
    }
    
    public List<SelectOption> getRecipientType() {
        
        if(selectedTemplate == 'Balance_Bill_Letter')
        {
            recipientTypee = new List<SelectOption>();
            recipientTypee.add(new SelectOption('Provider','Provider'));
        }
        else if(selectedTemplate == '--None--' || selectedTemplate != 'Balance_Bill_Letter') {
            recipientTypee = new List<SelectOption>();
            recipientTypee.add(new SelectOption('--None--','--None--'));
            recipientTypee.add(new SelectOption('Member','Member'));
            recipientTypee.add(new SelectOption('Provider','Provider'));
            selectedRecipientType='--None--';
            selectedRecipientSubType = '--None--';
        }
        return recipientTypee;
    }
    
    
    public void onchangerecipienttype()
    {
        system.debug('selectedRecipientType is '+receipentVal);
        if(receipentVal == '--None--')
        {
            system.debug('receipentVal onchange is '+receipentVal);
            
        }
        getRecipientSubType();
    }
    public List<selectOption> getRecipientSubType() {
        
        if(receipentVal == '--None--' || receipentVal == 'Provider')
        { 
            RecipientSubTypee = new List<selectOption>();
            RecipientSubTypee.add(new selectOption('--None--','--None--'));
            RecipientSubTypee.add(new selectOption('Facility','Facility'));
            RecipientSubTypee.add(new selectOption('Person','Person'));
            
            system.debug('RecipientSubTypee is '+RecipientSubTypee);
            selectedRecipientSubType = '--None--';
        }
        
        else if(receipentVal == 'Member')
        { 
            RecipientSubTypee = new List<selectOption>();
            RecipientSubTypee.add(new selectOption('Person','Person'));
            system.debug('RecipientSubTypee is '+RecipientSubTypee);
        }
        return RecipientSubTypee;
    }
    
    public List<SelectOption> getTypes() {
        List<SelectOption> types = new List<SelectOption>();
        types.add(new SelectOption('Letter','Letter'));
        return types;
    }
    
    public Pagereference CreateLetter(){
        String Selectedtemplatename;
        for (SelectOption so : Templates)
        {
            if (so.getValue() == selectedTemplate)
            {
                Selectedtemplatename = so.getLabel();
            }
        }
        //system.debug('cases.Member_ID__c is '+Cases.Member_ID__c);
        
        list<String> SearchParameters = new String[]{Selectedtemplate,String.valueof(cases.caseNumber),String.valueof(date.today()),cases.Member_ID__c,UserInfo.getFirstname(),Userinfo.getLastName(),selectedDeliveryOption,selectedDeliveryOption2,emailAddress,String.valueoF(faxNumber),selectedRecipientType,selectedRecipientSubType,recipientfacilityName,recipientFirstName,recipientFirstName,recipientLastName,recipientsuffix};
            system.debug('SearchParameters is '+SearchParameters);
        
        StaticResource RequestJSONSR;
        if (!test.isRunningTest())
        {
            RequestJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETLetterAttachmentXML'];
            RequestBodyFormat = RequestJSONSR.Body.toString(); 
            system.debug('RequestBodyFormat is '+RequestBodyFormat);
        }
        String XMLAttach = String.format(RequestBodyFormat, SearchParameters).replaceAll('null', '').replaceAll('--None--', '');
        
        system.debug('XML attachment'+XMLAttach);
        ACETCreateLetterWebservice ACETCLW = new ACETCreateLetterWebservice();
        ACETWSCalloutResult createLetterCalloutResult = new ACETWSCalloutResult ();
        createLetterCalloutResult = ACETCLW.CreateLetterWS(XMLAttach,Selectedtemplate);
        if(createLetterCalloutResult.success != null && createLetterCalloutResult.success ){
            CLResult =  (ACETCreateLetterResult)createLetterCalloutResult.Response;
        } 
        system.debug('CLRESULT--->'+clresult);
        Create_Letter__c letter = new Create_Letter__c();
        letter.Case__c = cases.id;
        letter.Letter_Name__c = selectedTemplatename;
        letter.Letter_Status__c = 'Pending Submission';
        if(selectedTemplate.contains('Balance Bill Letter'))
            letter.CC_Status__c = 'Pending Submission';
        
        letter.Work_Item_Id__c = clResult.resultLetterId ;
        letter.Delivery_Method_1__c =  selectedDeliveryOption;
        letter.Delivery_Method_2__c = selectedDeliveryOption2;
        letter.Email__c = emailAddress;
        letter.Fax__c = faxNumber;     
        
        letter.Recipient_Facility_Name__c = recipientfacilityName;
        letter.Recipient_Name__c = recipientFirstName;
        letter.Recipient_Last_Name__c = recipientLastName;
        system.debug('selectedRecipientSubType is '+selectedRecipientSubType);
        letter.Recipient_Sub_Type__c = selectedRecipientSubType;
        letter.Recipient_Suffix__c = recipientsuffix;
        letter.Recipient_Type__c = selectedRecipientType;   
        system.debug('letter is '+letter);
        insert letter;
        String strurl = String.valueof(URL.getSalesforceBaseUrl().toExternalForm())+'/apex/ACETCreateLetter?id='+cases.id+'&letterid='+letter.Id;
        system.debug('strurl is '+strurl);
        Pagereference pageref = new pagereference(strurl);
        system.debug('pageref is '+pageref);
        return pageref;
        
    }
    public Pagereference SubmitLetter(){
        try{
            ACETFindLetterService find = new ACETFindLetterService();
            ACETWSCalloutResult findLetterCalloutResult = new ACETWSCalloutResult();
            findLetterCalloutResult = find.FindLetterWS(newletter.Work_Item_Id__c);
            if(findLetterCalloutResult.Message == 'ACTIVE_COMPLETE')
            {
                ACETProcessLetterWebservice service = new ACETProcessLetterWebservice();
                ACETWSCalloutResult processLetterCalloutResult = new ACETWSCalloutResult();
                system.debug('newletter.Work_Item_Id__c is '+newletter.Work_Item_Id__c);
                processLetterCalloutResult = service.ProcessLetterWS(newletter.Work_Item_Id__c, 'PUBLISH');
                
                newletter.Letter_Status__c = 'Submitted';
                newletter.Submitted_By__c = userinfo.getName();
                if(newletter.Letter_Name__c.contains('Balance Bill Letter')){
                    newletter.CC_Status__c = 'Submitted';
                }
                update newletter;
                
                String strurl = String.valueof(URL.getSalesforceBaseUrl().toExternalForm())+'/apex/ACETCreateLetter?id='+cases.id+'&letterid='+newletter.Id+'&submitresult='+processLetterCalloutResult.Success+'findresult='+findLetterCalloutResult.Success;
                system.debug('strurl is '+strurl);
                Pagereference pageref = new pagereference(strurl);
                system.debug('pageref is '+pageref);
                return pageref;
            }
            else{
                String strurl = String.valueof(URL.getSalesforceBaseUrl().toExternalForm())+'/apex/ACETCreateLetter?id='+cases.id+'&letterid='+newletter.Id+'&submitresult=false&findresult='+findLetterCalloutResult.Success;
                system.debug('strurl is '+strurl);
                Pagereference pageref = new pagereference(strurl);
                system.debug('pageref is '+pageref);
                return pageref;
                //Apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,'Letter Incomplete Please complete the letter by clicking on Review/Edit'));
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex); 
            
        }
        return null;
    }
    
    Public Pagereference LaunchActiveX()
    {
        Create_Letter__c letter = new Create_Letter__c();
        letter.id = Apexpages.currentpage().getparameters().get('letterid');
        letter.Review_on_ActiveX__c = true;
        //Added by Krishna for User story US600908
        letter.Letter_Status__c='Pending Fulfillment';
        if(newletter.Letter_Name__c.contains('Balance Bill Letter')){
            letter.CC_Status__c = 'Pending Fulfillment';
        }
        update letter;
        system.debug('letter is '+letter);
        String strurl = String.valueof(URL.getSalesforceBaseUrl().toExternalForm())+'/apex/ACETCreateLetter?id='+cases.id+'&letterid='+letter.Id;
        system.debug('strurl is '+strurl);
        Pagereference pageref = new pagereference(strurl);
        system.debug('pageref is '+pageref);
        return pageref;
    }
    
    public Pagereference CancelLetter()
    {
        ACETProcessLetterWebservice service = new ACETProcessLetterWebservice();
        ACETWSCalloutResult processLetterCalloutResult = new ACETWSCalloutResult();
        system.debug('newletter.Work_Item_Id__c is '+newletter.Work_Item_Id__c);
        processLetterCalloutResult = service.ProcessLetterWS(newletter.Work_Item_Id__c, 'CANCEL');
        if(processLetterCalloutResult.Success)
        {
            newletter.Letter_Status__c = 'Canceled';
            if(newletter.Letter_Name__c.contains('Balance Bill Letter')){
                newletter.CC_Status__c = 'Canceled';
            }
        }
        update newletter;
        system.debug('processLetterCalloutResult is '+processLetterCalloutResult);
        String strurl = String.valueof(URL.getSalesforceBaseUrl().toExternalForm())+'/apex/ACETCreateLetter?id='+cases.id+'&letterid='+Apexpages.currentpage().getparameters().get('letterid')+'&cancelresult='+processLetterCalloutResult.Success;
        system.debug('strurl for cancel is '+strurl);
        Pagereference pageref = new pagereference(strurl);
        system.debug('pageref is '+pageref);
        
        return pageref;
    }
    
    public void DisplayMessage()
    {
        system.debug('Display Message');
        system.debug('myparam is '+Apexpages.currentpage().getparameters().get('myparam'));
        Apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,Apexpages.currentpage().getparameters().get('myparam')));
    }
}