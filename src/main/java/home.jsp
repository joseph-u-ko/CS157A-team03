<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
		<title>Home Page</title>
	</head>
	<body style="background-color: lightblue;">
		<%-- Box showing current user --%>
		<div style="width: 200px; height: 50px; background-color: white; border-radius: 5px; border: 2px solid #333; text-align: center;">
			<p>
				Current User:
				<%
			        if (session != null) {
			        	String user = (String) session.getAttribute("currentUser");
			    %>
			    	<%=user%>
			    <%
				    }
				%>
			</p>
		</div>
		
		<%-- A logout button which has functionality tied to LogoutServlet.java --%>
		<div style="width: 100px; height: 50px; border-radius: 5px; border: 2px solid #333; margin-left: 50px; margin-top: 10px">
			<form action="logout" method="post">
				<button type="submit" style="width: 100px; height: 50px;">Log Out</button>
			</form>	
		</div>
		
		<%-- A button for adding friends --%>
		<div style="width: 100px; height: 50px; border-radius: 5px; border: 2px solid #333; margin-left: 50px; margin-top: 10px">
			<button onclick="addFriendFormPopup.showModal()" style="width: 100px; height: 50px;">Add a Friend</button>
		</div>
		
		
		<%-- The Pop-up Dialog --%>
		<dialog id="addFriendFormPopup">
			<form action="add-friend" method="post">
				<h3>Enter Friend</h3>
				
				<%-- Text Input Field --%>
				<label for="friend-user">Username:</label>
				<input type="text" id="friend-user" name="friend-user" placeholder="Type here..." required>
			
				<br></br>
				
				<%-- Action Buttons --%>
				<button type="submit">Submit</button>
				<button type="button" onclick="addFriendFormPopup.close()">Cancel</button>
			</form>
		</dialog>
		
		<c:if test="${showResponse}">
		    <script>
		        window.addEventListener('DOMContentLoaded', () => {
		            addFriendResponsePopup.showModal();
		        });
		    </script>
		</c:if>
		
		<dialog id="addFriendResponsePopup">
			<form method="post">
				<h3>Output:</h3>
				<p>
					<% String message = (String) request.getAttribute("popupMessage"); %>
					<%=message%>
				<p>
				<button type="button" onclick="addFriendResponsePopup.close()">Ok</button>
			</form>
		</dialog>
		
		
		<%-- Home Page Title Text (centered on home page) --%>
		<div style="width: 600px; text-align: center; background-color: white; border-radius: 5px; border: 2px solid #333; margin-top: 25px; margin-left: 500px; margin-right: 500px;">
			<p>Welcome to PokéTrader!</p>
		</div>
		
		<%-- Container for navigator-div and image-div --%>
		<div style="display: flex;">
			<div style="width: 150px; height: 500px; background-color: white; border-radius: 5px; border: 2px solid #333; margin-top: 25px; margin-left: 25px;">
				<div style="width: 100px; height: 75px; border-radius: 5px; border: 2px solid #333; margin: auto; margin-top: 60px;">
					<%-- TODO: Add 'action="Home" method="post"' to <form>--%>
					<form>
						<button type="button" style="width: 100px; height: 75px;">Home</button>
					</form>
				</div>
				<div style="width: 100px; height: 75px; border-radius: 5px; border: 2px solid #333; margin: auto; margin-top: 10px;">
					<form action="binder" method="post">
						<button type="submit" style="width: 100px; height: 75px;">Binder</button>
					</form>	
				</div>
				<div style="width: 100px; height: 75px; border-radius: 5px; border: 2px solid #333; margin: auto; margin-top: 10px;">
					<form>
						<button type="button" style="width: 100px; height: 75px;" onclick="window.location.href='pack-open-dropdowns.jsp';">Shop</button>
					</form>	
				</div>
				<div style="width: 100px; height: 75px; border-radius: 5px; border: 2px solid #333; margin: auto; margin-top: 10px;">
					<form>
						<button type="button" style="width: 100px; height: 75px;">Trade</button>
					</form>	
				</div>
			</div>
			<div style="width: 900px; height: 500px; border-radius: 5px; border: 2px solid #333; margin-top: 25px; margin-left: 25px;">
				<img src="https://corporate.bestbuy.com/wp-content/uploads/2026/02/Pokemon-TCG-30th-Celebration-Facebook_EN-thegem-blog-default.jpg"
				alt="Picture of Pokemon 30th Anniversary"
				width = "900"
				height = "500"
				class="inline-title-img">
			</div>
			<div style="width: 350px; height: 500px; background-color: white; border-radius: 5px; border: 2px solid #333; margin-top: 25px; margin-left: 25px; text-align: center;">
				<p>Bulletin board updates go here (nextTicketTime, new Trade statuses)</p>
			</div>
		</div>
	</body>
</html>