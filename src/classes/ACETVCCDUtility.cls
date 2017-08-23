public class ACETVCCDUtility{
    public static Interaction__c populateVCCDInfo(Interaction__c intraction){
        String vccdParams = ApexPages.currentPage().getParameters().get('vccdParams');
        system.debug('vccdParams in VCCD utility '+vccdParams);
        if(vccdParams != null && vccdParams != ''){
            ACETVCCDInteractionInfo vccdInfo = (ACETVCCDInteractionInfo)JSON.deserialize(vccdParams,ACETVCCDInteractionInfo.class);
            system.debug('vccdInfo >>>> '+vccdInfo);
            if(vccdInfo.callerANI != null){
            	intraction.Caller_Id_ANI__c = vccdInfo.callerANI;
            }
            	
            intraction.Question_Type__c = vccdInfo.QuestionType;//will be mapped with question type code using configurator.
            intraction.TFN_Toll_Free_Number__c = vccdInfo.TFN;
            intraction.id__c = vccdInfo.idStr;
            intraction.Caller_Type__c = 'Member';//for demo only. will get change using custom setting
            if(vccdinfo.CallerID != null){
            	intraction.Caller_Id_ANI__c = vccdinfo.CallerID;
            }

            if(vccdinfo.MemberDOB != null && vccdinfo.MemberDOB != '')
                intraction.Member_Date_of_Birth__c = Date.parse(vccdinfo.MemberDOB);//Date.valueof(vccdinfo.MemberDOB);
            intraction.Tax_Id__c = vccdinfo.TaxID;
            intraction.NPI__c = vccdinfo.npi;
            intraction.Member_Id__c = vccdinfo.MemberID;
            intraction.Caller_Type__c = vccdinfo.callerType;
           
            
            if(!String.isEmpty(vccdinfo.ReferralNumber)){
            	 intraction.Claim_Authorization_Referral_Number__c = vccdinfo.ReferralNumber;
            }
            if(!String.isEmpty(vccdinfo.AuthorizationNumber)){
            	 intraction.Claim_Authorization_Referral_Number__c = vccdinfo.AuthorizationNumber;
            }            
            if(!String.isEmpty(vccdinfo.ClaimID)){
            	 intraction.Claim_Authorization_Referral_Number__c = vccdinfo.ClaimID;
            }            
            
            
            
        }
        return intraction;
    }
}