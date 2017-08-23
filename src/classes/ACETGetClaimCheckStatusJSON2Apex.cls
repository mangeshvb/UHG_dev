public class ACETGetClaimCheckStatusJSON2Apex {
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

	public class GetCheckStatusResponseMsg {
		public Body body {get;set;} 

		public GetCheckStatusResponseMsg(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'body') {
							body = new Body(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'GetCheckStatusResponseMsg consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class SourceSysCode {
		public String code {get;set;} 

		public SourceSysCode(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'code') {
							code = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'SourceSysCode consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CheckStatusCode {
		public String code {get;set;} 
		public String desc_Z {get;set;} // in json: desc

		public CheckStatusCode(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'code') {
							code = parser.getText();
						} else if (text == 'desc') {
							desc_Z = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'CheckStatusCode consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Result result {get;set;} 

	public ACETGetClaimCheckStatusJSON2Apex(JSONParser parser) {
		while (parser.nextToken() != JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != JSONToken.VALUE_NULL) {
					if (text == 'result') {
						result = new Result(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class VoidDate {
		public String voiddate {get;set;} 

		public VoidDate(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'date') {
							voiddate = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'VoidDate consuming unrecognized property: '+text);
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
	
	public class DivisionId {
		public String id {get;set;} 

		public DivisionId(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'DivisionId consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CheckStatusResponse {
		public CheckStatusCode checkStatusCode {get;set;} 
		public VoidDate voidDate {get;set;} 
		public DivisionId divisionId {get;set;} 
		public DivisionId itemId {get;set;} 
		public DivisionId docId {get;set;} 
		public SourceSysCode sourceSysCode {get;set;} 
		public FinalPaymentAmount finalPaymentAmount {get;set;} 
		public DivisionId issuingBankId {get;set;} 
		public DivisionId issuingBankAccountNumberId {get;set;} 
		public VoidDate paymentSendDate {get;set;} 
		public VoidDate paymentFundDate {get;set;} 

		public CheckStatusResponse(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'checkStatusCode') {
							checkStatusCode = new CheckStatusCode(parser);
						} else if (text == 'voidDate') {
							voidDate = new VoidDate(parser);
						} else if (text == 'divisionId') {
							divisionId = new DivisionId(parser);
						} else if (text == 'itemId') {
							itemId = new DivisionId(parser);
						} else if (text == 'docId') {
							docId = new DivisionId(parser);
						} else if (text == 'sourceSysCode') {
							sourceSysCode = new SourceSysCode(parser);
						} else if (text == 'finalPaymentAmount') {
							finalPaymentAmount = new FinalPaymentAmount(parser);
						} else if (text == 'issuingBankId') {
							issuingBankId = new DivisionId(parser);
						} else if (text == 'issuingBankAccountNumberId') {
							issuingBankAccountNumberId = new DivisionId(parser);
						} else if (text == 'paymentSendDate') {
							paymentSendDate = new VoidDate(parser);
						} else if (text == 'paymentFundDate') {
							paymentFundDate = new VoidDate(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'CheckStatusResponse consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Body {
		public List<CheckStatusResponse> checkStatusResponse {get;set;} 

		public Body(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'checkStatusResponse') {
							checkStatusResponse = new List<CheckStatusResponse>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								checkStatusResponse.add(new CheckStatusResponse(parser));
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
	
	public class Result {
		public GetCheckStatusResponseMsg getCheckStatusResponseMsg {get;set;} 

		public Result(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'getCheckStatusResponseMsg') {
							getCheckStatusResponseMsg = new GetCheckStatusResponseMsg(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Result consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static ACETGetClaimCheckStatusJSON2Apex parse(String json) {
		return new ACETGetClaimCheckStatusJSON2Apex(System.JSON.createParser(json));
	}
}