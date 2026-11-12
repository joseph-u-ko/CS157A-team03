<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<!DOCTYPE html>

<%-- Used this source as inspiration to display the list of friends as a table --%>
<%-- https://stackoverflow.com/questions/31200393/how-to-display-a-database-table-in-the-jsp-page --%>

<html>
	<head>
		<meta charset="UTF-8">
		<title>Friends Page</title>
	</head>
	
	<%-- Using 'Back' button code from Thaneesha's catalog.jsp --%>
	<body style="background-color: lightblue">
		<div style="position: fixed; bottom: 20px; right: 20px; width: 100px; height: 50px; border-radius: 5px; border: 2px solid #333; background-color: white; overflow: hidden;">
			<button type="button" style="width: 100px; height: 50px;" onclick="window.location.href='home.jsp';">&#8592; Back</button>
		</div>
		
		<div style="width: 400px; height: 50px; background-color: white; border-radius: 2px; border: 2px solid #333; text-align: center; margin: auto;">
			<p>Friends</p>
		</div>
		<div style="width: 1000px; height: 900px; background-color: white; border-radius: 2px; border: 2px solid #333; margin: auto; margin-top: 50px; display: flex;">
			<%-- Shows list of user's friends and their statuses --%>
			<div style="width: 750px; height: 900px; border-radius: 2px; border: 2px solid #333; text-align: center; display: flex; justify-content: center;">
				<form method="post">
					<table style="border-collapse: separate; border-spacing: 20px 20px;">
						<tr>
							<th>Friend</th>
							<th>Status</th>
						</tr>
						<%
							try {
								Class.forName("com.mysql.cj.jdbc.Driver");
						        String url = "jdbc:mysql://localhost:3306/poketrader?autoReconnect=true&useSSL=false";
						        String user = "root";
						        String password = "o{%}*pEhL@uIRUW]ZbmJ5V[2";
						       	
						        String query = "SELECT * FROM friends WHERE userA = ?";
						        Connection con = DriverManager.getConnection(url, user, password);
						        PreparedStatement selectFriends = con.prepareStatement(query);
						        selectFriends.setString(1, (String) session.getAttribute("currentUser"));
						        ResultSet rs = selectFriends.executeQuery();
						       
					        	while(rs.next()) {        
						%>
									<tr>
										<td><%=rs.getString("userB") %></td>
										<td><%=rs.getString("status") %></td>
									</tr>
						<%
				        		}
					    %>
					    </table>
					    <%
					        	rs.close();
					    		selectFriends.close();
								con.close();
							}
							catch(Exception e) {
								e.printStackTrace();
							}
						%>
				</form>
			</div>
			<%-- Right-side divs that send friend request, accept friend request, and remove friends --%>
			<div style="width: 250px; height: 600px; border-radius: 2px; border: 2px solid #333;">
				<%-- Div for sending friend requests --%>
				<div style="width: 250px; height: 295px; border-radius: 2px; border: 2px solid #333; text-align: center;">
					<form action="requestFriend" method="post" style="margin-top: 80px;">
						<label>Friend's Username</label>
						<br>
						<input type="text" name="friendToRequest" required>
						<br><br>
						<button type="submit">Send friend request</button>
					</form>
					<%-- A message will appear below send-friend-request button that signals success/failure --%>
					<%
						String requestFriendOutput = (String) request.getAttribute("requestFriendOutput");
						if (requestFriendOutput != null) {
					%>
						<p style="color:red"><%=requestFriendOutput %></p>
					<%
						}
					%>
				</div>
				<%-- Div for accepting friend requests --%>
				<div style="width: 250px; height: 295px; border-radius: 2px; border: 2px solid #333; text-align: center;">
					<form action="addFriend" method="post" style="margin-top: 80px;">
						<label>Friend's Username</label>
						<br>
						<input type="text" name="friendToAdd" required>
						<br><br>
						<button type="submit">Accept friend request</button>
					</form>
					<%-- A message will appear below accept-friend button that signals success/failure of accepting the friend request --%>
					<%
						String acceptFriendOutput = (String) request.getAttribute("acceptFriendOutput");
						if (acceptFriendOutput != null) {
					%>
						<p style="color:red"><%=acceptFriendOutput %></p>
					<%
						}
					%>
				</div>
				<%-- Div for removing friends --%>
				<div style="width: 250px; height: 295px; border-radius: 2px; border: 2px solid #333; text-align: center;">
					<form action="removeFriend" method="post" style="margin-top: 80px;">
						<label>Friend's Username</label>
						<br>
						<input type="text" name="friendToRemove" required>
						<br><br>
						<button type="submit">Remove friend</button>
					</form>
					<%-- A message will appear below accept-friend button that signals success/failure of accepting the friend request --%>
					<%
						String removeFriendOutput = (String) request.getAttribute("removeFriendOutput");
						if (removeFriendOutput != null) {
					%>
						<p style="color:red"><%=removeFriendOutput %></p>
					<%
						}
					%>
				</div>
			</div>
		</div>
	</body>
</html>