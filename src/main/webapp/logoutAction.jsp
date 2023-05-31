<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Rubik:wght@600&display=swap" rel="stylesheet">
<title>LET'S CHAT!</title>
</head>
<body>
	<%
		session.invalidate();
		request.getSession().setAttribute("messageType", "알림 메시지");
		request.getSession().setAttribute("messageContent", "로그아웃 되었습니다.");
	%>
	<script>
		location.href = "index.jsp";
	</script>
</body>
</html>