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
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Rubik:wght@600&display=swap" rel="stylesheet">
<title>LET'S CHAT!</title>
<!-- JS -->
<script src="js/bootstrap.js"></script>
</head>
<body>
	<% 
		// userID로 세션 관리  
		String userID = null;
		if (session.getAttribute("userID") != null) { // 로그인을 했다면 
			userID = (String) session.getAttribute("userID"); // session 값은 존재하는 것이고, userID에 해당 사용자의 값을 String으로 변환해서 넣어준다 -> 해당 사용자의 접속 유무를 파악할 수 있다 
		}
		
		// '로그인 상태에서' 회원가입 페이지에 접근했을 때 메인으로 돌려보냄 [9강]
		// 로그인 상태에서는 회원가입 페이지 메뉴가 사라지므로 일반적으로 접근은 불가능 
		if (userID != null) { // 로그인한 상태라면 
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인 상태입니다. 로그아웃 후 회원가입이 가능합니다.");
			response.sendRedirect("index.jsp");
			return; 
		}
	%>
	<nav class="navbar navbar-default" style="border: none;">
		<!-- <div class="navbar-header">
			<button type="button" class="navbar-toggle collapse" data-toggle="collapsed" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
			</button>
			<a href="index.jsp" class="navbar-brand">logo</a> 
		</div> -->
	
	<!-- navbar 메인 | 친구찾기 | 채팅 -->
	<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
		<ul class="nav navbar-nav" style="padding-top: 10px;">
			<li class="active"><a href="index.jsp" style="padding-top: 10px;">
				<img src="./img/logo_chat.svg" alt="" style="width: 30px; height: 30px;">
			</a></li>
			<li><a class="nav-ele" href="find.jsp">친구찾기</a></li>
			<li><a class="nav-ele" href="boardList.jsp">자유게시판</a></li>
			<li><a class="nav-ele" href="chat.jsp">채팅</a></li>
		</ul>
			<%
				if (userID == null) { // 로그인을 하지 않은 상태라면 
			%>
			<!-- 로그인을 하지 않은 상태일 때 -->
			<ul class="nav navbar-nav navbar-right" style="padding-top: 10px;">
				<li class="active"><a class="nav-ele" href="login.jsp">로그인</a></li>
				<li><a class="nav-ele" href="join.jsp">회원가입</a></li>
			</ul>
			<% 
				} 
			%>
		</div>
	</nav>

	<div class="container" style="width: 450px; max-width: 450px;">
		<form action="UserLoginServlet" method="post"> <!-- 서블릿 -->
			<table class="table table-bordered" style="border: 1px solid #dddddd; text-align: center;">
				<thead>
					<tr>
						<th colspan="2"><h4>로그인</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 50px;"><h5>아이디</h5></td>
						<td><input name="userID" id="userID" class="form-control" type="text" maxlength="20" placeholder="아이디를 입력하세요"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>비밀번호</h5></td>
						<td colspan="2"><input  name="userPassword1" id="userPassword1"  type="password" class="form-control" maxlength="20" placeholder="비밀번호를 입력하세요"></td>
					</tr>
				</tbody>
			</table>
			<div class="btn-flex">
				<input class="btn btn-primary" type="button" value="회원가입" onclick="location.href='join.jsp'" style="background-color: #49545d;">
				<input class="btn btn-primary" type="submit" value="로그인">
			</div>
		</form>
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
					<div class="modal-content <% if (messageType.equals("오류 메시지")) out.println("panel-warning"); else out.println("panel-success"); %>">
						<div class="modal-header panel-heading">
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&times;</span> <!-- x 문자 -->
								<span class="sr-only">Close</span>
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
				// 모달창은 한번만 띄우고 세션 파괴 
				session.removeAttribute("messageContent"); // 서버로부터 받은 세션 값 
				session.removeAttribute("messageType");
				}
		%>
		
		<!-- 사용자에게 모달창 띄우기 --> 
		<div class="modal fade" id="checkModal" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="vertical-alignment-helper">
				<div class="modal-dialog vertical-alignment-center">

					<!-- 정보를 띄워주는 모달창 --> 
					<div class="modal-content panel-info" id="checkType">
						<div class="modal-header panel-heading">
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&times;</span>
								<!-- <span aria-hidden="true">Close</span> -->
							</button>
							<h4 class="modal-title">
								확인 메시지
							</h4>
						</div>
						<div class="modal-body" id="checkMessage">
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		
	










</body>
</html>