<%@ page contentType="text/html; charset=UTF-8" language = "java"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="pokemonInfo.Card" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Binder</title>
	</head>
<body>
		<div style="position: fixed; bottom: 20px; right: 20px; width: 100px; height: 50px; border-radius: 5px; border: 2px solid #333;">
			<form action="home.jsp" method="get">
				<button type="submit" style="width: 100px; height: 50px;">Home</button>
			</form>	
		</div>
<%
	ArrayList<Card> cards = (ArrayList<Card>) session.getAttribute("cards");
	String search = (String) session.getAttribute("search");
	if (search == null) search = "";
%>
	<form action="binder" method="post">
		<input type="text" name="cardName" value="<%= search %>" placeholder="Search card name">
		<button type="submit">Search</button>
	</form>
	<table border="1">
		<tr> 
    		<th>Card ID</th>
    		<th>Card Name</th>
    		<th>Card Type</th>
    		<th>Card Sub Type</th>
    		<th>Rarity</th>
    		<th>Image Link</th>
    		<th>Quantity</th>
    		<th>Set Name</th>
   		</tr>
<%
    if (cards == null || cards.isEmpty()) {
%>
        <tr><td colspan="8">You don't own any cards yet.</td></tr>
<%
    } else {
        for (Card card : cards) {
%>
        <tr>
            <td><%= card.getCardID() %></td>
            <td><%= card.getCardName() %></td>
            <td><%= card.getCardType() %></td>
            <td><%= card.getSubType() %></td>
            <td><%= card.getRarity() %></td>
            <td><img src="<%= card.getImageLink() %>" height="80" alt=""></td>
            <td><%= card.getQuantity() %></td>
            <td><%= card.getSetName() %></td>
        </tr>
<%
        }
    }
%>
	</table>
        
</body>
</html>