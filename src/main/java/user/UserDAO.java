package user;

import java.sql.*;

public class UserDAO {
	// ConnectionPool 사용 
	private DBConnectionMgr pool;
	
	// 생성자: 객체가 만들어지자마자 데이터베이스에 접속하도록(?)  
	public UserDAO() {
		try {
			pool = DBConnectionMgr.getInstance(); // DBConnectionMgr 객체의 인스턴스를 가져옴 
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		
		
	}
	
	
	// 로그인 처리 함수 
	public int login(String userID, String userPwd) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = pool.getConnection(); // 커넥션 풀 접근 
			String sql = "SELECT * FROM USER1 WHERE userID = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				if (rs.getString("userPwd").equals(userPwd)) { 
					// 사용자가 입력한 userPwd와 데이터베이스의 userPwd가 동일하다면
					// getString("userPwd") -> 데이터베이스의 컬럼 접근 
					
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
	
	
	// ID중복확인 메소드 & 친구찾기 기능 
	public int registerCheck(String userID) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = pool.getConnection(); // 커넥션 풀 접근 
			String sql = "SELECT * FROM USER1 WHERE userID = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			
			if (rs.next() || userID.equals("")) { // 아이디가 이미 존재하거나, 공백일경우 
				return 0; // 이미 존재하는 회원 & 찾은 친구일 경우 
			} else { // 그렇지 않은 경우 
				return 1; // 가입 가능한 아이디 & 친구를 찾을 수 없음 
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
		return -1; // 데이터베이스 오류 알림 
	} // end of register() 
		
	
	// 회원정보 가져오기: userID에 해당하는 사용자 정보를 가져오는 함수 
	// user를 반환하므로 반환 타입은 UserDTO 
	public UserDTO getUser(String userID) {
		UserDTO user = new UserDTO();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = pool.getConnection(); // 커넥션 풀 접근 
			String sql = "SELECT * FROM USER1 WHERE userID = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			
			if (rs.next()) { 
				user.setUserID(userID);
				user.setUserPwd(rs.getString("userPwd"));
				user.setUserName(rs.getString("userName"));
				user.setPhone(rs.getString("phone"));
				user.setZipcode(rs.getString("zipcode"));
				user.setAddress(rs.getString("address"));
				user.setDetailAddress(rs.getString("detailAddress"));
				user.setUserProfile(rs.getString("userProfile"));
				// 데이터를 참조 변수 user에 저장 
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return user;
	} // end of getUser() 
		
	// 회원정보수정 함수 -> 비밀번호, 이름, 연락처, 주소만 변경 가능하게 처리 
	public int update(String userID, String userPwd, String userName, String phone, String zipcode, String address, String detailAddress) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = pool.getConnection();
			String sql = "UPDATE USER1 SET userPwd = ?, userName = ?, phone = ?, zipcode = ?, address = ?, detailAddress = ? WHERE userID = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userPwd);
			pstmt.setString(2, userName);
			pstmt.setString(3, phone);
			pstmt.setString(4, zipcode);
			pstmt.setString(5, address);
			pstmt.setString(6, detailAddress);
			pstmt.setString(7, userID); 
			return pstmt.executeUpdate(); 
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return -1; // 데이터베이스 오류 알림 
	} // end of update() 
	
	

}