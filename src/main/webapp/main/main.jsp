<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
// 세션 정보
String id = (String)session.getAttribute("id");
Boolean login = (Boolean)session.getAttribute("login");

// 세션 정보가 없을 경우 로그인 페이지로 이동
if (id == null || !login) {
	response.sendRedirect("../auth/login.jsp");
}
%>

<%@ include file="/layout/top.jsp" %>

<main role="main" class="container">
	<div class="starter-template">
 		<h1>오이 마켓</h1>
 		<p class="lead">싱싱한 오이를 드셔보세요</p>
	</div>
</main>

<%@ include file="/layout/top.jsp" %>

<script>
	
</script>