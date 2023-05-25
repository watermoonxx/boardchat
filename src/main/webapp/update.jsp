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
	//비밀번호 확인 
	function passwordCheckFunction() {
		let userPassword1 = $('#userPassword1').val();
		let userPassword2 = $('#userPassword2').val();
		if (userPassword1 != userPassword2) {
			$('#passwordCheckMessage').html('비밀번호가 일치하지 않습니다!');
		} else {
			$('#passwordCheckMessage').html('비밀번호가 일치합니다.');
		}
	}
</script>
<!-- 주소 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
// 주소 API
function findAddr() {
    new daum.Postcode({
        oncomplete: function(data) {
        	let roadAddr = data.roadAddress;
            let engAddr = data.addressEnglish;
            let extraAddr = "";
            let jibunAddr = data.userSelectedType;
            
            
            document.getElementById("postcode").value = data.zonecode; // 우편번호 입력될 창 <input id="postcode">

            if (data.userSelectedType == 'R') {
                if (roadAddr != "") { // 비어있는 경우에 법정동이나 건물명만 넣지 않으므로 
                    if (data.bname != "") { // 이미 들어가 있는지 확인부터 
                        extraAddr += data.bname;
                    }

                    if (data.buildingName != "") {
                        extraAddr += extraAddr != "" ? ", " + data.buildingName : data.buildingName;
                    }
                    
                    roadAddr += extraAddr != "" ? "(" + extraAddr + ")" : "";
                    document.getElementById("address").value = roadAddr; // 주소 입력될 창 <input id="addr">
                }
            } else if (data.userSelectedType == 'J') {
                document.getElementById("address").value = jibunAddr;
            }
            document.getElementById("detailAddress").focus();
        }
    }).open();
}
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
	
		<!-- navbar 메인 | 친구찾기 | 채팅 -->
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="index.jsp">메인</a></li>
				<li><a href="find.jsp">친구찾기</a></li>
				<li><a href="boardList.jsp">자유게시판</a></li>
			</ul>
			
			<!-- 로그인한 상태일 때 -->
			<ul class="nav navbar-nav navbar-right">
				<li><a href="#"><%= userID %> 님</a></li>
				<li class="active"><a href="update.jsp">회원정보수정</a></li>
				<li><a href="logoutAction.jsp">로그아웃</a></li>
			</ul>
		</div>
	</nav>

	<div class="container" style="width: 900px;">
		<form action="UserUpdate" method="post">
			<table class="table table-bordered table-hover" style="border: 1px solid #dddddd;">
				<thead>
					<tr>
						<th colspan="3"><h4>회원정보수정</h4></th>
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
						<td style="width: 110px;"><h5>비밀번호</h5></td>
						<td colspan="2"><input  name="userPassword1" id="userPassword1" onkeyup="passwordCheckFunction();" type="password" class="form-control" maxlength="20" placeholder="비밀번호를 입력하세요"></td>
						<!-- onkeyup="passwordCheckFunction();" 비밀번호 체크 함수, onkeyup: 입력될 때마다 확인 -->
					</tr>
					<tr>
						<td style="width: 110px;"><h5>비밀번호 확인</h5></td>
						<td colspan="2"><input name="userPassword2" id="userPassword2" onkeyup="passwordCheckFunction();" type="password" class="form-control" maxlength="20" placeholder="비밀번호를 한번 더 입력하세요"></td>
					</tr>
					<tr>
						<!-- 이름/연락처/주소: 사용자가 변경 가능하게 처리 (value 값 얻어옴) --> 
						<td style="width: 110px;"><h5>이름</h5></td>
						<td colspan="2"><input name="userName" id="userName" type="text" class="form-control" maxlength="20" placeholder="이름을 입력하세요" value="<%= user.getUserName() %>"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>연락처</h5></td>
						<td colspan="2"><input name="phone" id="phone" type="text" class="form-control" maxlength="11" placeholder="연락처를 입력하세요" value="<%= user.getPhone() %>"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>우편번호</h5></td>
						<td style="width: 110px;"><input name="zipcode" id="postcode" type="text" class="form-control" readonly value="<%= user.getZipcode() %>"></td>
						<td><button class="btn btn-primary" onclick="findAddr();" type="button" style="background-color: #49545d;">우편번호 찾기</button></td>
					</tr>

					<tr>
						<td style="width: 110px;"><h5>주소</h5></td>
						<td colspan="2">
							<input name="address" id="address" class="form-control" size="80" readonly value="<%= user.getAddress() %>"><br> <!-- 우편번호 찾고 주소 클릭 시 자동 입력됨 -->
							<input name="detailAddress" id="detailAddress" type="text" class="form-control" size="80" placeholder="상세주소를 입력하세요" value="<%= user.getDetailAddress() %>">
						</td>
					</tr>
					<tr>
						<td style="text-align: left;" colspan="3">
							<h5 style="color: #3c90e2;" id="passwordCheckMessage"></h5>
						</td>
					</tr>
				</tbody>
			</table>

			<div class="btn-flex">
				<input class="btn btn-primary" type="submit" value="수정완료">
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