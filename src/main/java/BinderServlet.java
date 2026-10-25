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
        String loginPage = "login_and_signup.jsp";
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
        String sql = """
        		SELECT cards.cardID, cardName, cardType, subType, rarity, imageLink, owns.quantity, setName
        		FROM cards, owns, sets
        		WHERE cards.cardID = owns.cardID AND owns.username = ? AND cards.setCode = sets.setCode AND cardName ILIKE ?
                """;
        
        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                PreparedStatement statement = connection.prepareStatement(sql)) {
                   statement.setString(1, username);
                   statement.setString(2, card);
                   ResultSet rs = statement.executeQuery();
                   while (rs.next()) {
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
                   
                   session.setAttribute("cards", cardsEntries);
                   System.out.println("Successfully retrived the cards that " + username + " owns.");
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
