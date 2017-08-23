public with sharing class ACETBenefitsDetails {
	public ACETBenefitsDetails(){
		Benefits = new Map<String,CategoryDetail>();
	}
	public Map<String,CategoryDetail> Benefits {get;set;}
	public class CategoryDetail{
		public String SectionName {get;set;}
		public String General {get;set;}
		public String InNWProvider {get;set;}
		public String OutNWProvider {get;set;}
		public String LimitationAndExpectation {get;set;}
	}		
}