<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- jQuery -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<!-- CSS -->
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Rubik:wght@600&display=swap" rel="stylesheet">
<title>LET'S CHAT!</title>
<%
	// userID로 세션 관리  
	String userID = null;
	if (session.getAttribute("userID") != null) { // 로그인을 했다면 
		userID = (String) session.getAttribute("userID"); // session 값은 존재하는 것이고, userID에 해당 사용자의 값을 String으로 변환해서 넣어준다 -> 해당 사용자의 접속 유무를 파악할 수 있다 
	}
	
	// 전송 버튼을 눌렀을 때 submitFunction()이 실행되는데, 데이터를 전송할 때 보내는 사람과 받는 사람을 모두 입력해야 하므로 매개 변수로 toID가 오도록 한다 
	String toID = null;
	if (request.getParameter("toID") != null) { // toID 값이 존재한다면 
		toID = (String) request.getParameter("toID"); // toID 값을 가지고 있는다 
	}
	
	
	// 로그인이 되지 않은 상태에서 채팅 페이지에 접근했을 때 로그인 페이지로 돌려보냄 [9]
	if (userID == null) { // 로그인하지 않은 상태라면  
		session.setAttribute("messageType", "알림 메시지");
		session.setAttribute("messageContent", "로그인이 필요합니다.");
		response.sendRedirect("login.jsp");
		return;
	}
	
	// 리디렉션 관련 
	// 대화 상대를 지정하지 않으면 채팅창 페이지로 돌려보냄
	if (toID == null) { 
		session.setAttribute("messageType", "알림 메시지");
		session.setAttribute("messageContent", "대화 상대가 지정되지 않았습니다.");
		// response.sendRedirect("chat.jsp");
		// return;
	}
	

%>
<!-- JS -->
<script src="js/bootstrap.js"></script>
<script type="text/javascript">
	// 전송 버튼 클릭 후 팝업 
	function autoClosingAlert(selector, delay) {
		let alert = $(selector).alert(); // selector에 해당하는 것을 
		alert.show();  
		window.setTimeout(function() {alert.hide()}, delay); // delay 시간만큼만 보여줄 수 있도록 처리 
	}
	
	// 메시지를 보내는 함수 
	function submitFunction() {
		let fromID = "<%= userID %>";
		let toID = "<%= toID %>";
		let chatContent = $('#chatContent').val(); 
		$.ajax({
			type: "post",
			url: "ChatSubmitServlet",
			data: { // 실제로 보내는 데이터 
				fromID: encodeURIComponent(fromID),
				toID: encodeURIComponent(toID),
				chatContent: encodeURIComponent(chatContent)
			},
			success: function(result) {
				if (result == 1) {
					autoClosingAlert('#successMessage', 3000); // 3초 
				} else if (result == 0) {
					autoClosingAlert('#dangerMessage', 3000);
				} else {
					autoClosingAlert('#warningMessage', 3000);
				}
				console.log("Ajax 통신 성공");
			},
			error: function() {
                console.log("Ajax 통신 실패");
            }
		});
		// 메시지 보낸 후 성공 여부에 상관없이 chatContent 값을 비워주는 처리 
		$('#chatContent').val("");
	}

	// 230527
	let lastID = 0; // 대화 데이터의 가장 마지막 userNum 
	function chatListFunction(type) {
		let fromID = '<%=userID%>';
		let toID = '<%=toID%>';
		$.ajax({
			type : "post",
			url : "ChatListServlet",
			data : {
				fromID : encodeURIComponent(fromID),
				toID : encodeURIComponent(toID),
				listType : type
			},
			success : function(data) {
				if (data == "") {
					return;
				}
				// 해당 데이터를 JSON 형태로 파싱 후 result에 저장 
				let parsed = JSON.parse(data);
				let result = parsed.result;
				for (let i = 0; i < result.length; i++) {
					if (result[i][0].value == fromID) { // 메시지를 보낸 사람이 자기자신과 같다면 
						result[i][0].value = '나'; 
					}
					
					// 대화창에 출력할 수 있게 
					addChat(result[i][0].value, result[i][2].value,
							result[i][3].value);
				}
				lastID = Number(parsed.last); // 가장 마지막으로 전달받은 userNum 
			}

		});

	}

	// 대화창에 대화를 넣어주는 함수 (<div id="chatlist">)  
	function addChat(chatName, chatContent, chatTime) { // 채팅을 보낸 사람, 채팅 내용, 시간 
		$('#chatlist').append('<div class="row">'
								+ '<div class="col-lg-12">'
								+ '<div class="media">'
								+ '<a class="pull-left" href="#">'
								+ '<img src="./img/userProfile.svg" alt="" style="width: 30px; height: 30px;" class="media-object img-circle">'
								+ '</a>' // 기본 프로필사진 (사용자 지정 생략)  
								+ '<div class="media-body">'
								+ '<h4 class="media-heading">' + chatName
								+ '<span class="small pull-right" style="line-height: normal;">' + chatTime
								+ '</span>' 
								+ '</h4>' 
								+ '<p style="font-size: 18px;">' + chatContent + '</p>' 
								+ '</div>' 
								+ '</div>' 
								+ '</div>'
								+ '</div>' 
								+ '<hr>');
	
		// 스크롤을 아래로 내려줌 
		$('#chatlist').scrollTop($('#chatlist')[0].scrollHeight);
	}

	// 몇 초 간격으로 새로운 메시지를 가져옴 
	 function getInfiniteChat() {
		setInterval(function() {
			chatListFunction(lastID);
		}, 2000); // 2초에 한번 실행됨 
	} 
</script>

</head>
<body>

	<nav class="navbar navbar-default" style="border: none;">
		<!-- <div class="navbar-header">
			<button type="button" class="navbar-toggle collapse"
				data-toggle="collapsed" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false"></button>
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
				if (userID != null) {
			%>
			<!-- 로그인한 상태일 때 -->
			<ul class="nav navbar-nav navbar-right" style="padding-top: 10px;">
				<li><a class="nav-ele" href="#"><%=userID%> 님</a></li>
				<li><a class="nav-ele" href="update.jsp">회원정보수정</a></li>
				<li><a class="nav-ele" href="logoutAction.jsp">로그아웃</a></li>
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
							<h4 style="font-size: 18px;">실시간 대화</h4>
						</div>
						<div class="clearfix"></div>
					</div>
					<div id="chat" class="panel-collapse collapse in">

						<!-- 채팅목록창 -->
						<div id="chatlist" class="portlet-body chat-widget"
							style="overflow-y: auto; width: auto; height: 450px;"><!-- addChat() 함수로 내용 들어가는 부분 --></div>

						<!-- 채팅 footer -->
						<div class="portlet-footer" style="border: 1px solid #dddddd;">
							<div class="row" style="height: 90px;">
								<div class="form-group col-xs-10">
									<textarea style="height: 80px; resize: none;" id="chatContent"
										class="form-control" maxlength="100" placeholder="메시지를 입력하세요"></textarea>
								</div>
								<div class="form-group col-xs-2">
									<button type="button" class="btn btn-default"
										onclick="submitFunction();">전송</button>
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
		<strong>내용을 입력하세요.</strong>
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

	<script type="text/javascript">
		// 세션과 상관없이 실행되어야 하므로 세션 다음 위치에 따로 빼주었음
		// 실시간으로 대화를 불러오는 것이 아니라 특정 시간을 설정해두고 그 시간 주기로 데이터베이스에서 대화 목록을 불러오는 것 
		$(document).ready(function() {
			chatListFunction('ten');
			getInfiniteChat();
		});
	</script>

</body>
</html>