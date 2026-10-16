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

    private static final String DB_URL =
        "jdbc:mysql://localhost:3306/poketrader?useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "o{%}*pEhL@uIRUW]ZbmJ5V[2";

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String enteredPassword = request.getParameter("password");

        String sql = """
            SELECT passwordHashed
            FROM users
            WHERE username = ?
            """;

        try (
            Connection connection = DriverManager.getConnection(
                DB_URL, DB_USER, DB_PASSWORD
            );

            PreparedStatement statement =
                connection.prepareStatement(sql)
        ) {
            statement.setString(1, username);

            try (ResultSet result = statement.executeQuery()) {

                if (result.next()) {
                    String storedHash =
                        result.getString("passwordHashed");

                    boolean passwordCorrect =
                        BCrypt.checkpw(enteredPassword, storedHash);

                    if (passwordCorrect) {
                        HttpSession session = request.getSession();
                        session.setAttribute("username", username);
                        System.out.println("Login successful! Welcome back, " + username);
                        // outputs 'success' message right under Login button
                        request.setAttribute(
        		            "loginSuccess",
        		            "Login is a success! Welcome back, " + username + "!"
        		        );
        		        request.getRequestDispatcher("login_and_signup.jsp")
        		               .forward(request, response);
        		        
                        response.sendRedirect("login_and_signup.jsp");
                    } else {
                        showError(request, response,
                            "Incorrect username or password.");
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();

            showError(request, response,
                "A database error occurred.");
        }
    }

    private void showError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws ServletException, IOException {

        request.setAttribute("loginError", message);
        request.getRequestDispatcher("login_and_signup.jsp")
               .forward(request, response);
    }
}
