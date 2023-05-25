<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO" %>
<%@ page import="user.UserDAO" %>
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
<script type="text/javascript">
	// //비밀번호 확인 
	// function passwordCheckFunction() {
	// 	let userPassword1 = $('#userPassword1').val();
	// 	let userPassword2 = $('#userPassword2').val();
	// 	if (userPassword1 != userPassword2) {
	// 		$('#passwordCheckMessage').html('비밀번호가 일치하지 않습니다!');
	// 	} else {
	// 		$('#passwordCheckMessage').html('비밀번호가 일치합니다.');
	// 	}
	// }
</script>
</head>
<body>
	<% 
		// userID로 세션 관리 
		// 로그인을 했다면 
		String userID = null;
		if (session.getAttribute("userID") != null) { 
			userID = (String) session.getAttribute("userID"); // session 값은 존재하는 것이고, userID에 해당 사용자의 값을 String으로 변환해서 넣어준다 -> 해당 사용자의 접속 유무를 파악할 수 있다 
		}
		
		// 로그인하지 않은 상태라면 
		if (userID == null) {  
			session.setAttribute("messageType", "알림 메시지");
			session.setAttribute("messageContent", "로그인이 필요합니다.");
			response.sendRedirect("login.jsp");
			return;
		}
		
		// 로그인 상태라면 사용자의 정보를 변수 user에 저장 
		UserDTO user = new UserDAO().getUser(userID);
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapse" data-toggle="collapsed" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
			</button>
			<!-- logo -->
			<a href="index.jsp" class="navbar-brand">logo</a> 
		</div>
	
		
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="index.jsp">메인</a></li>
				<li><a href="find.jsp">친구찾기</a></li>
				<li class="active"><a href="boardList.jsp">자유게시판</a></li>
			</ul>
			
			<!-- 로그인한 상태일 때 -->
			<ul class="nav navbar-nav navbar-right">
				<li><a href="#"><%= userID %> 님</a></li>
				<li><a href="update.jsp">회원정보수정</a></li>
				<li><a href="logoutAction.jsp">로그아웃</a></li>
			</ul>
		</div>
	</nav>

	<div class="container" style="width: 900px;">
		<form action="BoardWriteServlet" method="post">
			<table class="table table-bordered table-hover" style="border: 1px solid #dddddd;">
				<thead>
					<tr>
						<th colspan="3"><h4>게시물 작성하기</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 110px;"><h5>아이디</h5></td>
						<td colspan="2"> <!-- 사용자 아이디 출력 -->
							<h5><%= user.getUserID() %></h5>
							<!-- userID 값을 서버로 전송 -->
							<input type="hidden" name="userID" value="<%= user.getUserID() %>">
						</td>
					</tr>
                    <tr>
                        <td style="width: 110px;"><h5>제목</h5></td>
                        <td><input class="form-control" type="text" name="boardTitle" maxlength="50" placeholder="제목을 입력하세요"></td>
                    </tr>
                    <tr>
                        <td style="width: 110px;"><h5>내용</h5></td>
                        <td>
                            <textarea class="form-control" name="boardContent" id="" cols="30" rows="10" maxlength="2048" placeholder="내용을 입력하세요" style="resize: none;"></textarea>
                        </td>
                            
                    </tr>
                    <tr>
                        <td style="width: 110px;"><h5>파일 업로드</h5></td>
                        <td colspan="2">
                            <input type="file" name="boardFile" class="file" style="background-color: #49545d;">
                            <!-- 서버쪽에서 boardFile 이라는 이름으로 받을 수 있음  -->
                        
                            
                            <div class="input-group col-xs-12" >
                                <span class="input-group-addon"><i class="glyphicon glyphicon-picture"></i></span>
                                <input type="text" class="form-control input-lg" disabled placeholder="파일을 업로드하세요">
                                <span class="input-group-btn">
                                    <button type="button" class="browse btn btn-primary input-lg"><i class="glyphicon glyphicon-search"></i></button>
                                </span>
                            </div>
                        </td>
                    </tr>




                    <!-- 텍스트 출력 부분 -->
					<tr>
						<td style="text-align: left;" colspan="3">
							<h5 style="color: #3c90e2;" id="passwordCheckMessage"></h5>
						</td>
					</tr>
				</tbody>
			</table>

			<div class="btn-flex">
				<input class="btn btn-primary" type="submit" value="작성하기">
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