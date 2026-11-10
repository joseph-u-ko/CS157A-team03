import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pokemonInfo.Card;

@WebServlet("/openPack")
public class PackOpenServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
    private static final String DB_URL = "jdbc:mysql://localhost:3306/poketrader?useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "$apphire9Warrior";

    @Override
    protected void doPost(
    		HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
    	
    	// Get the current session and current user's name
        HttpSession session = request.getSession(false);
        String packShop = "pack-open-menu.jsp";
        String loginPage = "login-and-signup.jsp";
        String packResult = "pack-open-results.jsp";
        
        if (session == null ||
                session.getAttribute("currentUser") == null) {
                // User is not authenticated
	        	HttpSession errorSession = request.getSession(true);
	
	            errorSession.setAttribute(
	                "sessionError",
	                "Session Error: you have been logged out."
	            );
            	response.sendRedirect(loginPage);
            	return;
            }

        String username = (String) session.getAttribute("currentUser");
        String packID = request.getParameter("packID");
        
        // Prepare the SQL statement that opens a pack
        String SQL_getCards = """
                SELECT cardID, cardName, cardType, subType, rarity, imageLink
                FROM cards
                WHERE cardID IN (SELECT cardID
                				 FROM contains
                				 WHERE packID = ?)
                """;
//        String SQL_getRarities = """
//        		SELECT *
//        		FROM rarities
//        		""";
        String SQL_ownsCard = """
        		SELECT quantity
        		FROM owns
        		WHERE username = ? AND cardID = ?
        		""";
        String SQL_addOwnedCards = """
        		UPDATE owns
        		SET quantity = quantity + 1
        		WHERE username = ? AND cardID = ?
        		""";
        String SQL_addUnownedCards = """
        		INSERT INTO owns(username, cardID, quantity) VALUES
        		(?, ?, 1)
        		""";
        String SQL_consumeTicket = """
        		UPDATE users
        		SET tickets = tickets - 1
        		WHERE username = ?
        		""";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        	 PreparedStatement statement_getCards = connection.prepareStatement(SQL_getCards);
//           	 PreparedStatement statement_getRarities = connection.prepareStatement(SQL_getRarities);
        	 PreparedStatement statement_consumeTicket = connection.prepareStatement(SQL_consumeTicket)) {
        	
        	//Attempted to open a pack without any tickets
        	if (!(Integer.parseInt(request.getParameter("numTickets")) > 0)) {
        		request.setAttribute("ticketError", "Not enough tickets!");
               	request.getRequestDispatcher(packShop)
           			   .forward(request, response);
               	return;
       		}
        	
        	//RARITY MAPPING
//    		try (ResultSet rarities = statement_getRarities.executeQuery()) {
//    			Map<String, String> nameToClass = new HashMap<>();
//    			while (rarities.next()) {
//    				String rarityName = rarities.getString("rarityName");
//    				String rarityClass = rarities.getString("rarityClass");
//    				nameToClass.put(rarityName, rarityClass);
//    			}
//    			Card.NAME_TO_CLASS = nameToClass;
//    		}
        	
        	//CARD DATA
        	statement_getCards.setString(1, packID);
//    		ArrayList<Card> possibleCards = new ArrayList<>();
    		ArrayList<Card> commonCards = new ArrayList<>();
    		ArrayList<Card> uncommonCards = new ArrayList<>();
    		ArrayList<Card> holoRareCards = new ArrayList<>();
    		ArrayList<Card> premiumRareCards = new ArrayList<>();
    		ArrayList<Card> chaseRareCards = new ArrayList<>();
    		ArrayList<Card> ultraChaseRareCards = new ArrayList<>();

        	try (ResultSet cards = statement_getCards.executeQuery()) {
        		while (cards.next()) {
        			int cardID = cards.getInt("cardID");
        			String cardName = cards.getString("cardName");
        			String cardType = cards.getString("cardType");
        			String subType = cards.getString("subType");
        			String rarity = cards.getString("rarity");
        			String imageLink = cards.getString("imageLink");
        			Card c = new Card(cardID, cardName, cardType, subType, rarity, imageLink, 0, null);
//        			possibleCards.add(c);
        			if (Card.NAME_TO_CLASS.get(rarity).equals("Common")) commonCards.add(c);
        			else if (Card.NAME_TO_CLASS.get(rarity).equals("Uncommon")) uncommonCards.add(c);
        			else if (Card.NAME_TO_CLASS.get(rarity).equals("Holo/Rare")) holoRareCards.add(c);
        			else if (Card.NAME_TO_CLASS.get(rarity).equals("Premium Rare")) premiumRareCards.add(c);
        			else if (Card.NAME_TO_CLASS.get(rarity).equals("Chase Rare")) chaseRareCards.add(c);
        			else if (Card.NAME_TO_CLASS.get(rarity).equals("Ultra-Chase Rare")) ultraChaseRareCards.add(c);
        		}
        	}
        	
        	//CARD PULLING
//	       	int numCards = possibleCards.size();
        	int numCommon = commonCards.size();
        	int numUncommon = uncommonCards.size();
        	int numHoloRare = holoRareCards.size();
        	int numPremium = premiumRareCards.size();
        	int numChase = chaseRareCards.size();
        	int numUltra = ultraChaseRareCards.size();
	       	ArrayList<Card> pulled = new ArrayList<>();
	       	Random r = new Random();
	       	
	      	//pull 11 cards (we won't consider guaranteed energy or pull rates yet)
		    for (int i = 0; i < 10; i++) {
//		    	int ind = (int) (Math.random() * numCards);
//	       		Card c = possibleCards.get(ind);
		     	Card c = null;
		     	
		     	//RARITY BASED PULLS
		     	//4 commons
	       		if (i < 4) c = commonCards.get(r.nextInt(numCommon));
	       		//3 uncommons
	       		else if (i < 7) c = uncommonCards.get(r.nextInt(numUncommon));
	       		//2 chance holo/rares
	       		else if (i < 9) {
	       			if (r.nextBoolean()) {
	       				if (r.nextBoolean()) c = commonCards.get(r.nextInt(numCommon));
	       				else c = uncommonCards.get(r.nextInt(numUncommon));
	       			}
	       			else c = holoRareCards.get(r.nextInt(numHoloRare));
	       		}
	       		//1 guaranteed holo/rare or rarer
	       		else {
	       			double val = Math.random();
	       			if (val < 0.799) c = holoRareCards.get(r.nextInt(numHoloRare));
	       			else if (val < 0.989) c = premiumRareCards.get(r.nextInt(numPremium));
	       			else if (val < 0.999) c = chaseRareCards.get(r.nextInt(numChase));
	       			else c = ultraChaseRareCards.get(r.nextInt(numUltra));
	       		}
	       		
	       		//DATA UPDATE
	       		pulled.add(c);
	       		//for each card, update the table
		      	try (PreparedStatement statement_ownsCard = connection.prepareStatement(SQL_ownsCard);
		       		 PreparedStatement statement_addOwnedCards = connection.prepareStatement(SQL_addOwnedCards);
		       		 PreparedStatement statement_addUnownedCards = connection.prepareStatement(SQL_addUnownedCards)) {
		       		statement_ownsCard.setString(1, username);
	       			int cardID = c.getCardID();
	       			statement_ownsCard.setInt(2, cardID);
		      		try (ResultSet result3 = statement_ownsCard.executeQuery()) {
		       			if (result3.next()) {
		       				//User already owns a copy of the card (or did and traded it away)
		      					statement_addOwnedCards.setString(1, username);
		      					statement_addOwnedCards.setInt(2, cardID);
		      					statement_addOwnedCards.executeUpdate();
		      				}
		       			else {
		       				//User does not own this card yet!
		      				statement_addUnownedCards.setString(1, username);
		     				statement_addUnownedCards.setInt(2, cardID);
		       				statement_addUnownedCards.executeUpdate();
		       			}
		      		}
		      		System.out.println("Card pulled: " + c.getCardName());
		      	}
		    }
		    
		    //DONE OPENING
		    statement_consumeTicket.setString(1,  username);
		    statement_consumeTicket.executeUpdate();
		    System.out.println("Ticket consumed.");
		    request.setAttribute("cards", pulled);
		    request.getRequestDispatcher(packResult)
		           .forward(request, response);
		    return;
        } 
        // General catch-all exception for logout errors
        catch (SQLException e) {
        	e.printStackTrace();
        	request.setAttribute("updateError", "Update Error: " + e.getMessage());
        	request.getRequestDispatcher(packShop)
        		.forward(request, response);
        	return;
        }
    }
}