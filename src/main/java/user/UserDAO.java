package user;

import java.sql.*;

public class UserDAO {
	// ConnectionPool 사용 
	private DBConnectionMgr pool;
	
	// 생성자: 객체가 만들어지자마자 데이터베이스에 접속하도록(?)  
	public UserDAO() {
		pool = DBConnectionMgr.getInstance(); // DBConnectionMgr 객체의 인스턴스를 가져옴 
	}
	
	// login 메소드
		/*
		public boolean login(String userID, String userPwd) {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			boolean flag = false;
			
			try {
				con = pool.getConnection();
				String sql = "SELECT USERID FROM USER WHERE USERID = ? AND USERPWD = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, userID);
				pstmt.setString(2, userPwd);
				rs = pstmt.executeQuery();
				flag = rs.next();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
			return flag;
		}
		*/
		
	
	// 로그인 처리 함수 
	public int login(String userID, String userPwd) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = pool.getConnection(); // 커넥션 풀 접근 
			String sql = "SELECT * FROM USER1 WHERE USERID = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				if (rs.getString("userPassword1").equals(userPwd)) { // 사용자가 입력한 userPwd와 데이터베이스의 userPwd가 동일하다면
					return 1; // 로그인 성공 
				} 
				return 2; // 비밀번호 일치하지 않음 
			} else { // 사용자 존재하지 않는다면 
				return 0; 
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return -1; // 데이터베이스 오류 
	} // end of login() 
	
	
	// ID중복확인 메소드 
	public int registerCheck(String userID) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = pool.getConnection(); // 커넥션 풀 접근 
			String sql = "SELECT * FROM USER1 WHERE USERID = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			
			if (rs.next() || userID.equals("")) { // 아이디가 이미 존재하거나, 공백일경우 
				return 0; // 이미 존재하는 회원 
			} else { // 그렇지 않은 경우 
				return 1; // 가입 가능한 회원 아이디 
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return -1; // 데이터베이스 오류 
	} // end of registerCheck() 
	
	// 회원가입시도 메소드 
		public int register(String userID, String userPwd, String userName, String phone, String zipcode, String address, String detailAddress, String userProfile) {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				con = pool.getConnection(); // 커넥션 풀 접근 
				String sql = "INSERT INTO USER1 VALUES(?,?,?,?,?,?,?,?)";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, userID);
				pstmt.setString(2, userPwd);
				pstmt.setString(3, userName);
				pstmt.setString(4, phone);
				pstmt.setString(5, zipcode);
				pstmt.setString(6, address);
				pstmt.setString(7, detailAddress);
				pstmt.setString(8, userProfile);
				return pstmt.executeUpdate(); // 조회가 아닌 삽입이므로(SELECT문이 아니라 INSERT문) executeQuery()가 아니라 executeUpdate() [5강]   
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt);
			}
			return -1; // 데이터베이스 오류 
		} // end of register() 
	
	

}
