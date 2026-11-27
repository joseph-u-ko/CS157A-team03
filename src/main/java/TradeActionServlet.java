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
@WebServlet("/tradeAction")
public class TradeActionServlet extends HttpServlet {
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
    	String tradesPage = "trades.jsp";
    	String user = (String) session.getAttribute("currentUser");
    	String friend = request.getParameter("userB");
    	String action = request.getParameter("action"); // TODO what action to perform
    	
    	if (session == null ||
    		session.getAttribute("currentUser") == null) {
    		// User is not authenticated
    		System.out.println("Session Error: you have been logged out.");
    		response.sendRedirect(loginPage);
    		return;
    	}
    	
    	// TODO
    	// Add SQL queries as needed and add PreparedStatements to the try parameters accordingly
    	String SQL_getUserTrade = """
    			SELECT username, otherUser, tradeStatus, cardIDOffered
    			FROM trades
    			WHERE username = ?
    			""";
    	String SQL_updateRow = """
    			UPDATE
    			""";
    	
    	try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    		 PreparedStatement statement_getUserTrade = connection.prepareStatement(SQL_getUserTrade);
    		 PreparedStatement statement_getOtherTrade = connection.prepareStatement(SQL_getUserTrade)) {
    			switch (action) {
    				case "accept":
    					// TODO
    					// Check whether otherUser has already responded with "Confirmed"
    					// If so,
    						// Set tradeStatus to "Accepted" for otherUser
    						// Set tradeStatus to null (NULL) for current user ONLY
    						// On receiving a card, make sure to check whether
    						// it is a new card (INSERT) or owned card (UPDATE)
    						// On sending a card, make sure to check whether
    						// the user still owns any after sending (is it 0?)
    						// and DELETE from table if it is 0
    						// Reset status to null (NULL) for current user ONLY
    						// Reset cardIDOffered to null (NULL) for current user ONLY
    						// Reset otherUser to null (NULL) for current user ONLY
    					// If not,
    						// Set tradeStatus to "Confirmed" for current user
    					break;
    				case "decline":
    					// TODO
    					// Set tradeStatus to "Declined" for otherUser
    					// Set tradeStatus to null (NULL) for current user ONLY
    					// Reset status to null (NULL) for current user ONLY
    					// Reset cardIDOffered to null (NULL) for current user ONLY
    					// Reset otherUser to null (NULL) for current user ONLY
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
