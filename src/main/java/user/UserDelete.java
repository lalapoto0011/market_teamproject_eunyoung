package user;

import org.json.simple.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/user/delete")
public class UserDelete extends HttpServlet { //서블릿으로 동작하기 위한 클래스가 되었음, httpservlet 기능을 확장하겠다
    // mariadb 연결정보
    private final String JDBC_DRIVER = "org.mariadb.jdbc.Driver";
    private final String DB_URL = "jdbc:mariadb://jeongps.com:3306/japan_eunyoung";
    private final String DB_USER = "eunyoung";
    private final String DB_PASSWORD = "FJ2aaGxwwLBXEfHE";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8"); //애플리케이션 제이썬 처리하는걸로 바꿔줌
        resp.setCharacterEncoding("UTF-8");

        String id = req.getParameter("id"); //id만 갖고 오면 됨, id만 삭제하면 되니까(?)

        Connection conn = null;  //변수 3개 다 임포트함.
        Statement state = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            state = conn.createStatement();

            String sql; //WEB_USER 에서 id 제거
            sql = "DELETE FROM WEB_USER WHERE ID=? LIMIT 1;"; //쿼리문에도 ; 해주기

            try {
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, id);
                pstmt.executeUpdate();
            } catch(Exception e) { //e는 error
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

            if (conn != null) { //위에 state if 문단 그대로 갖고옴
                try {
                    conn.close();
                } catch (SQLException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }

        } //finally 괄호

        JSONObject data = new JSONObject();//제이썬 형태로 넘김
        data.put("data", "success"); //성공하면 석세스뜬다고????
        resp.getWriter().println(data);
    }
}


