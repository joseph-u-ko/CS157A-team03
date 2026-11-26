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

@WebServlet("/resetTradeStatus")
public class ResetTradeStatus extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String DB_URL =
        "jdbc:mysql://localhost:3306/poketrader?useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "$apphire9Warrior";

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String loginPage = request.getContextPath() + "/login-and-signup.jsp";
        String friendsPage = request.getContextPath() + "/friends.jsp";

        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(loginPage);
            return;
        }

        String currentUser = (String) session.getAttribute("currentUser");
        String otherUser = request.getParameter("userB");

        if (otherUser == null || otherUser.trim().isEmpty()) {
            response.sendRedirect(friendsPage);
            return;
        }

        String resetQuery =
            "UPDATE trades " +
            "SET otherUser = NULL, status = NULL, " +
            "tradeStatus = NULL, cardIDOffered = NULL " +
            "WHERE username = ? AND otherUser = ? " +
            "AND tradeStatus IN ('Accepted', 'Declined')";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection connection = DriverManager.getConnection(
                    DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement statement =
                     connection.prepareStatement(resetQuery)) {

                statement.setString(1, currentUser);
                statement.setString(2, otherUser);
                statement.executeUpdate();
            }

            response.sendRedirect(friendsPage);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to reset the trade status."
            );
        }
    }
}
