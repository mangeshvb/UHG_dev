public with sharing class ACETDocumentController {
	public String selectAddress{get;set;}
	
	public String recepientId {get;set;}
	public string documentId{get;set;}
	public string documentType{get;set;}
	
	public Boolean showSubmitBtnAOF{get;set;}
	public Boolean showPopUpAddress{get;set;}
	public Boolean chooseAddress{get;set;}
	public String showOriginatorMsg{get;set;}
	
	public ACETCommunicationSearchResult selectedResWrapper{get;set;}
	
	public String personOrganizationAA{get;set;}
    public String personFirstNameAA{get;set;}
    public String personMiddleNameAA{get;set;}
    public String personLastNameAA{get;set;}
    public String personSuffixAA{get;set;}
    public String personAddOneAA{get;set;}
    public String personAddTwoAA{get;set;}
    public String personCityAA{get;set;}
    public String personStateAA{get;set;}
    public String personZipCodeAA{get;set;}
        
    public personwrapper personWrap{get;set;}
    
    public String DocTempUrl {get;set;}
    public String AttachmentId {get;set;}
    public String IsDocSizeMoreThanOneMB {get;set;}
    //public String FileContentB64 {get;set;}
    
	
	public ACETDocumentController(){
		selectAddress = 'AddressOnFile';
		ShowPopUpAddress = false;
		documentId = ApexPages.currentPage().getParameters().get('DocId');
		string perWrap = ApexPages.currentPage().getParameters().get('personWrap');
		showOriginatorMsg = ApexPages.currentPage().getParameters().get('showOriginatorMsg');
		documentType = ApexPages.currentPage().getParameters().get('docType');
		system.debug('perwrap'+perWrap);
		
		IsDocSizeMoreThanOneMB = ApexPages.currentPage().getParameters().get('IsDocSizeMoreThanOneMB');
		
        if(String.IsNotBlank(perWrap)){
            personWrap  = (personWrapper)JSON.deserialize(perWrap, personWrapper.class);
            personOrganizationAA = personWrap.personOrganization;
    		personFirstNameAA = personWrap.personFirstName;
		    personMiddleNameAA = personWrap.personMiddleName;
		    personLastNameAA = personWrap.personLastName;
		    personSuffixAA = personWrap.personSuffix;
		    personAddOneAA = personWrap.personAddOne;
		    personAddTwoAA = personWrap.personAddTwo;
		    personCityAA = personWrap.personCity;
		    personStateAA = personWrap.personState;
		    personZipCodeAA = personWrap.personZipCode;
		    if(showOriginatorMsg.contains('false') && String.isBlank(personWrap.personAddOne) &&  String.isBlank(personWrap.personCity) && String.isBlank(personWrap.personState) &&  String.isBlank(personWrap.personZipCode) && (String.isBlank(personWrap.personOrganization)|| (String.isBlank(personWrap.personFirstName) && String.isBlank(personWrap.personLastName)))){
        		showSubmitBtnAOF = true;    
        	}
        }
        
        
	}
	public Pagereference btnresend(){
		showPopUpAddress = True;
		chooseAddress = true;
		return null;
	}
	public PageReference btnSubmit(){
        
        ACETDocRedeliveryWebservice ACETDCWS = new ACETDocRedeliveryWebservice();
        ACETWSCalloutResult docRedeliveryCalloutResult = new ACETWSCalloutResult ();
        selectedResWrapper = new ACETCommunicationSearchResult();
        
        String redeliveryId = 'ACET-R-'+String.valueof(system.now());
        recepientId = ApexPages.currentPage().getParameters().get('recepientId');
        Interaction__c Interaction = ACETMemberQueryUtil.queryInteraction(ApexPages.currentPage().getParameters().get('InteractionID'));
            
        if(selectAddress.contains('AddressOnFile')){
            if(String.ISBlank(personWrap.personFirstName) && String.IsBlank(personWrap.personLastName)){
                personFirstNameAA = personWrap.personFirstName = personWrap.personOrganization;
                personLastNameAa = personWrap.personLastName = '.';   
            }
            docRedeliveryCalloutResult = ACETDCWS.docRedeliveryWS(redeliveryId, recepientId, 'Member', personWrap.personFirstName, personWrap.personMiddleName, personWrap.personLastName, personWrap.personSuffix, personWrap.personAddOne, personWrap.personAddTwo, personWrap.personCity, personWrap.personState,personWrap.personZipCode, selectedResWrapper);
        }
        else if(selectAddress.contains('AlternateAddress')){
            if(String.ISBlank(personFirstNameAA) && String.IsBlank(personLastNameAA)){
                personFirstNameAA = personOrganizationAA;
                personLastNameAA = '.'; 
            }
            docRedeliveryCalloutResult = ACETDCWS.docRedeliveryWS(redeliveryId, recepientId, 'Member', personFirstNameAA, personMiddleNameAA, personLastNameAA, personSuffixAA, personAddOneAA, personAddTwoAA, personCityAA, personStateAA,personZipCodeAA, selectedResWrapper);
        
	        if(docRedeliveryCalloutResult.success != null && docRedeliveryCalloutResult.success ){ 
	            selectedResWrapper =  (ACETCommunicationSearchResult)docRedeliveryCalloutResult.Response;
	        }
	        else{
	        	 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Service is not working'));
	        }
	        system.debug('selectedResWrapper--->'+selectedResWrapper); 
        }
        return null;
	}
    
    public PageReference fetchDoc(){
    	String docId = ApexPages.currentPage().getParameters().get('DocId');
    	String docContentType = ApexPages.currentPage().getParameters().get('docContentType');
    	String isDocSizeMoreThanOneMB = ApexPages.currentPage().getParameters().get('isDocSizeMoreThanOneMB');
    	    	
    	if(!String.isEmpty(docId) && !String.isEmpty(docContentType) && isDocSizeMoreThanOneMB == 'false'){
    		ACETGetDocWebservice service = new ACETGetDocWebservice();
			ACETWSCalloutResult ac = service.fetchDocument('PSEUDO1', docId);
			
			Attachment a;			
			String value = EncodingUtil.convertToHex(ac.Attach.body);			
			
			//locate the first <payload> in the reponse stream
			String payload = EncodingUtil.convertToHex(Blob.valueOf('<payload>'));
			Integer index = value.indexOf(payload);
			
			if(index > = -1){				
				//locate the end boundary of payload
				String uuid = EncodingUtil.convertToHex(Blob.valueOf('--uuid:'));
				Integer index2 = value.indexOf(uuid, index);
				
				//skip the \r\n after <payload> and retrieve attachment content
				value = value.substring(index + payload.length() + 8, index2);
				
				//remove blank lines \r\n at end
				if(value.substring(value.length()-4, value.length()) == '0d0a'){
					value = value.substring(0, value.length()-4);	
				}				
			}
												
			Temp_Document__c td = new Temp_Document__c();
			insert td;
			a = new Attachment();
			a.Name = docId;
			a.parentId = td.Id;
			a.body = EncodingUtil.convertFromHex(value);
			a.ContentType = docContentType;
			insert a;
									
			DocTempUrl = '/servlet/servlet.FileDownload?file=' + a.Id;
			AttachmentId = a.Id;			
    	}
    	    	
    	return null;
    }   
	
	
	public class personWrapper{
    	public String personOrganization{get;set;}
	    public String personFirstName{get;set;}
	    public String personMiddleName{get;set;}
	    public String personLastName{get;set;}
	    public String personSuffix{get;set;}
	    public String personAddOne{get;set;}
	    public String personAddTwo{get;set;}
	    public String personCity{get;set;}
	    public String personState{get;set;}
	    public String personZipCode{get;set;}
    	
    }
            
    @RemoteAction
    public static String getDocContent(String attachmentId){
    	Attachment a = [select body from Attachment where Id = :attachmentId];
    	return EncodingUtil.base64Encode(a.body); 		
    }
}