package chat;

import java.io.IOException;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ChatSubmitServlet")
public class ChatSubmitServlet extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		String fromID = request.getParameter("fromID"); // 사용자로부터 입력받은 값 
		String toID = request.getParameter("toID");
		String chatContent = request.getParameter("chatContent");
		
		if (fromID == null || fromID.equals("") || toID == null || toID.equals("") || 
				chatContent == null || chatContent.equals("")) {
			response.getWriter().write("0"); // (입력이 제대로 되지 않았을 경우) 문자 "0"을 클라이언트에게 반환해 준다 
		} else {
			fromID = URLDecoder.decode(fromID, "UTF-8"); // URLDecoder 클래스는 URLEncoder로 인코딩된 결과를 디코딩하는 클래스 -> 텍스트화 시킨다 (문자열로 변환한다) 
			toID = URLDecoder.decode(toID, "UTF-8");
			
			/*
			// [18] 
			HttpSession session = request.getSession();
			if (!fromID.equals((String) session.getAttribute("userID"))) {
				response.getWriter().write("");
				return;
			}
			*/
			
			chatContent = URLDecoder.decode(chatContent, "UTF-8"); 
			response.getWriter().write(new ChatDAO().submit(fromID, toID, chatContent) + ""); // 채팅을 보내는 함수를 실행해서 실행된 결과를 클라이언트에게 반환하는 것 
		}
	}

}