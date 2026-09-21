<%@ page import="java.sql.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
	<head>
	    <meta charset="UTF-8">
	    <meta name="viewport" content="width=device-wdith, initial-scale=1.0">
	    <title>Poketrader Webpage</title>
	    <link rel="stylesheet" href="poketrader_styles.css">
	    <style>
	    	.inline-title-img { /* for in-text align of pokeball icons with the title's text '*/
	    		width: 40px;
	    		height: auto;
	    		vertical-align: middle;  /* Keeps the image aligned with the center of the letters */
	    		margin-right: 12px; /* right-margin of pokeball */
	    		margin-left: 12px; /* left-margin of pokeball */
			}
	    </style>
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
		        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/poketrader?autoReconnect=true&useSSL=false",user, password);
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
				<p style="font-family: Fira Sans, sans-serif;">
					First time here? Sign up here to start your journey as a Pokémon Trainer today!
				</p>
				<p> 
					Email address: 
					<input type="text" id="email" name="email">
				</p>
				<p> 
					Password:
					<input type="text" id="password" name="password">
				</p>
				<p>
					Reconfirm password:
					<input type="text" id="rc_password" name="rc_password">
				</p>
				<button type="button">Sign Up</button>
			</div>
			<div class="child-box">
				<p style="font-family: Fira Sans, sans-serif;">
					Already have an account? Sign in here to continue your Pokémon journey!
				</p>
				<p>
					Email address:
					<input type="text" id="email" name="email">
				</p>
				<p>
					Password:
					<input type="text" id="password" name="password">
				</p>
				<button type="button">Sign In</button>
			</div>
		</div>
			
	</body>
</html>