package util;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.Properties;
import java.sql.ResultSet;
import java.sql.SQLException;

public class JDBCUtil {

	public static Connection getConnection() {
		Connection conn = null;
		
		Properties p = new Properties();
		try {
			p.load(new FileInputStream("C:/eunyoung/workspace_team/market_teamproject_eunyoung/WebContent/WEB-INF/lib/dbinfo.txt")); 
			
			String driver = p.getProperty("__driver"); 
			String url = p.getProperty("__url");
			String user = p.getProperty("__user");
			String pw = p.getProperty("__pw"); 
			
			Class.forName(driver);
			
			conn = DriverManager.getConnection(url,user,pw);
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return conn;
	}
	
	public static void close(Connection conn , Statement st , ResultSet rs ) { 
		
		try {
			if(rs != null) rs.close(); 
			if(st != null) st.close();
			if(conn != null) conn.close();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	

}
