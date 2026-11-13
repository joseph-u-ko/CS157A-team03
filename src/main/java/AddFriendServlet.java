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
@WebServlet("/addFriend")
public class AddFriendServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private static final String DB_URL = "jdbc:mysql://localhost:3306/poketrader?autoReconnect=true&useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "o{%}*pEhL@uIRUW]ZbmJ5V[2";
    
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
    	String friend = request.getParameter("friendToAdd");
    	
    	if (session == null ||
    		session.getAttribute("currentUser") == null) {
    		// User is not authenticated
    		System.out.println("Session Error: you have been logged out.");
    		response.sendRedirect(loginPage);
    		return;
    	}
    	// Prepare the SQL statement that checks if the user who sent the friend request
    	// exists in 'users' table.
    	String SQL_checkFriendExists = """
    			SELECT username
    			FROM users
    			WHERE username = ?
    			""";
    	
    	/* Prepare the SQL statement that checks if the current user is the receiver of the friend request.
    	   The servlet should reject the acceptance of the friend request if the current user is not the
    	   receiver of the friend request (i.e. the sender).
    	   
    	   Also if the sender and receiver are already friends (i.e. (sender, receiver, "Friend") exists), then
    	   the servlet should reject acceptance of the friend request and output a failure message to the current user.
    	   userA = receiver of friend request, userB = user who sent the friend request
    	*/
    	String SQL_checkReceiver = """
    			SELECT userA, userB, status
    			FROM friends
    			WHERE userA = ? AND userB = ?
    			""";
    	
    	// Prepare the two SQL statements: one that updates the status of friend's status to "Friend"
    	// and the other that updates user's status to "Friend".
    	String SQL_updateFriendStatus = """
    			UPDATE friends
    			SET status = "Friend"
    			WHERE userB = ? AND userA = ?
    			""";
    	String SQL_updateUserStatus = """
    			UPDATE friends
    			SET status = "Friend"
    			WHERE userA = ? AND userB = ?
    			""";
    	
    	try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    		 PreparedStatement checkFriendExists = connection.prepareStatement(SQL_checkFriendExists);
    		 PreparedStatement checkReceiver = connection.prepareStatement(SQL_checkReceiver);
    		 PreparedStatement updateFriendStatus = connection.prepareStatement(SQL_updateFriendStatus);
    		 PreparedStatement updateUserStatus = connection.prepareStatement(SQL_updateUserStatus)) {
    			
    			checkFriendExists.setString(1, friend);
    			try(ResultSet returnedUser = checkFriendExists.executeQuery()) {
    				if (returnedUser.next()) {
    					// This is the case where the sender of the friend request is found in 'users' table.
    					// Check passes and continues to next check (checkForRequest).
    				}
    				// This is the case where the sender of the friend request is not found in 'users' table.
    				// In this case, output a failure message to the user.
    				else {
    					request.setAttribute("acceptFriendOutput", "Oops, this " + friend + " doesn't exist in PokeTrader! Double-check the spelling and case-sensitivity of the user sending you the request.");
    					request.getRequestDispatcher(friendsPage).forward(request, response);
    					return;
    				}
    			}
    		
    			/*
    			 * Check if the user who's accepting the friend request is the sender.
    			 * If that is the case, output a failure message to tell the user that they can't accept the
    			 * friend request on their end since they sent the friend request.
    			 */
    			checkReceiver.setString(1, user);
    			checkReceiver.setString(2, friend);
    			try(ResultSet result = checkReceiver.executeQuery()) {
    				if (result.next()) {
    					// Case where the user accidentally tries to accept the friend request as the sender instead of as the receiver
    					if (result.getString("status").equals("Request pending")) {
    						request.setAttribute("acceptFriendOutput", "Oops, you cannot accept the friend request, since you sent the friend request. " + friend + " must accept the friend request on their end.");
    						request.getRequestDispatcher(friendsPage).forward(request, response);
    						return;
    					}
    					// Case where the sender and receiver are already friends
    					if (result.getString("status").equals("Friend")) {
    						request.setAttribute("acceptFriendOutput", "Oops, you are already friends with " + friend + ".");
    						request.getRequestDispatcher(friendsPage).forward(request, response);
    						return;
    					}
    				}
    				// Case where no rows are returned (i.e. friend request not found)
    				else {
    					request.setAttribute("acceptFriendOutput", "Sorry, " + friend + " has not sent you a friend request.");
    					request.getRequestDispatcher(friendsPage).forward(request, response);
    					return;
    				}
    			}
    		
    			updateFriendStatus.setString(1, user);
    			updateFriendStatus.setString(2, friend);
    			updateFriendStatus.executeUpdate();
    			
    			updateUserStatus.setString(1, user);
    			updateUserStatus.setString(2, friend);
    			updateUserStatus.executeUpdate();
    			
				// Add the user_friend as the user's friend
				System.out.println("Success!, Added " + friend + " as a friend!");
				request.getRequestDispatcher(friendsPage).forward(request, response);
				return;
    	}
    	catch (SQLException e) {
    		e.printStackTrace();
    	}
    }

}
