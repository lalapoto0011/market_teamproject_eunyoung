package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import util.JDBCUtil;
import vo.UserVO;

public class UserDAO_Mariadb {
	public List<UserVO> userList() {
		List<UserVO> list = new ArrayList<UserVO>();
		String sql = "select * from WEB_USER order by id asc";
		
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			conn = JDBCUtil.getConnection();
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery(); //쿼리문 실행
			
			while (rs.next()) {
				UserVO vo = new UserVO();
				vo.setId(rs.getString("id"));
				vo.setPassword(rs.getString("password"));
				vo.setName(rs.getString("name"));
				vo.setEmail(rs.getString("email"));
				vo.setPhone(rs.getString("phone"));
				vo.setUserType(rs.getInt("user_type"));
				
				list.add(vo);
			}
		} catch(Exception e) {
			System.out.println("error" + e);
		} finally {
			JDBCUtil.close(conn, ps, rs);
		}
		return list;
	}
	
	public void userAdd(UserVO vo) {
		String sql = "insert into WEB_USER (id, password, name, email, phone) values (?, ?, ?, ?, ?)";
		
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		int row = 0;
		
		try {
			conn = JDBCUtil.getConnection();
			ps = conn.prepareStatement(sql); 
			
			ps.setString(1, vo.getId());
			ps.setString(2, vo.getPassword());
			ps.setString(3, vo.getName());
			ps.setString(4, vo.getEmail());
			ps.setString(5, vo.getPhone());
			row = ps.executeUpdate();
			
			if(row == 0) {
				throw new Exception("등록 실패");
			}
			
		} catch (Exception e) {
			System.out.println("error : " + e);
		} finally {
			JDBCUtil.close(conn, ps, rs);
		}		
	}
	
	public UserVO getUser(String id) { //String으로 잡았음
		String sql = "select * from WEB_USER where id = ?";
		
		Connection conn = null;
		PreparedStatement ps = null; // SQL 관리
		ResultSet rs = null;
		UserVO vo = null;
		
		try {
			conn = JDBCUtil.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, id);
			rs = ps.executeQuery(); // 가지고있는거 사용할때 사용
		 
			while(rs.next() ) {
				vo = new UserVO();
				vo.setId(rs.getString("id"));
				vo.setPassword(rs.getString("password"));
				vo.setName(rs.getString("name"));
				vo.setEmail(rs.getString("email"));
				vo.setPhone(rs.getString("phone"));
				vo.setUserType(rs.getInt("user_type"));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("error :" + e);
		} finally {
			JDBCUtil.close(conn, ps, rs); // 자원반납 필수
		}
		return vo;		
	}
	
	public void userDelete(String id) {
		String sql = "delete from WEB_USER where id = ?";
		
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		int row = 0;
		
		try {
			conn = JDBCUtil.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, id);
			
			row = ps.executeUpdate();
			
			if(row == 0) {
				throw new Exception("삭제 실패");
			}
			
		} catch(Exception e) {
			System.out.println("error : " + e);
		} finally {
			JDBCUtil.close(conn, ps, rs);
		}		
	}
	
	public UserVO login(String email, String password) {
		UserVO vo = null;
		String sql = "select * from WEB_USER where email = ? and password = ?";
		
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			conn = JDBCUtil.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, email);
			ps.setString(2, password);
			
			rs = ps.executeQuery();
			
			while (rs.next()) {
				vo = new UserVO();
				vo.setId(rs.getString("id"));
				vo.setPassword(rs.getString("password"));
				vo.setName(rs.getString("name"));
				vo.setEmail(rs.getString("email"));
				vo.setPhone(rs.getString("phone"));
				vo.setUserType(rs.getInt("user_type"));
			}
			
		} catch(Exception e) {
			System.out.println("error : " + e);
		} finally {
			JDBCUtil.close(conn, ps, rs);
		}
		return vo;
	}
	
	public List<UserVO> userSearch(String condition, String keyword) {
		int row = 0;
		String sql = "select * from WEB_USER where " + condition + " like ?";
		// select * from book where publisher like '%한%';
		
		Connection conn = null;
		PreparedStatement ps = null; // SQL 관리
		ResultSet rs = null;
		List<UserVO> list = new ArrayList<UserVO>();		// is a 관계
		
		try {
			conn = JDBCUtil.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, "%" + keyword + "%");
			
			rs = ps.executeQuery(); // 가지고있는거 사용할때 사용
			
			while(rs.next()) {
				UserVO vo = new UserVO();
				
				vo.setId(rs.getString("id"));
				vo.setPassword(rs.getString("password"));
				vo.setName(rs.getString("name"));
				vo.setEmail(rs.getString("email"));
				vo.setPhone(rs.getString("phone"));
				vo.setUserType(rs.getInt("user_type"));

				list.add(vo);
			}
		
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("error :" + e);
		} finally {
			JDBCUtil.close(conn, ps, rs); // 자원반납 필수
		}
		return list;		
	}
	
}
