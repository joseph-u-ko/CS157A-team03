package pokemonInfo;

public class Pack {
	private String packName;
	private int packID;
	private int available;
	private String setCode;
	
	public Pack (String packName, int packID, int available, String setCode){
		this.setPackName(packName);
		this.setPackID(packID);
		this.setAvailable(available);
		this.setSetCode(setCode);
	}
	
	
	public Pack (String packName, int packID, String setCode) {
		this.setPackName(packName);
		this.setPackID(packID);
		this.setSetCode(setCode);
		
	}
	
	public Pack (String packName, int packID) {
		this.setPackName(packName);
		this.setPackID(packID);
	}


	public String getPackName() {
		return packName;
	}


	public void setPackName(String packName) {
		this.packName = packName;
	}


	public int getPackID() {
		return packID;
	}


	public void setPackID(int packID) {
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