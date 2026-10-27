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
        String packShop = "pack-open-dropdowns.jsp";
        String loginPage = "login-and-signup.jsp";
        String username = (String) session.getAttribute("currentUser");
        
        if (session == null ||
                session.getAttribute("currentUser") == null) {
                // User is not authenticated
            	request.setAttribute("sessionError", "Session Error: you have been logged out.");
            	response.sendRedirect(loginPage);
            	return;
            }
        
        String packID = request.getParameter("packID");
        String setCode = request.getParameter("setCode");
        
        // Prepare the SQL statement that opens a pack
        String SQL_getCards = """
                SELECT cardID, cardName, rarity, imageLink
                FROM cards
                WHERE cardID IN (SELECT cardID
                				 FROM contains
                				 WHERE packID = ?)
                """;
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
        	 PreparedStatement statement_consumeTicket = connection.prepareStatement(SQL_consumeTicket)) {
        	if (!(Integer.parseInt(request.getParameter("numTickets")) > 0)) {
        		request.setAttribute("ticketError", "Not enough tickets!");
               	request.getRequestDispatcher(packShop)
           			   .forward(request, response);
               	return;
       		}
        	statement_getCards.setString(1, packID);
    		ArrayList<Card> possibleCards = new ArrayList<>();
    		//Getting the cards
        	try (ResultSet cards = statement_getCards.executeQuery()) {
        		while (cards.next()) {
        			int cardID = cards.getInt("cardID");
        			String cardName = cards.getString("cardName");
        			String rarity = cards.getString("rarity");
        			String imageLink = cards.getString("imageLink");
        			possibleCards.add(new Card(cardID, cardName, null, null, rarity, imageLink, 0, null));
        		}
        	}
	       	int numCards = possibleCards.size();
	      	//pull 11 cards (we won't consider guaranteed energy or pull rates yet)
		    for (int i = 0; i < 11; i++) {
		     	int ind = (int) (Math.random() * numCards);
	       		Card c = possibleCards.get(ind);
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
		    //Fully opened pack
		    statement_consumeTicket.setString(1,  username);
		    statement_consumeTicket.executeUpdate();
		    System.out.println("Ticket consumed.");
		    response.sendRedirect(packShop);
		    return;
        } 
        // General catch-all exception for logout errors
        catch (SQLException e) {
        	e.printStackTrace();
        	request.setAttribute("updateError", "Update Error: " + e.getMessage());
        	request.getRequestDispatcher(packShop)
        		.forward(request, response);
        }
    }
}