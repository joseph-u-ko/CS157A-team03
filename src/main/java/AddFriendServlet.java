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
    	String friend = (String) session.getAttribute("friendToAdd");
    	
    	if (session == null ||
    		session.getAttribute("currentUser") == null) {
    		// User is not authenticated
    		System.out.println("Session Error: you have been logged out.");
    		response.sendRedirect(loginPage);
    		return;
    	}
    	
    	// Prepare the two SQL statements: one that updates the status of friend's status to "Friend"
    	// and the other that updates user's status to "Friend"
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
    		 PreparedStatement updateFriendStatus = connection.prepareStatement(SQL_updateFriendStatus);
    		 PreparedStatement updateUserStatus = connection.prepareStatement(SQL_updateUserStatus)) {
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
