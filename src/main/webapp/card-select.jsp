<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="pokemonInfo.DBPassword" %>
<!DOCTYPE html>

<%
    String currentUser = (String) session.getAttribute("currentUser");
    String userB = request.getParameter("userB");
    String search = request.getParameter("search");
    String cardIDOffered = request.getParameter("cardIDOffered");
    String selectionError = null;

    if (userB == null || userB.trim().isEmpty()) {
        userB = "Friend";
    }
    if (search == null) {
        search = "";
    }

    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login-and-signup.jsp");
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod())
            && cardIDOffered != null
            && !cardIDOffered.trim().isEmpty()) {
        String url = "jdbc:mysql://localhost:3306/poketrader?autoReconnect=true&useSSL=false";
        String dbUser = "root";
        String password = DBPassword.YOUR_PASSWORD;

        String ownedCardQuery =
            "SELECT 1 FROM owns WHERE username = ? AND cardID = ?";
        String updateTradeQuery =
            "UPDATE users SET cardIDOffered = ? " +
            "WHERE username = ? AND otherUser = ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(url, dbUser, password);
                 PreparedStatement ownedCard = con.prepareStatement(ownedCardQuery);
                 PreparedStatement updateTrade = con.prepareStatement(updateTradeQuery)) {

                int selectedCardID = Integer.parseInt(cardIDOffered);
                ownedCard.setString(1, currentUser);
                ownedCard.setInt(2, selectedCardID);

                boolean ownsCard;
                try (ResultSet ownedCardRs = ownedCard.executeQuery()) {
                    ownsCard = ownedCardRs.next();
                }

                if (!ownsCard) {
                    selectionError = "You cannot select a card you do not own.";
                } else {
                    updateTrade.setInt(1, selectedCardID);
                    updateTrade.setString(2, currentUser);
                    updateTrade.setString(3, userB);

                    int updatedRows = updateTrade.executeUpdate();
                    if (updatedRows == 0) {
                        selectionError = "The trade could not be found.";
                    } else {
                        String encodedUserB = URLEncoder.encode(userB, "UTF-8");
                        response.sendRedirect(
                            request.getContextPath() + "/trades.jsp?userB="
                            + encodedUserB + "&cardIDOffered=" + selectedCardID
                        );
                        return;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            selectionError = "Unable to select this card.";
        }
    }
%>

<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Select a Card</title>
        <style>
            body {
                background-color: lightblue;
                font-family: Arial, sans-serif;
            }

            .page-title,
            .search-box,
            .cards-panel {
                background-color: white;
                border: 2px solid #333;
                border-radius: 5px;
                margin-left: auto;
                margin-right: auto;
            }

            .page-title {
                width: 500px;
                margin-top: 30px;
                text-align: center;
            }

            .search-box {
                width: 500px;
                margin-top: 25px;
                padding: 15px;
                box-sizing: border-box;
                text-align: center;
            }

            .cards-panel {
                width: 1000px;
                min-height: 500px;
                margin-top: 25px;
                padding: 20px;
                box-sizing: border-box;
            }

            .card-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
            }

            .card-option {
                min-height: 330px;
                padding: 10px;
                border: 2px solid #333;
                border-radius: 5px;
                background-color: white;
                cursor: pointer;
                text-align: center;
            }

            .card-option:hover {
                background-color: #e6f2ff;
                border-color: #0066cc;
            }

            .card-option img {
                width: 180px;
                height: 250px;
                object-fit: contain;
                display: block;
                margin: 0 auto 8px;
            }

            .card-option p {
                margin: 5px 0;
            }

            .empty-message,
            .error-message {
                text-align: center;
                padding: 20px;
            }

            .error-message {
                color: darkred;
            }

            .back-button-container {
                position: fixed;
                bottom: 20px;
                right: 20px;
            }

            .back-button,
            .search-button {
                padding: 10px 16px;
                border: 2px solid #333;
                border-radius: 4px;
                background-color: white;
                font-size: 16px;
                cursor: pointer;
            }
        </style>
    </head>

    <body>
        <div class="page-title">
            <h1>Select a Card for Trade</h1>
            <p>Trading with <%=userB%></p>
        </div>

        <div class="search-box">
            <form action="card-select.jsp" method="get">
                <input type="hidden" name="userB" value="<%=userB%>">
                <input type="text" name="search" value="<%=search%>"
                       placeholder="Search card name">
                <button type="submit" class="search-button">Search</button>
            </form>
        </div>

        <% if (selectionError != null) { %>
            <div class="error-message" style="width: 500px; margin: 15px auto 0;
                 background-color: white; border: 2px solid #333; border-radius: 5px;
                 box-sizing: border-box;">
                <%=selectionError%>
            </div>
        <% } %>

        <div class="cards-panel">
            <%
                boolean cardsFound = false;
                String query =
                    "SELECT c.cardID, c.cardName, c.cardType, c.subType, " +
                    "c.rarity, c.imageLink, o.quantity, s.setName " +
                    "FROM cards AS c " +
                    "JOIN owns AS o ON c.cardID = o.cardID " +
                    "JOIN sets AS s ON c.setCode = s.setCode " +
                    "WHERE o.username = ?";

                if (!search.trim().isEmpty()) {
                    query += " AND c.cardName LIKE ?";
                }
                query += " ORDER BY c.cardName ASC";

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String url = "jdbc:mysql://localhost:3306/poketrader?autoReconnect=true&useSSL=false";
                    String dbUser = "root";
                    String password = DBPassword.YOUR_PASSWORD;

                    try (Connection con = DriverManager.getConnection(url, dbUser, password);
                         PreparedStatement statement = con.prepareStatement(query)) {
                        int parameterIndex = 1;
                        statement.setString(parameterIndex++, currentUser);

                        if (!search.trim().isEmpty()) {
                            statement.setString(parameterIndex, "%" + search.trim() + "%");
                        }

                        try (ResultSet rs = statement.executeQuery()) {
            %>
                            <div class="card-grid">
                                <% while (rs.next()) {
                                    cardsFound = true;
                                    int cardID = rs.getInt("cardID");
                                    String cardName = rs.getString("cardName");
                                    String cardType = rs.getString("cardType");
                                    String subType = rs.getString("subType");
                                    String rarity = rs.getString("rarity");
                                    String imageLink = rs.getString("imageLink");
                                    int quantity = rs.getInt("quantity");
                                    String setName = rs.getString("setName");
                                %>
                                    <form action="card-select.jsp" method="post">
                                        <input type="hidden" name="userB" value="<%=userB%>">
                                        <button type="submit" name="cardIDOffered"
                                                value="<%=cardID%>" class="card-option">
                                            <img src="<%=imageLink%>" alt="<%=cardName%>">
                                            <p><strong><%=cardName%></strong></p>
                                            <p><%=setName%></p>
                                            <p><%=rarity%></p>
                                            <p>Quantity owned: <%=quantity%></p>
                                        </button>
                                    </form>
                                <% } %>
                            </div>
            <%
                        }
                    }

                    if (!cardsFound) {
            %>
                        <div class="empty-message">
                            <p>No matching cards found.</p>
                        </div>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
                    <div class="error-message">
                        Unable to load your cards.
                    </div>
            <%
                }
            %>
        </div>

        <div class="back-button-container">
            <button type="button" class="back-button"
                    onclick="window.location.href='trades.jsp?userB=<%=userB%>';">
                &#8592; Back to Trade
            </button>
        </div>
    </body>
</html>
