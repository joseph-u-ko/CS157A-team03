

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Servlet implementation class AddFriendServlet
 */
@WebServlet("/friends")
public class FriendsServlet extends HttpServlet {
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
    	String friendsPage = "friends.jsp";
    	
    	if (session == null ||
    		session.getAttribute("currentUser") == null) {
    		// User is not authenticated
    		request.setAttribute("sessionError", "Session Error: you have been logged out.");
    		return;
    	}
    	
    	try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
    		response.sendRedirect(friendsPage);
    	}
    	catch (SQLException e) {
    		e.printStackTrace();
    	}
    }

}
