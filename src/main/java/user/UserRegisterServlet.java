package user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UserRegisterServlet")
public class UserRegisterServlet extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// 실제로 회원가입을 수행하는 서블릿 
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8"); 
		
		// 사용자 입력값을 변수에 저장 
		String userID = request.getParameter("userID");
		String userPwd = request.getParameter("userPwd");
		String userPwd2 = request.getParameter("userPwd2");
		String userName = request.getParameter("userName");
		String phone = request.getParameter("phone");
		String zipcode = request.getParameter("zipcode");
		String address = request.getParameter("address");
		String detailAddress = request.getParameter("detailAddress");
		String userProfile = request.getParameter("userProfile");
		
		if (userID == null || userID.equals("") || userPwd == null || userPwd.equals("") || 
			userPwd2 == null || userPwd2.equals("") || userName == null || userName.equals("") || 
			phone == null || phone.equals("") || zipcode == null || zipcode.equals("") || 
			address == null || address.equals("") || detailAddress == null || detailAddress.equals("")) {
			// userProfile == null || userProfile.equals("") 프로필 사진을 넣는 것은 필수 요소 아님 
			
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "모든 내용을 입력하세요!");
			response.sendRedirect("join.jsp");
			return;
		}
		
		if (!userPwd.equals(userPwd2)) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "비밀번호가 서로 다릅니다!");
			response.sendRedirect("join.jsp");
			return;
		}
		
		// 코드가 이곳까지 작동했다면 오류가 없는 것이므로 회원가입 시켜줌 
		int result = new UserDAO().register(userID, userPwd, userName, phone, zipcode, address, detailAddress, userProfile);
		if (result == 1) {
			request.getSession().setAttribute("messageType", "성공 메시지");
			request.getSession().setAttribute("messageContent", "회원가입 되었습니다.");
			response.sendRedirect("index.jsp");
			return;
		} else {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "이미 존재하는 회원입니다!");
			response.sendRedirect("join.jsp");
			
		}
	}
		
}
