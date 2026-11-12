

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
 * Servlet implementation class RequestFriendServlet
 */
@WebServlet("/requestFriend")
public class RequestFriendServlet extends HttpServlet {
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
    	
    	// Gets the friend's username
    	String user_friend = request.getParameter("friendToRequest");
    	
    	if (session == null ||
    		session.getAttribute("currentUser") == null) {
    		// User is not authenticated
    		System.out.println("Session Error: you have been logged out.");
    		response.sendRedirect(loginPage);
    		return;
    	}
    	
    	// Prepare the SQL statement that checks for receiver in 'users' table
    	String SQL_checkFriend = """
    			SELECT username
    			FROM users
    			WHERE username = ?
    			""";
    	
    	// Prepare the SQL statement that checks if receiver is unique in 'friend' table
    	String SQL_checkUnique = """
    			SELECT userA, userB, status
    			FROM friends
    			WHERE userA = ? AND userB = ?
    			""";
    	
    	// Prepare the SQL statement that creates a friend request between two users.
    	// Note: This works both ways (e.g. If Jake friend-requests Dave, you'll need to add (Jake, Dave, "Request pending") 
    	// and (Dave, Jake, "Accept pending") to 'friends' table).
    	String SQL_requestFriend = """
    			INSERT INTO friends
    			VALUES
    			(?, ?, ?),
    			(?, ?, ?)
    			""";
    	
    	/* First check for the following things for the receiver of the friend request:
    	 	1.) They exist in 'users' table.
    	 	2.) The receiver is not the current user.
    	 	3.) The receiver did not receive a friend-request (i.e. not in 'friends' table)
    	 	4.) The receiver is already a friend of the sender.
    	 	
    	   Then, if all of these things are good, then send the friend-request both-ways (sender, receiver, "Request pending") and (receiver, sender, "Accept pending").
    	*/
    	try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    		 PreparedStatement checkFriend = connection.prepareStatement(SQL_checkFriend);
    		 PreparedStatement checkUnique = connection.prepareStatement(SQL_checkUnique);
    		 PreparedStatement requestFriend = connection.prepareStatement(SQL_requestFriend)) {
    			checkFriend.setString(1, user_friend);
    			
    			// Checking condition 1.) check for receiver in 'users' first
    			try (ResultSet result = checkFriend.executeQuery()) {
    				// This if-condition will be true if the receiver is found (i.e. one row returned).
    				if (result.next()) {
    					// Checking condition 2.) the returned receiver is not the current user.
    					// If that is not the case, don't send the friend request to the receiver.
    					if (result.getString("username").equals(user)) {
    						request.setAttribute("requestFriendOutput", "Oops, you cannot add yourself as a friend.");
    						request.getRequestDispatcher(friendsPage).forward(request, response);
    						return;
    					}
    				}
    				// Case where receiver is not found (i.e. zero rows returned).
    				else {
    					request.setAttribute("requestFriendOutput", "Sorry, " + user_friend + " cannot be found. Try double-checking the spelling of your friend's username.");
    					request.getRequestDispatcher(friendsPage).forward(request, response);
    					return;
    				}
    			}
    			
    			checkUnique.setString(1, user);
				checkUnique.setString(2, user_friend);
    			// Checking condition 3.) the returned receiver has already sent/received a friend-request to/by the sender/current user.
				// If this is the case [i.e. their (sender, receiver, status) and (receiver, sender, status) exists in 'friend' table],
				// don't send friend-request to avoid duplicate friend requests.
				try (ResultSet result2 = checkUnique.executeQuery()) {
					// Case where one row is returned
					if (result2.next()) {
						// This is the case where the sender already sent a friend request to the receiver.
						if (result2.getString("userA").equals(user) && result2.getString("userB").equals(user_friend) && result2.getString("status").equals("Request pending")) {
							request.setAttribute("requestFriendOutput", "Oops, you either have already sent a friend request to " + user_friend + " or have received a friend request by " + user_friend + ".");
							request.getRequestDispatcher(friendsPage).forward(request, response);
    						return;
						}
						// This is the case where the sender is already friends with the receiver.
						if (result2.getString("status").equals("Friend")) {
							request.setAttribute("requestFriendOutput", "Oops, you already are friends with " + user_friend + ".");
							request.getRequestDispatcher(friendsPage).forward(request, response);
							return;
						}
					}
					// Case where no rows are returned.
					else {
						// nothing is wrong; continue to adding (user, friend, "Request pending") and (friend, user, "Accept pending") to 'friends' table
					}
				}
				
				// "Sends" a friend request to the receiver by storing their statuses in 'friends' table
				requestFriend.setString(1, user);
				requestFriend.setString(2, user_friend);
				requestFriend.setString(3, "Request pending");
				requestFriend.setString(4, user_friend);
				requestFriend.setString(5, user);
				requestFriend.setString(6, "Accept pending");
				int rowsInserted = requestFriend.executeUpdate();
				System.out.println("Rows inserted into 'friends' table: " + rowsInserted);
				
				request.setAttribute("requestFriendOutput", "Friend request has been sent to " + user_friend + ".");
				request.getRequestDispatcher(friendsPage).forward(request, response);
				return;
    	}
    	catch (SQLException e) {
    		e.printStackTrace();
    	}
    }

}
