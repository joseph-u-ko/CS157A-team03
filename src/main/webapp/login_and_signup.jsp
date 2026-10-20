<%@ page import="java.sql.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<html>
	<head>
	    <meta charset="UTF-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <title>PokeTrader Login</title>
	    <link rel="stylesheet" href="login_and_signup.css">
	</head>
	<body>
		<%-- Database connection --%>
		<%
		 String db = "poketrader";
		    String user; // assumes database name is the same as username
		      user = "root";
		    String password = "o{%}*pEhL@uIRUW]ZbmJ5V[2";
		    
		    try {
		        java.sql.Connection con;
		        Class.forName("com.mysql.cj.jdbc.Driver");
		        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/poketrader?autoReconnect=true&useSSL=false", user, password); 
		        con.close();
		    } 
		    catch(SQLException e) {
		        out.println("SQLException caught: " + e.getMessage());
		    } 
		%>
		
		<%-- Title bar --%>
		<h1>
			<img src="https://upload.wikimedia.org/wikipedia/commons/5/53/Pok%C3%A9_Ball_icon.svg?utm_source=commons.wikimedia.org&utm_campaign=index&utm_content=original"
				alt="A red-and-white pokeball icon at the top of the webpage"
				width="100"
				class="inline-title-img">
			Welcome to The PokéTrader Website
			<img src="https://upload.wikimedia.org/wikipedia/commons/5/53/Pok%C3%A9_Ball_icon.svg?utm_source=commons.wikimedia.org&utm_campaign=index&utm_content=original"
				alt="A red-and-white pokeball icon at the top of the webpage"
				width="100"
				class="inline-title-img">
		</h1>
		
		<%-- The pikachu in the signup/login page (Will replace with an original illustration later) --%>
		<div class=center>
			<a href="https://www.freeiconspng.com/img/32576" title="Image from freeiconspng.com">
				<img src="https://www.freeiconspng.com/uploads/pikachu-transparent-hd-1.png"
					width="350" 
					alt="pikachu transparent hd"/>
			</a>
		</div>
		
		<%-- Flex container for Sign-up Box and Login Box --%>
		<div class="parent-container">
			<%-- Sign-up Box --%>
			<div class="child-box">
				<form action="signup" method="post">
					<label>Username:</label>
					<input type="text" name="username" required>
					<br><br>
					
					<label>Password:</label>
					<input type="password" name="password" required>
					<br><br>
					
					<label>Reconfirm Password:</label>
					<input type="password" name="reconfirmed_password" required>
					<br><br>
					
					<button type="submit">Sign Up</button>
				</form>
				<%-- An error message will appear below sign-up button if something goes wrong with sign-up. --%>
				<%
			        String signupError = (String) request.getAttribute("signupError");
			        if (signupError != null) {
			    %>
			        <p style="color:red;"><%= signupError %></p>
			    <%
			        }
			    %>
			</div>
			
			<%-- Login Box --%>
			<div class="child-box">
				<form action="login" method="post">
					<label>Username:</label>
					<input type="text" id="username" name="username" required>
					<br><br>
					
					<label>Password:</label>
					<input type="password" id="password" name="password" required>
					<br><br>
					
					<button type="submit">Login</button>
				</form>
				<%-- An error message will appear below login button if something goes wrong with login. --%>
				<%
			        String loginError = (String) request.getAttribute("loginError");
			        if (loginError != null) {
			    %>
			        <p style="color:red;"><%= loginError %></p>
			    <%
			        }
			    %>
			</div>
		</div>
			
	</body>
</html>