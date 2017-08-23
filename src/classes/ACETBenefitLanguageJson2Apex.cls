public class ACETBenefitLanguageJson2Apex{
	public GetBenefitLanguageRSResponse getBenefitLanguageRSResponse;
	public class GetBenefitLanguageRSResponse {
		public GetBenefitLanguageResponseMsgType getBenefitLanguageResponseMsgType;
	}
	public class GetBenefitLanguageResponseMsgType {
		public Response response;
	}
	public class Response {
		public PlanCode[] planCode;
	}
	public class PlanCode {
		public String code;
		public String descr;
		public BenefitSection[] benefitSection;
	}
	public class BenefitSection {
		public String benefitSectionName;
		public BenefitSectionDescription benefitSectionDescription;
		public BenefitSubsection[] benefitSubsection;
	}
	public class BenefitSectionDescription {
		public String text;
	}
	public class BenefitSubsection {
		public String benefitSubsectionectionName;
		public BenefitSubsectionDescription benefitSubsectionDescription;
		public BenefitSubsectionLanguage benefitSubsectionLanguage;
	}
	public class BenefitSubsectionDescription {
		public String text;
	}
	public class BenefitSubsectionLanguage {
		public String text;
	}
}