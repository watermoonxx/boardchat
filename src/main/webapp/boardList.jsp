<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- jQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<!-- CSS -->
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>Insert title here</title>
<!-- JS -->
<script src="js/bootstrap.js"></script>
</head>
<body>
	<% 
		// userID로 세션 관리 
		String userID = null;
		if (session.getAttribute("userID") != null) {  
			userID = (String) session.getAttribute("userID"); // 로그인을 했다면 session 값은 존재하는 것이고, userID에 해당 사용자의 값을 String으로 변환해서 넣어준다 -> 해당 사용자의 접속 유무를 파악할 수 있다 
		}
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapse" data-toggle="collapsed" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
			</button>
			<!-- logo -->
			<a href="index.jsp" class="navbar-brand">logo</a> 
		</div>
	
		<!-- navbar 메인 | 친구찾기 | 채팅 -->
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="index.jsp">메인</a></li>
				<li><a href="find.jsp">친구찾기</a></li>
				<li class="active"><a href="boardList.jsp">자유게시판</a></li>
				<li><a href="chat.jsp">채팅</a></li>
			</ul>
			<%
				if (userID == null) { // 로그인을 하지 않은 상태라면 
			%>
			<!-- 로그인을 하지 않은 상태일 때 -->
			<ul class="nav navbar-nav navbar-right">
				<li><a href="login.jsp">로그인</a></li>
				<li><a href="join.jsp">회원가입</a></li>
			</ul>

			<%
				} else {
			%>
			<!-- 로그인한 상태일 때 -->
			<ul class="nav navbar-nav navbar-right">
					<li><a href="#"><%= userID %> 님</a></li>
					<li><a href="update.jsp">회원정보수정</a></li>
					<li><a href="logoutAction.jsp">로그아웃</a></li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>

	<!-- 게시판 form -->
	<div class="container" style="width: 900px;">
		<table class="table table-bordered table-hover" style="border: 1px solid #dddddd; text-align: center;" >
			<thead>
				<tr>
					<th colspan="5"><h4>자유게시판</h4></th>
				</tr>
				<tr>
					<th style="width: 70px; background-color: rgb(180, 220, 255);"><h5>번호</h5></th>
					<th style="background-color: rgb(180, 220, 255);"><h5>제목</h5></th>
					<th style="width: 100px; background-color: rgb(180, 220, 255);"><h5>작성자</h5></th>
					<th style="width: 100px; background-color: rgb(180, 220, 255);"><h5>작성날짜</h5></th>
					<th style="width: 70px; background-color: rgb(180, 220, 255);"><h5>조회수</h5></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>1</td>
					<td>게시물제목예시</td>
					<td>김자바</td>
					<td>2023-05-25 예시</td>
					<td>999</td>
				</tr>
			</tbody>
		</table>
		<div class="btn-flex">
			<input class="btn btn-primary" type="button" value="게시물 작성하기" onclick="location.href='boardWrite.jsp'">
		</div>
	
	
	
	
	</div>











	<!-- 서버로부터 메시지를 받아서 출력하는 부분 -->
	<% 
		String messageContent = null;
		if (session.getAttribute("messageContent") != null) {
			messageContent = (String) session.getAttribute("messageContent");
		}
		
		String messageType = null;
		if (session.getAttribute("messageType") != null) {
			messageType = (String) session.getAttribute("messageType");
		}
		
		if (messageContent != null) { // 존재한다면 
	%>
		<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="vertical-alignment-helper">
				<div class="modal-dialog vertical-alignment-center">
					<div class="modal-content 
					<% 
						if (messageType.equals("오류 메시지")) { 
							out.println("panel-warning"); 
						} else {
							out.println("panel-success");
							}
					%>">
						<div class="modal-header panel-heading">
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&times;</span> <!-- x 문자 -->
								<!-- <span class="sr-only">Close</span> -->
							</button> 
							<h4 class="modal-title">
								<%= messageType %>
							</h4>
						</div>
						<div class="modal-body">
							<%= messageContent %>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		<script>
			$('#messageModal').modal("show");
		</script>
		<%
				// 모달창은 한번만 띄우고 세션 파괴 (모달창 메시지를 사용자에게 단 한 번만 보여줌) 
				session.removeAttribute("messageContent"); // 서버로부터 받은 세션 값 
				session.removeAttribute("messageType");
				}
		%>
</body>
</html>