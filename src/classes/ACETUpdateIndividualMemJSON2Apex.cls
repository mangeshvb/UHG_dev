public class ACETUpdateIndividualMemJSON2Apex {
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

	public class IndividualMembership {
		public Integer groupNumber {get;set;} 
		public Long memberIDCardSerialNumber {get;set;} 
		public String subscriberIDCardSerialNumber {get;set;} 
		public Name name {get;set;} 
		public Integer socialSecurityNumber {get;set;} 
		public String cpTIN {get;set;} 
		public String gender {get;set;} 
		public String birthDate {get;set;} 
		public List<Address> address {get;set;} 
		public List<Phone> phone {get;set;} 
		public List<Email> email {get;set;} 
		public List<Cob> cob {get;set;} 
		public List<Providers> providers {get;set;} 

		public IndividualMembership(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'groupNumber') {
							groupNumber = parser.getIntegerValue();
						} else if (text == 'memberIDCardSerialNumber') {
							memberIDCardSerialNumber = parser.getLongValue();
						} else if (text == 'subscriberIDCardSerialNumber') {
							subscriberIDCardSerialNumber = parser.getText();
						} else if (text == 'name') {
							name = new Name(parser);
						} else if (text == 'socialSecurityNumber') {
							socialSecurityNumber = parser.getIntegerValue();
						} else if (text == 'cpTIN') {
							cpTIN = parser.getText();
						} else if (text == 'gender') {
							gender = parser.getText();
						} else if (text == 'birthDate') {
							birthDate = parser.getText();
						} else if (text == 'address') {
							address = new List<Address>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								address.add(new Address(parser));
							}
						} else if (text == 'phone') {
							phone = new List<Phone>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								phone.add(new Phone(parser));
							}
						} else if (text == 'email') {
							email = new List<Email>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								email.add(new Email(parser));
							}
						} else if (text == 'cob') {
							cob = new List<Cob>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								cob.add(new Cob(parser));
							}
						} else if (text == 'providers') {
							providers = new List<Providers>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								providers.add(new Providers(parser));
							}
						} else {
							System.debug(LoggingLevel.WARN, 'IndividualMembership consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Email {
		public String communicationTypeCode {get;set;} 
		public String electronicAddress {get;set;} 
		public String primaryIndicator {get;set;} 

		public Email(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'communicationTypeCode') {
							communicationTypeCode = parser.getText();
						} else if (text == 'electronicAddress') {
							electronicAddress = parser.getText();
						} else if (text == 'primaryIndicator') {
							primaryIndicator = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Email consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Address {
		public String addressTypeCode {get;set;} 
		public String effectiveStartDate {get;set;} 
		public String effectiveEndDate {get;set;} 
		public String addressLine1 {get;set;} 
		public String addressLine2 {get;set;} 
		public String city {get;set;} 
		public String postalCode {get;set;} 
		public String stateCode {get;set;} 
		public String countryCode {get;set;} 
		public String countrySubDivisionCode {get;set;} 

		public Address(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'addressTypeCode') {
							addressTypeCode = parser.getText();
						} else if (text == 'effectiveStartDate') {
							effectiveStartDate = parser.getText();
						} else if (text == 'effectiveEndDate') {
							effectiveEndDate = parser.getText();
						} else if (text == 'addressLine1') {
							addressLine1 = parser.getText();
						} else if (text == 'addressLine2') {
							addressLine2 = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'postalCode') {
							postalCode = parser.getText();
						} else if (text == 'stateCode') {
							stateCode = parser.getText();
						} else if (text == 'countryCode') {
							countryCode = parser.getText();
						} else if (text == 'countrySubDivisionCode') {
							countrySubDivisionCode = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Address consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ProviderIdentifiers {
		public String id {get;set;} 
		public String type_Z {get;set;} // in json: type

		public ProviderIdentifiers(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'type') {
							type_Z = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ProviderIdentifiers consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Phone {
		public String phoneType {get;set;} 
		public String phoneNumber {get;set;} 
		public String phoneExt {get;set;} 
		public String primaryIndicator {get;set;} 

		public Phone(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'phoneType') {
							phoneType = parser.getText();
						} else if (text == 'phoneNumber') {
							phoneNumber = parser.getText();
						} else if (text == 'phoneExt') {
							phoneExt = parser.getText();
						} else if (text == 'primaryIndicator') {
							primaryIndicator = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Phone consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Cob {
		public String otherInsuranceIndicator {get;set;} 
		public String relationShipCode {get;set;} 
		public String otherInsuranceCoverageType {get;set;} 
		public String otherInsuranceEffectiveStartDate {get;set;} 
		public String otherInsuranceEndDate {get;set;} 
		public String otherInsuranceVerificationDate {get;set;} 
		public String custodyCode {get;set;} 
		public String otherInsurancePolicyNumber {get;set;} 
		public String otherInsuranceType {get;set;} 
		public String primacyIndicator {get;set;} 
		public String otherInsuranceCardholderFirstName {get;set;} 
		public String otherInsuranceCardholderLastName {get;set;} 
		public String medicareIndicator {get;set;} 
		public List<MedicareEntitlement> medicareEntitlement {get;set;} 

		public Cob(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'otherInsuranceIndicator') {
							otherInsuranceIndicator = parser.getText();
						} else if (text == 'relationShipCode') {
							relationShipCode = parser.getText();
						} else if (text == 'otherInsuranceCoverageType') {
							otherInsuranceCoverageType = parser.getText();
						} else if (text == 'otherInsuranceEffectiveStartDate') {
							otherInsuranceEffectiveStartDate = parser.getText();
						} else if (text == 'otherInsuranceEndDate') {
							otherInsuranceEndDate = parser.getText();
						} else if (text == 'otherInsuranceVerificationDate') {
							otherInsuranceVerificationDate = parser.getText();
						} else if (text == 'custodyCode') {
							custodyCode = parser.getText();
						} else if (text == 'otherInsurancePolicyNumber') {
							otherInsurancePolicyNumber = parser.getText();
						} else if (text == 'otherInsuranceType') {
							otherInsuranceType = parser.getText();
						} else if (text == 'primacyIndicator') {
							primacyIndicator = parser.getText();
						} else if (text == 'otherInsuranceCardholderFirstName') {
							otherInsuranceCardholderFirstName = parser.getText();
						} else if (text == 'otherInsuranceCardholderLastName') {
							otherInsuranceCardholderLastName = parser.getText();
						} else if (text == 'medicareIndicator') {
							medicareIndicator = parser.getText();
						} else if (text == 'medicareEntitlement') {
							medicareEntitlement = new List<MedicareEntitlement>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								medicareEntitlement.add(new MedicareEntitlement(parser));
							}
						} else {
							System.debug(LoggingLevel.WARN, 'Cob consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class UpdateIndividualMembershipRequest {
		public IndividualMembership individualMembership {get;set;} 

		public UpdateIndividualMembershipRequest(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'individualMembership') {
							individualMembership = new IndividualMembership(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'UpdateIndividualMembershipRequest consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Providers {
		public List<ProviderIdentifiers> providerIdentifiers {get;set;} 
		public String assignmentType {get;set;} 
		public String effectiveStartDate {get;set;} 
		public String effectiveEndDate {get;set;} 

		public Providers(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'providerIdentifiers') {
							providerIdentifiers = new List<ProviderIdentifiers>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								providerIdentifiers.add(new ProviderIdentifiers(parser));
							}
						} else if (text == 'assignmentType') {
							assignmentType = parser.getText();
						} else if (text == 'effectiveStartDate') {
							effectiveStartDate = parser.getText();
						} else if (text == 'effectiveEndDate') {
							effectiveEndDate = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Providers consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	/*public ACETUpdateIndividualMemJSON2Apex() {
	
	}*/
		public UpdateIndividualMembershipRequest updateIndividualMembershipRequest {get;set;} 

		public ACETUpdateIndividualMemJSON2Apex(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'updateIndividualMembershipRequest') {
							updateIndividualMembershipRequest = new UpdateIndividualMembershipRequest(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'ACETUpdateIndividualMemJSON2Apex consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	
	
	public class Name {
		public String lastName {get;set;} 
		public String firstName {get;set;} 
		public String middleName {get;set;} 
		public String nameSuffix {get;set;} 

		public Name(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'lastName') {
							lastName = parser.getText();
						} else if (text == 'firstName') {
							firstName = parser.getText();
						} else if (text == 'middleName') {
							middleName = parser.getText();
						} else if (text == 'nameSuffix') {
							nameSuffix = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Name consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class MedicareEntitlement {
		public String entitlementType {get;set;} 
		public String effectiveDate {get;set;} 
		public String cancellationDate {get;set;} 

		public MedicareEntitlement(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'entitlementType') {
							entitlementType = parser.getText();
						} else if (text == 'effectiveDate') {
							effectiveDate = parser.getText();
						} else if (text == 'cancellationDate') {
							cancellationDate = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'MedicareEntitlement consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static ACETUpdateIndividualMemJSON2Apex parse(String json) {
		return new ACETUpdateIndividualMemJSON2Apex(System.JSON.createParser(json));
	}
}