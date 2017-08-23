public class ACETWSCalloutResult
{
    public Boolean Success { get; set; }
    public String Message { get; set; }
    public Object Response { get; set; }
    public ApexPages.Severity MessageSeverity { get; set; }
    
    public String pageNumber {get;set;}
    public String pageSize {get;set;}
    public String recordCount {get;set;}
    public String totalCount {get;set;}
    public String totalPages {get;set;}
    
    public Attachment Attach{get;set;}
    
    public ACETWSCalloutResult()
    {
        pageNumber = '0';
        pageSize = '50';
        recordCount = '0';
        totalCount = '0';
        totalPages = '0';
    }
}