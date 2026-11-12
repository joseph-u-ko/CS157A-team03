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
        
        ArrayList<Card> cardsEntries = new ArrayList<Card>();
        ArrayList<String> setNames = new ArrayList<String>();
        
        //String username = (String) session.getAttribute("currentUser"); // might not need this for catalog
        String card = request.getParameter("cardName");
        String pack = request.getParameter("packID");
        String set = request.getParameter("setCode");
        String limitString = request.getParameter("limitResults");
        boolean limit = false;
        if (limitString != null) {
        	limit = true;
        }
        
        // Prepare the SQL statement that gets all the Cards a user owns
        String SQL_cards = """
        		SELECT c.cardID, c.cardName, c.cardType, c.subType,
        			   c.rarity, c.imageLink, s.setName, p.packName
        		FROM cards AS c
        		JOIN sets AS s USING (setCode)
        		JOIN contains USING (cardID)
        		JOIN packs AS p USING (packID)
                """;
        String where = " WHERE";
        String cardFilter = " c.cardName LIKE ?";
        String setFilter = " s.setCode = ?";
        String packFilter = " p.packID = ?";
        String and = " AND";
        
        //NOTE FOR IMPROVEMENT - might be a better way to implement the "filtering/searching" system
        //can improv/change this system during the meeting
        
        boolean condCard = ((card!=null) && (!(card.equals("")))); //card
        boolean condSet = ((set!=null) && (!(set.equals("")))); //set
        boolean condPack = ((pack!=null) && (!(pack.equals("")))); //pack
        
        if (condCard || condPack || condSet) SQL_cards = SQL_cards + where;
        boolean nextCond = false;
        if (condCard) {
        	SQL_cards = SQL_cards + cardFilter;
        	nextCond = true;
        }
        if (condSet) {
        	if (nextCond) SQL_cards = SQL_cards + and;
        	SQL_cards = SQL_cards + setFilter;
        	nextCond = true;
        }
        if (condPack) {
            if (nextCond) SQL_cards = SQL_cards + and;
        	SQL_cards = SQL_cards + packFilter;
        	nextCond = true;
        }
        if (limit) {
        	SQL_cards = SQL_cards + " LIMIT 1000";
        }
        
//        String retrieve_setNames = """
//        		SELECT s.setName
//        		FROM sets AS s
//        		""";
        
        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
//        		PreparedStatement set_statement = connection.prepareStatement(retrieve_setNames);
        		PreparedStatement statement = connection.prepareStatement(SQL_cards)) {
        	
//        	ResultSet rs1 = set_statement.executeQuery();
//        	while(rs1.next()) {
//        		String setName = rs1.getString(1);
//        		setNames.add(setName);
//        	}
//        	session.setAttribute("setNames", setNames);
//            System.out.println("Successfully got all set names.");
            
            int numCond = 0;
        	if (condCard) {
				statement.setString(++numCond,  "%" + card + "%");
        	}
        	if (condSet) {
        		statement.setString(++numCond, set);
        	}
        	if (condPack) {
        		statement.setString(++numCond, pack);
        	}
        	
        	ResultSet rs = statement.executeQuery();
            boolean cardsFound = false;
            while (rs.next() /*&& cardsEntries.size() < 1000*/) { // I changed this to be at SQL statement itself
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
                /*session.setAttribute("cardsFoundCat", cardsFound);
                }
            else {
            	session.setAttribute("cardsFoundCat", cardsFound); */
            	}
            session.setAttribute("cardsFoundCat", cardsFound); // setting accurate values
            session.setAttribute("selLimit", limit); // ensuring box stays checked
            session.setAttribute("search", card); // making sure that search check in JSP works appropriately
            
               
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