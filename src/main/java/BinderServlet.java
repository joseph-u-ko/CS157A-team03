import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pokemonInfo.Card;


@WebServlet("/binder")
public class BinderServlet extends HttpServlet {
	
    private static final long serialVersionUID = 1L;
    
    private static final String DB_URL = "jdbc:mysql://localhost:3306/poketrader?useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Chingloo1234$$";
    
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
    	
    	// Get the current session and current user's name
        HttpSession session = request.getSession(false);
        String binderPage = "binder.jsp";
<<<<<<< Updated upstream
        String loginPage = "login_and_signup.jsp";
=======
        String loginPage = "login-and-signup.jsp";
>>>>>>> Stashed changes
        String username = (String) session.getAttribute("currentUser");
        String card = request.getParameter("cardName");
        
        ArrayList<Card> cardsEntries = new ArrayList<Card>();
        
        // Taken from Isaiah's code (session error) 
        if (session == null ||
                session.getAttribute("currentUser") == null) {
                // User is not authenticated
            	request.setAttribute("sessionError", "Session Error: you have been logged out.");
            	response.sendRedirect(loginPage);
            	return;
            	}
        // Prepare the SQL statement that gets all the Cards a user owns
<<<<<<< Updated upstream
        String sql = """
        		SELECT cards.cardID, cardName, cardType, subType, rarity, imageLink, owns.quantity, setName
        		FROM cards, owns, sets
        		WHERE cards.cardID = owns.cardID AND owns.username = ? AND cards.setCode = sets.setCode AND cardName ILIKE ?
                """;
        
=======
        String SQL_cards = """
        		SELECT cards.*, owns.quantity
        		FROM cards NATURAL JOIN owns
        		WHERE owns.username = ?
                """;
        String filter = " AND cardName LIKE ?";
        //
        boolean conditionForFilter = ((card!=null) && (!(card.equals(""))));
        if (conditionForFilter) {
        	SQL_cards = SQL_cards + filter;
        	
           }        
>>>>>>> Stashed changes
        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                PreparedStatement statement = connection.prepareStatement(sql)) {
                   statement.setString(1, username);
<<<<<<< Updated upstream
                   statement.setString(2, card);
=======
                   if (conditionForFilter) {
                	   String cardREGEX = "%" + card + "%";
                	   System.out.println(cardREGEX);
                	   statement.setString(2, cardREGEX);
                   }
>>>>>>> Stashed changes
                   ResultSet rs = statement.executeQuery();
                   boolean cardsFound = false;
                   while (rs.next()) {
                	   cardsFound = true;
                	   int cardID = rs.getInt(1);
                	   String cardName = rs.getString(2);
                	   String cardType = rs.getString(3);
                	   String subType = rs.getString(4);
                	   String rarity = rs.getString(5);
                	   String imageLink = rs.getString(6);
                	   int quantity = rs.getInt(7);
                	   String setName = rs.getString(8);
                	   cardsEntries.add(new Card(cardID, cardName, cardType, subType, rarity, imageLink, quantity, setName));
                   }
                   
                   if (cardsFound) {
                	   session.setAttribute("cards", cardsEntries);
                       System.out.println("Successfully retrived the cards that " + username + " owns.");
                       session.setAttribute("cardsFound", cardsFound);
                	   
                   }
                   else {
                	   session.setAttribute("cardsFound", cardsFound);
                   }
               
                   rs.close();
                   statement.close();
                   connection.close();
                   response.sendRedirect(binderPage);
                   
        }
        // catch-all exception
        // check in meeting if this should be more specific
        catch (SQLException e) {
        	e.printStackTrace();
        	request.setAttribute("updateError", "Update Error: " + e.getMessage());
        	request.getRequestDispatcher(binderPage)
        		.forward(request, response);
        }


  
    	
    }
    
    
	
}
