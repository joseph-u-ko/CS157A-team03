// Libraries
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
    private static final String DB_URL = "jdbc:mysql://localhost:3306/poketrader?autoReconnect=true&useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "$apphire9Warrior";
	
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

    	String loginPage = "login-and-signup.jsp";
    	String homePage = "home.jsp";
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String reconfirmed_password = request.getParameter("reconfirmed_password");

        if (username == null || password == null || reconfirmed_password == null ||
            username.isBlank() || password.isBlank() || reconfirmed_password.isBlank()) {

            request.setAttribute("signupError", "All fields are required.");
            request.getRequestDispatcher(loginPage)
                   .forward(request, response);
            return;
        }
        
        // Check if password and reconfirmed password match.
        // If they don't match, then output a message for the user and then reject the sign-up.
        if (!password.equals(reconfirmed_password)) {
        	request.setAttribute("signupError", "Passwords need to match.");
        	request.getRequestDispatcher(loginPage)
        		   .forward(request, response);
        	return;
        }
        
        String sql = """
        		INSERT INTO users (username, passwordHashed, loggedIn, nextTicketTime, tickets)
                VALUES (?, ?, ?, ?, ?)
        		""";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, username);
                
                // generates and stores the hashed password
                String passwordHashed = BCrypt.hashpw(
                        password,
                        BCrypt.gensalt()
                );
                statement.setString(2, passwordHashed);
                statement.setBoolean(3, true); // loggedIn is defaulted to true (user will automatically be logged-in after successfully signing-up)
                
                LocalTime now = LocalTime.now();
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss");
                String time = now.format(formatter);
                statement.setString(4, time); //current timestamp for now
                
                statement.setInt(5, 1); // a new user has 1 ticket
                int rowsInserted = statement.executeUpdate(); // Inserts new user data into 'users' table (throws error if username already exists)
                System.out.println("Rows inserted: " + rowsInserted);
  
                // If the user successfully signs-up, the current session's user will be set to the new user.
                // Afterwards, the user will be redirected to the main page.
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", username);
                response.sendRedirect(homePage);
		    } 
        	// This exception will be caught if the user tries to sign-up with a username that already exists in the PokéTrader database.
        	catch (SQLIntegrityConstraintViolationException e) {
        		// Username already exists
        		e.printStackTrace();
        		request.setAttribute("signupError", 
        				"Sorry, it appears that this username is already taken. Try a different username.");
        		
        		request.getRequestDispatcher(loginPage)
        			   .forward(request, response);;
        	}
        	// General catch-all exception with sign-up error
        	catch (SQLException e) {
		        e.printStackTrace();
		
		        request.setAttribute(
		            "signupError",
		            "Database error: " + e.getMessage()
		        );
		
		        request.getRequestDispatcher(loginPage)
		               .forward(request, response);
		    }
    }
}