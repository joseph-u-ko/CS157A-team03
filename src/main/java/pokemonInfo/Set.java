package pokemonInfo;

public class Set {
	private String setCode;
	private String setName;
	
	public Set (String setCode, String setName) {
		this.setCode = setCode;
		this.setName = setName;
	}
	public Set (String setCode) {
		this.setCode = setCode;
	}
	
	
	public String getSetCode() {
		return setCode;
	}
	public void setSetCode(String setCode) {
		this.setCode = setCode;
	}
	public String getSetName() {
		return setName;
	}
	public void setSetName(String setName) {
		this.setName = setName;
	}
	
}