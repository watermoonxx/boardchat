<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- CSS -->
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>Insert title here</title>
<!-- JS -->
<script src="js/bootstrap.js"></script>
<!-- jQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<!-- Google font -->
<!-- <link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Source+Code+Pro:wght@200&display=swap" rel="stylesheet"> -->
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
                    document.getElementById("addr").value = roadAddr; // 주소 입력될 창 <input id="addr">
                }
            } else if (data.userSelectedType == 'J') {
                document.getElementById("addr").value = jibunAddr;
            }
            document.getElementById("detailAddr").focus();
        }
    }).open();
}
</script>
</head>
<body>
	<% 
		// userID를 토대로 세션 관리  
		String userID = null;
		if (session.getAttribute("userID") != null) { // 로그인을 했다면 
			userID = (String) session.getAttribute("userID"); // session 값은 존재하는 것이고, userID에 해당 사용자의 값을 String으로 변환해서 넣어준다 -> 해당 사용자의 접속 유무를 파악할 수 있다 
		}
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapse" data-toggle="collapsed" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<!-- logo -->
			<a href="index.jsp" class="navbar-brand">BOARD CHAT</a> 
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
				<li><a href="#">회원정보</a></li>
				<!-- <li><a href="#">로그아웃</a></li> -->
			</ul>
			<%
				}
			%>
		</div>
	</nav>

	<!-- 실시간 채팅창 -->
	<div class="container bootstrap snippet">
		<div class="row">
			<div class="col-xs-12">
				<div class="portlet portlet-default" style="border: 1px solid #dddddd;">
					<div class="portlet-heading">
						<div class="portlet-title">
							<h4><i class="fa fa-circle text-green"></i>실시간 채팅</h4>
						</div>
						<div class="clearfix"></div>
					</div>
					<div id="chat" class="panel-collapse collapse in">
						<div id="chatlist" class="portlet-body chat-widget" style="overflow-y: auto; width: auto; height: 450px;"></div>
						<div class="portlet-footer" style="border: 1px solid #dddddd;">
							<div class="row">
								<div class="form-group col-xs-4">
									<input id="chatName" class="form-control" style="height: 40px;" type="text" placeholder="이름" maxlength="8"> <!-- id="chatName" 어떤 사람이 채팅을 보냈는지 이름 명시 -->
								</div>
							</div>
							<div class="row" style="height: 90px;">
								<div class="form-group col-xs-10">
									<textarea style="height: 80px;" id="chatContent" class="form-control" maxlength="100" placeholder="메시지를 입력하세요"></textarea>
								</div>
								<div class="form-group col-xs-2">
									<button type="button" class="btn btn-default pull-right" onclick="submitFunction();">전송</button>
									<div class="clearfix"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="alert alert-success" id="successMessage" style="display: none;">
		<strong>메시지 전송에 성공했습니다!</strong>
	</div>
	<div class="alert alert-danger" id="dangerMessage" style="display: none;">
		<strong>이름과 내용을 모두 입력하세요.</strong>
	</div>
	<div class="alert alert-warning" id="warningMessage" style="display: none;">
		<strong>데이터베이스 오류 발생</strong>
	</div>




</body>
</html>