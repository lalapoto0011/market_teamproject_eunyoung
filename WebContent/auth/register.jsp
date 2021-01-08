<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
// 세션 정보
String id = (String)session.getAttribute("id");
Boolean login = (Boolean)session.getAttribute("login");

// 세션이 있는 경우 /main/main.jsp로 페이지 이동
if (id != null && login) {
	response.sendRedirect("/main/main.jsp");
}
%>

<!doctype html>
<html lang="en">
	<head>
	<!-- Required meta tags -->
	<meta charset="utf-8">
	<meta name="viewport"
		content="width=device-width, initial-scale=1, shrink-to-fit=no">
	
	<!-- Bootstrap CSS -->
	<link rel="stylesheet"
		href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
		integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z"
		crossorigin="anonymous">
		
	<style>
		.login-box {
			margin-top: 100px;
		}
	</style>

	<title>회원가입</title>
</head>
<body>

	<div class="container">
	
		<div class="row justify-content-md-center">
			<div class="col-md-4">
			
				<div class="card login-box">
					<div class="card-header">
						회원가입
					</div>
			  		<div class="card-body">
			    		<form id="registerForm" method="post" action="<c:url value='/' />register">
			    			<div class="form-group">
    							<label>아이디(필수)</label>
    							<input type="text" class="form-control" name="id" placeholder="아이디" required maxlength="15">
  							</div>
			    			<div class="form-group">
    							<label>비밀번호(필수)</label>
    							<input type="password" class="form-control" name="password" placeholder="비밀번호(최대 25글자)" required maxlength="25">
  							</div>
			    			<div class="form-group">
    							<label>닉네임(필수)</label>
    							<input type="text" class="form-control" name="name" placeholder="닉네임">
  							</div>			    			
  							<div class="form-group">
    							<label>이메일(선택)</label>
    							<input type="email" class="form-control" name="email" placeholder="이메일">
  							</div>
  							<div class="form-group">
    							<label>전화번호(선택)</label>
    							<input type="text" class="form-control" name="phone" placeholder="010-XXXX-XXXX" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/, '$1-$2-$3').replace('--', '-') ;">
  							</div>
			    		</form>
			  		</div>
			  		<div class="card-footer">
			  			<button class="btn btn-success" id="btnRegister">회원가입</button>
			  			<div class="float-right">
							<button type="button" class="btn btn-warning"
									onclick="location.href='<c:url value='/' />auth/login.jsp'">로그인</button>
			  			</div>
			  		</div>
				</div>
				
			</div>
		</div>		
		
	</div>	

	<!-- Optional JavaScript -->
	<!-- jQuery first, then Popper.js, then Bootstrap JS -->
	<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
		integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"
		integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN"
		crossorigin="anonymous"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"
		integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV"
		crossorigin="anonymous"></script>
		
	<script>
		// 이메일 검사
		function isEmail(value) {
			let regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
			return regExp.test(value); // 형식에 맞는 경우 true 리턴	
		}
		
		/*
		// 전화번호 입력할때 자동으로 하이픈(-) 추가
	    $('input[name="phone"]').on("keyup", function() {
	        $(this).val( 
	        	$(this).val()
	        	.replace(/[^0-9]/g, "")
	        	.replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/,"$1-$2-$3")
	        	.replace("--", "-") 
	        );
	    });
		*/
		
		// 회원가입 버튼을 누른 경우
		$('#btnRegister').on('click', function(e) {
			e.preventDefault();
			
			//$('input[name="email"]').val( $.trim($('input[name="email"]').val()) );
			
			let id = $.trim( $('input[name="id"]').val() );
			let password = $.trim( $('input[name="password"]').val() );
			let name = $.trim( $('input[name="name"]').val() );
			let email = $.trim( $('input[name="email"]').val() );
			let phone = $.trim( $('input[name="phone"]').val() );
			
			if ( !id ) {
				alert('아이디를 입력해주세요');
				$('input[name="id"]').focus();
				return false;	
			}
			
			if ( id.length < 5 ) {
				alert('아이디는 5글자 이상을 입력해주세요');
				$('input[name="id"]').focus();
				return false;	
			}
			
			if ( !password ) {
				alert('비밀번호를 입력해주세요');
				$('input[name="password"]').focus();
				return false;	
			}
			
			/*
			if ( !email ) {
				alert('이메일을 입력해주세요');
				$('input[name="email"]').focus();
				return false;	
			}
			*/
			
			if ( !isEmail(email) ) {
				alert('올바른 형식의 이메일을 입력해주세요');
				$('input[name="email"]').focus();
				return false;
			}
			
			/*
			// 아이디 검증
			$.ajax({
				method: "GET",
				url: "<c:url value='/' />valid_id",
				data: { 
					id: $('#input[name=id]').val(), 
				}
			}).done(function(response) {
				if (response.data) {
					alert('아이디가 존재합니다');
				} else {
					$('#registerForm').submit();
				}
			});
			*/
			
			// 아이디, 비밀번호, 이름, 이메일, 전화번호 전송
			$('#registerForm').submit();
		});
	</script>
</body>
</html>
