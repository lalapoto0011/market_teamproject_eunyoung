<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>

<%
// 세션 정보
String id = (String)session.getAttribute("id");
Boolean login = (Boolean)session.getAttribute("login");

//세션 정보가 없을 경우 로그인 페이지로 이동
if (id == null || !login) {
	response.sendRedirect("/secondProject/auth/login.jsp");
}
%>

<%@ include file="/layout/top.jsp" %>
	
<div class="container">
	<div class="add-box">
	
		<div class="card">
			<div class="card-body">
				<form name="addForm" method="post" action="<c:url value='/' />board/add">
	    			<div class="form-group">
  						<label>제목</label>
  						<input type="text" class="form-control" name="title">
					</div>
					<div class="form-group">
  						<label>내용</label>
  						<textarea class="form-control" rows="10" name="content"></textarea>
					</div>
	    		</form>
			</div>
			<div class="card-footer">
				<a href="<c:url value='/' />board/list.jsp" class="btn btn-primary">목록</a>
				<div class="float-right">
					<button type="button" class="btn btn-success" id="btnAdd">등록</button>
				</div>
			</div>
		</div>
		
	</div>
</div>

<%@ include file="/layout/script.jsp" %>
		
<script>
	$('#btnAdd').on('click', function() {
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
		
		$('form[name=addForm]').submit();
	});
</script>
