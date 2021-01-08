<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
	
<%
// 세션 정보
String id = (String)session.getAttribute("id");
Boolean login = (Boolean)session.getAttribute("login");

// 세션 정보가 없는 경우
if (id == null || !login) {
	// 로그인 화면으로 이동
	response.sendRedirect("auth/login.jsp");
}

// 세션 정보가 있는 경우
else {
	// 메인 화면으로 이동
	response.sendRedirect("main/main.jsp");
} 
%>