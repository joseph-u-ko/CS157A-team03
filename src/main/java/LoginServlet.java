import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/poketrader?useSSL=false";
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
        String enteredPassword = request.getParameter("password");

        // Set up SQL statements (getting the hashed password; updating loggedIn for the logged-in user)
        String SQL_getPassword = """
            SELECT passwordHashed
            FROM users
            WHERE username = ?
            """; 
        String SQL_getLoggedIn = """
        	SELECT loggedIn
        	FROM users
        	WHERE username = ?	
        	""";
        
        String SQL_updateLoggedIn = """
        	UPDATE users
            SET loggedIn = true
            WHERE username = ?
        	""";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement statement_getPassword = connection.prepareStatement(SQL_getPassword);
        	 PreparedStatement statement_getLoggedIn = connection.prepareStatement(SQL_getLoggedIn);
        	 PreparedStatement statement_updateLoggedIn = connection.prepareStatement(SQL_updateLoggedIn)) {
        	// Set ?s in statements to corresponding parameters
        	statement_getPassword.setString(1, username);
        	statement_getLoggedIn.setString(1, username);
            statement_updateLoggedIn.setString(1, username);
            
            // Checks if someone else is using the account.
            // If someone else is using the account (i.e. loggedIn = true), then reject the login.
            try (ResultSet result = statement_getLoggedIn.executeQuery()) {
	            if (result.next()) {
	            	boolean isLoggedIn = result.getBoolean("loggedIn");
	            	if (isLoggedIn) {
	            		request.setAttribute("loginError", "Sorry, someone has logged onto your account. Please try again later.");
	            		request.getRequestDispatcher(loginPage)
	            			   .forward(request, response);
	            		return;
	            	}
	            }
	            else {
	            	request.setAttribute("loginError",  "An account of this username does not exist. Please sign up!");
	            	request.getRequestDispatcher(loginPage)
	            		   .forward(request, response);
	            	return;
	            }
            }

            try (ResultSet result = statement_getPassword.executeQuery()) {
                if (result.next()) {
                    String storedHash = result.getString("passwordHashed");

                    // Checks if entered password equals to the stored hashed password (according to the hashing system)
                    boolean passwordCorrect = BCrypt.checkpw(enteredPassword, storedHash);
                    
                    // If the user successfully logins, the current session's user will be set to the logged-in user.
                    // Afterwards, the user will be redirected to the main page.
                    if (passwordCorrect) {
                        HttpSession session = request.getSession();
                        session.setAttribute("currentUser", username);
                        System.out.println("Login successful! Welcome back, " + username);
                        statement_updateLoggedIn.executeUpdate(); // changes loggedIn to true
                        response.sendRedirect(homePage);
                    }
                    else {
                        request.setAttribute("loginError", "Incorrect username or password.");
                        request.getRequestDispatcher(loginPage)
                               .forward(request, response);
                    }
                }
            }

        } 
        // General catch-all exception for login error
        catch (SQLException e) {
        	e.printStackTrace();
        	
            request.setAttribute("loginError", "A database error occurred.");
            request.getRequestDispatcher(loginPage)
                   .forward(request, response);
        }
    }
}