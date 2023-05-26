package chat;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ChatListServlet")
public class ChatListServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// ajax를 이용해서 사용자들이 주고 받은 대화를 데이터베이스에서 가져오는(반환하는) 서블릿  
		
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		String fromID = request.getParameter("fromID"); // 사용자로부터 입력받은 값 
		String toID = request.getParameter("toID");
		String listType = request.getParameter("listType");
		
		
		if (fromID == null || fromID.equals("") || toID == null || toID.equals("") || 
				listType == null || listType.equals("")) {
			response.getWriter().write(""); // 하나라도 비어있을경우 오류: 공백을 클라이언트에게 반환
		} else if (listType.equals("ten")) {  
			// 만약 listType이 ten 이라는 내용이라면, getTen() 함수를 실행해서 사용자에게 보여준다(데이터베이스에 접근해서 값을 출력)  
			
			response.getWriter().write(getTen(fromID, toID));
		} else { // 비어있지 않고, listType = "ten"은 아닌 경우 getID() 함수를 실행해서 사용자에게 보여준다(데이터베이스에 접근해서 값을 출력) 
			try {
				response.getWriter().write(getID(fromID, toID, listType));
			} catch (Exception e) {
				response.getWriter().write("");  
			}
		}
		
		
		public String getTen(String fromID, String toID) {
			StringBuffer result1 = new StringBuffer(""); // 인스턴스 생성 
			// StringBuffer: 문자열을 저장하기 위한 클래스. String과 달리 내용을 변경할 수 있다(참조변수에 append() 가능)

			
			// json 형태의 배열 반환 
			/*
				{ \"result\" : [
					-> { \result\ : [  이스케이프 문자 표현, 객체 name "result", 배열 시작 
			 	
				[ { \"value\" : \"
			    	-> [ { \value\ : \	
			    
				\"},
			    	-> \ }
		
		// JSON 형태: 객체는 쌍으로 존재, value에는 배열, 객체, 기본자료형 가능 	    	
    	{ \result\ : [
    					[ { \value\ : \fromID\ }, { \value\ : \toID\ }, { \value\ : \chatContent\ }, { \value\ : \chatTime\ } ] 
    				 ],
    				 
    				 \last\ : \ (chatList 객체 개수의 -1) \ 
    	}
			    	
			    	객체 안에 name \result\, value 배열
			    	배열 안에 객체 
			    	
			*/
			
			result1.append(" {\"result\":[ "); 
			ChatDAO chatDAO = new ChatDAO();
			ArrayList<ChatDTO> chatList = chatDAO.getChatListByRecent(fromID, toID, 10);
			
			if (chatList.size() == 0) { // ArrayList에 저장된 객체의 개수가 0이면 
				return ""; // 공백 반환 
			}
			
			
			
			for (int i=0; i<chatList.size(); i++) {
				result1.append(" [ {\"value\" : \"" + chatList.get(i).getFromID() + " \"}, ");
				result1.append(" [ {\"value\" : \"" + chatList.get(i).getToID() + " \"}, ");
				result1.append(" [ {\"value\" : \"" + chatList.get(i).getChatContent() + "\"}, ");
				result1.append(" [ {\"value\" : \"" + chatList.get(i).getChatTime() + " \"} ");
				
				if (i != chatList.size() -1) { // 마지막 원소가 아니라면 
					result1.append(",");
				}
			}
			result1.append("], \"last\":\"" + chatList.get(chatList.size() -1).getChatNum() + "\"}");
			
			// JSON 형태의 문자열 반환
			return result1.toString();
		}
		

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
