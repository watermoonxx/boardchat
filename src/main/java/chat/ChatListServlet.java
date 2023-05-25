package chat;

import java.io.IOException;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ChatListServlet")
public class ChatListServlet extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		String fromID = request.getParameter("fromID"); // 사용자로부터 입력받은 값 
		String toID = request.getParameter("toID");
		String listType = request.getParameter("listType");
		
		/*
		if (fromID == null || fromID.equals("") || toID == null || toID.equals("") || 
				listType == null || listType.equals("")) {
			response.getWriter().write(""); // 공백을 클라이언트에게 반환
		} else if (listType.equals("ten")) { // 비어있거나 null 값이 아닌 경우, 데이터베이스에 접근해서 값을 출력 
			// 만약 listType이 ten 에 관련된 내용이라면 getTen() 함수를 실행해서 사용자에게 보여준다  
			
			response.getWriter().write(getTen(fromID, toID));
		} else {
			try {
				response.getWriter().write(getID(fromID, toID, listType));
			} catch (Exception e) {
				response.getWriter().write(""); // 공백 반환 
			}
		}
		
		public String getTen() {
			// json: 서버와 클라이언트가 문자를 주고 받는 규칙에 따라서 
		}
		*/

		/* 회원정보수정 관련 [18]
		HttpSession session = request.getSession();
		if (!fromID.equals((String) session.getAttribute("userID"))) {
		response.getWriter().write("");
		(서블릿이므로 공백으로 출력)

		session.setAttribute("messageType", "오류 메시지");
		session.setAttribute("messageContent", "접근할 수 없습니다.");
		response.sendRedirect("login.jsp");
		return;
		*/
		
		
		
		
			
		}
		

}








