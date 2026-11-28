import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;

import pokemonInfo.DBPassword;

/**
 * Servlet implementation class AddFriendServlet
 */
@WebServlet("/tradeRequest")
public class TradeRequestServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private static final String DB_URL = "jdbc:mysql://localhost:3306/poketrader?autoReconnect=true&useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = DBPassword.YOUR_PASSWORD;
    
    @Override
	protected void doPost(
			HttpServletRequest request,
			HttpServletResponse response)
			throws ServletException, IOException {
    	
    	// Gets the current session and current user's name
    	HttpSession session = request.getSession(false);
    	String loginPage = "login-and-signup.jsp";
    	String friendsPage = "friends.jsp";
    	String user = (String) session.getAttribute("currentUser");
    	String friend = request.getParameter("userB");
    	String action = request.getParameter("task");
    	
    	if (session == null ||
    		session.getAttribute("currentUser") == null) {
    		// User is not authenticated
    		System.out.println("Session Error: you have been logged out.");
    		response.sendRedirect(loginPage);
    		return;
    	}
    	
    	String SQL_getUserRequest = """
    			SELECT username, otherUser, status
    			FROM users
    			WHERE username = ?
    			""";
    	
    	String SQL_updateRequestingUser = """
    			UPDATE users
				SET otherUser = ?, status = "Accept Pending"
				WHERE username = ?
    			""";
    	String SQL_updateAcceptingUser = """
    			UPDATE users
				SET otherUser = ?, status = "Request Pending"
				WHERE username = ?
    			""";
    	String SQL_updateInProgress = """
    			UPDATE users
				SET otherUser = ?, status = "In Progress"
				WHERE username = ?
    			""";
    	String SQL_removeRequest = """
    			UPDATE users
    			SET otherUser = NULL, status = NULL
    			WHERE username = ?
    			""";
    	
    	
    	try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
    		int rowsUpdatedForTrades;
    			switch (action) {
    				case "addTradeRequest":
    					
    					// For null check
    		    		PreparedStatement otherRequest = connection.prepareStatement(SQL_getUserRequest);
    		    		PreparedStatement requestingUser = connection.prepareStatement(SQL_updateRequestingUser);
    		    		PreparedStatement acceptingUser = connection.prepareStatement(SQL_updateAcceptingUser);
    		        	otherRequest.setString(1, friend); 
    	    			ResultSet result = otherRequest.executeQuery();
    	    			
    					
    					if (result.next()) { // there should only be one
    						
    						if (result.getString("otherUser") != null) { // Check that other user is not already in a trade
    							// can also check if status is not null
    							request.setAttribute("tradeRequestError", "Sorry, " + result.getString("username") + " is currently in a trade.");
    	    					request.getRequestDispatcher(friendsPage).forward(request, response);
    	    					return;
    						}
    						
    						// requesting user
        	    			
        	    			requestingUser.setString(1, friend);
        	    			requestingUser.setString(2, user);
        	    			rowsUpdatedForTrades = requestingUser.executeUpdate();
        	    			System.out.println("Rows updated in 'trades' table: " + rowsUpdatedForTrades);
        	    			
        	    			// accepting user
        	    			
        	    			acceptingUser.setString(1, user);
        	    			acceptingUser.setString(2, friend);
        	    			rowsUpdatedForTrades = acceptingUser.executeUpdate();
        	    			System.out.println("Rows updated in 'trades' table: " + rowsUpdatedForTrades);
    					}
    					
    					break;
    				case "acceptTradeRequest":
    					// Update the status for both users to "In Progress"
    					PreparedStatement requestingUserInProgress = connection.prepareStatement(SQL_updateInProgress);
    					PreparedStatement acceptingUserInProgress = connection.prepareStatement(SQL_updateInProgress);
    					
						// requesting user
    	    			requestingUserInProgress.setString(1, friend);
    	    			requestingUserInProgress.setString(2, user);
    	    			rowsUpdatedForTrades = requestingUserInProgress.executeUpdate();
    	    			System.out.println("Rows updated in 'trades' table: " + rowsUpdatedForTrades);
    	    			
    	    			// accepting user
    	    			acceptingUserInProgress.setString(1, user);
    	    			acceptingUserInProgress.setString(2, friend);
    	    			rowsUpdatedForTrades = acceptingUserInProgress.executeUpdate();
    	    			System.out.println("Rows updated in 'trades' table: " + rowsUpdatedForTrades);
    					break;
    					
    				case "declineTradeRequest":
    				case "cancelTradeRequest":
    					PreparedStatement resetUser = connection.prepareStatement(SQL_removeRequest);
    					PreparedStatement resetOther = connection.prepareStatement(SQL_removeRequest);
    					
    					// current user
    					resetUser.setString(1, user);
    					rowsUpdatedForTrades = resetUser.executeUpdate();
    					System.out.println("Rows updated in 'trades' table: " + rowsUpdatedForTrades);
    					
    					// other user
    					resetOther.setString(1, friend);
    					rowsUpdatedForTrades = resetOther.executeUpdate();
    					System.out.println("Rows updated in 'trades' table: " + rowsUpdatedForTrades);
    					
    					break;
    				default:
    					request.setAttribute("tradeRequestError", "Sorry, there was an error with making this trade.");
    					request.getRequestDispatcher(friendsPage).forward(request, response);
    					break;
    			}
    			
				// Success
				System.out.println("Trade Request action success");
				request.getRequestDispatcher(friendsPage).forward(request, response);
				return;
    	}
    	catch (SQLException e) {
    		e.printStackTrace();
    	}
    	
    }

}
