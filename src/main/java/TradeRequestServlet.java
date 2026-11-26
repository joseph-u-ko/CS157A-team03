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

/**
 * Servlet implementation class AddFriendServlet
 */
@WebServlet("/tradeRequest")
public class TradeRequestServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private static final String DB_URL = "jdbc:mysql://localhost:3306/poketrader?autoReconnect=true&useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "$apphire9Warrior";
    
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
    	String friend = request.getParameter(""); // TODO
    	String action = request.getParameter(""); // TODO what action to perform
    	
    	if (session == null ||
    		session.getAttribute("currentUser") == null) {
    		// User is not authenticated
    		System.out.println("Session Error: you have been logged out.");
    		response.sendRedirect(loginPage);
    		return;
    	}
    	
    	// TODO
    	// Add SQL queries as needed and add PreparedStatements to the try parameters accordingly
    	String SQL_getUserRequest = """
    			SELECT username, otherUser, status
    			FROM trades
    			WHERE username = ?
    			""";
    	String SQL_updateRow = """
    			UPDATE
    			""";
    	
    	try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
    			switch (action) {
    				case "Start Request":
    		    		PreparedStatement otherRequest = connection.prepareStatement(SQL_getUserRequest);
    		        	otherRequest.setString(1, friend);
    	    			ResultSet result = otherRequest.executeQuery();
    	    			
    					// Check that other user is not already in a trade
    					while (result.next()) { //there should only be one
    						if (result.getString("otherUser") != null) {
    							// TODO
    							// Error, the otherUser is already in a trade
    							// The error attribute is "tradeRequestError"
    						}
    						// TODO
    						// Request can go through
    					}
    					break;
    				case "Accept Request":
    					// TODO
    					// Update the status for both users to "In Progress"
    					break;
    				case "Decline Request":
    				case "Cancel Request":
    					// TODO
    					// Update the status for both users to null (NULL)
    					break;
    				default:
    					// TODO
    					// Error, just in case
    					// Can just redirect with an error message
    					// The error attribute is "tradeRequestError"
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
