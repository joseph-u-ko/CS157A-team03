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


@WebServlet("/catalog")
public class CatalogServlet extends HttpServlet {
	
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
        String catalogPage = "catalog.jsp";
        String loginPage = "login-and-signup.jsp";

        
        ArrayList<Card> cardsEntries = new ArrayList<Card>();
        ArrayList<String> setNames = new ArrayList<String>();
        
        // Taken from Isaiah's code (session error) 
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
        //String username = (String) session.getAttribute("currentUser"); // might not need this for catalog
        String card = request.getParameter("cardName");
        String set = request.getParameter("setName");
        
        // Prepare the SQL statement that gets all the Cards a user owns
        String SQL_cards = """
        		SELECT c.cardID, c.cardName, c.cardType, c.subType,
        			   c.rarity, c.imageLink, s.setName
        		FROM cards AS c
        		JOIN sets AS s ON c.setCode = s.setCode
                """;
        String filter1 = " WHERE c.cardName LIKE ?";
        String filter2 = " WHERE s.setName = ?";
        String filter3 = " WHERE c.cardName LIKE ? AND s.setName = ?";
        
        //NOTE FOR IMPROVEMENT - might be a better way to implement the "filtering/searching" system
        //can improv/change this system during the meeting
        
        boolean conditionForFilter1 = ((card!=null) && (!(card.equals(""))));
        boolean conditionForFilter2 = ((set!=null) && (!(set.equals(""))));
        boolean conditionCombined = conditionForFilter1 && conditionForFilter2;
        
        if (conditionCombined) {
        	SQL_cards = SQL_cards + filter3;
        }
        else if (conditionForFilter1) {
        	SQL_cards = SQL_cards + filter1;
        } 
        else if (conditionForFilter2) {
        	SQL_cards = SQL_cards + filter2;
        }
        
        String retrieve_setNames = """
        		SELECT s.setName
        		FROM sets AS s
        		""";
        
        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        		PreparedStatement set_statement = connection.prepareStatement(retrieve_setNames);
        		PreparedStatement statement = connection.prepareStatement(SQL_cards)) {
        	
        	ResultSet rs1 = set_statement.executeQuery();
        	while(rs1.next()) {
        		String setName = rs1.getString(1);
        		setNames.add(setName);
        	}
        	session.setAttribute("setNames", setNames);
            System.out.println("Successfully got all set names.");
           
        	
        	if (conditionCombined) {
        		String cardREGEX = "%" + card + "%";
        		System.out.println(cardREGEX);
        		//String setREGEX = "%" + set + "%";
        		//System.out.println(setREGEX);
        		statement.setString(1, cardREGEX);
        		statement.setString(2, set);
        	}
        	
        	else if (conditionForFilter1) {
        		String cardREGEX = "%" + card + "%";
        		System.out.println(cardREGEX);
        		statement.setString(1, cardREGEX);
        	}
        	
        	else if (conditionForFilter2) {
        		//String setREGEX = "%" + set + "%";
        		//System.out.println(setREGEX);
        		statement.setString(1, set);
        	}
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
                String setName = rs.getString(7);
                cardsEntries.add(new Card(cardID, cardName, cardType, subType, rarity, imageLink, setName));
                }
            if (cardsFound) {
            	session.setAttribute("cardsCat", cardsEntries);
                System.out.println("Successfully retrived the cards.");
                session.setAttribute("cardsFoundCat", cardsFound);
                }
            else {
            	session.setAttribute("cardsFoundCat", cardsFound);
            	}
               
            rs.close();
            statement.close();
            connection.close();
            response.sendRedirect(catalogPage);
            return;
                   
        }
        // catch-all exception
        // check in meeting if this should be more specific
        catch (SQLException e) {
        	e.printStackTrace();
        	request.setAttribute("updateError", "Update Error: " + e.getMessage());
        	request.getRequestDispatcher(catalogPage)
        		.forward(request, response);
        }
    }	
}