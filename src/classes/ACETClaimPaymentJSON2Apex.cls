public class ACETClaimPaymentJSON2Apex {
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

    public class CoverageTypeCode {
        public String code {get;set;} 

        public CoverageTypeCode(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'code') {
                            code = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'CoverageTypeCode consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class PaymentFundDate {
        public String dateTime_z {get;set;} 
        public String PaymentFundDate {get; set;}

        public PaymentFundDate(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'dateTime') {
                            dateTime_z = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'PaymentFundDate consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class OtherClaimId {
        public String id {get;set;} 

        public OtherClaimId(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'OtherClaimId consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Address {
        public String line1 {get;set;} 
        public String line2 {get;set;} 
        public String line3 {get;set;} 
        public String city {get;set;} 
        public CoverageTypeCode state {get;set;} 
        public List<PostalCode> postalCode {get;set;} 

        public Address(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'line1') {
                            line1 = parser.getText();
                        } else if (text == 'line2') {
                            line2 = parser.getText();
                        } else if (text == 'line3') {
                            line3 = parser.getText();
                        } else if (text == 'city') {
                            city = parser.getText();
                        } else if (text == 'state') {
                            state = new CoverageTypeCode(parser);
                        } else if (text == 'postalCode') {
                            postalCode = new List<PostalCode>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                postalCode.add(new PostalCode(parser));
                            }
                        } else {
                            System.debug(LoggingLevel.WARN, 'Address consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public FindClaimPaymentsSummaryResult FindClaimPaymentsSummaryResult {get;set;} 

    public ACETClaimPaymentJSON2Apex(JSONParser parser) {
        while (parser.nextToken() != JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != JSONToken.VALUE_NULL) {
                    if (text == 'FindClaimPaymentsSummaryResult') {
                        FindClaimPaymentsSummaryResult = new FindClaimPaymentsSummaryResult(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
                        consumeObject(parser);
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
        public Name professional {get;set;} 

        public BillingProvider(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'professional') {
                            professional = new Name(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'BillingProvider consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class PostalCode {
        public CoverageTypeCode code {get;set;} 

        public PostalCode(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'code') {
                            code = new CoverageTypeCode(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'PostalCode consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public class PatientIndividual {
        public Name name {get;set;} 

        public PatientIndividual(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = new Name(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'PatientIndividual consuming unrecognized property: '+text);
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
    
    public class ClaimServiceLine {
        public OtherClaimId customerAccountId {get;set;} 

        public ClaimServiceLine(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'customerAccountId') {
                            customerAccountId = new OtherClaimId(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'ClaimServiceLine consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public class CashedDate {
        public String date_z {get;set;} 

        public CashedDate(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'date') {
                            date_z = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'CashedDate consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public class FindClaimPaymentsSummaryResult {
        public FindClaimPaymentSummaryResponseMsg findClaimPaymentSummaryResponseMsg {get;set;} 

        public FindClaimPaymentsSummaryResult(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'findClaimPaymentSummaryResponseMsg') {
                            findClaimPaymentSummaryResponseMsg = new FindClaimPaymentSummaryResponseMsg(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'FindClaimPaymentsSummaryResult consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class FindClaimPaymentSummaryResponseMsg {
        public Body body {get;set;} 

        public FindClaimPaymentSummaryResponseMsg(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'body') {
                            body = new Body(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'FindClaimPaymentSummaryResponseMsg consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class Body {
        public Payments payments {get;set;} 

        public Body(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'payments') {
                            payments = new Payments(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Body consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class Payments {
        public List<Payment> payment {get;set;} 

        public Payments(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'payment') {
                            payment = new List<Payment>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                payment.add(new Payment(parser));
                            }
                        } else {
                            System.debug(LoggingLevel.WARN, 'Payments consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class Payment {
        public List<ClaimTransaction> claimTransaction {get;set;} 
        public CoverageTypeCode paymentMethodCode {get;set;} 
        public CoverageTypeCode payeeTypeCode {get;set;} 
        public OtherClaimId seriesDesignatorId {get;set;} 
        public OtherClaimId paymentTrackingNumberId {get;set;} 
        public FinalPaymentAmount finalPaymentAmount {get;set;} 
        public PaymentFundDate paymentFundDate {get;set;} 
        public CashedDate cashedDate {get;set;} 
        public String payeeName {get;set;} 
        public OtherClaimId draftNumberId {get;set;} 
        public CoverageTypeCode status {get;set;} 
        public List<Address> address {get;set;} 

        public Payment(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'claimTransaction') {
                            claimTransaction = new List<ClaimTransaction>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                claimTransaction.add(new ClaimTransaction(parser));
                            }
                        } else if (text == 'paymentMethodCode') {
                            paymentMethodCode = new CoverageTypeCode(parser);
                        } else if (text == 'payeeTypeCode') {
                            payeeTypeCode = new CoverageTypeCode(parser);
                        } else if (text == 'seriesDesignatorId') {
                            seriesDesignatorId = new OtherClaimId(parser);
                        } else if (text == 'paymentTrackingNumberId') {
                            paymentTrackingNumberId = new OtherClaimId(parser);
                        } else if (text == 'finalPaymentAmount') {
                            finalPaymentAmount = new FinalPaymentAmount(parser);
                        } else if (text == 'paymentFundDate') {
                            paymentFundDate = new PaymentFundDate(parser);
                        } else if (text == 'cashedDate') {
                            cashedDate = new CashedDate(parser);
                        } else if (text == 'payeeName') {
                            payeeName = parser.getText();
                        } else if (text == 'draftNumberId') {
                            draftNumberId = new OtherClaimId(parser);
                        } else if (text == 'status') {
                            status = new CoverageTypeCode(parser);
                        } else if (text == 'address') {
                            address = new List<Address>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                address.add(new Address(parser));
                            }
                        } else {
                            System.debug(LoggingLevel.WARN, 'Payment consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class ClaimTransaction {
        public List<OtherClaimId> otherClaimId {get;set;} 
        public CoverageTypeCode coverageTypeCode {get;set;} 
        public SecurityReason securityReason {get;set;} 
        public PatientIndividual patientIndividual {get;set;} 
        public BillingProvider billingProvider {get;set;} 
        public List<ClaimServiceLine> claimServiceLine {get;set;} 
        public ClaimServiceDateRange claimServiceDateRange {get;set;} 

        public ClaimTransaction(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'otherClaimId') {
                            otherClaimId = new List<OtherClaimId>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                otherClaimId.add(new OtherClaimId(parser));
                            }
                        } else if (text == 'coverageTypeCode') {
                            coverageTypeCode = new CoverageTypeCode(parser);
                        } else if (text == 'securityReason') {
                            securityReason = new SecurityReason(parser);
                        } else if (text == 'patientIndividual') {
                            patientIndividual = new PatientIndividual(parser);
                        } else if (text == 'billingProvider') {
                            billingProvider = new BillingProvider(parser);
                        } else if (text == 'claimServiceLine') {
                            claimServiceLine = new List<ClaimServiceLine>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                claimServiceLine.add(new ClaimServiceLine(parser));
                            }
                        } else if (text == 'claimServiceDateRange') {
                            claimServiceDateRange = new ClaimServiceDateRange(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'ClaimTransaction consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class SecurityReason {
        public String code {get;set;} 
        public String desc_Z {get;set;} // in json: desc

        public SecurityReason(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'code') {
                            code = parser.getText();
                        } else if (text == 'desc') {
                            desc_Z = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'SecurityReason consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public static ACETClaimPaymentJSON2Apex parse(String json) {
        return new ACETClaimPaymentJSON2Apex(System.JSON.createParser(json));
    }
}