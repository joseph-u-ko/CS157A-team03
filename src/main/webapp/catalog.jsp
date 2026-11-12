<%@ page import="java.sql.*"%>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="pokemonInfo.*" %>
<%!
	
	private static String h(String s) {
		if (s == null) return "";
		return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
				.replace("\"", "&quot;").replace("'", "&#39;");
	}
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Catalog</title>
		<style>
			.arrow:hover:not(:disabled) { background-color: #333; color: white; }
			.arrow:disabled { opacity: 0.3; cursor: default; }
			.nav-btn { width: 100%; height: 100%; border: none; background-color: white; font-size: 16px; cursor: pointer; }
			.nav-btn:hover { background-color: #333; color: white; }
			select:disabled { opacity: 0.5; cursor: not-allowed; background-color: #e6e6e6; }
		</style>
	</head>
<body style="background-color: lightblue;">
	<div style="position: fixed; bottom: 20px; right: 20px; width: 100px; height: 50px; border-radius: 5px; border: 2px solid #333; background-color: white; overflow: hidden;">
		<button type="button" class="nav-btn" onclick="window.location.href='home.jsp';">&#8592; Back</button>
	</div>

	<%-- Database connection --%>
<%
	// Taken from previous code (Isaiah's + other jsp) //

	String db = "jdbc:mysql://localhost:3306/poketrader?useSSL=false";
	String user;
	user = "root";
	String password = "Chingloo1234$$";

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

<%

	ArrayList<Card> cards = (ArrayList<Card>) session.getAttribute("cardsCat");
	Boolean found = (Boolean) session.getAttribute("cardsFoundCat");
	session.removeAttribute("cardsFoundCat"); // so the "not found" banner doesn't stick around

	Boolean selLimit = (Boolean) session.getAttribute("selLimit"); // will reference this from servlet, makes sure box stays checked reflecting what the user should be seeing
	boolean limitChecked = (selLimit == null) || selLimit;
	
	String search = (String) session.getAttribute("search");

	ArrayList<Set> setNames = new ArrayList<Set>();
	ArrayList<Pack> packNames = new ArrayList<Pack>();
	
	if (search == null) search = "";

%>

<%
	String SQL_getSets = """
		SELECT setCode, setName
		FROM sets
		ORDER BY setName
	""";

	String SQL_getPacks = """
		SELECT packName, packID, setCode
		FROM packs
		ORDER BY packName
	""";

	try (Connection connection = DriverManager.getConnection(db, user, password);
			PreparedStatement statement_getSets = connection.prepareStatement(SQL_getSets);
			PreparedStatement statement_getPacks = connection.prepareStatement(SQL_getPacks)) {

		try (ResultSet rs1 = statement_getSets.executeQuery()) {
			while (rs1.next()){
				setNames.add(new Set(rs1.getString("setCode"), rs1.getString("setName")));
			}
		}
		try (ResultSet rs2 = statement_getPacks.executeQuery()) {
			while (rs2.next()){
				packNames.add(new Pack(rs2.getString("packName"), rs2.getString("packID"), rs2.getString("setCode")));
			}
		}
	}
	catch(SQLException e) {
		out.println("SQLException caught: " + e.getMessage());
	}
%>

	<%-- Search bar + set dropdown + pack dropdown + limit checkbox --%>
	<div style="width: 800px; background-color: white; border-radius: 5px; border: 2px solid #333; padding: 10px; margin: 25px auto 0 auto; text-align: center;">
		<form action="catalog" method="post" style="margin: 0;">
			<input type="text" name="cardName" value="<%= search %>" placeholder="Search card name">
			
			<%-- Set dropdown: shows "setName - setCode", submits the setCode --%>
			<select name="setCode" id="setSelect">
				<option value="">All sets</option>
<%
	for (Set s : setNames) {
		String code = String.valueOf(s.getSetCode());
%>
				<option value="<%= code %>"><%= h(s.getSetName()) %> - <%= code %></option>
<%
	}
%>
			</select>

			<%-- Pack dropdown: grayed out until a set is chosen (a disabled select is not submitted) --%>
			<select name="packID" id="packSelect" disabled>
				<option value="">Select a set first</option>
			</select>

			<button type="submit">Search</button>

			<div style="margin-top: 8px;">
				<label>
					<input type="checkbox" name="limitResults" value="true"<%= limitChecked ? " checked" : "" %>>
					Display top 1000 results
				</label>
			</div>
		</form>
	</div>

	<%-- Every pack, tagged with its setCode, for the script below --%>
	<div id="packData" style="display:none;">
<%
	for (Pack p : packNames) {
%>
		<div data-set="<%= p.getSetCode() %>" data-id="<%= p.getPackID() %>" data-name="<%= h(p.getPackName()) %>"></div>
<%
	}
%>
	</div>

	<script>
		var setSelect = document.getElementById('setSelect');
		var packSelect = document.getElementById('packSelect');
		var packItems = Array.prototype.slice.call(document.querySelectorAll('#packData > div'));

		function updatePacks() {
			packSelect.innerHTML = '';

			// No set chosen: grayed out and unselectable
			if (setSelect.value === '') {
				packSelect.add(new Option('Select a set first', ''));
				packSelect.disabled = true;
				return;
			}

			// Set chosen: enable and show only that set's packs
			packSelect.add(new Option('All packs', ''));
			packItems.forEach(function (el) {
				if (el.dataset.set === setSelect.value) {   // Review this, see if we can split this part into Servlet (not sure if possible)
					packSelect.add(new Option(el.dataset.name, el.dataset.id));
				}
			});
			packSelect.disabled = false;
		}

		setSelect.addEventListener('change', updatePacks);
		updatePacks();
	</script>

<% if ((found != null) && (!found) && !search.isEmpty()) { %>
	<div style="width: 800px; background-color: white; border-radius: 5px; border: 2px solid #333; padding: 10px; margin: 15px auto 0 auto; text-align: center; color: darkred;">
		Card not found
	</div>
<% } %>
<%
	if (cards == null || cards.isEmpty()) {
%>
	<div style="width: 800px; background-color: white; border-radius: 5px; border: 2px solid #333; padding: 10px; margin: 25px auto 0 auto; text-align: center;">
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

	<%-- Scrollable grid of every card in the results --%>
	<div id="grid" style="width: 1000px; background-color: white; border-radius: 5px; border: 2px solid #333; padding: 10px; margin: 25px auto 80px auto; display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;"></div>

	<%-- All cards, written out once by the server and read by the script --%>
	<div id="cardData" style="display:none;">
<%
		for (Card c : cards) {
%>
		<div
			data-name="<%= h(c.getCardName()) %>"
			data-type="<%= h(c.getCardType()) %>"
			data-sub="<%= h(c.getSubType()) %>"
			data-rarity="<%= h(c.getRarity()) %>"
			data-set="<%= h(c.getSetName()) %>"
			data-img="<%= h(c.getImageLink()) %>">
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

			for (var k = 0; k < grid.children.length; k++) {
				grid.children[k].style.borderColor = (k === index) ? '#333' : 'transparent';
			}
		}

		prevBtn.onclick = function () { if (index > 0) show(index - 1); };
		nextBtn.onclick = function () { if (index < items.length - 1) show(index + 1); };

		document.addEventListener('keydown', function (e) {
			if (e.target.tagName === 'INPUT' || e.target.tagName === 'SELECT') return;
			if (e.key === 'ArrowLeft' && index > 0) show(index - 1);
			if (e.key === 'ArrowRight' && index < items.length - 1) show(index + 1);
		});

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