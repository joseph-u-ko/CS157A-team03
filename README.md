# CS157A-team03
## Project Description - 
PokéTrader is a website for Pokémon enthusiasts who just want to collect Pokémon cards without having to spend too much money on singles and packs. The website offers a way to open virtual packs of real sets in the Pokémon Trading Card Game and store them in a virtual “binder” for their collection. Additionally, it also allows users to engage in trades for cards that they want.

The primary goal of PokéTrader is to provide an accessible, free experience to the Pokémon Trading Card Game. Pokémon products (booster packs, booster boxes, booster bundles, Elite Trainer Boxes (ETBs), collector boxes & tins, etc.) are relatively expensive for the average consumer to purchase. 

The major stakeholders are primarily Pokémon fans, who will be the main target audience of this website application.

Our specific innovation is to provide more variety to enjoy the Pokémon Trading Card Game pack-opening and trading experience. Pokémon already has their Pokémon Trading Card Game Pocket, which is only available on mobile devices. We are providing a web-based application which can reach computer users who want to take part in Pokémon (if they enjoy opening packs and trading cards).

## Project Download Instructions -
Requirements:
- Eclipse IDE
- Tomcat v10.1
- MySQL
- MySQL Workbench
External Libraries
- jbcrypt-0.4.jar (find this in `external_libaries/`)

# MySQL Database Management System (`/sql`)
Open MySQL Workbench to import the database schema and system data. Data entries include various sets across Pokémon's 30 years of TCG sets from Base Set to 30th Celebration. We also added the cards from a more recent mobile game TCG Pocket.
- To import the database in one go, use `/sql/poketrader.sql`, which is a self-contained file. All schemas and system data can be imported by running this SQL file. Existing users, owned cards, trades, and friend data that were exported into this file will also be imported.
- In `/sql/importer`, each schema can be imported individually. It is recommended you use the self-contained file though.

You may also use the manual creation through `/sql/createPokeTraderSplit` and `/sql/addData`, which will generate a fresh database. This means that there will be no entries in user-dependent tables such as users, owned cards, and friends. If you choose to start a fresh database this way, please follow the instructions exactly in order.
1. Create the schema: The following can be done manually, but `createPokeTraderSplit/createEmptySchema.sql` will generate the schema into MySQL.
2. Add entity sets: Run `/createPokeTraderSplit/addEntities.sql`. This will add the necessary entity sets for the database. This includes rarity classes and rarity mapping.
3. Add relation sets: Run `/createPokeTraderSplit/addRelations.sql`. This will add the relations between two or more entity sets in the database.
4. Finally, you may add the datasets in `/sql/addData`. Batches of cards are spread across several files.

# Eclipse Project (`/src`)
1. Create a Dynamic Web Project in Eclipse.<br>
2. Download all `.jsp`, `.css`, and `.java` files in webapp and java folders, and also download the external JAR, `jbcrypt-0.4.jar`, found in `/external_libraries`.<br>
3. Place all downloaded files into corresponding project directories
   - `.jsp` and `.css` files go in webapp folder
   - `.java` files go in java folder
   - Note: For `jbcrypt-0.4.jar`, you can leave the JAR file anywhere, but it is recommended to keep it close to the project directory (e.g. If your project directory looks like CS157A/semester_project/poketrader, put the jar file in CS157A/semester_project).

4. Right-click on project --> Build Path --> Configure Build Path --> Click Classpath --> Add External Jar --> Add the jbcrypt-0.4.jar
   - Note: If `jbcrypt-0.4.jar` is not in `src/main/webapp/WEB-INF/lib`, add the `WEB-INF/lib` folders manually to the project explorer directory and add the jar file inside of lib. 
5. Create a new server (select Tomcat v10.1)<br>
6. Start server<br>
7. Run login_and_signup.jsp and select "Run on Server"
