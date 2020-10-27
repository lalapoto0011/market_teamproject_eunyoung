package user;

import org.json.simple.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/user/update")
public class UserUpdate extends HttpServlet { //서블릿으로 동작하기 위한 클래스가 되었음, httpservlet 기능을 확장하겠다
    // mariadb 연결정보
    private final String JDBC_DRIVER = "org.mariadb.jdbc.Driver";
    private final String DB_URL = "jdbc:mariadb://jeongps.com:3306/japan_eunyoung";
    private final String DB_USER = "eunyoung";
    private final String DB_PASSWORD = "FJ2aaGxwwLBXEfHE";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8"); //애플리케이션 제이썬 처리하는걸로 바꿔줌
        resp.setCharacterEncoding("UTF-8");

        String id = req.getParameter("id"); //앞에서 id, name, phone, email로 받았으니까
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

            String sql = "UPDATE WEB_USER SET NAME=?, PHONE=?, EMAIL=? WHERE ID=? LIMIT 1;";

            try {
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, name);
                pstmt.setString(2, phone);
                pstmt.setString(3, email);
                pstmt.setString(4, id);

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
        }	//큰 finally 괄호

        //응답을 제이썬 형태로 넘기기
        //제이썬데이터 - 응답
        JSONObject data = new JSONObject();//제이썬 형태로 넘김
        data.put("data", "success"); //성공하면 석세스뜬다고????
        resp.getWriter().println(data);
    }
}


