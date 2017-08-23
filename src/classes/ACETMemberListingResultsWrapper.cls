public class ACETMemberListingResultsWrapper implements comparable{
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String memberID {get; set;}
    public String relationShip {get; set;}
    public String bundleId {get; set;}
    public String effectiveDate {get; set;}
    public String terminationDate {get; set;}
    public String contractType {get; set;}
    public String billingGroup {get; set;}
    public String status {get; set;}
    public String memberDOB {get; set;}
    public static String SortBy = 'LastName';
    public static String SortOrder = 'Asc';
    
    public ACETMemberListingResultsWrapper() {
    
    }
    
     public Integer compareTo(Object objToCompare){
        ACETMemberListingResultsWrapper memberToCompare = (ACETMemberListingResultsWrapper)objToCompare;        
        if(memberToCompare == null) return 1;
        Integer compareResult = 0;
        if(sortBy == 'LastName'){
            compareResult = (LastName == null? -1 : (LastName.compareTo(memberToCompare.LastName)));  
        }
        return compareResult;
    }
}