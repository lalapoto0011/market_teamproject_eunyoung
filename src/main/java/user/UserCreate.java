package user;

import org.json.simple.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/user/create")
public class UserCreate extends HttpServlet { //서블릿으로 동작하기 위한 클래스가 되었음, httpservlet 기능을 확장하겠다
    // mariadb 연결정보 - DB 연결 설정
    private final String JDBC_DRIVER = "org.mariadb.jdbc.Driver";
    private final String DB_URL = "jdbc:mariadb://jeongps.com:3306/japan_eunyoung";
    private final String DB_USER = "eunyoung";
    private final String DB_PASSWORD = "FJ2aaGxwwLBXEfHE";


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String id = req.getParameter("id");
        String password = req.getParameter("password");
        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");

        Connection conn = null;
        Statement state = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            state = conn.createStatement();

            String sql;
            sql = "INSERT INTO WEB_USER (ID, PASSWORD, NAME, PHONE, EMAIL)";
            sql += "VALUE (?, ?, ?, ?, ?)";

            try {
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, id);
                pstmt.setString(2, password);
                pstmt.setString(3, name);
                pstmt.setString(4, phone);
                pstmt.setString(5, email);
                pstmt.executeUpdate();
            } catch(Exception e) {
                System.out.println("e: " + e.toString());
            }
        } catch(Exception e) {
            System.out.println("e: " + e.toString());
        } finally {
            if (state != null) {
                try {
                    state.close();
                } catch (SQLException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }

            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
        }

        JSONObject data = new JSONObject();
        data.put("data", "success");
        resp.getWriter().println(data);
    }
}