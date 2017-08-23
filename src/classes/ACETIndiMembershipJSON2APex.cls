public class ACETIndiMembershipJSON2APex{
	public cls_getIndividualMembershipResponse getIndividualMembershipResponse;
	public class cls_getIndividualMembershipResponse {
		public cls_individual individual;
	}
	public class cls_individual {
		public String individualIdentifier;	//1234567890987654321
		public cls_name name;
		public String birthDate;	//1980-11-23
		public String genderCode;	//M
		public String genderDescription;	//Male
		public String socialSecurityNumber;	//123456789
		public String maritalStatusCode;	//M
		public String maritalStatusDescription;	//Married
		public String deceasedDate;	//2016-01-01
		public String privacyIndicator;	//Y
		public String tobaccoUsageIndicator;	//T
		public String ethnicityCode;	//A
		public String ethnicityDescription;	//Asian or Pacific Islander
		public cls_address[] address;
		public cls_phone[] phone;
		public cls_email[] email;
		public cls_employment[] employment;
		public cls_language[] language;
		public cls_otherContact[] otherContact;
		public cls_identifiers[] identifiers;
		public cls_membership membership;
	}
	public class cls_name {
		public String firstName;	//Ravi
		public String lastName;	//nadella
		public String middleName;	//R
		public String nameSuffix;	//Senior
	}
	public class cls_address {
		public String addressLine1;	//1 Main St
		public String addressLine2;	//Apt 200
		public String city;	//Hartford
		public String stateCode;	//CT
		public String postalCode;
		public String typeCode;
		public String countryCode;	//US
		public String countryDescription;	//United States of America
	}
	public class cls_phone {
		public String phoneType;	//WRK
		public String phoneNumber;	//2489504568
		public String phoneExt;	//2077
		public String internationalIndicator;	//N
		public String primaryIndicator;	//Y
	}
	public class cls_email {
		public String communicationTypeCode;	//EML
		public String electronicAddress;	//ravi.nadella@gmail.com
		public String primaryIndicator;	//Y
	}
	public class cls_employment {
		public String employmentStatus;	//FT
		public String employeeIdentifier;	//1238857
		public String employmentStartDate;	//2015-01-01
		public String retirementDate;	//2055-01-01
	}
	public class cls_language {
		public String languageCode;	//ENG
		public String languageDescription;	//English
		public String languageUsedTypeCode;	//7
	}
	public class cls_otherContact {
		public cls_name name;
		public cls_address address;
	}
	public class cls_identifiers {
		public String id;	//B9898
		public String type_Z;	//enrollId
	}
	public class cls_membership {
		public String sourceSysCode;	//OIL
		public cls_coverages[] coverages;
		public cls_utilizationPlan[] utilizationPlan;
		public cls_cob[] cob;
		public cls_providers[] providers;
		public cls_clinicalProgram[] clinicalProgram;
		public cls_carrierType carrierType;
		public cls_identifiers[] identifiers;
	}
	public class cls_coverages {
		public String groupNumber;	//123456789
		public String groupName;	//Cirrus
		public String eligibilitySystemTypeCode;	//AAAA
		public String claimSystemTypeCode;	//AAAA
		public cls_bundleOptions[] bundleOptions;
	}
	public class cls_bundleOptions {
		public cls_benefits[] benefits;
	}
	public class cls_benefits {
		public String benefitBundleId;	//1234
		public String benefitBundleName;	//CTLG BUNDLE
		public String benefitBundleOptionId;	//A1111
		public String benefitBundleOptionDescription;	//extended description
		public String benefitEffectiveDate;	//2016-01-01
		public String benefitExpirationDate;	//2016-01-01
		public String benefitPlanId;	//M000000023
		public String benefitPlanName;	//CTLG DIRECT HSA
		public String benefitType;	//ABC
		public String benefitTypeDescription;	//another extended description
		public String coverageLevelCode;	//ABC
		public cls_product product;
		public String relationshipCode;	//001
		public String relationshipDescription;	//SPOUSE/DOMESTIC PARTNER
		public String memberIdCardSerialNumber;	//A1234567
		public String subscriberIdCardSerialNumber;	//S987654
		public String eligibilityStatusCode;	//AAAA
		public String serviceArea;	//NE
		public String cancelReasonTypeCode;	//O
		public String planType;	//H
		public String marketSegment;	//T
		public String stateOfIssueCode;	//ER
		public String fundingArrangementCode;	//ON
		public String fundingArrangementDescription;	//ON TIME
		public String coverageLastUpdateDate;	//2016-01-01
		public String individualGroupTypeCode;	//E
		public cls_indicators indicators;
	}
	public class cls_product {
		public String productIdentifier;	//PM00000001
		public String productName;	//INN ONLY
		public String productType;	//M001
	}
	public class cls_indicators {
		public String erisaIndicator;	//Y
		public String qmscoIndicator;	//Y
		public String onshoreRestrictionIndicator;	//Y
		public String proofOfHealthCoverageIndicator;	//T
		public String dvcnIndicator;	//Y
		public String pcpRequiredIndicator;	//Y
		public String clickToCall;	//Y
		public String clickToChat;	//Y
		public String activationMessaging;	//Y
		public String secureMessaging;	//Y
	}
	public class cls_utilizationPlan {
		public String planId;	//A2345
		public String entityId;	//7890
		public String externalPlanId;	//EXT2345
	}
	public class cls_cob {
		public String cobTypeCode;	//ABB
		public String cobTypeCodeDescription;	//ABB HOSPITAL
		public String custodyCode;	//E
		public String otherInsurancePrimacyIndicator;	//ONSITE
		public String coverageType;	//ALL
		public String cobEffectiveStartDate;	//2016-01-01
		public String cobEffectiveEndDate;	//2016-01-01
		public String otherInsuranceVerifyDate;	//2016-01-01
		public String otherInsurancePolicyNumber;	//A12345
		public String otherInsuranceCardholderId;	//B23456
		public String otherInsuranceCarrierName;	//GARDIAN
		public String cobRelatedEntityContactTelephoneNumber;	//9738909090
	}
	public class cls_providers {
		public cls_providerIdentifiers[] providerIdentifiers;
		public String assignmentType;	//SHARE
		public String effectiveDate;	//2016-01-01
		public String expirationDate;	//2016-01-01
		public String firstName;	//Kelly
		public String lastName;	//Carter
		public String networkId;	//KC010100
		public String networkScheduleId;	//23232
		public String networkScheduleDescription;	//ONSITE
		public String organizationLocationId;	//ERIIII
	}
	public class cls_providerIdentifiers {
		public String id;	//A111
		public String type;	//PRIMARY
	}
	public class cls_clinicalProgram {
		public String clinicalProgramVendor;	//WALGREEN
		public String serviceCategory;	//PHARM
		public String umDetermination;	//YES
	}
	public class cls_carrierType {
		public String carrierId;	//C11111
		public String carrierName;	//GARDIAN
		public String carrierExternalId;	//G2222
		public cls_lob[] lob;
	}
	public class cls_lob {
		public String lineOfBusinessId;	//5343
		public String lineOfBusinessName;	//DENTAL
		public String lineOfBusinessDescription;	//DENTAL OFFICE
	}


}