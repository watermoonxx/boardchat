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
<!-- Google font -->
<!-- <link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Source+Code+Pro:wght@200&display=swap" rel="stylesheet"> -->
</head>
<body>
	<% 
		// userID로 세션 관리  
		String userID = null;
		if (session.getAttribute("userID") != null) { // 로그인을 했다면 
			userID = (String) session.getAttribute("userID"); // session 값은 존재하는 것이고, userID에 해당 사용자의 값을 String으로 변환해서 넣어준다 -> 해당 사용자의 접속 유무를 파악할 수 있다 
		}
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapse" data-toggle="collapsed" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
			</button>
			<!-- logo -->
			<a href="index.jsp" class="navbar-brand">CHATTALK</a> 
		</div>
	
		<!-- navbar 메인 | 친구찾기 | 채팅 -->
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li class="active"><a href="index.jsp">메인</a></li>
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
				<!-- <li><a href="#">(신짱구) 님</a></li> -->
				<li>
					<a href="#">회원정보</a>
					<ul class="nav navbar-nav navbar-right">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>
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