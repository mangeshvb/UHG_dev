/**
 * @name         :   ACETGetBenefitsLanguageWebService
 * @description  :   Custom Class for Get Benefits Language call out
 * @author       :   Bhanu Jain
 * @createddate  :   17-12-2017
 * @lastmodifiedby:
 *
 **/
public class ACETGetBenefitsLanguageWebService extends ACETWebService{ 
	public override void GetEndpoint(){
		GetEndpointDetail('GetBenefitPlanLanguageEndpoint');
	}

	private void getRequestBody(String planId){ 
		RequestBody = '{'+
				'"getBenefitLanguageRSRequest": {'+
				'"getBenefitLanguageRequestMsgType": {'+
				'"request": {'+
				'"planCode": {'+
				'"code": "'+planId+'",'+
				'"desc": "PULSE Plan ID"'+
				'}'+
				'}'+
				'}'+
				'}'+
				'}';
	}
	public ACETWSCalloutResult getBenefitLanguage(String planId){
		ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
		try{
			getEndpoint();
			getRequestBody(planId);
			HttpResponse Response = Send(OAuthConfig); 

			if (Response.getStatusCode() == 200){
				ACETBenefitsDetails wrapper = new ACETBenefitsDetails();
				String jsonfullstring = Response.getBody();
				jsonfullstring = jsonfullstring.replace('"desc"', '"descr"');
				jsonfullstring = jsonfullstring.replace('\n', '');
				jsonfullstring = jsonfullstring.replace('\r', '');
				ACETBenefitLanguageJson2Apex jsontoapex = new ACETBenefitLanguageJson2Apex();
				jsontoapex = (ACETBenefitLanguageJson2Apex)JSON.deserialize(jsonfullstring, ACETBenefitLanguageJson2Apex.class);

				if(jsontoapex != null && jsontoapex.getBenefitLanguageRSResponse != null 
						&& jsontoapex.getBenefitLanguageRSResponse.getBenefitLanguageResponseMsgType != null 
						&& jsontoapex.getBenefitLanguageRSResponse.getBenefitLanguageResponseMsgType.response != null){
					List<ACETBenefitLanguageJson2Apex.BenefitSection> benefitSectionList =  jsontoapex.getBenefitLanguageRSResponse.getBenefitLanguageResponseMsgType.response.planCode[0].benefitSection;
					Integer sectionStartIndex = 1;
					for(ACETBenefitLanguageJson2Apex.BenefitSection benefit : benefitSectionList){
						//String sectionName = benefit.benefitSectionName;
						String sectionName = benefit.benefitSectionDescription.text;
						system.debug(benefit.benefitSectionDescription.text);
						ACETBenefitsDetails.CategoryDetail category = new ACETBenefitsDetails.CategoryDetail();
						if(benefit.benefitSubsection != null){
							String generalText;
							String inNWText;
							String outNWText;
							for(ACETBenefitLanguageJson2Apex.BenefitSubsection subsection : benefit.benefitSubsection){
								if(subsection.benefitSubsectionDescription != null){
									generalText = subsection.benefitSubsectionDescription.text.equalsIgnoreCase('GENERAL TEXT') ? subsection.benefitSubsectionLanguage.text :generalText;
									inNWText = subsection.benefitSubsectionDescription.text.equalsIgnoreCase('INPLAN TEXT') ? subsection.benefitSubsectionLanguage.text :inNWText;
									outNWText = subsection.benefitSubsectionDescription.text.equalsIgnoreCase('OUTPLAN TEXT') ? subsection.benefitSubsectionLanguage.text :outNWText;
									category.General = generalText;
									category.InNWProvider = inNWText;
									category.OutNWProvider = outNWText;
								}
							}
						}
						category.SectionName = sectionName;
						//Dynamic unique id for each section. will be used as key for each categorydetail
						//String hashString = 'Section' + String.valueOf(sectionStartIndex);
						//Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
						//String sectionKey = EncodingUtil.convertToHex(hash);
						String sectionKey = sectionName.deleteWhitespace().replace('$', '').replace('(', '_').replace(')', '_').replace('%', '_').replace('/', '_').replace('&', '') + sectionStartIndex;
						system.debug(sectionKey);
						wrapper.Benefits.put(sectionKey, category);
						sectionStartIndex++;
					}
				}
				oACETWSCalloutResult.Response = wrapper;
				oACETWSCalloutResult.Success = true;
			}
		}catch(Exception ex){
			oACETWSCalloutResult.Success = false;
			oACETWSCalloutResult.Message = ex.getMessage();
		}
		return oACETWSCalloutResult;
	}      
}