<%@ page import="java.sql.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<html>
	<head>
	    <meta charset="UTF-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <title>PokeTrader Login</title>
	    <link rel="stylesheet" href="poketrader_styles.css">
	</head>
	<body>
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
		
		<div class=center>
			<a href="https://www.freeiconspng.com/img/32576" title="Image from freeiconspng.com">
				<img src="https://www.freeiconspng.com/uploads/pikachu-transparent-hd-1.png"
					width="350" 
					alt="pikachu transparent hd"/>
			</a>
		</div>
		
		<div class="parent-container">
			<div class="child-box">
				<form action="signup" method="post">
					<label>Username:</label>
					<input type="text" name="username" required>
					<br><br>
					
					<label>Password:</label>
					<input type="password" name="password" required>
					<br><br>
					
					<button type="submit">Sign Up</button>
				</form>
				<%-- This error message will show up if an error occurs in the signup box --%>
				<%
			        String signupError = (String) request.getAttribute("signupError");
			        if (signupError != null) {
			    %>
			        <p style="color:red;"><%= signupError %></p>
			    <%
			        }
			    %>
			    
			    <%-- This message will show up if signup is successful --%>
			    <%
			    	String signupSuccessMsg = (String) request.getAttribute("signupSuccess");
			    if (signupSuccessMsg != null) {
			    %>
			    	<p style="color:black;"><%= signupSuccessMsg %></p>
			    <%
			    	}
			    %>
			</div>
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
				<%
			        String loginError = (String) request.getAttribute("loginError");
			        if (loginError != null) {
			    %>
			        <p style="color:red;"><%= loginError %></p>
			    <%
			        }
			    %>
			    <%-- This message will show up if login is successful --%>
			    <%
			    	String loginSuccessMsg = (String) request.getAttribute("loginSuccess");
			    if (loginSuccessMsg != null) {
			    %>
			    	<p style="color:black;"><%= loginSuccessMsg %></p>
			    <%
			    	}
			    %>
			</div>
		</div>
			
	</body>
</html>
