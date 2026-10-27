<%@ page contentType="text/html; charset=UTF-8" language = "java"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="pokemonInfo.Card" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Binder</title>
		<%-- Allows you to "hover" over your arrows, will gray out the arrow during hovering --%>
		<style>
			.arrow:hover:not(:disabled) {
				background-color: #333;
				color: white;
			}
			.arrow:disabled {
				opacity: 0.3;
				cursor: default;
			}
			.nav-btn {
				width: 100%;
				height: 100%;
				border: none;
				background-color: white;
				font-size: 16px;
				cursor: pointer;
			}
			.nav-btn:hover {
				background-color: #333;
				color: white;
			}
		</style>
	</head>
<<<<<<< Updated upstream
<body>
		<div style="position: fixed; bottom: 20px; right: 20px; width: 100px; height: 50px; border-radius: 5px; border: 2px solid #333;">
			<form action="home.jsp" method="get">
				<button type="submit" style="width: 100px; height: 50px;">Home</button>
			</form>	
		</div>
=======
<body style="background-color: lightblue;">
	<div style="position: fixed; bottom: 20px; right: 20px; width: 100px; height: 50px; border-radius: 5px; border: 2px solid #333; background-color: white; overflow: hidden;">
		<button type="button" class="nav-btn" onclick="window.location.href='home.jsp';">&#8592; Back</button>
	</div>
>>>>>>> Stashed changes
<%
	ArrayList<Card> cards = (ArrayList<Card>) session.getAttribute("cards");
	String search = (String) session.getAttribute("search");
	Boolean found = (Boolean) session.getAttribute("cardsFound");
	session.removeAttribute("found"); // have to remove this attribute in JSP, as it will affect later searches if not removed
	
	if (search == null) search = "";
%>
	<div style="width: 400px; background-color: white; border-radius: 5px; border: 2px solid #333; padding: 10px; margin: 25px auto 0 auto; text-align: center;">
		<form action="binder" method="post" style="margin: 0;">
			<input type="text" name="cardName" value="<%= search %>" placeholder="Search card name">
			<button type="submit">Search</button>
		</form>
	</div>
	<% if ((found != null) && (!found)) { // Since Boolean not boolean, it can be null and need to check for that %> 
	<div style="width: 400px; background-color: white; border-radius: 5px; border: 2px solid #333; padding: 10px; margin: 15px auto 0 auto; text-align: center; color: darkred;">
		Card not found
		
	</div>
<% } %>
<%
    if (cards == null || cards.isEmpty()) {
%>
	<div style="width: 400px; background-color: white; border-radius: 5px; border: 2px solid #333; padding: 10px; margin: 25px auto 0 auto; text-align: center;">
		<p style="margin: 0;">You don't own any cards yet.</p>
	</div>
<%
    } else {
%>
	<div style="width: 1000px; background-color: white; border-radius: 5px; border: 2px solid #333; padding: 10px; margin: 25px auto 0 auto;">
		<table border="1" style="width: 100%; border-collapse: collapse; text-align: center;">
			<tr>
	    		<th style="padding: 8px;">Card Name</th>
	    		<th style="padding: 8px;">Card Type</th>
	    		<th style="padding: 8px;">Card Sub Type</th>
	    		<th style="padding: 8px;">Rarity</th>
	    		<th style="padding: 8px;">Quantity</th>
	    		<th style="padding: 8px;">Set Name</th>
	   		</tr>
	   		<tr>
	   			<td id="f-name" style="padding: 8px;"></td>
	   			<td id="f-type" style="padding: 8px;"></td>
	   			<td id="f-sub" style="padding: 8px;"></td>
	   			<td id="f-rarity" style="padding: 8px;"></td>
	   			<td id="f-qty" style="padding: 8px;"></td>
	   			<td id="f-set" style="padding: 8px;"></td>
	   		</tr>
		</table>
	</div>
	
	<div style="width: 1000px; height: 500px; background-color: white; border-radius: 5px; border: 2px solid #333; margin: 25px auto 0 auto; display: flex; align-items: center; justify-content: center;">
		<button type="button" class="arrow" id="prevBtn" style="font-size: 40px; width: 64px; height: 64px; border-radius: 50%; border: 2px solid #333; background-color: white; cursor: pointer;">&#8592;</button>
		<img id="cardImage" src="" alt="" style="max-height: 460px; max-width: 700px; margin: 0 40px;">
		<button type="button" class="arrow" id="nextBtn" style="font-size: 40px; width: 64px; height: 64px; border-radius: 50%; border: 2px solid #333; background-color: white; cursor: pointer;">&#8594;</button>
	</div>
	<div id="counter" style="text-align: center; margin-top: 10px;"></div>

	<%-- All cards, written out once by the server and read by the script --%>
	<div id="cardData" style="display:none;">
	
<%
    	
        for (Card card : cards) {
%>

<div
			data-name="<%= card.getCardName() %>"
			data-type="<%= card.getCardType() %>"
			data-sub="<%= card.getSubType() %>"
			data-rarity="<%= card.getRarity() %>"
			data-qty="<%= card.getQuantity() %>"
			data-set="<%= card.getSetName() %>"
			data-img="<%= card.getImageLink() %>">
</div>
<%
        }
%>
	</div>

	<script>
		var items = Array.prototype.slice.call(document.querySelectorAll('#cardData > div'));
		var index = 0;
		var prevBtn = document.getElementById('prevBtn');
		var nextBtn = document.getElementById('nextBtn');

		function show(i) {
			index = i;
			var d = items[index].dataset;
			document.getElementById('f-name').textContent = d.name;
			document.getElementById('f-type').textContent = d.type;
			document.getElementById('f-sub').textContent = d.sub;
			document.getElementById('f-rarity').textContent = d.rarity;
			document.getElementById('f-qty').textContent = d.qty;
			document.getElementById('f-set').textContent = d.set;
			document.getElementById('cardImage').src = d.img;
			document.getElementById('counter').textContent = (index + 1) + ' / ' + items.length;
			prevBtn.disabled = (index === 0);
			nextBtn.disabled = (index === items.length - 1);
		}

		prevBtn.onclick = function () { if (index > 0) show(index - 1); };
		nextBtn.onclick = function () { if (index < items.length - 1) show(index + 1); };

		// Keyboard left/right arrows (ignored while typing in the search box)
		document.addEventListener('keydown', function (e) {
			if (e.target.tagName === 'INPUT') return;
			if (e.key === 'ArrowLeft' && index > 0) show(index - 1);
			if (e.key === 'ArrowRight' && index < items.length - 1) show(index + 1);
		});

		show(0);
	</script>
<%
    }
%>
        
</body>
</html>