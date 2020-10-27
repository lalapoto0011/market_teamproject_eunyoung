<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="java.sql.*" %>

<%
// 세션 정보
String id = (String)session.getAttribute("id");
Boolean login = (Boolean)session.getAttribute("login");

//세션 정보가 없을 경우 로그인 페이지로 이동
if (id == null || !login) {
	response.sendRedirect("/auth/login.jsp");
}

String boardId = request.getParameter("board_id");

//mariadb 연결정보
String JDBC_DRIVER = "org.mariadb.jdbc.Driver";
String DB_URL = "jdbc:mariadb://jeongps.com:3306/japan_eunyoung";
String DB_USER = "eunyoung";
String DB_PASSWORD = "FJ2aaGxwwLBXEfHE";

String title = "";
String userId = "";
String dateTime = "";
String name = "";
String content = "";

Connection conn = null;
Statement state = null;
PreparedStatement pstmt = null;

try {
	Class.forName(JDBC_DRIVER);
	conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
	state = conn.createStatement();
	ResultSet rs = null;
	
	String sql = "SELECT A.ID, A.TITLE, A.USER_ID, A.DATE_TIME, A.CONTENT, B.NAME "; 
	sql += "FROM WEB_BOARD AS A ";
	sql += "LEFT JOIN WEB_USER AS B ON A.USER_ID = B.ID ";
	sql += "WHERE A.ID=? LIMIT 1;";
	pstmt = conn.prepareStatement(sql);
	pstmt.setNString(1, boardId);
	rs = pstmt.executeQuery();
	
	// WEB_BOARD 정보 있음
	if (rs != null) {	
		while(rs.next()) {		
			title = rs.getNString("A.TITLE");
			userId = rs.getNString("A.USER_ID");
			dateTime = rs.getNString("A.DATE_TIME");
			name = rs.getNString("B.NAME");
			content = rs.getNString("A.CONTENT");
		}
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

<%@ include file="/layout/top.jsp" %>

<div class="container">
	<div class="edit-box">
	
		<div class="card">
			<div class="card-body">
				<form name="editForm" method="post" action="<c:url value='/' />board/edit">
					<input type="hidden" name="board_id" value="<%=boardId%>">
	    			<div class="form-group">
  							<label>이름</label>
  							<input type="text" class="form-control" value="<%=name%>" disabled>
					</div>
	    			<div class="form-group">
  							<label>제목</label>
  							<input type="text" class="form-control" name="title" value="<%=title%>">
						</div>
						<div class="form-group">
  							<label>내용</label>
  							<textarea class="form-control" rows="10" name="content"><%=content %></textarea>
						</div>
	    		</form>
			</div>
			<div class="card-footer">
				<!-- 
				<a href="<c:url value='/' />board/view.jsp?id=<%=boardId %>" class="btn btn-primary">뒤로가기</a>
				-->
				<a href="#" onclick="history.back();" class="btn btn-primary">뒤로가기</a>
				<div class="float-right">
					<button type="button" class="btn btn-warning" id="btnEdit">수정</button>
				</div>
			</div>
		</div>
		
	</div>
</div>
		
<%@ include file="/layout/script.jsp" %>
		
<script>
	$('#btnEdit').on('click', function() {
		if (!$('input[name="title"]').val()) {
			alert('제목을 입력해주세요');
			$('input[name="title"]').focus();
			return false;
		}
		
		if (!$('textarea[name="content"]').val()) {
			alert('내용을 입력해주세요');
			$('textarea[name="content"]').focus();
			return false;
		}
		
		$('form[name=editForm]').submit();
	});
</script>

