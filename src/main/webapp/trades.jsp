<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="pokemonInfo.DBPassword" %>
<!DOCTYPE html>

<%
    String currentUser = (String) session.getAttribute("currentUser");
    String userB = request.getParameter("userB");
    String cardIDOffered = request.getParameter("cardIDOffered");

    if (userB == null || userB.trim().isEmpty()) {
        userB = "Friend";
    }

    String tradeRequestStatus = null;
    String currentTradeStatus = null;
    String currentCardImageLink = null;
    String otherCardImageLink = null;
    String otherCardID = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/poketrader?autoReconnect=true&useSSL=false";
        String user = "root";
        String password = DBPassword.YOUR_PASSWORD;

        String tradeQuery =
            "SELECT status, tradeStatus, cardIDOffered " +
            "FROM users WHERE username = ? AND otherUser = ?";
        String otherTradeQuery =
            "SELECT cardIDOffered " +
            "FROM users WHERE username = ? AND otherUser = ?";
        String cardImageQuery =
            "SELECT imageLink FROM cards WHERE cardID = ?";

        try (Connection con = DriverManager.getConnection(url, user, password);
             PreparedStatement getTrade = con.prepareStatement(tradeQuery)) {
            getTrade.setString(1, currentUser);
            getTrade.setString(2, userB);

            try (ResultSet tradeRs = getTrade.executeQuery()) {
                if (tradeRs.next()) {
                    tradeRequestStatus = tradeRs.getString("status");
                    currentTradeStatus = tradeRs.getString("tradeStatus");

                    if (cardIDOffered == null || cardIDOffered.trim().isEmpty()) {
                        cardIDOffered = tradeRs.getString("cardIDOffered");
                    }
                }
            }

            if (cardIDOffered != null && !cardIDOffered.trim().isEmpty()) {
                try (PreparedStatement getCurrentCard =
                         con.prepareStatement(cardImageQuery)) {
                    getCurrentCard.setInt(1, Integer.parseInt(cardIDOffered));
                    try (ResultSet cardRs = getCurrentCard.executeQuery()) {
                        if (cardRs.next()) {
                            currentCardImageLink = cardRs.getString("imageLink");
                        }
                    }
                }
            }

            try (PreparedStatement getOtherTrade =
                     con.prepareStatement(otherTradeQuery)) {
                getOtherTrade.setString(1, userB);
                getOtherTrade.setString(2, currentUser);
                try (ResultSet otherTradeRs = getOtherTrade.executeQuery()) {
                    if (otherTradeRs.next()) {
                        otherCardID = otherTradeRs.getString("cardIDOffered");
                    }
                }
            }

            if (otherCardID != null && !otherCardID.trim().isEmpty()) {
                try (PreparedStatement getOtherCard =
                         con.prepareStatement(cardImageQuery)) {
                    getOtherCard.setInt(1, Integer.parseInt(otherCardID));
                    try (ResultSet cardRs = getOtherCard.executeQuery()) {
                        if (cardRs.next()) {
                            otherCardImageLink = cardRs.getString("imageLink");
                        }
                    }
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    boolean tradeInProgress =
        "In Progress".equalsIgnoreCase(tradeRequestStatus);
    boolean tradeAccepted =
        "Accepted".equalsIgnoreCase(currentTradeStatus);
    boolean tradeDeclined =
        "Declined".equalsIgnoreCase(currentTradeStatus);
    boolean bothCardsSelected =
        cardIDOffered != null && !cardIDOffered.trim().isEmpty()
        && otherCardID != null && !otherCardID.trim().isEmpty();
%>

<html>
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title><%=userB%></title>
		<style>
			body {
				background-color: lightblue;
				font-family: Arial, sans-serif;
			}
			.page-title {
				width: 500px;
				min-height: 70px;
				background-color: white;
				border-radius: 2px;
				border: 2px solid #333;
				text-align: center;
				margin: 30px auto 0;
				display: flex;
				align-items: center;
				justify-content: center;
			}
			.trades-panel {
                width: 1000px;
                height: 700px;
                background-color: white;
                border-radius: 2px;
                border: 2px solid #333;
                margin: 35px auto;
                box-sizing: border-box;
                display: flex;
                flex-direction: column;
                align-items: center;
            }
            .offered-trade-container {
            	width: 495px;
            	height: 600px;
            	border: 2px solid #333;
            	border-radius: 1px;
            	margin: 0.3px;
            	display: flex;
            	flex-direction: column;
            	justify-content: center;
            	align-items: center;
            }
            .offered-card-container {
            	width: 300px;
            	height: 400px;
            	border: 2px solid #333;
            	border-radius: 1px;
				display: flex;
				align-items: center;
				justify-content: center;
				overflow: hidden;
			}
			.offered-card-image {
				max-width: 100%;
				max-height: 100%;
				object-fit: contain;
            }
            .trade-button {
            	width: 100px;
            	height: 50px;
				padding: 10px 16px;
				border: 2px solid #333;
				border-radius: 4px;
				background-color: white;
				font-size: 16px;
				cursor: pointer;
			}
			.trade-buttons-container {
				display: flex;
				flex-direction: row;
				gap: 20px;
				margin-top: 20px;
			}
				.trade-result-overlay {
					position: fixed;
					top: 0;
					left: 0;
					width: 100%;
					height: 100%;
					background-color: rgba(0, 0, 0, 0.45);
					display: flex;
					align-items: center;
					justify-content: center;
				}
				.trade-result-box {
					width: 360px;
					min-height: 160px;
					padding: 25px;
					background-color: white;
					border: 2px solid #333;
					border-radius: 5px;
					text-align: center;
					box-sizing: border-box;
				}
            .back-button {
				padding: 10px 16px;
				border: 2px solid #333;
				border-radius: 4px;
				background-color: white;
				font-size: 16px;
				cursor: pointer;
			}
			.back-button-container {
				position: fixed;
				bottom: 20px;
				right: 20px;
			}
		</style>
	</head>
	<body>
		<div class="page-title">
			<h1>Trades with <%=userB%></h1>
		</div>
		
		<div class="trades-panel">
			<div style="display: flex; flex-direction: row;">
				<div class="offered-trade-container">
					<h2>Your Card</h2>
					<div class="offered-card-container">
						<% if (currentCardImageLink != null) { %>
							<img class="offered-card-image"
								 src="<%=currentCardImageLink%>"
								 alt="Your offered card">
						<% } %>
					</div>
					<form action="card-select.jsp" method="get">
						<input type="hidden" name="userB" value="<%=userB%>">
						<button type="submit" class="trade-button" style="margin-top: 20px;">
							Select Card
						</button>
					</form>
				</div>
				<div class="offered-trade-container">
					<h2><%=userB%>'s Card</h2>
					<div class="offered-card-container">
						<% if (otherCardImageLink != null) { %>
							<img class="offered-card-image"
								 src="<%=otherCardImageLink%>"
								 alt="<%=userB%>'s offered card">
						<% } %>
					</div>
				</div>
			</div>
			
				<% if (tradeInProgress && !tradeAccepted && !tradeDeclined) { %>
    				<div class="trade-buttons-container">
        				<% if (bothCardsSelected) { %>
            				<form action="<%=request.getContextPath()%>/tradeAction" method="post">
                				<input type="hidden" name="action" value="accept">
                				<input type="hidden" name="userB" value="<%=userB%>">
                				<button type="submit" class="trade-button">
                    				Accept Trade
                				</button>
            				</form>
        				<% } %>
        				<form action="<%=request.getContextPath()%>/tradeAction" method="post">
            				<input type="hidden" name="action" value="decline">
            				<input type="hidden" name="userB" value="<%=userB%>">
            				<button type="submit" class="trade-button">
                				Decline Trade
            				</button>
        				</form>
    				</div>
				<% } %>
		</div>
		
		<div class="back-button-container">
			<button type="button" class="back-button" onclick="window.location.href='friends.jsp';">
				&#8592; Back to Friends
			</button>
		</div>

			<% if (tradeAccepted || tradeDeclined) { %>
				<div class="trade-result-overlay">
					<div class="trade-result-box">
						<p>
							<%=tradeAccepted
								? "The trade was accepted."
								: "The trade was declined."%>
						</p>
						<form action="<%=request.getContextPath()%>/resetTradeStatus" method="post">
							<input type="hidden" name="userB" value="<%=userB%>">
							<button type="submit" class="trade-button">
								Done
							</button>
						</form>
					</div>
				</div>
			<% } %>
	</body>
</html>
