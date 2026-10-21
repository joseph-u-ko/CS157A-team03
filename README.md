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
External Libraries
- jbcrypt-0.4.jar (find this in external_libaries/)

Step 1.) Create a Dynamic Web Project in Eclipse.<br>
Step 2.) Download all .jsp, .css, and .java files in webapp and java folders, and also download the external jar, jbcrypt-0.4.jar, found in external_libraries folder<br>
Step 3.) Place all downloaded files into corresponding project directories
- .jsp and .css files go in webapp folder
- .java files go in java folder
- Note: For jbcrypt-0.4.jar, you can leave the jar file anywhere, but it is recommended to keep it close to the project directory (e.g. If your project directory looks like CS157A/semester_project/poketrader, put the jar file in CS157A/semester_project).
<br>

Step 4.) Right-click on project --> Build Path --> Configure Build Path --> Click Classpath --> Add External Jar --> Add the jbcrypt-0.4.jar

Step 5.) Create a new server (select Tomcat v10.1)<br>

Step 6.) Start server<br>

Step 7.) Run login_and_signup.jsp and select "Run on Server"
