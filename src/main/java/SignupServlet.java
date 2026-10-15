// Libraries
import org.mindrot.jbcrypt.BCrypt;

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

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
    private static final String DB_URL = "jdbc:mysql://localhost:3306/poketrader?autoReconnect=true&useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "o{%}*pEhL@uIRUW]ZbmJ5V[2";
	
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null ||
            username.isBlank() || password.isBlank()) {

            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("login_and_signup.jsp")
                   .forward(request, response);
            return;
        }
        
        String sql = """
        		INSERT INTO users (username, passwordHashed, loggedIn, nextTicketTime, tickets)
                VALUES (?, ?, ?, ?, ?)
        		""";

        try (
                Connection connection = DriverManager.getConnection(
                        DB_URL, DB_USER, DB_PASSWORD);

                PreparedStatement statement =
                        connection.prepareStatement(sql)
            ) {
                statement.setString(1, username);
                
                // generates and stores the hashed password
                String passwordHashed = BCrypt.hashpw(
                        password,
                        BCrypt.gensalt()
                );
                statement.setString(2, passwordHashed);
                
                // loggedIn is defaulted to false
                statement.setBoolean(3, false);
                
                // nextTicketTime is null
                statement.setTimestamp(4, null);
                
                // a new user has 0 tickets
                statement.setInt(5, 0);
                
                

                int rowsInserted = statement.executeUpdate();
                System.out.println("Rows inserted: " + rowsInserted);

                response.sendRedirect("login_and_signup.jsp");

		    } catch (SQLException e) {
		        e.printStackTrace();
		
		        request.setAttribute(
		            "error",
		            "Database error: " + e.getMessage()
		        );
		
		        request.getRequestDispatcher("login_and_signup.jsp")
		               .forward(request, response);
		    }
    }
}