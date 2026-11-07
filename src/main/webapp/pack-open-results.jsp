<%@ page import="java.util.ArrayList" %>
<%@ page import="pokemonInfo.Card" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pack Opening Results</title>
    <link rel="stylesheet" href="pack-open-results.css">
</head>
<body>

<%
    ArrayList<Card> cards =
        (ArrayList<Card>) request.getAttribute("cards");
%>

<main class="page">

    <div class="topbar">
        <button type="button"
                onclick="window.location.href='home.jsp';">
            Back
        </button>

        <button type="button"
                onclick="window.location.href='pack-open-menu.jsp';">
            Open Another Pack
        </button>
    </div>

    <section class="hero">
        <h1>Pack Opening Results</h1>
        <p class="subtitle">Here are the cards you pulled.</p>
    </section>

    <section class="results-panel"
             aria-labelledby="results-heading">

        <h2 id="results-heading">Your Cards</h2>

<%
    if (cards == null || cards.isEmpty()) {
%>
        <p class="empty-message">
            No card results were received.
        </p>
<%
    } else {
        int cardsToDisplay = Math.min(cards.size(), 10);
%>
        <!-- The CSS grid creates two rows when ten cards are supplied. -->
        <div class="card-grid">
<%
        for (int i = 0; i < cardsToDisplay; i++) {
            Card card = cards.get(i);
            String imageLink = card.getImageLink();
            String cardName = card.getCardName();
            String setName = card.getSetName();
            String rarity = card.getRarity();
            String cardType = card.getCardType();
            String subType = card.getSubType();
%>
            <article class="card-result">

<%
            if (imageLink != null && !imageLink.isBlank()) {
%>
                <img class="card-image"
                     src="<%= imageLink %>"
                     alt="<%= cardName %>">
<%
            } else {
%>
                <div class="image-placeholder">
                    Image unavailable
                </div>
<%
            }
%>

                <div class="card-info">
                    <h3><%= cardName %></h3>

                    <p class="card-detail">
                        <strong>Rarity:</strong>
                        <%= rarity %>
                    </p>

                    <p class="card-detail">
                        <strong>Type:</strong>
                        <%= cardType %>
                    </p>

<%
            if (subType != null && !subType.isBlank()) {
%>
                    <p class="card-detail">
                        <strong>Subtype:</strong>
                        <%= subType %>
                    </p>
<%
            }
%>
                </div>
            </article>
<%
        }
%>
        </div>
<%
    }
%>

    </section>

</main>

</body>
</html>

