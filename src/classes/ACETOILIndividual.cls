public class ACETOILIndividual {
    public String FirstName { get; set; }
	public String LastName { get; set; }
	public Date Birthdate { get; set; }
	public Set<String> SurrogateKeys { get; set; }
	public String EId { get; set; }
	public String Phone { get; set; } 
	
	public ACETOILIndividual() {
		SurrogateKeys = new Set<String>();
	} 	
	
	public ACETOILIndividual(String FirstName, String LastName, Date Birthdate, Set<String> SurrogateKeys, String EId, String Phone) {
		this.FirstName = FirstName;
		this.LastName = LastName;
		this.Birthdate = Birthdate;
		this.SurrogateKeys = SurrogateKeys;
		this.EId = EId;
		this.Phone = Phone;	
	}
}