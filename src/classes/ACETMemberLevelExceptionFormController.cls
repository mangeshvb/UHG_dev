public with sharing class ACETMemberLevelExceptionFormController{
 
    public String comments{get;set;} 
    public string redirectUrl {get; set;} 
    public final Case caseObj;
    
    /******* input fields for Member Level Exception Form *********/
    public string phone{get;set;}
    public string selectedExceptionType{get;set;}
    public string selectedRootCauseException{get;set;}
    public string selectedServiceTerm{get;set;}
    public string selectedBatchCode{get;set;}
    public string broekrId{get;set;}
    public string broekrName{get;set;}
    public string accManager{get;set;}
    public string salesRep{get;set;}
    public boolean displayFlag{get; set;}
    public string selectedrequestor{get;set;}
    public list<memberDetailWrap> memberDetailList{get;set;}
    public boolean RRUser {get; set;}
    public ACETSystemUnavailableWrapper wrapperObj {get; set;}
    public ACETMemberExceptionWrapper deserializedExceptionData{get; set;}
    
    public List<SelectOption> getExceptionType() {
        List<SelectOption> exceptionType= new List<SelectOption>();
        exceptionType.add(new SelectOption('--None--','--None--'));
        exceptionType.add(new SelectOption('Changing QE Dates','Changing QE Dates'));
        exceptionType.add(new SelectOption('COBRA Reinstatement','COBRA Reinstatement'));
        exceptionType.add(new SelectOption('COBRA Transfer','COBRA Transfer'));
        exceptionType.add(new SelectOption('Correct QE Date Change to QE / QE Reason Change','Correct QE Date Change to QE / QE Reason Change'));
        exceptionType.add(new SelectOption('CSP / BG Changes','CSP / BG Changes'));
        exceptionType.add(new SelectOption('Date of Termination Change (Other than Retro','Date of Termination Change (Other than Retro'));
        exceptionType.add(new SelectOption('EDI Member Exception','EDI Member Exception'));
        exceptionType.add(new SelectOption('Effective Date Change','Effective Date Change'));
        exceptionType.add(new SelectOption('Indemnifier Group Member Exception','Indemnifier Group Member Exception'));
        exceptionType.add(new SelectOption('Newborn Addition','Newborn Addition'));
        exceptionType.add(new SelectOption('OTHER','OTHER'));
        exceptionType.add(new SelectOption('Reinstatement','Reinstatement'));
        exceptionType.add(new SelectOption('Retroactive Addition','Retroactive Addition'));
        exceptionType.add(new SelectOption('Retroactive Termination','Retroactive Termination'));
        exceptionType.add(new SelectOption('Self Billing Member Exception','Self Billing Member Exception'));
        exceptionType.add(new SelectOption('Oxford Error (Priority)','Oxford Error (Priority)'));
        exceptionType.add(new SelectOption('Retro Enroll (Priority)','Retro Enroll (Priority)'));        
        return exceptionType;
    }
    
    public List<SelectOption> getRootCauseException() {
        List<SelectOption> rootCauseException= new List<SelectOption>();
        rootCauseException.add(new SelectOption('--None--','--None--'));
        rootCauseException.add(new SelectOption('Web Issue','Web Issue'));
        rootCauseException.add(new SelectOption('Enrollment PO Box Issue','Enrollment PO Box Issue'));
        rootCauseException.add(new SelectOption('Faxed Document to OXP Rep','Faxed Document to OXP Rep'));
        rootCauseException.add(new SelectOption('EDI Issue','EDI Issue'));       
        rootCauseException.add(new SelectOption('Paper Report','Paper Report'));
        rootCauseException.add(new SelectOption('Tape Report','Tape Report'));
        return rootCauseException;
    }
    
    public List<SelectOption> getServiceTerm() {
        List<SelectOption> serviceTerm= new List<SelectOption>();
        serviceTerm.add(new SelectOption('--None--','--None--'));
        serviceTerm.add(new SelectOption('CTAC','CTAC'));
        serviceTerm.add(new SelectOption('CTLG','CTLG'));
        serviceTerm.add(new SelectOption('CTPPO','CTAC'));
        serviceTerm.add(new SelectOption('DESM','DESM'));
        serviceTerm.add(new SelectOption('GRPHSP','GRPHSP'));
        serviceTerm.add(new SelectOption('KGRPHSP','KGRPHSP'));
        serviceTerm.add(new SelectOption('MCAID','MCAID'));
        serviceTerm.add(new SelectOption('MCARE','MCARE'));
        serviceTerm.add(new SelectOption('MCARE-CS','MCARE-CS'));
        serviceTerm.add(new SelectOption('MCAREGA','MCAREGA'));
        serviceTerm.add(new SelectOption('MCGRP-CS','MCGRP-CS'));
        serviceTerm.add(new SelectOption('MEDLRG','MEDLRG'));
        serviceTerm.add(new SelectOption('MEDSPAN','MEDSPAN'));
        serviceTerm.add(new SelectOption('NHIP','NHIP'));
        serviceTerm.add(new SelectOption('NJACC','NJACC'));
        serviceTerm.add(new SelectOption('NJES','NJES'));
        serviceTerm.add(new SelectOption('NJKY','NJKY'));
        serviceTerm.add(new SelectOption('NYIP','NYIP'));
        serviceTerm.add(new SelectOption('NYKY','NYKY'));
        serviceTerm.add(new SelectOption('NYLG','NYLG'));
        serviceTerm.add(new SelectOption('NYLI','NYLI'));
        serviceTerm.add(new SelectOption('NYMN','NYMN'));
        serviceTerm.add(new SelectOption('NYMS','NYMS'));
        serviceTerm.add(new SelectOption('NYSN','NYSN'));
        serviceTerm.add(new SelectOption('OXHP','OXHP'));
        serviceTerm.add(new SelectOption('PAAC','PAAC'));
        serviceTerm.add(new SelectOption('PASM','PASM'));
        serviceTerm.add(new SelectOption('PGAL','PGAL'));
        serviceTerm.add(new SelectOption('PGKY','PGKY'));
        serviceTerm.add(new SelectOption('SBKY','SBKY'));
        return serviceTerm;
    }
    
    public List<SelectOption> getBatchCode() {
        List<SelectOption> batchCode= new List<SelectOption>();
        batchCode.add(new SelectOption('--None--','--None--'));
        batchCode.add(new SelectOption('BANK_11','BANK_11'));
        batchCode.add(new SelectOption('BANK_7','BANK_7'));
        batchCode.add(new SelectOption('BNDR-CTAC','BNDR-CTAC'));
        batchCode.add(new SelectOption('BNDR-CTLG','BNDR-CTLG'));
        batchCode.add(new SelectOption('BNDR-DESM','BNDR-DESM'));
        batchCode.add(new SelectOption('BNDR-NHLI','BNDR-NHLI'));
        batchCode.add(new SelectOption('BNDR-NHLI2','BNDR-NHLI2'));
        batchCode.add(new SelectOption('BNDR-NHMN','BNDR-NHMN'));
        batchCode.add(new SelectOption('BNDR-NHMN2','BNDR-NHMN2'));
        batchCode.add(new SelectOption('BNDR-NHMT','BNDR-NHMT'));
        batchCode.add(new SelectOption('BNDR-NHPPO','BNDR-NHPPO'));
        batchCode.add(new SelectOption('BNDR-NJAC','BNDR-NJAC'));
        batchCode.add(new SelectOption('BNDR-NJES','BNDR-NJES'));
        batchCode.add(new SelectOption('BNDR-NYLG','BNDR-NYLG'));
        batchCode.add(new SelectOption('BNDR-NYLG2','BNDR-NYLG2'));
        batchCode.add(new SelectOption('BNDR-PAAC','BNDR-PAAC'));
        batchCode.add(new SelectOption('BNDR-PALG','BNDR-PALG'));
        batchCode.add(new SelectOption('BNDR-SBILL','BNDR-SBILL'));
        batchCode.add(new SelectOption('BNDR-SF','BNDR-SF'));
        batchCode.add(new SelectOption('CTAC','CTAC'));
        batchCode.add(new SelectOption('CTLG','CTLG'));
        batchCode.add(new SelectOption('DESM','DESM'));
        batchCode.add(new SelectOption('HNY','HNY'));
        batchCode.add(new SelectOption('HOLD_10','HOLD_10'));
        batchCode.add(new SelectOption('HOLD_11','HOLD_11'));
        batchCode.add(new SelectOption('HOLD_12','HOLD_12'));
        batchCode.add(new SelectOption('HOLD_13','HOLD_13'));
        batchCode.add(new SelectOption('HOLD_15','HOLD_15'));
        batchCode.add(new SelectOption('HOLD_16','HOLD_16'));
        batchCode.add(new SelectOption('HOLD_17','HOLD_17'));
        batchCode.add(new SelectOption('HOLD_18','HOLD_18'));
        batchCode.add(new SelectOption('HOLD_20','HOLD_20'));
        batchCode.add(new SelectOption('HOLD_21','HOLD_21'));
        batchCode.add(new SelectOption('HOLD_22','HOLD_22'));
        batchCode.add(new SelectOption('HOLD_23','HOLD_23'));
        batchCode.add(new SelectOption('HOLD_30','HOLD_30'));
        batchCode.add(new SelectOption('HOLD_31','HOLD_31'));
        batchCode.add(new SelectOption('HOLD_32','HOLD_32'));
        batchCode.add(new SelectOption('HOLD_33','HOLD_33'));
        batchCode.add(new SelectOption('HOLD_40','HOLD_40'));
        batchCode.add(new SelectOption('HOLD_41','HOLD_41'));
        batchCode.add(new SelectOption('HOLD_42','HOLD_42'));
        batchCode.add(new SelectOption('HOLD_43','HOLD_43'));
        batchCode.add(new SelectOption('HOLD_50','HOLD_50'));
        batchCode.add(new SelectOption('HOLD_51','HOLD_51'));
        batchCode.add(new SelectOption('HOLD_52','HOLD_52'));
        batchCode.add(new SelectOption('HOLD_53','HOLD_53'));
        batchCode.add(new SelectOption('HOLD_6','HOLD_6'));
        batchCode.add(new SelectOption('HOLD_60','HOLD_60'));
        batchCode.add(new SelectOption('HOLD_61','HOLD_61'));
        batchCode.add(new SelectOption('HOLD_62','HOLD_62'));
        batchCode.add(new SelectOption('HOLD_63','HOLD_63'));
        batchCode.add(new SelectOption('HOLD_7','HOLD_7'));
        batchCode.add(new SelectOption('HOLD_8','HOLD_8'));
        batchCode.add(new SelectOption('HOLD_9','HOLD_9'));
        batchCode.add(new SelectOption('HOLD_PA','HOLD_PA'));
        batchCode.add(new SelectOption('HOLD_SB','HOLD_SB'));
        batchCode.add(new SelectOption('MCARE','MCARE'));
        batchCode.add(new SelectOption('MSP_10','MSP_10'));
        batchCode.add(new SelectOption('MSP_11','MSP_11'));
        batchCode.add(new SelectOption('MSP_12','MSP_12'));
        batchCode.add(new SelectOption('NHLI','NHLI'));
        batchCode.add(new SelectOption('NHLI2','NHLI2'));
        batchCode.add(new SelectOption('NHMN','NHMN'));
        batchCode.add(new SelectOption('NHMN2','NHMN2'));
        batchCode.add(new SelectOption('NHMT','NHMT'));
        batchCode.add(new SelectOption('NHPPO','NHPPO'));
        batchCode.add(new SelectOption('NJAC','NJAC'));
        batchCode.add(new SelectOption('NJES','NJES'));
        batchCode.add(new SelectOption('NYLG','NYLG'));
        batchCode.add(new SelectOption('NYLG2','NYLG2'));
        batchCode.add(new SelectOption('NYSHIPP','NYSHIPP'));
        batchCode.add(new SelectOption('ONYH','ONYH'));
        batchCode.add(new SelectOption('ONXHP','ONXHP'));
        batchCode.add(new SelectOption('PAAC','PAAC'));
        batchCode.add(new SelectOption('PALG','PALG'));
        batchCode.add(new SelectOption('SELF_BILL','SELF_BILL'));
        batchCode.add(new SelectOption('SF','SF'));
        batchCode.add(new SelectOption('UNDELIV','UNDELIV'));
        return batchCode;
    }
    
    public List<SelectOption> getRequestors() {
        List<SelectOption> requestor = new List<SelectOption>();
        requestor.add(new SelectOption('--None--','--None--'));
        requestor.add(new SelectOption('Account Manager','Account Manager'));
        requestor.add(new SelectOption('BA','BA'));
        requestor.add(new SelectOption('Broker','Broker'));
        requestor.add(new SelectOption('GA','GA'));       
        requestor.add(new SelectOption('Group','Group'));
        requestor.add(new SelectOption('Sales Rep','Sales Rep'));
        requestor.add(new SelectOption('Third Party Designee','Third Party Designee'));
        return requestor;
    }
    public case caseObj1;
    public ACETMemberLevelExceptionFormController(ApexPages.StandardController controller) {
        
        //Assign value 
        this.caseObj = (Case)controller.getRecord();
        caseObj1 = [select id,Member_Level_Exception_String__c from case where id=:caseObj.id];
        id caseId = caseObj.id;  
        if(caseObj1.Member_Level_Exception_String__c != null)
        deserializedExceptionData = (ACETMemberExceptionWrapper)JSON.deserialize(caseObj1.Member_Level_Exception_String__c, ACETMemberExceptionWrapper.class);
        system.debug('deserializedExceptionData----->'+deserializedExceptionData);      
        memberDetailList = new list<memberDetailWrap>();
        memberDetailWrap wrapp = new memberDetailWrap();
        memberDetailList.add(wrapp);
        //deserializedExceptionData = new List<ACETMemberExceptionWrapper>();
      //  redirectUrl = '/apex/ACETOriginatingPageServiceRenewal?Originator='+Interaction.Originator__r.Name+'&OriginatorType='+Interaction.Originator_Type__c+'&InteractionId='+InteractionId+'&contactid='+Interaction.Originator__c; 
    }
    
    public pagereference savecase(){
        Case CaseObj = new Case();
        return new PageReference('/' + CaseObj.Id);     
    }
    
    public void addMoreRows()
    {
        memberDetailWrap wrapp = new memberDetailWrap();
        memberDetailList.add(wrapp);
        displayFlag = true;
    
    }
    
    public void saveException()
    {
        ACETMemberExceptionWrapper obj = new ACETMemberExceptionWrapper(selectedrequestor,phone,selectedExceptionType,selectedRootCauseException,selectedServiceTerm,selectedBatchCode,broekrId,broekrName,accManager,salesRep,Comments,memberDetailList);
        system.debug('obj---->'+obj);
        group queueObj= [select Id from Group where Name = 'ACET Finance Queue' and Type = 'Queue' LIMIT 1]; 
            if(obj != null)
            {
                String JSONBody = JSON.serialize(obj);
                system.debug('JSONBody---->'+JSONBody);
                
                if(JSONBody != Null)
                {
                    system.debug('JSONBody in111---->'+JSONBody);
                    caseObj.Member_Level_Exception_String__c = JSONBody;
                    //caseObj.Route_to__c = 'Finance Team';  //     US615311
                    caseObj.DCN_Number__c = '241324123';
                    caseObj.OwnerId = queueObj.id;
                    system.debug('caseObj---->'+caseObj);
                    update caseObj;     
                }
            }
    
        
        //PageReference pagePdf = Page.ACETMemberLevelExceptionFormPDF;
        PageReference pagePdf = new PageReference('/apex/ACETMemberLevelExceptionFormPDF?id='+caseObj.id);
        //pagePdf.getParameters().put('id',caseObj.id);
        //pagePdf.setRedirect(false);
        
        /*
        
        Attachment attach = new Attachment();
        Blob body;

        try 
        {
            body = pagePdf.getContentAsPDF();
            attach.Body = body;
            attach.Name = '---';
            attach.ParentId = caseObj.id;
            attach.ContentType = 'application/pdf';
    
            insert attach;
        } 
        catch (VisualforceException e) 
        {
            body = Blob.valueOf('Error...');
        }
        
        */
       // return pagePdf;
    
    }
    
    public void memberExceptionData()
    {
        //caseObj.
        //deserializedExceptionData = new ACETMemberExceptionWrapper();
        if(caseObj1.Member_Level_Exception_String__c != null)
        deserializedExceptionData = (ACETMemberExceptionWrapper)JSON.deserialize(caseObj1.Member_Level_Exception_String__c, ACETMemberExceptionWrapper.class);
        system.debug('deserializedExceptionData----->'+deserializedExceptionData);
    }
    
    
    public void getloggedinProfileName(){ 
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String loggedinProfileName = PROFILE[0].Name;
    
        //Check if the logged-in User has profile 'Research' type
           if(loggedinProfileName.contains('Rapid Responder') || loggedinProfileName.contains('System Administrator') )
           {  
               RRUser = true;
           }else
           {
               RRUser = false;
           }
           
    }
    
    public void attachPDF()
    {
        PageReference pagePdf = new PageReference('/apex/ACETMemberLevelExceptionFormPDF?id='+caseObj.id);
        //pagePdf.getParameters().put('id',caseObj.id);
        //pagePdf.setRedirect(false);
        system.debug('pagePdf ----->'+pagePdf );
        
        
        Attachment attach = new Attachment();
        Blob body;

        try 
        {
            body = pagePdf.getContentAsPDF();
            attach.Body = body;
            attach.Name = 'Member Level Exception Form';
            attach.ParentId = caseObj.id;
            attach.ContentType = 'application/pdf';
            system.debug('attach----->'+attach);
            insert attach;
        } 
        catch (VisualforceException e) 
        {
            body = Blob.valueOf('Error...');
        }
        
        
       // return pagePdf;
    
    }
    
    public class memberDetailWrap{
        public string memberId{get;set;}
        public string memberFName{get;set;}
        public string memberLName{get;set;}    
    
    }
    
    

}