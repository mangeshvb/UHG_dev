public class ACETGetIndividualResultJSON2Apex {
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

    public class GetIndividualResponse {
        public Individual individual {get;set;} 

        public GetIndividualResponse(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'individual') {
                            individual = new Individual(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'GetIndividualResponse consuming unrecognized property: '+text);
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
        public String typeCode {get;set;} 
        public String addressLine1 {get;set;} 
        public String addressLine2 {get;set;} 
        public String city {get;set;} 
        public String postalCode {get;set;} 
        public String stateCode {get;set;} 
        public String countryCode {get;set;} 
        public String countryDescription {get;set;} 

        public Address(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'typeCode') {
                            typeCode = parser.getText();
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
                        } else if (text == 'countryDescription') {
                            countryDescription = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Address consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Language {
        public String languageCode {get;set;} 
        public String languageDescription {get;set;} 
        public Integer languageUsedTypeCode {get;set;} 
        public String languageUsedTypeDescription {get;set;} 

        public Language(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'languageCode') {
                            languageCode = parser.getText();
                        } else if (text == 'languageDescription') {
                            languageDescription = parser.getText();
                        } else if (text == 'languageUsedTypeCode') {
                            languageUsedTypeCode = parser.getIntegerValue();
                        } else if (text == 'languageUsedTypeDescription') {
                            languageUsedTypeDescription = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Language consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public GetIndividualResponse getIndividualResponse {get;set;} 

    public ACETGetIndividualResultJSON2Apex(JSONParser parser) {
        while (parser.nextToken() != JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != JSONToken.VALUE_NULL) {
                    if (text == 'getIndividualResponse') {
                        getIndividualResponse = new GetIndividualResponse(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Employment {
        public String employmentStatus {get;set;} 
        public Integer employeeIdentifier {get;set;} 
        public String employmentStartDate {get;set;} 
        public String retirementDate {get;set;} 

        public Employment(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'employmentStatus') {
                            employmentStatus = parser.getText();
                        } else if (text == 'employeeIdentifier') {
                            employeeIdentifier = parser.getIntegerValue();
                        } else if (text == 'employmentStartDate') {
                            employmentStartDate = parser.getText();
                        } else if (text == 'retirementDate') {
                            retirementDate = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Employment consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Name_Z {
        public String firstName {get;set;} 
        public String lastName {get;set;} 
        public String middleName {get;set;} 
        public String nameSuffix {get;set;} 

        public Name_Z(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'firstName') {
                            firstName = parser.getText();
                        } else if (text == 'lastName') {
                            lastName = parser.getText();
                        } else if (text == 'middleName') {
                            middleName = parser.getText();
                        } else if (text == 'nameSuffix') {
                            nameSuffix = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Name_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Phone {
        public String phoneType {get;set;} 
        public Long phoneNumber {get;set;} 
        public Integer phoneExt {get;set;} 
        public String internationalIndicator {get;set;} 
        public String primaryIndicator {get;set;} 

        public Phone(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'phoneType') {
                            phoneType = parser.getText();
                        } else if (text == 'phoneNumber') {
                            phoneNumber = parser.getLongValue();
                        } else if (text == 'phoneExt') {
                            phoneExt = parser.getIntegerValue();
                        } else if (text == 'internationalIndicator') {
                            internationalIndicator = parser.getText();
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
    
    public class Individual {
        public Integer individualIdentifier {get;set;} 
        public Name name {get;set;} 
        public String birthDate {get;set;} 
        public String genderCode {get;set;} 
        public String genderDescription {get;set;} 
        public Integer socialSecurityNumber {get;set;} 
        public String maritalStatusCode {get;set;} 
        public String maritalStatusDescription {get;set;} 
        public String deceasedDate {get;set;} 
        public Integer relationshipCode {get;set;} 
        public String relationshipDescription {get;set;} 
        public String privacyIndicator {get;set;} 
        public String tobaccoUsageIndicator {get;set;} 
        public String ethnicityCode {get;set;} 
        public String ethnicityDescription {get;set;} 
        public List<Address> address {get;set;} 
        public List<Phone> phone {get;set;} 
        public List<Email> email {get;set;} 
        public List<Employment> employment {get;set;} 
        public List<Language> language {get;set;} 
        public List<OtherContact> otherContact {get;set;} 
        public List<Identifiers> identifiers {get;set;} 

        public Individual(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'individualIdentifier') {
                            individualIdentifier = parser.getIntegerValue();
                        } else if (text == 'name') {
                            name = new Name(parser);
                        } else if (text == 'birthDate') {
                            birthDate = parser.getText();
                        } else if (text == 'genderCode') {
                            genderCode = parser.getText();
                        } else if (text == 'genderDescription') {
                            genderDescription = parser.getText();
                        } else if (text == 'socialSecurityNumber') {
                            socialSecurityNumber = parser.getIntegerValue();
                        } else if (text == 'maritalStatusCode') {
                            maritalStatusCode = parser.getText();
                        } else if (text == 'maritalStatusDescription') {
                            maritalStatusDescription = parser.getText();
                        } else if (text == 'deceasedDate') {
                            deceasedDate = parser.getText();
                        } else if (text == 'relationshipCode') {
                            relationshipCode = parser.getIntegerValue();
                        } else if (text == 'relationshipDescription') {
                            relationshipDescription = parser.getText();
                        } else if (text == 'privacyIndicator') {
                            privacyIndicator = parser.getText();
                        } else if (text == 'tobaccoUsageIndicator') {
                            tobaccoUsageIndicator = parser.getText();
                        } else if (text == 'ethnicityCode') {
                            ethnicityCode = parser.getText();
                        } else if (text == 'ethnicityDescription') {
                            ethnicityDescription = parser.getText();
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
                        } else if (text == 'employment') {
                            employment = new List<Employment>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                employment.add(new Employment(parser));
                            }
                        } else if (text == 'language') {
                            language = new List<Language>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                language.add(new Language(parser));
                            }
                        } else if (text == 'otherContact') {
                            otherContact = new List<OtherContact>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                otherContact.add(new OtherContact(parser));
                            }
                        } else if (text == 'identifiers') {
                            identifiers = new List<Identifiers>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                identifiers.add(new Identifiers(parser));
                            }
                        } else {
                            System.debug(LoggingLevel.WARN, 'Individual consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Identifiers {
        public Integer id {get;set;} 
        public String type_Z {get;set;} // in json: type

        public Identifiers(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getIntegerValue();
                        } else if (text == 'type') {
                            type_Z = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Identifiers consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class OtherContact {
        public Name_Z name {get;set;} 
        public String relationshipType {get;set;} 
        public Address address {get;set;} 
        public Email electronicContact {get;set;} 

        public OtherContact(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = new Name_Z(parser);
                        } else if (text == 'relationshipType') {
                            relationshipType = parser.getText();
                        } else if (text == 'address') {
                            address = new Address(parser);
                        } else if (text == 'electronicContact') {
                            electronicContact = new Email(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'OtherContact consuming unrecognized property: '+text);
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
    
    
    public static ACETGetIndividualResultJSON2Apex parse(String json) {
        return new ACETGetIndividualResultJSON2Apex(System.JSON.createParser(json));
    }
}