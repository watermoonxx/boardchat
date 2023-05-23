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
<!-- Google font -->
<!-- <link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Source+Code+Pro:wght@200&display=swap" rel="stylesheet"> -->
<title>Insert title here</title>
<!-- JS -->
<script src="js/bootstrap.js"></script>
<script type="text/javascript">
	// ID 중복체크 
	function registerCheckFunction() {
		let userID = $('#userID').val();
		$.ajax({
			type: "post",
			url: 'UserRegisterCheckServlet', // 해당 서블릿으로 어떠한 값을 post 방식으로 보냄 
			data: {userID: userID}, // 선언방법1) value가 위의 userID 변수에 담긴 값 
			//data: {userID: $("#userID").val()} // 선언방법2)

			// (KH) data: {input: $("#input1").val()}, // key -> input, value -> $("#input1").val()
			success: function(result) {
				if (result == 1) {
					$('#checkMessage').html('사용할 수 있는 아이디입니다.');
					$('#checkType').attr('class', 'modal-content panel-success');
				} else {
					$('#checkMessage').html('사용할 수 없는 아이디입니다!');
					$('#checkType').attr('class', 'modal-content panel-warning');
				}
				$('#checkModal').modal("show");
				// 부트스트랩 모달창이 화면에 보이도록 띄움 
			},
			error: function() {
				console.log("Ajax 통신 실패");
				}
			});
		}
	
	// 비밀번호 확인 
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
		String userID = null;
		if (session.getAttribute("userID") != null) { // 로그인을 했다면 
			userID = (String) session.getAttribute("userID"); // session 값은 존재하는 것이고, userID에 해당 사용자의 값을 String으로 변환해서 넣어준다 -> 해당 사용자의 접속 유무를 파악할 수 있다 
		}
		
		// 로그인 상태에서 회원가입 페이지에 접근했을 때 메인으로 돌려보냄 [9강]
		if (userID != null) { // 로그인한 상태라면 
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인 상태입니다.");
			response.sendRedirect("index.jsp");
			return; 
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
			<% } %>
		</div>
	</nav>

	<!-- 회원가입 form -->
	<!-- DB에 있는 [컬럼명]과 빈에 있는 [변수명], <input name=""> 태그의 [name 속성값]은 당연히 같아야 한다 -->
	<!-- 서버로 전송되는 값 모든 <input> 태그에 value 속성 필요? -->
			<!-- ID중복확인 버튼을 눌렀을 때 값이 바뀌도록 value 속성 필요  -->
	<div class="container" style="width: 900px;">
		<form action="UserRegisterServlet" method="post"> <!-- userRegister로 회원정보를 보냄 -->
			<table class="table table-bordered table-hover" style="border: 1px solid #dddddd;">
				<thead>
					<tr>
						<th colspan="3"><h4>회원가입</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 110px;"><h5>아이디</h5></td>
						<td><input name="userID" id="userID" class="form-control" type="text" maxlength="20" placeholder="아이디를 입력하세요"></td>
						<td style="width: 110px;"><button class="btn btn-primary" onclick="registerCheckFunction();" type="button" style="background-color: #49545d;">중복확인</button></td>
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
						<td style="width: 110px;"><h5>이름</h5></td>
						<td colspan="2"><input name="userName" id="userName" type="text" class="form-control" maxlength="20" placeholder="이름을 입력하세요"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>연락처</h5></td>
						<td colspan="2"><input name="phone" id="phone" type="text" class="form-control" maxlength="11" placeholder="연락처를 입력하세요"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>우편번호</h5></td>
						<td style="width: 110px;"><input name="zipcode" id="postcode" type="text" class="form-control" readonly></td>
						<td><button class="btn btn-primary" onclick="findAddr();" type="button" style="background-color: #49545d;">우편번호 찾기</button></td>
					</tr>

					<tr>
						<td style="width: 110px;"><h5>주소</h5></td>
						<td colspan="2">
							<input name="address" id="address" class="form-control" size="80" readonly><br> <!-- 우편번호 찾고 주소 클릭 시 자동 입력됨 -->
							<input name="detailAddress" id="detailAddress" type="text" class="form-control" size="80" placeholder="상세주소를 입력하세요">
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
				<input class="btn btn-primary" type="button" value="로그인 이동" onclick="location.href='login.jsp'" style="background-color: #49545d;">
				<input class="btn btn-primary" type="submit" value="회원가입">
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