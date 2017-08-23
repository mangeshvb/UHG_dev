public with sharing class ACETClaimJsonSerialization {
    public static void consumeObject(JSONParser parser) {
		Integer depth = 0;
		do {
			JSONToken curr = parser.getCurrentToken();
			if (curr == JSONToken.START_OBJECT || 
				curr == JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == JSONToken.END_OBJECT ||
				curr == JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}

	public class OtherIdentifier {
		public EligibilityRelationshipCode otherIdentifierTypeCode {get;set;} 
		public EmployeeId otherId {get;set;} 

		public OtherIdentifier(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'otherIdentifierTypeCode') {
							otherIdentifierTypeCode = new EligibilityRelationshipCode(parser);
						} else if (text == 'otherId') {
							otherId = new EmployeeId(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'OtherIdentifier consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Tin_Y {
		public Tin_Z tin {get;set;} 

		public Tin_Y(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'tin') {
							tin = new Tin_Z(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Tin_Y consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Organization {
		public List<TinOwner> tinOwner {get;set;} 
		public String name {get;set;} 

		public Organization(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'tinOwner') {
							tinOwner = new List<TinOwner>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								tinOwner.add(new TinOwner(parser));
							}
						} else if (text == 'name') {
							name = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Organization consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ClaimAccumulator {
		public FinalPaymentAmount accumulatorAmount {get;set;} 
		public FinalPaymentAmount accumulatorPlanAmount {get;set;} 
		public FinalPaymentAmount accumulatorYearToDateAmount {get;set;} 

		public ClaimAccumulator(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'accumulatorAmount') {
							accumulatorAmount = new FinalPaymentAmount(parser);
						} else if (text == 'accumulatorPlanAmount') {
							accumulatorPlanAmount = new FinalPaymentAmount(parser);
						} else if (text == 'accumulatorYearToDateAmount') {
							accumulatorYearToDateAmount = new FinalPaymentAmount(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'ClaimAccumulator consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Tin_Z {
		public EligibilityRelationshipCode typeCode {get;set;} 

		public Tin_Z(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'typeCode') {
							typeCode = new EligibilityRelationshipCode(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Tin_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Npi {
		public EmployeeId nationalProviderId {get;set;} 

		public Npi(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'nationalProviderId') {
							nationalProviderId = new EmployeeId(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Npi consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ClaimServiceDateRange {
		public String startDate {get;set;} 
		public String stopDate {get;set;} 

		public ClaimServiceDateRange(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'startDate') {
							startDate = parser.getText();
						} else if (text == 'stopDate') {
							stopDate = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ClaimServiceDateRange consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class BillingProvider {
		public String participatingStatusIndicator {get;set;} 
		public Organization organization {get;set;} 
		public Professional professional {get;set;} 
		public List<ServiceProvider> serviceProvider {get;set;} 

		public BillingProvider(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'participatingStatusIndicator') {
							participatingStatusIndicator = parser.getText();
						} else if (text == 'organization') {
							organization = new Organization(parser);
						} else if (text == 'professional') {
							professional = new Professional(parser);
						} else if (text == 'serviceProvider') {
							serviceProvider = new List<ServiceProvider>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								serviceProvider.add(new ServiceProvider(parser));
							}
						} else {
							System.debug(LoggingLevel.WARN, 'BillingProvider consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class OtherIdentifier_Z {
		public OtherId otherId {get;set;} 

		public OtherIdentifier_Z(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'otherId') {
							otherId = new OtherId(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'OtherIdentifier_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class DiagnosisRelatedGroup {
		public CoverageTypeCode code {get;set;} 

		public DiagnosisRelatedGroup(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'code') {
							code = new CoverageTypeCode(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'DiagnosisRelatedGroup consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class DiagnosisCodeOidId {
		public String codeValueId {get;set;} 
		public String codeDescription {get;set;} 

		public DiagnosisCodeOidId(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'codeValueId') {
							codeValueId = parser.getText();
						} else if (text == 'codeDescription') {
							codeDescription = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'DiagnosisCodeOidId consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class OtherId {
		public String sourceSysCode {get;set;} 
		public String id {get;set;} 

		public OtherId(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'sourceSysCode') {
							sourceSysCode = parser.getText();
						} else if (text == 'id') {
							id = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'OtherId consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class FinalPaymentAmount {
		public String value {get;set;} 

		public FinalPaymentAmount(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'value') {
							value = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'FinalPaymentAmount consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class OtherIndividualId {
		public String code {get;set;} 
		public String sourceSysCode {get;set;} 
		public String id {get;set;} 

		public OtherIndividualId(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'code') {
							code = parser.getText();
						} else if (text == 'sourceSysCode') {
							sourceSysCode = parser.getText();
						} else if (text == 'id') {
							id = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'OtherIndividualId consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Name {
		public String firstName {get;set;} 
		public String lastName {get;set;} 

		public Name(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'firstName') {
							firstName = parser.getText();
						} else if (text == 'lastName') {
							lastName = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Name consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Employment {
		public EmployeeId employeeId {get;set;} 

		public Employment(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'employeeId') {
							employeeId = new EmployeeId(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Employment consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class OtherIdentifiers {
		public String code {get;set;} 
		public String id {get;set;} 

		public OtherIdentifiers(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'code') {
							code = parser.getText();
						} else if (text == 'id') {
							id = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'OtherIdentifiers consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Membership {
		public EmployeeId customerAccountId {get;set;} 
		public EligibilityRelationshipCode eligibilityRelationshipCode {get;set;} 

		public Membership(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'customerAccountId') {
							customerAccountId = new EmployeeId(parser);
						} else if (text == 'eligibilityRelationshipCode') {
							eligibilityRelationshipCode = new EligibilityRelationshipCode(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Membership consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class EffectiveDateRange {
		public String startDate {get;set;} 
		public String startTime {get;set;} 

		public EffectiveDateRange(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'startDate') {
							startDate = parser.getText();
						} else if (text == 'startTime') {
							startTime = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'EffectiveDateRange consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class EmployeeId {
		public String id {get;set;} 

		public EmployeeId(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'EmployeeId consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class EffectiveDateRange_Z {
		public EffectiveDateRange effectiveDateRange {get;set;} 
		public String code {get;set;} 

		public EffectiveDateRange_Z(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'effectiveDateRange') {
							effectiveDateRange = new EffectiveDateRange(parser);
						} else if (text == 'code') {
							code = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'EffectiveDateRange_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ClaimTransactionDetail {
		public OtherIndividualId otherIndividualId {get;set;} 
		public SubscriberIndividual subscriberIndividual {get;set;} 
		public PatientIndividual patientIndividual {get;set;} 
		public BillingProvider billingProvider {get;set;} 
		public RenderingProvider renderingProvider {get;set;} 
		public ClaimAuthorization claimAuthorization {get;set;} 
		public CoverageTypeCode coverageTypeCode {get;set;} 
		public List<Payment> payment {get;set;} 
		public String inNetworkIndicator {get;set;} 
		public FinalPaymentAmount totalCoPayAmount {get;set;} 
		public FinalPaymentAmount totalNotCoveredAmount {get;set;} 
		public String remittanceAdviceRemarkCodeCountValue {get;set;} 
		public EligibilityRelationshipCode remittanceAdvice {get;set;} 
		public CoverageTypeCode claimSubmittedMethodCode {get;set;} 
		public CoverageTypeCode fundingTypeCode {get;set;} 
		public String claimAdjustmentIndicator {get;set;} 
		public String capitationIndicator {get;set;} 
		public List<CoverageTypeCode> claimRemarkCode {get;set;} 
		public CoverageTypeCode institutionProfessionalCode {get;set;} 
		public String phiRestrictionIndicator {get;set;} 
		public EligibilityRelationshipCode submissionClarificationCode {get;set;} 
		public EffectiveDateRange_Z effectiveDateRange {get;set;} 
		public EligibilityRelationshipCode serviceLevelCode {get;set;} 
		public CoverageTypeCode claimTransactionTypeCode {get;set;} 
		public String originalPayerClaimNumber {get;set;} 
		public CoverageTypeCode adjudicationPlatformCode {get;set;} 
		public String patientAccountNumber {get;set;} 
		public EligibilityRelationshipCode claimBillTypeCode {get;set;} 
		public BirthDate claimReceiptDate {get;set;} 
		public FinalPaymentAmount totalBilledChargeAmount {get;set;} 
		public FinalPaymentAmount totalPatientPaidAmount {get;set;} 
		public FinalPaymentAmount totalClaimPaidAmount {get;set;} 
		public FinalPaymentAmount totalPatientResponsibilityAmount {get;set;} 
		public EmployeeId billingProviderId {get;set;} 
		public FinalPaymentAmount totalClaimDeductibleAmount {get;set;} 
		public ClaimServiceDateRange claimServiceDateRange {get;set;} 
		public CoverageTypeCode statusCode {get;set;} 
		public DiagnosisRelatedGroup diagnosisRelatedGroup {get;set;} 
		public List<TransactionAdjustment> transactionAdjustment {get;set;} 
		public List<DiagnosisCode> diagnosisCode {get;set;} 
		public List<HeaderMsg> procedureCode {get;set;} 
		public List<HeaderMsg> serviceProvider {get;set;} 
		public List<HeaderMsg> referringProvider {get;set;} 
		public HeaderMsg capitatedProvider {get;set;} 
		public List<ClaimAccumulator> claimAccumulator {get;set;} 

		public ClaimTransactionDetail(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'otherIndividualId') {
							otherIndividualId = new OtherIndividualId(parser);
						} else if (text == 'subscriberIndividual') {
							subscriberIndividual = new SubscriberIndividual(parser);
						} else if (text == 'patientIndividual') {
							patientIndividual = new PatientIndividual(parser);
						} else if (text == 'billingProvider') {
							billingProvider = new BillingProvider(parser);
						} else if (text == 'renderingProvider') {
							renderingProvider = new RenderingProvider(parser);
						} else if (text == 'claimAuthorization') {
							claimAuthorization = new ClaimAuthorization(parser);
						} else if (text == 'coverageTypeCode') {
							coverageTypeCode = new CoverageTypeCode(parser);
						} else if (text == 'payment') {
							payment = new List<Payment>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								payment.add(new Payment(parser));
							}
						} else if (text == 'inNetworkIndicator') {
							inNetworkIndicator = parser.getText();
						} else if (text == 'totalCoPayAmount') {
							totalCoPayAmount = new FinalPaymentAmount(parser);
						} else if (text == 'totalNotCoveredAmount') {
							totalNotCoveredAmount = new FinalPaymentAmount(parser);
						} else if (text == 'remittanceAdviceRemarkCodeCountValue') {
							remittanceAdviceRemarkCodeCountValue = parser.getText();
						} else if (text == 'remittanceAdvice') {
							remittanceAdvice = new EligibilityRelationshipCode(parser);
						} else if (text == 'claimSubmittedMethodCode') {
							claimSubmittedMethodCode = new CoverageTypeCode(parser);
						} else if (text == 'fundingTypeCode') {
							fundingTypeCode = new CoverageTypeCode(parser);
						} else if (text == 'claimAdjustmentIndicator') {
							claimAdjustmentIndicator = parser.getText();
						} else if (text == 'capitationIndicator') {
							capitationIndicator = parser.getText();
						} else if (text == 'claimRemarkCode') {
							claimRemarkCode = new List<CoverageTypeCode>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								claimRemarkCode.add(new CoverageTypeCode(parser));
							}
						} else if (text == 'institutionProfessionalCode') {
							institutionProfessionalCode = new CoverageTypeCode(parser);
						} else if (text == 'phiRestrictionIndicator') {
							phiRestrictionIndicator = parser.getText();
						} else if (text == 'submissionClarificationCode') {
							submissionClarificationCode = new EligibilityRelationshipCode(parser);
						} else if (text == 'effectiveDateRange') {
							effectiveDateRange = new EffectiveDateRange_Z(parser);
						} else if (text == 'serviceLevelCode') {
							serviceLevelCode = new EligibilityRelationshipCode(parser);
						} else if (text == 'claimTransactionTypeCode') {
							claimTransactionTypeCode = new CoverageTypeCode(parser);
						} else if (text == 'originalPayerClaimNumber') {
							originalPayerClaimNumber = parser.getText();
						} else if (text == 'adjudicationPlatformCode') {
							adjudicationPlatformCode = new CoverageTypeCode(parser);
						} else if (text == 'patientAccountNumber') {
							patientAccountNumber = parser.getText();
						} else if (text == 'claimBillTypeCode') {
							claimBillTypeCode = new EligibilityRelationshipCode(parser);
						} else if (text == 'claimReceiptDate') {
							claimReceiptDate = new BirthDate(parser);
						} else if (text == 'totalBilledChargeAmount') {
							totalBilledChargeAmount = new FinalPaymentAmount(parser);
						} else if (text == 'totalPatientPaidAmount') {
							totalPatientPaidAmount = new FinalPaymentAmount(parser);
						} else if (text == 'totalClaimPaidAmount') {
							totalClaimPaidAmount = new FinalPaymentAmount(parser);
						} else if (text == 'totalPatientResponsibilityAmount') {
							totalPatientResponsibilityAmount = new FinalPaymentAmount(parser);
						} else if (text == 'billingProviderId') {
							billingProviderId = new EmployeeId(parser);
						} else if (text == 'totalClaimDeductibleAmount') {
							totalClaimDeductibleAmount = new FinalPaymentAmount(parser);
						} else if (text == 'claimServiceDateRange') {
							claimServiceDateRange = new ClaimServiceDateRange(parser);
						} else if (text == 'statusCode') {
							statusCode = new CoverageTypeCode(parser);
						} else if (text == 'diagnosisRelatedGroup') {
							diagnosisRelatedGroup = new DiagnosisRelatedGroup(parser);
						} else if (text == 'transactionAdjustment') {
							transactionAdjustment = new List<TransactionAdjustment>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								transactionAdjustment.add(new TransactionAdjustment(parser));
							}
						} else if (text == 'diagnosisCode') {
							diagnosisCode = new List<DiagnosisCode>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								diagnosisCode.add(new DiagnosisCode(parser));
							}
						} else if (text == 'procedureCode') {
							procedureCode = new List<HeaderMsg>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								procedureCode.add(new HeaderMsg(parser));
							}
						} else if (text == 'serviceProvider') {
							serviceProvider = new List<HeaderMsg>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								serviceProvider.add(new HeaderMsg(parser));
							}
						} else if (text == 'referringProvider') {
							referringProvider = new List<HeaderMsg>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								referringProvider.add(new HeaderMsg(parser));
							}
						} else if (text == 'capitatedProvider') {
							capitatedProvider = new HeaderMsg(parser);
						} else if (text == 'claimAccumulator') {
							claimAccumulator = new List<ClaimAccumulator>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								claimAccumulator.add(new ClaimAccumulator(parser));
							}
						} else {
							System.debug(LoggingLevel.WARN, 'ClaimTransactionDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Body {
		public List<Claim> claim {get;set;} 

		public Body(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'claim') {
							claim = new List<Claim>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								claim.add(new Claim(parser));
							}
						} else {
							System.debug(LoggingLevel.WARN, 'Body consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CoverageTypeCode {
		public String code {get;set;} 
		public String desc_Z {get;set;} // in json: desc

		public CoverageTypeCode(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'code') {
							code = parser.getText();
						} else if (text == 'desc') {
							desc_Z = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'CoverageTypeCode consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Professional_Z {
		public List<Npi> npi {get;set;} 
		public List<OtherIdentifier_Z> otherIdentifier {get;set;} 
		public String lastName {get;set;} 
		public String firstName {get;set;} 

		public Professional_Z(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'npi') {
							npi = new List<Npi>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								npi.add(new Npi(parser));
							}
						} else if (text == 'otherIdentifier') {
							otherIdentifier = new List<OtherIdentifier_Z>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								otherIdentifier.add(new OtherIdentifier_Z(parser));
							}
						} else if (text == 'lastName') {
							lastName = parser.getText();
						} else if (text == 'firstName') {
							firstName = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Professional_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public GetClaimResult getClaimResult {get;set;} 

	public ACETClaimJsonSerialization(JSONParser parser) {
		while (parser.nextToken() != JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != JSONToken.VALUE_NULL) {
					if (text == 'getClaimResult') {
						getClaimResult = new GetClaimResult(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class DiagnosisCode {
		public String sequenceNumber {get;set;} 
		public DiagnosisCodeOidId diagnosisCodeOidId {get;set;} 
		public EligibilityRelationshipCode levelTypeCode {get;set;} 
		public String presentOnAdmissionsIndicator {get;set;} 

		public DiagnosisCode(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'sequenceNumber') {
							sequenceNumber = parser.getText();
						} else if (text == 'diagnosisCodeOidId') {
							diagnosisCodeOidId = new DiagnosisCodeOidId(parser);
						} else if (text == 'levelTypeCode') {
							levelTypeCode = new EligibilityRelationshipCode(parser);
						} else if (text == 'presentOnAdmissionsIndicator') {
							presentOnAdmissionsIndicator = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'DiagnosisCode consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class PatientIndividual {
		public List<OtherIdentifiers> otherIdentifiers {get;set;} 
		public List<Membership_Z> membership {get;set;} 
		public Name name {get;set;} 
		public BirthDate birthDate {get;set;} 

		public PatientIndividual(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'otherIdentifiers') {
							otherIdentifiers = new List<OtherIdentifiers>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								otherIdentifiers.add(new OtherIdentifiers(parser));
							}
						} else if (text == 'membership') {
							membership = new List<Membership_Z>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								membership.add(new Membership_Z(parser));
							}
						} else if (text == 'name') {
							name = new Name(parser);
						} else if (text == 'birthDate') {
							birthDate = new BirthDate(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'PatientIndividual consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class TransactionAdjustment {
		public EligibilityRelationshipCode reasonCode {get;set;} 

		public TransactionAdjustment(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'reasonCode') {
							reasonCode = new EligibilityRelationshipCode(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'TransactionAdjustment consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class EligibilityRelationshipCode {
		public String code {get;set;} 

		public EligibilityRelationshipCode(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'code') {
							code = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'EligibilityRelationshipCode consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class TinOwner {
		public Tin tin {get;set;} 

		public TinOwner(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'tin') {
							tin = new Tin(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'TinOwner consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class RenderingProvider {
		public String participatingStatusIndicator {get;set;} 
		public EmployeeId providerId {get;set;} 
		public Organization organization {get;set;} 
		public Professional_Z professional {get;set;} 

		public RenderingProvider(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'participatingStatusIndicator') {
							participatingStatusIndicator = parser.getText();
						} else if (text == 'providerId') {
							providerId = new EmployeeId(parser);
						} else if (text == 'organization') {
							organization = new Organization(parser);
						} else if (text == 'professional') {
							professional = new Professional_Z(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'RenderingProvider consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ClaimAuthorization {
		public String number_Z {get;set;} // in json: number

		public ClaimAuthorization(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'number') {
							number_Z = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ClaimAuthorization consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class GetClaimResult {
		public GetClaimResponse getClaimResponse {get;set;} 

		public GetClaimResult(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'getClaimResponse') {
							getClaimResponse = new GetClaimResponse(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'GetClaimResult consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class HeaderMsg {

		public HeaderMsg(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'HeaderMsg consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Payment {
		public CoverageTypeCode paymentMethodCode {get;set;} 
		public EmployeeId seriesDesignatorId {get;set;} 
		public EmployeeId paymentTrackingNumberId {get;set;} 
		public FinalPaymentAmount finalPaymentAmount {get;set;} 
		public BirthDate paymentSendDate {get;set;} 

		public Payment(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'paymentMethodCode') {
							paymentMethodCode = new CoverageTypeCode(parser);
						} else if (text == 'seriesDesignatorId') {
							seriesDesignatorId = new EmployeeId(parser);
						} else if (text == 'paymentTrackingNumberId') {
							paymentTrackingNumberId = new EmployeeId(parser);
						} else if (text == 'finalPaymentAmount') {
							finalPaymentAmount = new FinalPaymentAmount(parser);
						} else if (text == 'paymentSendDate') {
							paymentSendDate = new BirthDate(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Payment consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Professional {
		public List<Npi> npi {get;set;} 
		public List<OtherIdentifier> otherIdentifier {get;set;} 
		public String lastName {get;set;} 
		public String firstName {get;set;} 

		public Professional(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'npi') {
							npi = new List<Npi>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								npi.add(new Npi(parser));
							}
						} else if (text == 'otherIdentifier') {
							otherIdentifier = new List<OtherIdentifier>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								otherIdentifier.add(new OtherIdentifier(parser));
							}
						} else if (text == 'lastName') {
							lastName = parser.getText();
						} else if (text == 'firstName') {
							firstName = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Professional consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Membership_Z {
		public EligibilityRelationshipCode eligibilityRelationshipCode {get;set;} 

		public Membership_Z(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'eligibilityRelationshipCode') {
							eligibilityRelationshipCode = new EligibilityRelationshipCode(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Membership_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ServiceProvider {
		public Tin_Y tin {get;set;} 

		public ServiceProvider(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'tin') {
							tin = new Tin_Y(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'ServiceProvider consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Tin {
		public String taxIdNbr {get;set;} 

		public Tin(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'taxIdNbr') {
							taxIdNbr = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Tin consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class GetClaimResponse {
		public HeaderMsg headerMsg {get;set;} 
		public Body body {get;set;} 

		public GetClaimResponse(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'headerMsg') {
							headerMsg = new HeaderMsg(parser);
						} else if (text == 'body') {
							body = new Body(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'GetClaimResponse consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class SubscriberIndividual {
		public List<Employment> employment {get;set;} 
		public List<Membership> membership {get;set;} 
		public Name name {get;set;} 

		public SubscriberIndividual(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'employment') {
							employment = new List<Employment>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								employment.add(new Employment(parser));
							}
						} else if (text == 'membership') {
							membership = new List<Membership>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								membership.add(new Membership(parser));
							}
						} else if (text == 'name') {
							name = new Name(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'SubscriberIndividual consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Claim {
		public ClaimTransactionDetail claimTransactionDetail {get;set;} 

		public Claim(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'claimTransactionDetail') {
							claimTransactionDetail = new ClaimTransactionDetail(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Claim consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class BirthDate {
		public String birthdate {get;set;} 

		public BirthDate(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'date') {
							birthdate = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'BirthDate consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static ACETClaimJsonSerialization parse(String json) {
		return new ACETClaimJsonSerialization(System.JSON.createParser(json));
	}
}