package user;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/user/list")
public class UserList extends HttpServlet { //서블릿으로 동작하기 위한 클래스가 되었음, httpservlet 기능을 확장하겠다
    // mariadb 연결정보 - DB 연결 설정
    private final String JDBC_DRIVER = "org.mariadb.jdbc.Driver";
    private final String DB_URL = "jdbc:mariadb://jeongps.com:3306/japan_eunyoung";
    private final String DB_USER = "eunyoung";
    private final String DB_PASSWORD = "FJ2aaGxwwLBXEfHE";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8"); //json은 application/json 으로 들어가야 제대로 받아서 해석?
        resp.setCharacterEncoding("UTF-8");

        Connection conn = null;
        Statement state = null;
        PreparedStatement pstmt = null;

        try {
            //DB 연결
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            state = conn.createStatement();

            //사용자 목록 가져오기 SQL 쿼리
            String sql = "SELECT ID, PASSWORD, NAME, EMAIL, PHONE ";
            sql += "FROM WEB_USER "; //의도적으로 띄어쓰기 한칸
            sql += "ORDER BY ID DESC;"; //아이디가 큰 것부터 먼저 출력해라.  SQL 쿼리문은 ;로 끝나니까 마지막에 넣어줬음
            pstmt = conn.prepareStatement(sql);

            //사용자 목록 가져오기 SQL 쿼리 실행
            ResultSet rs = null;
            rs = pstmt.executeQuery(); //쿼리문 실행

            if ( rs == null ) { //값 없음
                resp.getWriter().println("null");
            } else {  //값 있음
                // Map<String, Object> jsonData = new HashMap<String, Object>();
                // jsonData.put("data", rs);
                // resp.getWriter().println(jsonData);

                JSONArray arr = new JSONArray(); //제이썬 형태로 넘김

                while(rs.next()) {
                    String id = rs.getNString("ID");
                    String password = rs.getNString("PASSWORD");
                    String name = rs.getNString("NAME");
                    String email = rs.getNString("EMAIL");
                    String phone = rs.getNString("PHONE");

                    JSONObject obj = new JSONObject();
                    obj.put("id", id);
                    obj.put("password", password);
                    obj.put("name", name);
                    obj.put("email", email);
                    obj.put("phone", phone);
                    arr.add(obj);
                }

                JSONObject data = new JSONObject(); //집어넣는거
                data.put("data", arr);
                System.out.println(data);
                resp.getWriter().println(data);
            }

            rs.close();

        } catch (Exception e) {
            resp.getWriter().println(e);  //오류메시지를 사용자의 프론트엔드 쪽으로 넣음

        } finally {
            try {
                state.close();
                conn.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }



    }

}


