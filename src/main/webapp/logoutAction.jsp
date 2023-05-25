<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Insert title here</title>
</head>
<body>
	<%
		session.invalidate();
		request.getSession().setAttribute("messageType", "알림 메시지");
		request.getSession().setAttribute("messageContent", "로그아웃 되었습니다.");
	%>
	<script>
		// alert("로그아웃 되었습니다");
		
		location.href = "index.jsp";
	</script>
</body>
</html>