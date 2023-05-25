<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, javax.naming.InitialContext, javax.naming.Context" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		InitialContext initCtx = new InitialContext();
		Context envContext = (Context) initCtx.lookup("java:/comp/env");
		DataSource ds = (DataSource) envContext.lookup("jdbc/boardchat");
		Connection con = ds.getConnection();
		Statement stmt = con.createStatement();
		ResultSet rset = stmt.executeQuery("SELECT VERSION()");
		while (rset.next()) {
			out.println("Oracle version: " + rset.getString("version()"));
		}
		rset.close();
		stmt.close();
		con.close();
		initCtx.close();
	
	%>

</body>
</html>