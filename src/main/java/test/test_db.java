package test;

import java.sql.Connection;
import util.JDBCUtil;

public class test_db {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		System.out.println("Connection Test");
		Connection conn = JDBCUtil.getConnection();
		System.out.println(conn);
		JDBCUtil.close(conn,null,null);
		
	}

}
