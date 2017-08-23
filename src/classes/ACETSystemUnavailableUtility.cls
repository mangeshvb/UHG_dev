public with sharing class ACETSystemUnavailableUtility{
    
    public static string getMemberInfo(boolean isEnrollment, boolean isTerminate, boolean isReinstatement, ACETSystemUnavailableWrapper systemUnavailableWrap){
        String memberInfo = '';
        system.debug('   ACETSystemUnavailableWrapper'+ systemUnavailableWrap);
        if(isEnrollment){
        system.debug('the family is called');
           memberInfo ='Specific action being requested:'+systemUnavailableWrap.actionRequested+'\n'+'Full Name of Authorized Contact:'+ systemUnavailableWrap.authorizedContact + '\n'
                       +'Member  Full name:' + systemUnavailableWrap.termDate+'\n'+'SSN/member ID:' + systemUnavailableWrap.SSNMemberId +'\n'
                       +'Complete home address:'+systemUnavailableWrap.homeAddress+'\n'+'Phone numbers:'+systemUnavailableWrap.Phone
                       + '\n'+ 'Gender:'+systemUnavailableWrap.gender+ '\n'+'PCP/Gynecologist (OBGYN):'+systemUnavailableWrap.pcpGyne+'\n'+ 'CSP/BG:'+ systemUnavailableWrap.cspBg+ '\n'+'Prior carrier name/ID number/dates:'+systemUnavailableWrap.priorInfo+'\n'+'Coordination of benefits:'+systemUnavailableWrap.coordinationOfBenefit +'\n';
         if(systemUnavailableWrap.qualifyingReasonCode != Null && systemUnavailableWrap.qualifyingReasonCode != '') 
         memberInfo = memberInfo + 'Qualifying event reason and code (if known):'+ systemUnavailableWrap.qualifyingReasonCode+ '\n';
         
         if(systemUnavailableWrap.tempCase4 != Null && systemUnavailableWrap.tempCase4.tst_Date_Field__c != Null ) 
         memberInfo = memberInfo + 'Effective date of coverage:'+systemUnavailableWrap.tempCase4.tst_Date_Field__c.format() + '\n';
         if(systemUnavailableWrap.tempCase5 != Null && systemUnavailableWrap.tempCase5.tst_Date_Field__c != Null) 
         memberInfo = memberInfo + 'Last Date of Coverage/ Enrollment Date:'+systemUnavailableWrap.tempCase5.tst_Date_Field__c.format()+ '\n';
         if(systemUnavailableWrap.tempCase3 != Null && systemUnavailableWrap.tempCase3.tst_Date_Field__c != Null) 
         memberInfo = memberInfo + 'Date of hire:'+ systemUnavailableWrap.tempCase3.tst_Date_Field__c.format()+ '\n';
         if(systemUnavailableWrap.tempCase != Null && systemUnavailableWrap.tempCase.tst_Date_Field__c != Null) 
         memberInfo = memberInfo + 'Date of birth:'+systemUnavailableWrap.tempCase.tst_Date_Field__c.format() + '\n';
         if(systemUnavailableWrap.tempCase2 != Null && systemUnavailableWrap.tempCase2.tst_Date_Field__c != Null) 
         memberInfo = memberInfo + 'Date of qualifying event:'+systemUnavailableWrap.tempCase2.tst_Date_Field__c.format()+ '\n';
           
            
            
            
            system.debug('member info is'+ memberInfo); 
            
        }else if(isTerminate){
            memberInfo = 'Specific action being requested: ' + systemUnavailableWrap.actionRequested + '\n' + ' Full Name of Authorized Contact: ' + systemUnavailableWrap.authorizedContact + '\n' + ' Member full name: ' + systemUnavailableWrap.memberName + '\n' + ' SSN/member ID: ' + systemUnavailableWrap.SSNMemberId + '\n' + ' Reason for Termination: ' + systemUnavailableWrap.termReason + '\n'; 
            if(systemUnavailableWrap.tempCase != Null && systemUnavailableWrap.tempCase.tst_Date_Field__c != Null) 
            memberInfo = memberInfo + '  Last date of coverage/termination date: ' + systemUnavailableWrap.tempCase.tst_Date_Field__c.format() + '\n';
            
        }else if(isReinstatement){
            memberInfo = 'Specific action being requested: ' + systemUnavailableWrap.actionRequested + '\n' + ' Full Name of Authorized Contact: ' + systemUnavailableWrap.authorizedContact + '\n' + ' Member full name: ' + systemUnavailableWrap.memberName + '\n' + ' SSN/member ID: ' + systemUnavailableWrap.SSNMemberId + '\n'; 
            
            if(systemUnavailableWrap.tempCase != Null && systemUnavailableWrap.tempCase.tst_Date_Field__c != Null) 
            memberInfo = memberInfo + ' Effective date of coverage/Reinstatement date: ' + systemUnavailableWrap.tempCase.tst_Date_Field__c.format() + '\n';
            
        }  
        system.debug('memberInfo >>>>>>>>>>>>>>>> '+memberInfo);      
        if(String.isNotEmpty(memberInfo) && String.isNotBlank(memberInfo))
            return memberInfo;
        else return null;
    }
}