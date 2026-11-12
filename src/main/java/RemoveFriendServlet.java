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
 * Servlet implementation class RemoveFriendServlet
 */
@WebServlet("/removeFriend")
public class RemoveFriendServlet extends HttpServlet {
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
    	String friend = request.getParameter("friendToRemove");
    	
    	if (session == null ||
    		session.getAttribute("currentUser") == null) {
    		// User is not authenticated
    		System.out.println("Session Error: you have been logged out.");
    		response.sendRedirect(loginPage);
    		return;
    	}
    	// Prepare the SQL statement that checks if the friend to remove
    	// exists in 'users' table.
    	String SQL_checkFriendExists = """
    			SELECT username
    			FROM users
    			WHERE username = ?
    			""";
    	
    	// Prepare the SQL statement that checks if the user and the friend are actually friends.
    	// (i.e. make sure (user, friend, "Friend") exists in 'friend' table)
    	String SQL_checkIsFriend = """
    			SELECT userA, userB, status
    			FROM friends
    			WHERE userA = ? AND userB = ?
    			""";
    	
    	// Prepare the SQL statement that deletes the rows where the two users are friends or pending friends.
    	String SQL_deleteFriends = """
    			DELETE FROM friends
    			WHERE (userA = ? AND userB = ?) OR (userA = ? AND userB = ?)
    			""";
    	
    	try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    		 PreparedStatement checkFriendExists = connection.prepareStatement(SQL_checkFriendExists);
    		 PreparedStatement checkIsFriend = connection.prepareStatement(SQL_checkIsFriend);
    		 PreparedStatement deleteFriends = connection.prepareStatement(SQL_deleteFriends)) {
    			
    			checkFriendExists.setString(1, friend);
    			try(ResultSet returnedUser = checkFriendExists.executeQuery()) {
    				if (returnedUser.next()) {
    					// This is the case where the friend to remove is found in 'users' table.
    					// Check passes and continues to next check (checkIsFriend).
    				}
    				// This is the case where the friend to remove is not found in 'users' table.
    				// In this case, output a failure message to the user.
    				else {
    					request.setAttribute("removeFriendOutput", "Oops, this " + friend + " doesn't exist in PokeTrader! Double-check the spelling and case-sensitivity of the friend you want to remove.");
    					request.getRequestDispatcher(friendsPage).forward(request, response);
    					return;
    				}
    			}
    		
    			/*
    			 * Check if the friend to remove is actually a friend of the user.
    			 * If that is not the case, output a failure message to the user.
    			 */
    			checkIsFriend.setString(1, user);
    			checkIsFriend.setString(2, friend);
    			try(ResultSet result = checkIsFriend.executeQuery()) {
    				// Case a row is returned (i.e. (user, friend) found)
    				if (result.next()) {
    					// Do nothing and move onto removing the friend.
    				}
    				// Case where no rows are returned (i.e. (user, friend) not found)
    				else {
    					request.setAttribute("removeFriendOutput", "Sorry, " + friend + " is not a pending friend or a friend.");
    					request.getRequestDispatcher(friendsPage).forward(request, response);
    					return;
    				}
    			}
    			
    			deleteFriends.setString(1, user);
    			deleteFriends.setString(2, friend);
    			deleteFriends.setString(3, friend);
    			deleteFriends.setString(4, user);
    			deleteFriends.executeUpdate();
    			
				// Output success message for deletion
    			request.setAttribute("removeFriendOutput", "Success: " + friend + " has been removed from your friends list.");
				request.getRequestDispatcher(friendsPage).forward(request, response);
				return;
    	}
    	catch (SQLException e) {
    		e.printStackTrace();
    	}
    }

}
