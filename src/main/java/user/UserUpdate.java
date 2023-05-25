package user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/UserUpdate")
public class UserUpdate extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");

		// 사용자 입력값을 변수에 저장
		String userID = request.getParameter("userID");

		// 회원정보수정의 경우 사용자 본인만 수정 가능해야하므로 세션 값 검증 필요
		// 현재 건너온 userID 값과, 로그인 된 userID 값이 같은지 비교해야 한다
		HttpSession session = request.getSession();

		String userPwd = request.getParameter("userPassword1");
		String userPwd2 = request.getParameter("userPassword2");
		String userName = request.getParameter("userName");
		String phone = request.getParameter("phone");
		String zipcode = request.getParameter("zipcode");
		String address = request.getParameter("address");
		String detailAddress = request.getParameter("detailAddress");
		String userProfile = request.getParameter("userProfile");

		if (userID == null || userID.equals("") || userPwd == null || userPwd.equals("") || userPwd2 == null
				|| userPwd2.equals("") || userName == null || userName.equals("") || phone == null || phone.equals("")
				|| zipcode == null || zipcode.equals("") || address == null || address.equals("")
				|| detailAddress == null || detailAddress.equals("")) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "모든 내용을 입력하세요!");
			response.sendRedirect("update.jsp"); 
			return;
		}

		// 회원정보수정의 경우 사용자 본인만 수정 가능해야하므로 세션 값 검증 필요
		// 현재 건너온 userID 값과, 로그인 된 userID 값이 같은지 비교해야 한다
		// null 값 검증 이후 수행
		if (!userID.equals((String) session.getAttribute("userID"))) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("login.jsp");
			return; 
		}
		
		if (!userPwd.equals(userPwd2)) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "비밀번호가 서로 다릅니다!");
			response.sendRedirect("update.jsp");
			return;
		}
		
		// 코드가 이곳까지 작동했다면 오류가 없는 것이므로 회원정보수정 진행됨 
		int result = new UserDAO().update(userID, userPwd, userName, phone, zipcode, address, detailAddress);
		if (result == 1) {
			request.getSession().setAttribute("userID", userID); // 회원가입에 성공했다면 세션 잡아줌 [8] (회원가입 후 세션 잡아서 로그인 처리) 
			request.getSession().setAttribute("messageType", "성공 메시지");
			request.getSession().setAttribute("messageContent", "회원정보수정 완료");
			response.sendRedirect("index.jsp");
		} else {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "오류 발생");
			response.sendRedirect("update.jsp");

		}


	}

}
