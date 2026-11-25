<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
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
                        <th>Friend</th>
                        <th>Status</th>
                        <th>Trade Request Status</th>
                        <th>Actions</th>
                    </tr>
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            String url = "jdbc:mysql://localhost:3306/poketrader?autoReconnect=true&useSSL=false";
                            String user = "root";
                            String password = "$apphire9Warrior";
                            String currentUser = (String) session.getAttribute("currentUser");

                            // This will query all the friends
                            String friendQuery = "SELECT * FROM friends f WHERE f.userA = ?";
                            // This will query who the current user is trading with
                            String tradeQuery = "SELECT * FROM trades t WHERE t.username = ?";
                            Connection con = DriverManager.getConnection(url, user, password);
                            PreparedStatement selectFriends = con.prepareStatement(friendQuery);
                            PreparedStatement getTrader = con.prepareStatement(tradeQuery);
                            selectFriends.setString(1, currentUser);
                            getTrader.setString(1, currentUser);
                            ResultSet rs = selectFriends.executeQuery();
                            while (rs.next()) {
                                String userB = rs.getString("userB");
                                String otherUser = userB;
                                String status = rs.getString("status");
                    %>
                    <tr>
                        <td><%=otherUser %></td>
                        <td>
                            <% if ("pending".equalsIgnoreCase(status) || isRecipientPending) { %>
                                Pending request
                            <% } else { %>
                                <%=status %>
                            <% } %>
                        </td>
                        <td>
                        	<% if (tradeRequestStatus != null) { %>
                        		<%=tradeRequestStatus%>
                        	<% } else { %>
                        		None
                        	<% } %>
                        </td>
                        <td>
                            <%-- A pending request can be cancelled by the sender. --%>
                            <% if ("request pending".equalsIgnoreCase(status)) { %>
                                <form action="removeFriend" method="post" style="display:inline;">
                                    <input type="hidden" name="friendToRemove" value="<%=otherUser%>">
                                    <button type="submit">Cancel request</button>
                                </form>
                            <% } %>

                            <%-- The mirrored recipient status is Accept pending. --%>
                            <% if (isRecipientPending) { %>
                                <form action="addFriend" method="post" style="display:inline;">
                                    <%-- addFriend already expects friendToAdd; this replaces the old text box. --%>
                                    <input type="hidden" name="friendToAdd" value="<%=otherUser%>">
                                    <button type="submit">Accept</button>
                                </form>
                                <form action="removeFriend" method="post" style="display:inline;">
                                    <input type="hidden" name="friendToRemove" value="<%=otherUser%>">
                                    <button type="submit">Decline</button>
                                </form>
                            <% } %>

                            <%-- Accepted friends can be removed or messaged. --%>
                            <% if ("accepted".equalsIgnoreCase(status) || "friend".equalsIgnoreCase(status)) { %>
                                <form action="removeFriend" method="post" style="display:inline;">
                                    <input type="hidden" name="friendToRemove" value="<%=otherUser%>">
                                    <button type="submit">Remove friend</button>
                                </form>
                                <form action="friend-messages.jsp" method="get">
    								<input type="hidden" name="userB" value="<%=otherUser%>">
    								<button type="submit">Message</button>
								</form>
								<% if (tradeRequestStatus == null) { %>
									<form action="handleTradeRequest" method="post">
										<input type="hidden" name="userB" value="<%=otherUser%>">
										<input type='hidden' name="task" value="addTradeRequest">
										<button type="submit">Request Trade</button>
									</form>
								<% } else if (tradeRequestStatus.equals("Responding to trade request")) { %>
									<form action="handleTradeRequest" method="post">
										<input type="hidden" name="userB" value="<%=otherUser %>">
										<input type='hidden' name="task" value="acceptTradeRequest">
										<button type="submit">Accept Trade Request</button>
									</form>
								<% } else if (tradeRequestStatus.equals("Accepted") && tradeStatus.equals("Trade In Process")) { %>				
                            		<form action="trades.jsp" method="get">
                            			<input type="hidden" name="userB" value="<%=otherUser %>">
                            			<button type="submit">Go To Trade</button>
                            		</form>
                            	<% } %>
                            <% } %>
                        </td>
                    </tr>
                    <%
                            }
                            rs.close();
                            selectFriends.close();
                            con.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </table>
            </div>

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
        </div>
    </body>
</html>