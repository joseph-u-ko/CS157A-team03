package pokemonInfo;

import java.util.Map;

public class Card {
	public static final Map<String, String> NAME_TO_CLASS = Map.ofEntries(
	        Map.entry("Common", "Common"),
	        Map.entry("Uncommon", "Uncommon"),

	        Map.entry("Rare", "Holo/Rare"),
	        Map.entry("Rare Holo", "Holo/Rare"),
	        Map.entry("Rare Holo EX", "Holo/Rare"),
	        Map.entry("Rare Holo GX", "Holo/Rare"),
	        Map.entry("Rare Holo LV.X", "Holo/Rare"),
	        Map.entry("Holo Rare V", "Holo/Rare"),
	        Map.entry("Holo Rare VMAX", "Holo/Rare"),
	        Map.entry("Holo Rare VSTAR", "Holo/Rare"),
	        Map.entry("Double Rare", "Holo/Rare"),

	        Map.entry("Amazing Rare", "Premium Rare"),
	        Map.entry("Futuristic Rare", "Premium Rare"),
	        Map.entry("Illustration Rare", "Premium Rare"),
	        Map.entry("MEGA_ATTACK_RARE", "Premium Rare"),
	        Map.entry("Pikachu Rare", "Premium Rare"),
	        Map.entry("Rare BREAK", "Premium Rare"),
	        Map.entry("Rare Prime", "Premium Rare"),
	        Map.entry("Rare Secret", "Premium Rare"),
	        Map.entry("Rare Ultra", "Premium Rare"),
	        Map.entry("Ultra Rare", "Premium Rare"),

	        Map.entry("LEGEND", "Chase Rare"),
	        Map.entry("Special Illustration Rare", "Chase Rare"),
	        Map.entry("Mega Hyper Rare", "Ultra-Chase Rare")
	        );
	private int cardID;
	private String cardName;
	private String cardType;
	private String subType;
	private String rarity;
	private String imageLink;
	private int quantity;
	private String setName;
	
	// Binder
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
	
	// Catalog
	public Card(int cardID, String cardName, String cardType, String subType, String rarity, String imageLink, String setName) {
	this.setCardID(cardID);
	this.setCardName(cardName);
	this.setCardType(cardType);
	this.setSubType(subType);
	this.setRarity(rarity);
	this.setImageLink(imageLink);
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