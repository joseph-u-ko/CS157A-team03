<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="pokemonInfo.DBPassword" %>
<%
    // Check if session exists and if the specific attribute is null
    if (session == null || session.getAttribute("currentUser") == null) {
        response.sendRedirect("login-and-signup.jsp");
        return; // Stop further execution of the JSP
    }
%>
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

            .page-title h1 {
                font-size: 28px;
                margin: 12px;
            }

            .messages-panel {
                width: 800px;
                height: 700px;
                background-color: white;
                border-radius: 2px;
                border: 2px solid #333;
                margin: 35px auto;
                padding: 24px;
                box-sizing: border-box;
                display: flex;
                flex-direction: column;
            }

            /* The single message box scrolls when more than 50 messages are displayed. */
            .message-box {
                flex: 1;
                overflow-y: auto;
                border: 2px solid #333;
                border-radius: 4px;
                background-color: #f5f5f5;
                padding: 16px;
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .empty-message {
                color: #666;
                text-align: center;
                margin: auto;
            }

            .message {
                max-width: 70%;
                padding: 10px 14px;
                border-radius: 10px;
                overflow-wrap: anywhere;
            }

            .message-sent {
                align-self: flex-end;
                background-color: #cce5ff;
                border: 1px solid #80bdff;
            }

            .message-received {
                align-self: flex-start;
                background-color: #e2e3e5;
                border: 1px solid #b8b8b8;
            }

            .message-sender {
                display: block;
                font-size: 12px;
                font-weight: bold;
                margin-bottom: 4px;
            }

            .message-text {
                margin: 0;
                font-size: 16px;
            }

            .message-controls {
                display: flex;
                gap: 10px;
                margin-top: 18px;
            }

            .message-controls input {
                flex: 1;
                min-width: 0;
                padding: 10px;
                border: 1px solid #777;
                border-radius: 4px;
                font-size: 16px;
            }

            .message-controls button,
            .back-button {
                padding: 10px 16px;
                border: 2px solid #333;
                border-radius: 4px;
                background-color: white;
                font-size: 16px;
                cursor: pointer;
            }

            .message-controls button:hover,
            .back-button:hover {
                background-color: #e6e6e6;
            }

            .back-button-container {
                position: fixed;
                bottom: 20px;
                right: 20px;
            }

            @media (max-width: 850px) {
                .page-title,
                .messages-panel {
                    width: 90%;
                }
            }
        </style>
    </head>

    <body>
        <div class="back-button-container">
            <button type="button" class="back-button" onclick="window.location.href='friends.jsp';">
                &#8592; Back to Friends
            </button>
        </div>

        <div class="page-title">
            <h1>Messages with <%=userB%></h1>
        </div>

        <main class="messages-panel">
            <div class="message-box">
                <%
                    boolean hasMessages = false;
                    boolean messageQueryFailed = false;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");

                        String url = "jdbc:mysql://localhost:3306/poketrader?autoReconnect=true&useSSL=false";
                        String user = "root";
                        String password = DBPassword.YOUR_PASSWORD;

                        String SQL_getMessages = """
                                SELECT sender, recipient, message
                                FROM (
                                    SELECT sender, recipient, message, messageID
                                    FROM friendMessages
                                    WHERE (sender = ? AND recipient = ?)
                                       OR (sender = ? AND recipient = ?)
                                    ORDER BY messageID DESC
                                    LIMIT 50
                                ) AS newestMessages
                                ORDER BY messageID ASC
                                """;

                        try (Connection con = DriverManager.getConnection(url, user, password);
                             PreparedStatement statement_getMessages = con.prepareStatement(SQL_getMessages)) {

                            statement_getMessages.setString(1, currentUser);
                            statement_getMessages.setString(2, userB);
                            statement_getMessages.setString(3, userB);
                            statement_getMessages.setString(4, currentUser);

                            try (ResultSet rs = statement_getMessages.executeQuery()) {
                                while (rs.next()) {
                                    hasMessages = true;

                                    String sender = rs.getString("sender");
                                    String recipient = rs.getString("recipient");
                                    String message = rs.getString("message");
                                    boolean sentByCurrentUser = currentUser != null && currentUser.equals(sender);
                                    String messageClass = sentByCurrentUser
                                            ? "message message-sent"
                                            : "message message-received";
                %>
                                    <div class="<%=messageClass%>">
                                        <span class="message-sender"><%=sender%></span>
                                        <p class="message-text"><%=message%></p>
                                    </div>
                <%
                                }
                            }
                        }
                    } catch (Exception e) {
                        messageQueryFailed = true;
                        e.printStackTrace();
                %>
                        <p class="empty-message">Unable to load messages.</p>
                <%
                    }

                    if (!hasMessages && !messageQueryFailed) {
                %>
                        <p class="empty-message">No messages yet.</p>
                <%
                    }
                %>
            </div>

            <%-- PLACEHOLDER SERVLET: replace sendMessage when the messaging servlet is implemented. --%>
            <form class="message-controls" action="addMessage" method="post">
            	<input type="hidden" name="userB" value="<%=userB%>">
            	<input type="text" name="message" placeholder="Type a message..." required>
            	<button type="submit">Send</button>
            </form>
        </main>
    </body>
</html>
