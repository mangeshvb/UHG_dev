public class ACETGetIndividualJSON2APexADP{
    public cls_getIndividualResponse getIndividualResponse;
    public class cls_getIndividualResponse {
        public cls_individual individual;
    }
    public class cls_individual {
        public String individualIdentifier; //159070131
        public cls_name name;
        public String birthDate;    //1964-11-11
        public String genderCode;   //M
        public String socialSecurityNumber; //792350900
        public String maritalStatusCode;    //
        public String deceasedDate; //
        public String tobaccoUsageIndicator;    //
        public String ethnicityCode;    //
        public cls_address[] address;
        public cls_phone[] phone;
        public cls_email[] email;
        public cls_employment[] employment;
        public cls_language[] language;
        public cls_otherContact[] otherContact;
        public cls_identifiers[] identifiers;
    }
    public class cls_name {
        public String firstName;    //Alice
        public String lastName; //Holmes
        public String middleName;   //
        public String nameSuffix;   //
    }
    public class cls_address {
        public String typeCode; //HOM
        public String addressLine1; //8113 Ramsey Crossing
        public String addressLine2; //
        public String city; //HARTFORD
        public String postalCode;   //06147
        public String stateCode;    //CT
        public String countryCode;  //US
    }
    public  class cls_phone {
        public String phoneType;    //H
        public String phoneNumber;  //321-686-7015
        public String phoneExt; //
        public String internationalIndicator;   //N
        public String primaryIndicator; //N
    }
    public class cls_email {
        public String communicationTypeCode;    //EML
        public String electronicAddress;    //alice@optum.com
        public String primaryIndicator; //N
    }
    public class cls_employment {
        public String employmentStatus; //
        public String employeeIdentifier;   //
        public String employmentStartDate;  //
        public String retirementDate;   //
    }
    public class cls_language {
        public String languageCode; //ENG
        public String languageUsedTypeCode; //8
    }
    public class cls_otherContact {
        public cls_name name;
        public String relationshipType; //9K
        public cls_address address;
        public cls_electronicContact electronicContact;
    }
    public class cls_electronicContact {
        public String electronicAddress;    //powerattor@optum.com
    }
    public class cls_identifiers {
        public String id;   //894666829
        public String type; //SRK
    }

}