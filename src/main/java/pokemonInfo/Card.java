package pokemonInfo;

public class Card {
	private int cardID;
	private String cardName;
	private String cardType;
	private String subType;
	private String rarity;
	private String imageLink;
	private int quantity;
	private String setName;
	
	
	public Card(int cardID, String cardName, String cardType, String subType, String rarity, String imageLink, int quantity, String setName) {
	this.setCardID(cardID);
	this.setCardName(cardName);
	this.setCardType(cardType);
	this.setSubType(subType);
	this.setRarity(rarity);
	this.setImageLink(imageLink);
	this.setQuantity(quantity);
	this.setSetName(setName);
}


	public String getCardName() {
		return cardName;
	}


	public void setCardName(String cardName) {
		this.cardName = cardName;
	}


	public String getCardType() {
		return cardType;
	}


	public void setCardType(String cardType) {
		this.cardType = cardType;
	}


	public String getSubType() {
		return subType;
	}


	public void setSubType(String subType) {
		this.subType = subType;
	}


	public String getRarity() {
		return rarity;
	}


	public void setRarity(String rarity) {
		this.rarity = rarity;
	}


	public String getImageLink() {
		return imageLink;
	}


	public void setImageLink(String imageLink) {
		this.imageLink = imageLink;
	}


	public int getQuantity() {
		return quantity;
	}


	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}


	public String getSetName() {
		return setName;
	}


	public void setSetName(String setName) {
		this.setName = setName;
	}


	public int getCardID() {
		return cardID;
	}


	public void setCardID(int cardID) {
		this.cardID = cardID;
	}
}