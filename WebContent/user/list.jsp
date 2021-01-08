<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
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
	response.sendRedirect("../auth/login.jsp");
}
%>

<%@ include file="/layout/top.jsp" %>
	
<div class="container">

	<div class="list-box">
		<div class="card">
			<div class="card-header">
				<button class="btn btn-primary" id="btnAdd">회원가입</button>
				<button class="btn btn-success d-none" id="btnAddConfirm">확인</button>
				<button class="btn btn-warning d-none" id="btnAddCancel">취소</button>
				<button class="btn btn-success d-none" id="btnEditConfirm">회원정보 수정</button>
				<button class="btn btn-warning d-none" id="btnEditCancel">취소</button>
				<button class="btn btn-danger d-none float-right" id="btnDelete">회원 탈퇴</button>
			</div>
			<div class="card-body">

				<div id="listBox">
				<table class="table table-hover" id="userTable">
					<thead class="thead-dark">
						<tr>
							<th>아이디</th>
							<th>비밀번호</th>
							<th>이름(닉네임)</th>
							<th>이메일</th>
							<th>전화번호</th>
						</tr>
					</thead>
					<tbody>


					</tbody>
				</table>
			</div>

				<div id="addBox" class="d-none">
					<form id="addForm">
						<div class="form-group">
							<label>아이디</label>
							<input type="text" class="form-control" name="id" placeholder="아이디">
						</div>
						<div class="form-group">
							<label>비밀번호</label>
							<input type="password" class="form-control" name="password" placeholder="비밀번호">
						</div>
						<div class="form-group">
							<label>이름</label>
							<input type="text" class="form-control" name="name" placeholder="닉네임">
						</div>
						<div class="form-group">
							<label>이메일</label>
							<input type="text" class="form-control" name="email" placeholder="이메일">
						</div>
						<div class="form-group">
							<label>전화번호</label>
							<input type="text" class="form-control" name="phone" placeholder="010-XXXX-XXXX" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/, '$1-$2-$3').replace('--', '-') ;">
						</div>
					</form>
				</div>

				<div id="editBox" class="d-none">
					<form id="editForm">
						<div class="form-group">
							<label>이름</label>
							<input type="text" class="form-control" name="name" placeholder="닉네임">
						</div>
						<div class="form-group">
							<label>전화번호</label>
							<input type="text" class="form-control" name="phone" placeholder="010-XXXX-XXXX" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/, '$1-$2-$3').replace('--', '-') ;">
						</div>
						<div class="form-group">
							<label>이메일</label>
							<input type="text" class="form-control" name="email" placeholder="이메일">
						</div>
					</form>
				</div>


			</div>
		</div>			
	</div>
			
</div>	

<%@ include file="/layout/script.jsp" %>

<script>
	let id;

	/* <1번 방식>
	$.ajax({ //성공, 실패에 대한 것을 각각 res, e에 넣음,  이 틀을 계속 재활용할 예정. 기억해두기!
		url : '<c:url value="/" />user/list',
		method: 'get',
		data: {},
		dataType: 'json',
		success: function(res){
			//console.log('success', res);

			let data = res.data;
			console.log(data.length);

			let tbody = "";

			$.each(data, function(index, item) {
				console.log(index, item.id, item.password, item.name, item.email, item.phone);

				tbody += '<tr>';
				tbody += '<td>' + item.id + '</td>';
				tbody += '<td>' + item.password + '</td>';
				tbody += '<td>' + item.name + '</td>';
				tbody += '<td>' + (item.email ? item.email : '') + '</td>';
				tbody += '<td>' + (item.phone ? item.phone : '') + '</td>';
				tbody += '</tr>';

			});

			$('#userTable tbody').append(tbody);

			$('#userTable').DataTable();
		},
		error: function(e) {
			console.log('error', e);
		},
	});
	*/
	<!-- <2번 방식> -->
	$('#userTable').DataTable({
		ajax: {
			url: '<c:url value="/" />user/list',
			dataSrc: 'data'
		},
		columns: [  //키를 넣어서 안의 밸류값을 자동으로 화면에 뿌려줌
			{ data: 'id' },
			{ data: 'password' },
			{ data: 'name' },
			{ data: 'email' },
			{ data: 'phone' },
		],

		createdRow: function (row, data, dataIndex, cells) {
			$(row).attr('data-id', data.id)  //한 행마다 수행하라?
					.attr('data-name', data.name)
					.attr('data-email', data.email)
					.attr('data-phone', data.phone);
		},
	});

	//★★★ ~폼 정보까지 매우 중요하다는데 이해가안됨 (필기는 해놓긴했으나 ...)
	// 아래 부분이 수정 버튼이랑 똑같다고 함, 그래서 위에서 수정버튼이 필요없음 (by.상옥씨)
	$('#userTable tbody').on('click', 'tr', function () {
		id = $(this).data('id'); //위에 let id 로 id 변수선언해놨음
		let name = $(this).data('name');
		let email = $(this).data('email');
		let phone = $(this).data('phone');

		$('#listBox').addClass('d-none');
		$('#editBox').removeClass('d-none');
		$('#btnAdd').addClass('d-none');
		$('#btnEditConfirm').removeClass('d-none');
		$('#btnEditCancel').removeClass('d-none');
		$('#btnDelete').removeClass('d-none'); //이부분 10/24 추가

		// 폼 클리어
		$('#editForm').each(function() { this.reset(); });

		// 폼 정보
		$('#editForm input[name=name]').val(name);
		$('#editForm input[name=email]').val(email);
		$('#editForm input[name=phone]').val(phone);
	});


	// 등록 (회원가입)
	$('#btnAdd').on('click', function() {
		$('#listBox').addClass('d-none');
		$('#addBox').removeClass('d-none');
		$('#btnAdd').addClass('d-none');
		$('#btnAddConfirm').removeClass('d-none');
		$('#btnAddCancel').removeClass('d-none');
	});

	// 등록확인
	$('#btnAddConfirm').on('click', function (e){
		e.preventDefault();

		let id = $.trim( $('#addForm input[name="id"]').val() );
		let password = $('#addForm input[name="password"]').val();
		let name = $('#addForm input[name="name"]').val();

		if ( !id || id.length < 6 || id.length > 12 ) {
			alert('아이디를 확인해주세요');
			$('#addForm input[name="id"]').focus();
			return false;
		}

		if (!password) {
			alert('비밀번호를 확인해주세요');
			$('#addForm input[name="password"]').focus();
			return false;
		}

		if (!name) {
			alert('이름을 확인해주세요');
			$('#addForm input[name="name"]').focus();
			return false;
		}

		$.ajax({
			url: '<c:url value="/" />user/create',
			method: 'post',
			data: {
				'id': $('#addForm input[name="id"]').val(),
				'password': $('#addForm input[name="password"]').val(),
				'name': $('#addForm input[name="name"]').val(),
				'phone': $('#addForm input[name="phone"]').val(),
				'email': $('#addForm input[name="email"]').val(),
			},
			dataType: 'json',
			success: function (res) {
				$('#userTable').DataTable().ajax.reload(function() {}, false);

				$('#listBox').removeClass('d-none');
				$('#addBox').addClass('d-none');
				$('#btnAdd').removeClass('d-none');
				$('#btnAddConfirm').addClass('d-none');
				$('#btnAddCancel').addClass('d-none');
			},
		});
	});

	// 등록취소
	$('#btnAddCancel').on('click', function() {
		$('#listBox').removeClass('d-none');
		$('#addBox').addClass('d-none');
		$('#btnAdd').removeClass('d-none');
		$('#btnAddConfirm').addClass('d-none');
		$('#btnAddCancel').addClass('d-none');
	});

	// 수정취소
	$('#btnEditCancel').on('click', function() {
		$('#listBox').removeClass('d-none');
		$('#editBox').addClass('d-none');
		$('#btnAdd').removeClass('d-none');
		$('#btnEditConfirm').addClass('d-none');
		$('#btnEditCancel').addClass('d-none');
		$('#btnDelete').addClass('d-none'); // 10/24 추가
	});

	// 수정 처리 (정보수정)
	$('#btnEditConfirm').on('click', function () {
		$.ajax({ //성공, 실패에 대한 것을 각각 res, e에 넣음 (위에서 복붙)
			url : '<c:url value="/" />user/update',
			method: 'post',
			data: {
				'id': id, //view에서 아이디값 넣어놨으니까 그냥 불러옴
				'name': $('#editForm input[name="name"]').val(),
				'phone': $('#editForm input[name="phone"]').val(),
				'email': $('#editForm input[name="email"]').val(),
			}, //데이터 리프래쉬 처리??
			dataType: 'json',
			success: function (res) {
				//결과를 정상적으로 받아왔으면 리스트를 새로 바꿈? 테이블에 보여지는 정보를 새로 바꿈
				$('#userTable').DataTable().ajax.reload(function() {}, false); //사용자 정보 테이블을 새로고침하겠다

				$('#listBox').removeClass('d-none');
				$('#editBox').addClass('d-none');
				$('#btnAdd').removeClass('d-none');
				$('#btnEditConfirm').addClass('d-none');
				$('#btnEditCancel').addClass('d-none');
				//데이터속성을 이용해서, 거기다 값을 넣어놓고 처리함(???)
			},
		}); //ajax 괄호
	});


	// 삭제 처리 (수정처리 하는 부분 그대로 갖고와서)
	$('#btnDelete').on('click', function () {
		if (confirm("정말 탈퇴하시겠습니까?") == true) {
			//확인
			alert("탈퇴되었습니다. 이용해주셔서 감사합니다.");
		$.ajax({ //성공, 실패에 대한 것을 각각 res, e에 넣음 (위에서 복붙)
			url : '<c:url value="/" />user/delete', //삭제니까 당연히 경로 delete
			method: 'post',
			data: {
				'id': id, //view에서 아이디값 넣어놨으니까 그냥 불러옴
			}, //데이터 리프래쉬 처리??
			dataType: 'json',
			success: function (res){
				//결과를 정상적으로 받아왔으면 리스트를 새로 바꿈? 테이블에 보여지는 정보를 새로 바꿈
				$('#userTable').DataTable().ajax.reload(function() {}, false); //사용자 정보 테이블을 새로고침하겠다

				$('#listBox').removeClass('d-none');
				$('#editBox').addClass('d-none');
				$('#btnAdd').removeClass('d-none');
				$('#btnEditConfirm').addClass('d-none');
				$('#btnEditCancel').addClass('d-none');
				//데이터속성을 이용해서, 거기다 값을 넣어놓고 처리함(???)
			},
		}); //ajax 괄호
		} else{
			//취소
			return;
		}
	});


</script>



