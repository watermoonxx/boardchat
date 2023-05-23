package user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
@WebServlet("/UserLoginServlet")
public class UserLoginServlet extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		String userID = request.getParameter("userID"); // 사용자 입력값
		String userPwd = request.getParameter("userPassword1"); // 사용자 입력값 
		
		// 오류 발생 시 오류 메시지를 띄우고 로그인 페이지로 이동 
		if (userID == null || userID.equals("") || userPwd == null || userPwd.equals("")) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "모든 내용을 입력해주세요.");
			response.sendRedirect("login.jsp");
			return;
		}
		
		// 정상 처리: 실제로 로그인 시도를 한 결과를 변수 result에 저장한다 
		int result = new UserDAO().login(userID, userPwd);
		if (result == 1) { // result == 1 이라면 로그인 성공한 것 -> 성공 메시지 
			request.getSession().setAttribute("userID", userID);
			request.getSession().setAttribute("messageType", "성공 메시지");
			request.getSession().setAttribute("messageContent", "로그인에 성공했습니다.");
			response.sendRedirect("index.jsp");
		} else if (result == 1) { // result == 2 -> 비밀번호 불일치 
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "비밀번호를 다시 확인하세요.");
			response.sendRedirect("login.jsp");
		} else if (result == 0) { // result == 0 -> 아이디가 존재하지 않음 
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "아이디가 존재하지 않습니다.");
			response.sendRedirect("login.jsp"); 
		} else if (result == -1) { // result == -1 -> 데이터베이스 오류 
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "데이터베이스 오류 발생");
			response.sendRedirect("login.jsp");
		}
		

	}

}
