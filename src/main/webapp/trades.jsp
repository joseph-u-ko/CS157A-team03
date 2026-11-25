<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    String currentUser = (String) session.getAttribute("currentUser");
    String userB = request.getParameter("userB");

    if (userB == null || userB.trim().isEmpty()) {
        userB = "Friend";
    }

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
					</div>
					<button type="button" class="trade-button" style="margin-top: 20px;">
						Offer For Trade
					</button>
				</div>
				<div class="offered-trade-container">
					<h2><%=userB%>'s Card</h2>
					<div class="offered-card-container">
					</div>
					<button type="button" class="trade-button" style="margin-top:20px;">
						Offer For Trade
					</button>
				</div>
			</div>
			
			<div class="trade-buttons-container">
				<button type="button" class="trade-button">
					Accept Trade
				</button>
				<button type="button" class="trade-button">
					Decline Trade
				</button>
			</div>
		</div>
		
		<div class="back-button-container">
			<button type="button" class="back-button" onclick="window.location.href='friends.jsp';">
				&#8592; Back to Friends
			</button>
		</div>
	</body>
</html>