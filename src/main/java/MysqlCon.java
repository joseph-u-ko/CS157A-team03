// Code template was used from 3-tier-demo.jsp
import java.sql.*;

public class MysqlCon {
    public static void main(String[] args) {
        String db = "poketrader";
        String user; // assumes database name is the same as user-name
        user = "root";
        String password = "o{%}*pEhL@uIRUW]ZbmJ5V[2"; // password for database

        try {
            java.sql.Connection con;
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/poketrader?autoReconnect=true&useSSL=false",user, password);

            System.out.println(db + " database successfully opened.<br/><br/>");
            
            con.close();
        } 
        catch(SQLException e) {
            System.out.println("SQLException caught: " + e.getMessage());
        }
        catch(ClassNotFoundException e ) { // added to catch exception for Class.forName() method
            System.out.println("ClassNotFoundException caught: " + e.getMessage());
        }
    }
}
