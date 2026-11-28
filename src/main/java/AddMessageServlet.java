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

import pokemonInfo.DBPassword;


@WebServlet("/addMessage")
public class AddMessageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String DB_URL = "jdbc:mysql://localhost:3306/poketrader?autoReconnect=true&useSSL=false";
	private static final String DB_USER = "root";
	private static final String DB_PASSWORD = DBPassword.YOUR_PASSWORD;
		    
	@Override
	protected void doPost(
			HttpServletRequest request,
			HttpServletResponse response)
					throws ServletException, IOException {
		
		
		HttpSession session = request.getSession(false);
		String loginPage = "login-and-signup.jsp";
    	String friendsMessagesPage = "friend-messages.jsp";
    	String user = (String) session.getAttribute("currentUser");
    	String friend = request.getParameter("userB");
    	String message = request.getParameter("message");
    	
    	if (session == null ||
        	session.getAttribute("currentUser") == null) {
        	// User is not authenticated
        	System.out.println("Session Error: you have been logged out.");
        	response.sendRedirect(loginPage);
        	return;
        }
    	
    	String SQL_AddMessage = """
    			INSERT INTO friendmessages(message, sender, recipient) VALUES
    			(?, ?, ?)
    			""";
    	try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
       		 PreparedStatement statement = connection.prepareStatement(SQL_AddMessage);) {
    		
    		
    		statement.setString(1, message);
    		statement.setString(2, user);
    		statement.setString(3, friend);
    		
        	statement.executeUpdate(); // when more time -- flesh this out with message sent! and message failed to send with try catch blocks
        	
        	
             statement.close();
             connection.close();
             //response.sendRedirect(friendsMessagesPage);
             request.getRequestDispatcher(friendsMessagesPage).forward(request, response);
             return;
             

    	
    	}
    	catch (SQLException e) {
    		e.printStackTrace();
        	request.setAttribute("updateError", "Update Error: " + e.getMessage());
        	request.getRequestDispatcher(friendsMessagesPage)
        		.forward(request, response);
    	}
  	    	
}

}