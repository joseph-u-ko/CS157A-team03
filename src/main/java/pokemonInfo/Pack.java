package pokemonInfo;

public class Pack {
	private String packName;
	private String packID;
	private int available;
	private String setCode;
	
	public Pack (String packName, String packID, int available, String setCode){
		this.setPackName(packName);
		this.setPackID(packID);
		this.setAvailable(available);
		this.setSetCode(setCode);
	}
	
	
	public Pack (String packName, String packID, String setCode) {
		this.setPackName(packName);
		this.setPackID(packID);
		this.setSetCode(setCode);
		
	}
	
	public Pack (String packName, String packID) {
		this.setPackName(packName);
		this.setPackID(packID);
	}


	public String getPackName() {
		return packName;
	}


	public void setPackName(String packName) {
		this.packName = packName;
	}


	public String getPackID() {
		return packID;
	}


	public void setPackID(String packID) {
		this.packID = packID;
	}


	public int getAvailable() {
		return available;
	}


	public void setAvailable(int available) {
		this.available = available;
	}


	public String getSetCode() {
		return setCode;
	}


	public void setSetCode(String setCode) {
		this.setCode = setCode;
	}
}