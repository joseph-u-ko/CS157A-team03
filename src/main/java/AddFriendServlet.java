

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
@WebServlet("/add-friend")
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
    	String homePage = "home.jsp";
    	String user = (String) session.getAttribute("currentUser");
    	
    	// Gets the friend's username
    	String user_friend = request.getParameter("friend-user");
    	
    	if (session == null ||
    		session.getAttribute("currentUser") == null) {
    		// User is not authenticated
    		request.setAttribute("sessionError", "Session Error: you have been logged out.");
    		response.sendRedirect(loginPage);
    		return;
    	}
    	
    	// Prepare the SQL statement that checks for friend in 'users' table
    	String SQL_checkFriend = """
    			SELECT username
    			FROM users
    			WHERE username = ?
    			""";
    	
    	// Prepare the SQL statement that checks if friend is unique in 'friend' table
    	String SQL_checkUnique = """
    			SELECT userA, userB
    			FROM friend
    			WHERE userA = ? AND userB = ?
    			""";
    	
    	// Prepare the SQL statement that adds the connection between a user and their friend.
    	// Note: This works both ways (e.g. If Jake adds Dave as a friend, you'll need to add (Jake, Dave) and (Dave, Jake)).
    	String SQL_addFriend = """
    			INSERT INTO friend
    			VALUES
    			(?, ?),
    			(?, ?)
    			""";
    	
    	/* First check for the following things for the friend:
    	 	1.) They exist in 'users' table.
    	 	2.) The friend is not the current user.
    	 	3.) The friend does not already exist as the user's friend.
    	 	
    	   Then, if all of these things are good, then add the friend to 'friend' table both-ways, (user, friend) and (friend, user).
    	*/
    	try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    		 PreparedStatement checkFriend = connection.prepareStatement(SQL_checkFriend);
    		 PreparedStatement checkUnique = connection.prepareStatement(SQL_checkUnique);
    		 PreparedStatement addFriend = connection.prepareStatement(SQL_addFriend)) {
    			checkFriend.setString(1, user_friend);
    			
    			// Checking condition 1.) check for friend in 'users' first
    			try (ResultSet result = checkFriend.executeQuery()) {
    				// This if-condition will be true if the friend is found (i.e. one row returned).
    				if (result.next()) {
    					// Checking condition 2.) the returned friend is not the current user.
    					// If that is the case, don't add as a friend.
    					if (result.getString("username").equals(user)) {
    						request.setAttribute("popupMessage", "Oops, you cannot add yourself as a friend.");
    						request.setAttribute("showResponse", true);;
    						request.getRequestDispatcher(homePage).forward(request, response);
    						return;
    					}
    				}
    				// Case where friend is not found (i.e. zero rows returned).
    				else {
    					request.setAttribute("popupMessage", "Sorry, " + user_friend + " cannot be found. Try double-checking the spelling of your friend's username.");
    					request.setAttribute("showResponse", true);
    					request.getRequestDispatcher(homePage).forward(request, response);
    					return;
    				}
    			}
    			
    			checkUnique.setString(1, user);
				checkUnique.setString(2, user_friend);
    			// Checking condition 3.) the returned friend is already the user's friend.
				// If they are [i.e. their (user, friend) pair exists in 'friend' table], don't add as a friend to avoid duplicates.
				try (ResultSet result2 = checkUnique.executeQuery()) {
					// Case where one row is returned
					if (result2.next()) {
						if (result2.getString("userA").equals(user) && result2.getString("userB").equals(user_friend)) {
							request.setAttribute("popupMessage", "Oops, you already have " + user_friend + " registered as one of your friends.");
							request.setAttribute("showResponse", true);
							request.getRequestDispatcher(homePage).forward(request, response);
    						return;
						}
					}
					// Case where no rows are returned.
					else {
						// nothing is wrong; continue to adding (user, friend) and (friend, user) to 'friend' table
					}
				}
				
				// Inserts (user, friend) and (friend, user) into 'friend' table
				addFriend.setString(1, user);
				addFriend.setString(2, user_friend);
				addFriend.setString(3, user_friend);
				addFriend.setString(4, user);
				int rowsInserted = addFriend.executeUpdate();
				System.out.println("Rows inserted into 'friend' table: " + rowsInserted);
				request.setAttribute("showResponse", true);
				request.setAttribute("popupMessage", "Success!, Added " + user_friend + " as a friend!");
				request.getRequestDispatcher(homePage).forward(request, response);
				return;
    	}
    	catch (SQLException e) {
    		e.printStackTrace();
    	}
    }

}
