import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
    private static final String DB_URL = "jdbc:mysql://localhost:3306/poketrader?useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "$apphire9Warrior";

    @Override
    protected void doPost(
    		HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
    	
    	// Get the current session and current user's name
        HttpSession session = request.getSession(false);
        String loginPage = "login-and-signup.jsp";
        String homePage = "home.jsp";
        String username = (String) session.getAttribute("currentUser");
        
        if (session == null ||
                session.getAttribute("currentUser") == null) {
            // User is not authenticated
        	HttpSession errorSession = request.getSession(true);
        	
            errorSession.setAttribute(
                "sessionError",
                "Session Error: you have been logged out."
            );
            response.sendRedirect(loginPage);
           	return;
        }
        
        // Prepare the SQL statement that logs the user out (changes loggedIn to false for that user)
        String sql = """
                UPDATE users
                SET loggedIn = false
                WHERE username = ?
                """;

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        	 PreparedStatement statement = connection.prepareStatement(sql)) {
        	statement.setString(1, username);
        	statement.executeUpdate();
        	System.out.println("User " + username + " logged out."); // Message to console for logout confirmation (for testing purposes)
        	response.sendRedirect(loginPage);
        	if (session != null) {
                session.invalidate(); // Ends the current session
            }
        } 
        // General catch-all exception for logout errors
        catch (SQLException e) {
        	e.printStackTrace();
        	request.setAttribute("logoutError", "Logout Error: " + e.getMessage());
        	request.getRequestDispatcher(homePage)
        		.forward(request, response);
        }
    }
}