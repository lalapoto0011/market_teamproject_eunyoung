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

String com_content = "";
String com_userId = "";
String com_dateTime = "";
String com_id = "";

Connection conn = null;
Statement state = null;
PreparedStatement pstmt = null;

try {
	Class.forName(JDBC_DRIVER);
	conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
	state = conn.createStatement();
	ResultSet rs = null;
	
	String sql = "SELECT A.BOARD_ID, A.TITLE, A.ID, A.DATE_TIME, A.CONTENT, B.NAME ";
	sql += "FROM WEB_BOARD AS A ";
	sql += "LEFT JOIN WEB_USER AS B ON A.ID = B.ID ";
    sql += "WHERE A.BOARD_ID=? LIMIT 1 ;";


	pstmt = conn.prepareStatement(sql);
	pstmt.setNString(1, boardId);
	rs = pstmt.executeQuery();
	
	// WEB_BOARD 정보 있음
	if (rs != null) {	
		while(rs.next()) {		
			title = rs.getNString("A.TITLE");
			userId = rs.getNString("A.ID");
			dateTime = rs.getNString("A.DATE_TIME");
			name = rs.getNString("B.NAME");
			content = rs.getNString("A.CONTENT");


		}
	}

	ResultSet rs_c = null;

    String sql_c = "SELECT C.ID, C.CONTENT, C.DATE_TIME FROM WEB_COMMENT AS C;";

    pstmt = conn.prepareStatement(sql);
    pstmt.setNString(1, boardId);
    rs_c = pstmt.executeQuery();

	// WEB_COMMENT 정보 있음
	if (rs_c != null) {
	    while(rs.next()) {
	        com_id = rs_c.getNString("C.ID");
            com_content = rs_c.getNString("C.CONTENT");
            com_dateTime = rs_c.getNString("C.DATE_TIME");
	    }
	}

	rs_c.close();
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

	<div class="view-box">
		<!-- 글내용 -->
		<div class="card">
			<div class="card-header"><%=title %></div>
			<div class="card-body">
				<p class="card-title"><%=name %> <%=dateTime %></p>
				<p class="card-text"><%=content %></p>
			</div>
			<div class="card-footer">
				<a href="<c:url value='/' />board/list.jsp" class="btn btn-primary">목록</a>
				<div class="float-right">
					<a href="<c:url value='/' />board/edit.jsp?board_id=<%=boardId %>" class="btn btn-warning">수정</a>
					<button type="button" class="btn btn-danger" data-toggle="modal" data-target="#deleteModal">삭제</button>
				</div>
			</div>
		</div>
		
		<!-- 댓글 -->
		<form id="commentForm" method="post" action="<c:url value='/' />board/view">
		<div class="card" style="margin-top:20px;">
			<div class="card-body">
				<div>
					<textarea class="form-control" rows="3" name="com_content"></textarea>
				</div>
			</div>
			<div class="card-footer">
				<button type="button" class="btn btn-success" id="btnAdd">등록</button>
			</div>
		</div>
		</form>

		<!-- 댓글 보여주기 -->
		<div class="card" style="margin-top:20px;">
        		<div class="card-body">
        		    <div>
                	    <p class="card-title"><%=com_userId %> <%=com_dateTime %></p>
                	    <p class="card-text"><%=com_content %></p>
                	</div>
                </div>
                <div class="card-footer">
                    <div class="float-right">
                    <button type="button" class="btn btn-danger" data-toggle="modal" data-target="#deleteComm">삭제</button>
                </div>
        </div>

    </div>
</div>


<div class="modal" tabindex="-1" id="deleteModal">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title text-danger">게시글 삭제</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<p class="text-danger">삭제된 내용은 복구가 불가능합니다. 정말 삭제할까요?</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary"
					data-dismiss="modal">취소</button>
				<button type="button" class="btn btn-danger" id="btnDelete">삭제</button>				
			</div>
		</div>
	</div>
</div>

<div class="modal" tabindex="-1" id="deleteComm">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title text-danger">댓글 삭제</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<p class="text-danger">삭제된 내용은 복구가 불가능합니다. 정말 삭제할까요?</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary"
					data-dismiss="modal">취소</button>
				<button type="button" class="btn btn-danger" id="btnDelete">삭제</button>
			</div>
		</div>
	</div>
</div>

<form id="deleteForm" method="post" action="<c:url value='/' />board/delete">
	<input type="hidden" name="board_id" value="<%=boardId%>">
</form>


<%@ include file="/layout/script.jsp" %>


<script>
	$('#btnAdd').on('click', function() {
		if (!$('textarea[name="com_content"]').val()) {
			alert('내용을 입력해주세요');
			$('textarea[name="com_content"]').focus();
			return false;
		}



		$('#commentForm').submit();

	});
</script>

<script>
	$('#btnDelete').on('click', function() {
		$('#deleteForm').submit();
	});
</script>
