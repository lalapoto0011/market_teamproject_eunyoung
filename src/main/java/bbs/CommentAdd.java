package bbs;

import org.json.simple.JSONObject;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class CommentAdd
 */
@WebServlet("/board/view")
public class CommentAdd extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // mariadb 연결정보
    private final String JDBC_DRIVER = "org.mariadb.jdbc.Driver";
    private final String DB_URL = "jdbc:mariadb://jeongps.com:3306/japan_eunyoung";
    private final String DB_USER = "eunyoung";
    private final String DB_PASSWORD = "FJ2aaGxwwLBXEfHE";


    /**
     * @see HttpServlet#HttpServlet()
     */
    public CommentAdd() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(true);
        String com_id = session.getAttribute("id").toString();
        String com_content = request.getParameter("com_content");

        Date time = new Date();
        SimpleDateFormat format = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
        String com_dateTime = format.format(time);

        Connection conn = null;
        Statement state = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            state = conn.createStatement();

            String sql;
            sql = "INSERT INTO WEB_COMMENT (ID, CONTENT, DATE_TIME) VALUES (?, ?, ?);";

            try {
                System.out.println(com_id + ", " + com_content + ", " + com_dateTime);
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, com_id);
                pstmt.setString(2, com_content);
                pstmt.setString(3, com_dateTime);
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
        response.getWriter().println(data);
    }

}
