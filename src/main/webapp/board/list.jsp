<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.util.Random" %> 
<%@ page import="java.util.Date" %> 
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.*" %>

<%
// 세션 정보
String id = (String)session.getAttribute("id");
Boolean login = (Boolean)session.getAttribute("login");

//세션 정보가 없을 경우 로그인 페이지로 이동
if (id == null || !login) {
	response.sendRedirect("/auth/login.jsp");
}

//mariadb 연결정보
String JDBC_DRIVER = "org.mariadb.jdbc.Driver";
String DB_URL = "jdbc:mariadb://jeongps.com:3306/japan_eunyoung";
String DB_USER = "eunyoung";
String DB_PASSWORD = "FJ2aaGxwwLBXEfHE";

Connection conn = null;
Statement state = null;
PreparedStatement pstmt = null;
%>

<%@ include file="/layout/top.jsp" %>
	
<div class="container">

	<div class="list-box">
		<div class="card">
			<div class="card-header">
				<a href="<c:url value='/' />board/add.jsp" class="btn btn-primary">등록</a>
			</div>
			<div class="card-body">
				<table class="table table-hover">
					<thead class="thead-dark">
						<tr>
							<th>번호</th>
							<th>제목</th>
							<th>글쓴이</th>
							<th>작성일시</th>
						</tr>
					</thead>
					<tbody>
<%
try {
	Class.forName(JDBC_DRIVER);
	conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
	state = conn.createStatement();
	ResultSet rs = null;
	
	String sql = "SELECT A.BOARD_ID, A.TITLE, A.ID, A.NAME, A.DATE_TIME ";
	sql += "FROM WEB_BOARD AS A ";
	sql += "ORDER BY A.ID DESC;";
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();
	
	// WEB_BOARD 정보 있음
	if (rs != null) {				
		int i = 1;
		while(rs.next()) {		
			String boardId = rs.getNString("A.BOARD_ID");
			String title = rs.getNString("A.TITLE");
			String userId = rs.getNString("A.ID");
		    String name = rs.getNString("A.NAME");
			String dateTime = rs.getNString("A.DATE_TIME");
%>
						<tr>
							<td><%=i %></td>
							<td><a href="<c:url value='/' />board/view.jsp?board_id=<%=boardId%>"><%=title %></a></td>
							<td><%=name %>(<%=userId %>)</td>
							<td><%=dateTime %></td>
						</tr>
<%		
			i++;
		}
	} 
	
	// WEB_BOARD 정보 없음
	else {
%>
						<tr>
							<td colspan="4" class="text-center">등록된 글이 없습니다.</td>
						</tr>
<%		
	}
	
	rs.close();
	state.close();
	conn.close();
} catch(Exception e) {
	System.out.println("e: " + e.toString());
} finally {
	state.close();
	conn.close();
}
%>						
					</tbody>
				</table>
			</div>
		</div>			
	</div>
			
</div>	

<%@ include file="/layout/script.jsp" %>

