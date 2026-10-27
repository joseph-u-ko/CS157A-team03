<%@ page import="java.sql.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pack Store</title>
    <link rel="stylesheet" href="pack-open-menu.css">
</head>
<body>
		<%-- Obtaining username from session --%>
		<%
			String username = null;
			if (session != null) {
				username = (String) session.getAttribute("currentUser");
			}
		%>
		<%-- Database connection --%>
		<%
		 	String db = "jdbc:mysql://localhost:3306/poketrader?useSSL=false";
		    String user; // assumes database name is the same as username
		      user = "root";
		    String password = "$apphire9Warrior";
		    
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
		
		<!-- Ticket count -->
        <%
        	String SQL_numTickets = """
				SELECT tickets
				FROM users
				WHERE username = ?
				""";
        	int numTickets = 0;
        	try (
                Connection connection =
                    DriverManager.getConnection(db, user, password);

                PreparedStatement statement_numTickets =
                    connection.prepareStatement(SQL_numTickets);
            ) {
        		statement_numTickets.setString(1, username);
        		try (ResultSet result = statement_numTickets.executeQuery()) {
	        		if (result.next()) {
	        			numTickets = result.getInt("tickets");
	        		}
        		}
        	}
        %>
<main class="page">
    <div class="topbar">
        <button type="button" onclick="window.location.href='home.jsp';">Back</button>
        <form action="${pageContext.request.contextPath}/addTicket" method="post">
        	<button type="submit" class="dev" aria-label="Add one ticket">+1 Ticket</button>
        </form>
        
        <span class="ticket-count">
            Tickets: <%= numTickets %>
        </span>
    </div>
    
    <%
	    String ticketError =
	        (String) request.getAttribute("ticketError");
	
	    if (ticketError != null) {
	%>
	
	<div class="error-message">
	    <%= ticketError %>
	</div>
	
	<%
	    }
	%>
	
	<%
	    String updateError =
	        (String) request.getAttribute("updateError");
	
	    if (updateError != null) {
	%>
	
	<div class="error-message">
	    <%= updateError %>
	</div>
	
	<%
	    }
	%>

    <section class="hero">
        <!-- Replace the image path when you choose a different header image. -->
        <img src="https://i.imgur.com/BgBCuKo.jpeg" alt="Connected artwork featuring Miraidon ex and Koraidon ex">
        <h1>Welcome to the Pack Store!</h1>
        <p class="subtitle">Instructions: Select a Set before choosing a Pack. Then, click Open.</p>
    </section>

    <form action="${pageContext.request.contextPath}/openPack"
          method="post">
          
        <input type="hidden"
           name="numTickets"
           value="<%= numTickets %>">

        <section class="panel" aria-labelledby="selection-heading">

            <h2 id="selection-heading">
                Open a Pack! Each Pack costs 1 ticket.
            </h2>


            <div class="controls">

                <!-- Set dropdown -->
                <div>

                    <label for="set-select">
                        Choose the Set!
                    </label>

                    <select id="set-select"
                            name="setCode">

                        <option value="">
                            Select a Set
                        </option>

<%
    String SQL_getSets = """
        SELECT setCode, setName
        FROM sets
        ORDER BY setName
    """;

    try (
        Connection connection =
            DriverManager.getConnection(db, user, password);

        PreparedStatement statement_getSets =
            connection.prepareStatement(SQL_getSets);

        ResultSet result =
            statement_getSets.executeQuery()
    ) {
        while (result.next()) {
            String setCode = result.getString("setCode");
            String setName = result.getString("setName");
%>

                        <option value="<%= setCode %>">
                            <%= setName %>
                        </option>

<%
        }
    }
%>

                    </select>

                </div>


                <!-- Pack dropdown -->
                <div>

                    <label for="pack-select">
                        Choose the Pack!
                    </label>

                    <select id="pack-select"
                            name="packID"
                            disabled>

                        <option value="">
                            Select a Pack
                        </option>

                    </select>

                </div>


                <!-- Open button -->
                <button type="submit"
                        id="open-button"
                        disabled>
                    Open
                </button>

            </div>


            <p class="placeholder">
                Cards will automatically added to your binder. Pack opening results to be implemented later.
            </p>

        </section>

    </form>

</main>


<script>
    /*
     * This array is generated by the JSP using database data.
     * Each Pack is associated with a Set through setCode.
     */
    const packs = [

<%
    String SQL_getPacks = """
        SELECT packID, packName, available, setCode
        FROM packs
        ORDER BY setCode, packName
    """;

    try (
        Connection connection =
            DriverManager.getConnection(db, user, password);

        PreparedStatement statement_getPacks =
            connection.prepareStatement(SQL_getPacks);

        ResultSet result =
            statement_getPacks.executeQuery()
    ) {
        while (result.next()) {
            String packID = result.getString("packID");
            String packName = result.getString("packName");
            boolean available = result.getInt("available") == 1;
            String packSetCode = result.getString("setCode");
            if (available) {
%>

        {
            packID: "<%= packID %>",
            packName: "<%= packName %>",
            setCode: "<%= packSetCode %>"
        },

<%
            }
        }
    }
%>

    ];


    const setSelect = document.getElementById("set-select");
    const packSelect = document.getElementById("pack-select");
    const openButton = document.getElementById("open-button");


    /*
     * When the user selects a Set, display only the Packs
     * whose setCode matches the selected Set's setCode.
     */
    setSelect.addEventListener("change", function () {

        const selectedSetCode = this.value;

        packSelect.innerHTML =
            '<option value="">Placeholder: choose a Pack</option>';

        const matchingPacks = packs.filter(function (pack) {
            return pack.setCode === selectedSetCode;
        });


        matchingPacks.forEach(function (pack) {

            const option = document.createElement("option");

            option.value = pack.packID;
            option.textContent = pack.packName;

            packSelect.appendChild(option);
        });


        packSelect.disabled = matchingPacks.length === 0;
        openButton.disabled = true;
    });


    /*
     * Enable the Open button only after a Pack is selected.
     */
    packSelect.addEventListener("change", function () {
        openButton.disabled = this.value === "";
    });
</script>
</body>
</html>
