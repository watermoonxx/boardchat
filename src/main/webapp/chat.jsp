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

<script type="text/javascript">
	// 실제로 메시지를 보낼수 있도록 함수 구현 [8강]
	function autoClosingAlert(selector, delay) {
		let alert = $(selector).alert();
		alert.show();
		window.setTimeout(function { alert.hide() }, delay);
	}
	function submitFunction() {
		
	}



</script>


</head>
<body>
	<%
	// userID로 세션 관리  
	String userID = null;
	if (session.getAttribute("userID") != null) { // 로그인을 했다면 
		userID = (String) session.getAttribute("userID"); // session 값은 존재하는 것이고, userID에 해당 사용자의 값을 String으로 변환해서 넣어준다 -> 해당 사용자의 접속 유무를 파악할 수 있다 
	}
	
	// 전송 버튼을 눌렀을 때 submitFunction()이 실행되는데, 우리는 데이터를 전송할 때 보내는 사람과 받는 사람을 모두 입력해야 하므로 매개 변수로 toID가 오도록 한다 
	String toID = null;
	if (request.getParameter("toID") != null) { // toID 값이 존재한다면 
		toID = (String) request.getParameter("toID"); // 가지고 있는다 
	}
	
	
	
	
	
	

	// 로그인이 되지 않은 상태에서 채팅 페이지에 접근했을 때 로그인 페이지로 돌려보냄 [9강]
	if (userID == null) { // 로그인하지 않은 상태라면  
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "로그인이 필요합니다!");
		response.sendRedirect("login.jsp");
		return;
	}

	// 대화 상대를 지정하지 않으면 채팅창 페이지로 돌려보냄
	/* if (toID == null) { // 대화 상대 지정하지 않았다면   
		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "대화 상대가 지정되지 않았습니다!");
		response.sendRedirect("chat.jsp");
		return;
	} */
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapse"
				data-toggle="collapsed" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false"></button>
			<!-- logo -->
			<a href="index.jsp" class="navbar-brand">CHATTALK</a>
		</div>

		<!-- navbar 메인 | 친구찾기 | 채팅 -->
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
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

	<!-- 실시간 채팅창 -->
	<div class="container bootstrap snippet">
		<div class="row" style="display: flex; justify-content: center;">
			<div class="col-xs-12" style="width: 500px;">
				<div class="portlet portlet-default"
					style="border: 1px solid #dddddd;">
					<div class="portlet-heading"
						style="height: 57px; display: flex; justify-content: center; align-items: center;">
						<div class="portlet-title">
							<h4 style="font-size: 18px;">실시간 채팅</h4>
						</div>
						<div class="clearfix"></div>
					</div>
					<div id="chat" class="panel-collapse collapse in">

						<!-- 채팅목록창 -->
						<div id="chatlist" class="portlet-body chat-widget"
							style="overflow-y: auto; width: auto; height: 450px;"></div>

						<!-- 채팅 footer -->
						<div class="portlet-footer" style="border: 1px solid #dddddd;">
							<div class="row">
								<div class="form-group col-xs-4">
									<input id="chatName" class="form-control" style="height: 40px;"
										type="text" placeholder="이름" maxlength="8">
									<!-- id="chatName" 어떤 사람이 채팅을 보냈는지 이름 명시 -->
								</div>
							</div>
							<div class="row" style="height: 90px;">
								<div class="form-group col-xs-10">
									<textarea style="height: 80px; resize: none;"
										chatContent" class="form-control" maxlength="100"
										placeholder="메시지를 입력하세요"></textarea>
								</div>
								<div class="form-group col-xs-2">
									<button type="button" class="btn btn-default onclick="submitFunction();">전송</button>
									<div class="clearfix"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 채팅창 하단 알림 -->
	<div class="alert alert-success" id="successMessage"
		style="display: none;">
		<strong>메시지 전송에 성공했습니다!</strong>
	</div>
	<div class="alert alert-danger" id="dangerMessage"
		style="display: none;">
		<strong>이름과 내용을 모두 입력하세요.</strong>
	</div>
	<div class="alert alert-warning" id="warningMessage"
		style="display: none;">
		<strong>데이터베이스 오류 발생</strong>
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
	<div class="modal fade" id="messageModal" tabindex="-1" role="dialog"
		aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-alignment-center">
				<div
					class="modal-content <%if (messageType.equals("오류 메시지"))
	out.println("panel-warning");
else
	out.println("panel-success");%>">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span>
							<!-- <span class="sr-only">Close</span> -->
						</button>
						<h4 class="modal-title">
							<%=messageType%>
						</h4>
					</div>
					<div class="modal-body">
						<%=messageContent%>
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
	session.removeAttribute("messageContent"); // 서버로부터 받은 세션 값 
	session.removeAttribute("messageType");
	}
	%>
</body>
</html>