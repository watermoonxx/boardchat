package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import user.DBConnectionMgr;

public class BoardDAO {
	
	// ConnectionPool 사용 
		private DBConnectionMgr pool;
		
		// 생성자: 객체가 만들어지자마자 데이터베이스에 접속하도록(?)  
		public BoardDAO() {
			try {
				pool = DBConnectionMgr.getInstance(); // DBConnectionMgr 객체의 인스턴스를 가져옴 
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		/*
		// 회원가입시도 메소드 수정해서 사용했음(데이터베이스에 INSERT) 
		public int register(String userID, String boardTitle, String boardContent, String boardDate, String boardFile) {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				con = pool.getConnection(); // 커넥션 풀 접근 
				String sql = "INSERT INTO BOARD1 VALUES(?,?,?,?,?,?,?,?)";
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
		} 
		
		*/
	
	
	

}
