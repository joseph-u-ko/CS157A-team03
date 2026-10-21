<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Placeholder Pack Opener</title>
    <link rel="stylesheet" href="pack-opening.css">
</head>
<body>
<main class="page">
    <div class="topbar">
        <button type="button" aria-label="Back">Back</button>
        <button type="button" class="dev" aria-label="Add one ticket">+1 Ticket</button>
    </div>

    <section class="hero">
        <!-- Replace the image path when you choose a different header image. -->
        <img src="https://i.imgur.com/BgBCuKo.jpeg" alt="Connected artwork featuring Miraidon ex and Koraidon ex">
        <h1>Placeholder Pack Opener</h1>
        <p class="subtitle">Placeholder instruction: select a Set before choosing a Pack.</p>
    </section>

    <section class="panel" aria-labelledby="selection-heading">
        <h2 id="selection-heading">Placeholder Pack Selection</h2>
        <div class="controls">
            <div>
                <label for="set-select">Placeholder Set</label>
                <select id="set-select">
                    <option value="">Placeholder: choose a Set</option>
                    <option value="set-1">Placeholder Set 1</option>
                    <option value="set-2">Placeholder Set 2</option>
                    <option value="set-3">Placeholder Set 3</option>
                </select>
            </div>
            <div>
                <label for="pack-select">Placeholder Pack</label>
                <select id="pack-select" disabled>
                    <option value="">Placeholder: choose a Set first</option>
                </select>
            </div>
            <button type="button" id="open-button" disabled>Placeholder Open</button>
        </div>
        <p class="placeholder">Placeholder: the selected pack will eventually be opened after ticket authentication.</p>
    </section>
</main>

<script>
    // Frontend-only filtering demo. Replace placeholder data with the values supplied by the page later.
    const packsBySet = {
        "set-1": ["Placeholder Pack 1", "Placeholder Pack 2", "Placeholder Pack 3"],
        "set-2": ["Placeholder Pack 1", "Placeholder Pack 2", "Placeholder Pack 3"],
        "set-3": ["Placeholder Pack 1", "Placeholder Pack 2", "Placeholder Pack 3"]
    };
    const setSelect = document.getElementById("set-select");
    const packSelect = document.getElementById("pack-select");
    const openButton = document.getElementById("open-button");

    setSelect.addEventListener("change", function () {
        const packs = packsBySet[this.value] || [];
        packSelect.innerHTML = "<option value=\"\">Placeholder: choose a Pack</option>";
        packs.forEach(function (pack, index) {
            const option = document.createElement("option");
            option.value = "pack-" + (index + 1);
            option.textContent = pack;
            packSelect.appendChild(option);
        });
        packSelect.disabled = packs.length === 0;
        openButton.disabled = true;
    });

    packSelect.addEventListener("change", function () {
        openButton.disabled = !this.value;
    });
</script>
</body>
</html>
