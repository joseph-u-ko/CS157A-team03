<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="pokemonInfo.Card" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Catalog</title>
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
<body style="background-color: lightblue;">
	<div style="position: fixed; bottom: 20px; right: 20px; width: 100px; height: 50px; border-radius: 5px; border: 2px solid #333; background-color: white; overflow: hidden;">
		<button type="button" class="nav-btn" onclick="window.location.href='home.jsp';">&#8592; Back</button>
	</div>
<%
	ArrayList<Card> cards = (ArrayList<Card>) session.getAttribute("cardsCat");
	ArrayList<String> setNames = (ArrayList<String>) session.getAttribute("setNames");
	Boolean found = (Boolean) session.getAttribute("cardsFoundCat");
	session.removeAttribute("cardsFound"); // so it doesn't affect later searches

	if (setNames == null) setNames = new ArrayList<String>();
%>
	<%-- Search bar + set dropdown --%>
	<div style="width: 600px; background-color: white; border-radius: 5px; border: 2px solid #333; padding: 10px; margin: 25px auto 0 auto; text-align: center;">
		<form action="catalog" method="post" style="margin: 0;">
			<input type="text" name="cardName" placeholder="Search card name">
			<select name="setName">
				<option value="">All sets</option>
<%
	for (String s : setNames) {
%>
				<option value="<%= s %>"><%= s %></option>
<%
	}
%>
			</select>
			<button type="submit">Search</button>
		</form>
	</div>
<% if ((found != null) && (!found)) { %>
	<div style="width: 600px; background-color: white; border-radius: 5px; border: 2px solid #333; padding: 10px; margin: 15px auto 0 auto; text-align: center; color: darkred;">
		Card not found
	</div>
<% } %>
<%
	if (cards == null || cards.isEmpty()) {
%>
	<div style="width: 600px; background-color: white; border-radius: 5px; border: 2px solid #333; padding: 10px; margin: 25px auto 0 auto; text-align: center;">
		<p style="margin: 0;">No cards to display. Try a search above.</p>
	</div>
<%
	} else {
%>
	<%-- Details of the card currently shown --%>
	<div style="width: 1000px; background-color: white; border-radius: 5px; border: 2px solid #333; padding: 10px; margin: 25px auto 0 auto;">
		<table border="1" style="width: 100%; border-collapse: collapse; text-align: center;">
			<tr>
				<th style="padding: 8px;">Card Name</th>
				<th style="padding: 8px;">Card Type</th>
				<th style="padding: 8px;">Card Sub Type</th>
				<th style="padding: 8px;">Rarity</th>
				<th style="padding: 8px;">Set Name</th>
			</tr>
			<tr>
				<td id="f-name" style="padding: 8px;"></td>
				<td id="f-type" style="padding: 8px;"></td>
				<td id="f-sub" style="padding: 8px;"></td>
				<td id="f-rarity" style="padding: 8px;"></td>
				<td id="f-set" style="padding: 8px;"></td>
			</tr>
		</table>
	</div>

	<%-- Card image with prev/next arrows --%>
	<div style="width: 1000px; height: 500px; background-color: white; border-radius: 5px; border: 2px solid #333; margin: 25px auto 0 auto; display: flex; align-items: center; justify-content: center;">
		<button type="button" class="arrow" id="prevBtn" style="font-size: 40px; width: 64px; height: 64px; border-radius: 50%; border: 2px solid #333; background-color: white; cursor: pointer;">&#8592;</button>
		<img id="cardImage" src="" alt="" style="max-height: 460px; max-width: 700px; margin: 0 40px;">
		<button type="button" class="arrow" id="nextBtn" style="font-size: 40px; width: 64px; height: 64px; border-radius: 50%; border: 2px solid #333; background-color: white; cursor: pointer;">&#8594;</button>
	</div>
	<div id="counter" style="text-align: center; margin-top: 10px;"></div>

	<%-- Scrollable grid of every card in the results; clicking one shows it in the viewer above --%>
	<div id="grid" style="width: 1000px; background-color: white; border-radius: 5px; border: 2px solid #333; padding: 10px; margin: 25px auto 80px auto; display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;"></div>

	<%-- All cards, written out once by the server and read by the script --%>
	<div id="cardData" style="display:none;">
<%
		for (Card c : cards) {
%>
		<div
			data-name="<%= c.getCardName() %>"
			data-type="<%= c.getCardType() %>"
			data-sub="<%= c.getSubType() %>"
			data-rarity="<%= c.getRarity() %>"
			data-set="<%= c.getSetName() %>"
			data-img="<%= c.getImageLink() %>">
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
		var grid = document.getElementById('grid');

		function show(i) {
			index = i;
			var d = items[index].dataset;
			document.getElementById('f-name').textContent = d.name;
			document.getElementById('f-type').textContent = d.type;
			document.getElementById('f-sub').textContent = d.sub;
			document.getElementById('f-rarity').textContent = d.rarity;
			document.getElementById('f-set').textContent = d.set;
			document.getElementById('cardImage').src = d.img;
			document.getElementById('counter').textContent = (index + 1) + ' / ' + items.length;
			prevBtn.disabled = (index === 0);
			nextBtn.disabled = (index === items.length - 1);

			// Highlight the selected card in the grid
			for (var k = 0; k < grid.children.length; k++) {
				grid.children[k].style.borderColor = (k === index) ? '#333' : 'transparent';
			}
		}

		prevBtn.onclick = function () { if (index > 0) show(index - 1); };
		nextBtn.onclick = function () { if (index < items.length - 1) show(index + 1); };

		// Keyboard left/right arrows (ignored while typing in the search box or using the dropdown)
		document.addEventListener('keydown', function (e) {
			if (e.target.tagName === 'INPUT' || e.target.tagName === 'SELECT') return;
			if (e.key === 'ArrowLeft' && index > 0) show(index - 1);
			if (e.key === 'ArrowRight' && index < items.length - 1) show(index + 1);
		});

		// Build the grid of all cards
		items.forEach(function (item, i) {
			var d = item.dataset;
			var img = document.createElement('img');
			img.src = d.img;
			img.alt = d.name;
			img.title = d.name;
			img.loading = 'lazy';
			img.style.cssText = 'width: 150px; cursor: pointer; border: 3px solid transparent; border-radius: 5px;';
			img.onclick = function () {
				show(i);
				window.scrollTo({ top: 0, behavior: 'smooth' });
			};
			grid.appendChild(img);
		});

		show(0);
	</script>
<%
	}
%>
</body>
</html>