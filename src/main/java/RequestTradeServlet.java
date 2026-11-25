

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.DriverManager;
import java.sql.SQLException;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
/**
 * Servlet implementation class RequestTrade
 */
@WebServlet("/handleTradeRequest")
public class RequestTradeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
     
	private static final String DB_URL = "jdbc:mysql://localhost:3306/poketrader?autoReconnect=true&useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "o{%}*pEhL@uIRUW]ZbmJ5V[2";

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Gets the current session and current user's name
		HttpSession session = request.getSession(false);
		String loginPage = "login-and-signup.jsp";
		String friendsPage = "friends.jsp";
		String user = (String) session.getAttribute("currentUser");
		String friend = request.getParameter("userB");
		String task = request.getParameter("task");
		
		if (session == null ||
    		session.getAttribute("currentUser") == null) {
    		// User is not authenticated
    		System.out.println("Session Error: you have been logged out.");
    		response.sendRedirect(loginPage);
    		return;
    	}
		
		// Prepare the SQL statement that checks for a pending trade request between user and friend
		String SQL_checkTrades = """
				SELECT *
				FROM trades
				WHERE (userA = ? AND userB = ?) AND
					  (userB = ? AND userA = ?) AND
					  (requestStatus = 'Pending trade request' OR requestStatus = 'Responding to trade request')
				""";
		
		// Prepare the SQL statement that inserts a new "trade log" into the 'trades' table
		String SQL_insertTrades = """
				INSERT INTO trades (userA, userB, requestStatus, tradeStatus, userACardName, userBCardName)
				VALUES
				(?, ?, ?, ?, ?, ?),
				(?, ?, ?, ?, ?, ?)
				""";
		
		// Prepare the SQL statement that updates the trade log's requestStatus to "Accepted" for both user and friend
		String SQL_updateTrades = """
				UPDATE trades
				SET requestStatus = "Accepted",
					tradeStatus = "Trade In Process"
				WHERE (userA = ? and userB = ?) OR (userA = ? and userB = ?)
				""";
		
		try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
			 PreparedStatement checkTrades = connection.prepareStatement(SQL_checkTrades);
			 PreparedStatement insertTrades = connection.prepareStatement(SQL_insertTrades);
			 PreparedStatement updateTrades = connection.prepareStatement(SQL_updateTrades)) {
			
			if (task.equals("addTradeRequest")) {
				checkTrades.setString(1, user);
				checkTrades.setString(2, friend);
				checkTrades.setString(3, friend);
				checkTrades.setString(4, user);
				ResultSet checkTradesResult = checkTrades.executeQuery();
				// Case where the pending trade request has been found (i.e. two rows)
				// In this case, don't make the trade request.
				if (checkTradesResult.next()) {
					request.getRequestDispatcher(friendsPage).forward(request, response);
					System.out.println("checkTrades detection: Pending trade request exists. Cancelling creating another trade request.");
					return;
				}
				// Case where trade request between user and friend is not found
				else {
					// Don't do anything here. This check is clear.
				}
				
				insertTrades.setString(1, user);
				insertTrades.setString(2, friend);
				insertTrades.setString(3, "Pending trade request");
				insertTrades.setString(4, "Trade not started");
				insertTrades.setString(5, "NA"); // Default values for userACardName and userBCardName will be 'NA' (or 'No Card').
				insertTrades.setString(6, "NA"); // These defaulted values will be updated once each user offers a card to trade.
				insertTrades.setString(7, friend);
				insertTrades.setString(8, user);
				insertTrades.setString(9, "Responding to trade request");
				insertTrades.setString(10, "Trade not started");
				insertTrades.setString(11, "NA");
				insertTrades.setString(12, "NA");
				
				int rowsInsertedForTrades = insertTrades.executeUpdate();
				System.out.println("Rows inserted into 'trades' table: " + rowsInsertedForTrades);
			
				request.getRequestDispatcher(friendsPage).forward(request, response);
				return;
			}
			if (task.equals("acceptTradeRequest")) {
				updateTrades.setString(1, user);
				updateTrades.setString(2, friend);
				updateTrades.setString(3, friend);
				updateTrades.setString(4, user);
				
				int rowsUpdatedForTrades = updateTrades.executeUpdate();
				System.out.println("Rows updated in 'trades' table: " + rowsUpdatedForTrades);
				
				request.getRequestDispatcher(friendsPage).forward(request, response);
				return;
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		// TO-DO: Once the Message Servlet has been implemeneted,
		// try to implement the optional message in the Request Trade Form.
	}
}
