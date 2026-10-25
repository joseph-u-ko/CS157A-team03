import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/addTicket")
public class AddTicketServlet extends HttpServlet {
	
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
        String packOpen = "pack-open-dropdowns.jsp";
        String username = (String) session.getAttribute("currentUser");
        
        if (session == null ||
            session.getAttribute("currentUser") == null) {
            // User is not authenticated
        	request.setAttribute("sessionError", "Session Error: you have been logged out.");
        	response.sendRedirect(loginPage);
        	return;
        }
        
        // Prepare the SQL statement that obtains number of tickets and sets user's number of tickets
        String SQL_getTickets = """
        		SELECT tickets
        		FROM users
        		WHERE username = ?
        		""";
        String SQL_setTickets = """
                UPDATE users
                SET tickets = ?
                WHERE username = ?
                """;

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        	PreparedStatement statement_getTickets = connection.prepareStatement(SQL_getTickets);
        	PreparedStatement statement_setTickets = connection.prepareStatement(SQL_setTickets)) {
        	statement_getTickets.setString(1,  username);
        	try (ResultSet result = statement_getTickets.executeQuery()) {
				if (result.next()) {
	        		int newTickets = result.getInt("tickets") + 1;
		        	statement_setTickets.setInt(1, newTickets);
		        	statement_setTickets.setString(2, username);
		        	statement_setTickets.executeUpdate();
		        	System.out.println("Tickets for " + username + " successfully incremented to " + newTickets + "."); // Message to console
		    	    response.sendRedirect(packOpen);
        		}
        	}
        }
        // General catch-all exception for logout errors
        catch (SQLException e) {
        	e.printStackTrace();
        	request.setAttribute("updateError", "Update Error: " + e.getMessage());
        	request.getRequestDispatcher(packOpen)
        		.forward(request, response);
        }
    }
}