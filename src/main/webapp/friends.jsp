<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="pokemonInfo.DBPassword" %>
<%
    // Check if session exists and if the specific attribute is null
    if (session == null || session.getAttribute("currentUser") == null) {
        response.sendRedirect("login-and-signup.jsp");
        return; // Stop further execution of the JSP
    }
%>
<!DOCTYPE html>

<html>
    <head>
        <meta charset="UTF-8">
        <title>Friends Page</title>
        <style>
            .friend-table {
                width: 95%;
                margin-top: 20px;
                font-size: 18px;
            }

            .friend-table th,
            .friend-table td {
                padding: 12px 16px;
            }

            .friend-table button {
                padding: 8px 12px;
                font-size: 16px;
            }
        </style>
    </head>

    <body style="background-color: lightblue">
        <div style="position: fixed; bottom: 20px; right: 20px; width: 100px; height: 50px; border-radius: 5px; border: 2px solid #333; background-color: white; overflow: hidden;">
            <button type="button" style="width: 100px; height: 50px;" onclick="window.location.href='home.jsp';">&#8592; Back</button>
        </div>

        <div style="width: 400px; height: 100px; background-color: white; border-radius: 2px; border: 2px solid #333; text-align: center; margin: auto;">
            <p style="font-size: 35px;">Friends</p>
        </div>
        <div style="width: 1000px; height: 900px; background-color: white; border-radius: 2px; border: 2px solid #333; margin: auto; margin-top: 50px; display: flex;">
            <%-- The database mirrors relationships so the current user is always userA. --%>
            <div style="width: 750px; height: 900px; border-radius: 2px; border: 2px solid #333; text-align: center; display: flex; justify-content: flex-start; align-items: flex-start;">
                <table class="friend-table" style="border-collapse: separate; border-spacing: 8px 8px;">
                    <tr>
                        <th>Username</th>
                        <th>Friend Status</th>
                        <th>Trade Status</th>
                        <th>Actions</th>
                    </tr>
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            String url = "jdbc:mysql://localhost:3306/poketrader?autoReconnect=true&useSSL=false";
                            String user = "root";
                            String password = DBPassword.YOUR_PASSWORD;
                            String currentUser = (String) session.getAttribute("currentUser");

                            String friendQuery =
                                "SELECT userA, userB, status " +
                                "FROM friends WHERE userA = ? ORDER BY userB ASC";
                            String tradeQuery =
                                "SELECT username, otherUser, status " +
                                "FROM users WHERE username = ?";

                            Map<String, String> tradeStatuses = new HashMap<>();
                            
                            // The following will track the status of the player's trade if there is one (either 0 or 1)
                            try (Connection con = DriverManager.getConnection(url, user, password);
                                 PreparedStatement getTrader = con.prepareStatement(tradeQuery)) {
                                getTrader.setString(1, currentUser);
                                try (ResultSet tradeRs = getTrader.executeQuery()) {
                                    while (tradeRs.next()) {
                                        String otherUser = tradeRs.getString("otherUser");
                                        if (otherUser != null) {
                                            tradeStatuses.put(otherUser, tradeRs.getString("status"));
                                        }
                                    }
                                }
                            }
                            
                            // The following will track every friend that the user has
                            try (Connection con = DriverManager.getConnection(url, user, password);
                                 PreparedStatement selectFriends = con.prepareStatement(friendQuery)) {
                                selectFriends.setString(1, currentUser);
                                try (ResultSet rs = selectFriends.executeQuery()) {
                                    while (rs.next()) {
                                        String otherUser = rs.getString("userB");
                                        String friendStatus = rs.getString("status");
                                        String tradeStatus = tradeStatuses.get(otherUser);
                    %>
                    <tr>
                        <td><%=otherUser %></td>
                        <td><%=friendStatus %></td>
                        <td><%=tradeStatus %></td>
                        <td>
                            <% if ("Accept Pending".equalsIgnoreCase(friendStatus)) { %>
                                <form action="removeFriend" method="post" style="display:inline;">
                                    <input type="hidden" name="friendToRemove" value="<%=otherUser%>">
                                    <button type="submit">Decline</button>
                                </form>
                                <form action="addFriend" method="post" style="display:inline;">
                                    <input type="hidden" name="friendToAdd" value="<%=otherUser%>">
                                    <button type="submit">Accept</button>
                                </form>
                            <% } else if ("Request Pending".equalsIgnoreCase(friendStatus)) { %>
                                <form action="removeFriend" method="post" style="display:inline;">
                                    <input type="hidden" name="friendToRemove" value="<%=otherUser%>">
                                    <button type="submit">Cancel request</button>
                                </form>
                            <% } else if ("Friend".equalsIgnoreCase(friendStatus)) { %>
                                <form action="removeFriend" method="post" style="display:inline;">
                                    <input type="hidden" name="friendToRemove" value="<%=otherUser%>">
                                    <button type="submit">Remove friend</button>
                                </form>
                                <form action="friend-messages.jsp" method="get">
    								<input type="hidden" name="userB" value="<%=otherUser%>">
    								<button type="submit">Message</button>
								</form>
								<% if (tradeStatus == null) { %>
									<form action="tradeRequest" method="post">
										<input type="hidden" name="userB" value="<%=otherUser%>">
										<input type='hidden' name="task" value="addTradeRequest">
										<button type="submit">Request Trade</button>
									</form>
								<% } else if ("Request Pending".equalsIgnoreCase(tradeStatus)) { %>
									<form action="tradeRequest" method="post">
										<input type="hidden" name="userB" value="<%=otherUser %>">
										<input type='hidden' name="task" value="acceptTradeRequest">
										<button type="submit">Accept Trade</button>
									</form>
									<form action="tradeRequest" method="post">
										<input type="hidden" name="userB" value="<%=otherUser %>">
										<input type='hidden' name="task" value="declineTradeRequest">
										<button type="submit">Decline Trade</button>
									</form>
								<% } else if ("Accept Pending".equalsIgnoreCase(tradeStatus)) { %>
									<form action="tradeRequest" method="post">
										<input type="hidden" name="userB" value="<%=otherUser%>">
										<input type='hidden' name="task" value="cancelTradeRequest">
										<button type="submit">Cancel Trade</button>
									</form>
								<% } else if ("In Progress".equalsIgnoreCase(tradeStatus)) { %>
									<form action="trade.jsp" method="get">
										<input type="hidden" name="userB" value="<%=otherUser%>">
										<button type="submit">Go To Trade</button>
									</form>
								<% } %>
                            <% } %>
                        </td>
                    </tr>
                    <%
                                    }
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </table>
            </div>

            <div style="width: 250px; display: flex; flex-direction: column; align-items: center;">
                <%-- Sending a new request remains the only username text box. --%>
                <div style="width: 250px; height: 295px; border-radius: 2px; border: 2px solid #333; text-align: center;">
                    <form action="requestFriend" method="post" style="margin-top: 80px;">
                        <label>Friend's Username</label>
                        <br>
                        <input type="text" name="friendToRequest" required>
                        <br><br>
                        <button type="submit">Send friend request</button>
                    </form>
                    <%
                        String requestFriendOutput = (String) request.getAttribute("requestFriendOutput");
                        if (requestFriendOutput != null) {
                    %>
                        <p style="color:red"><%=requestFriendOutput %></p>
                    <%
                        }
                    %>
                </div>

                <%
                    String tradeRequestError =
                        (String) request.getAttribute("tradeRequestError");
                %>

                <%-- This box is empty unless a trade error is provided. --%>
                <div style="width: 250px; height: 295px; margin-top: 25px;
                            border: 2px solid #333; border-radius: 2px;
                            background-color: #fff; text-align: center;">
                    <% if (tradeRequestError != null) { %>
                        <p style="color: red; margin: 10px 0;">
                            <%=tradeRequestError %>
                        </p>
                    <% } %>
                </div>
            </div>
        </div>
    </body>
</html>
