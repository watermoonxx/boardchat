package user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UserRegisterCheckServlet")
public class UserRegisterCheckServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 사용자에게 ID중복체크한 결과를 반환하는 서블릿
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		String userID = request.getParameter("userID"); // 사용자 입력값

		// 세션 관리 
		if (userID == null || userID.equals("")) {
			response.getWriter().write("-1");
			
		}
		
		response.getWriter().write(new UserDAO().registerCheck(userID) + ""); // 문자열 형태로 출력해서 사용자에게 반환

	}

}
