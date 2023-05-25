package chat;

import java.sql.*;
import java.util.ArrayList;

import user.DBConnectionMgr;
// DBConnectionMgr.java 파일이 여러 개 존재하지 x 

public class ChatDAO {
	// ConnectionPool 사용
	private DBConnectionMgr pool;

	// 생성자: 객체가 만들어지자마자 데이터베이스에 접속하도록(?)
	public ChatDAO() {
		pool = DBConnectionMgr.getInstance(); // DBConnectionMgr 객체의 인스턴스를 가져옴
	}

	// 어떠한 역할을 수행하는 함수 생성 
	// 특정 userID에 따라서 채팅 내역 가져오기
	public ArrayList<ChatDTO> getChatListByID(String fromID, String toID, String chatNum) {
		ArrayList<ChatDTO> chatList = null; // 메시지를 배열에 담아 보관
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = pool.getConnection();
			String sql = "SELECT * FROM CHAT WHERE ((fromID = ? AND toID = ?) OR (fromID = ? AND toID = ?)) AND chatNum > ? ORDER BY chatTime";
			// 자신이 보낸 사람이든, 받는 사람이든 모두 가져올 수 있도록 처리
			// CHATNUM이 ?보다 클 때
			// 시간 순서에 따라 정렬

			pstmt = con.prepareStatement(sql); // SQL 문장을 사용하기 직전까지 만들어 둔다
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			pstmt.setString(3, toID);
			pstmt.setString(4, fromID);
			pstmt.setInt(5, Integer.parseInt(chatNum)); // 숫자로 저장
			rs = pstmt.executeQuery(); // 문장을 실행한 결과를 rs에 저장
			chatList = new ArrayList<ChatDTO>(); // chatList 초기화

			while (rs.next()) { // 어떠한 결과가 나올때마다 배열에 담아준다
				ChatDTO chat = new ChatDTO();
				chat.setChatNum(rs.getInt("chatNum"));
				
				// 특수문자 치환 [7강]
				chat.setFromID(rs.getString("fromID").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
						.replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				chat.setToID(rs.getString("toID").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
						.replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				chat.setChatContent(rs.getString("ChatContent").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
						.replaceAll(">", "&gt;").replaceAll("\n", "<br>"));

				// 메시지 시간 처리 
				int chatTime = Integer.parseInt(rs.getString("chatTime").substring(11, 13));
				String timeType = "오전"; // 기본값을 오전으로 설정
				if (chatTime >= 12) {
					timeType = "오후";
					chatTime -= 12;
				}
				chat.setChatTime(rs.getString("chatTime").substring(0, 11) + " " + timeType + " " + chatTime + ":"
						+ rs.getString("chatTime").substring(14, 16) + " ");
				chatList.add(chat);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return chatList; // 리스트 반환
	}
	
	// 대화 내역 중 최근의 몇 개만 가지고 옴
	public ArrayList<ChatDTO> getChatListByRecent(String fromID, String toID, int number) { 
		ArrayList<ChatDTO> chatList = null; // 메시지를 배열에 담아 보관
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = pool.getConnection();
			String sql = "SELECT * FROM CHAT WHERE ((fromID = ? AND toID = ?) OR (fromID = ? AND toID = ?)) AND chatNum > (SELECT MAX(chatNum) - ? FROM CHAT) ORDER BY chatTime";
			// 자신이 보낸 사람이든, 받는 사람이든 모두 가져올 수 있도록 처리
			// CHATNUM이 ?보다 클 때
			// 시간 순서에 따라 정렬

			pstmt = con.prepareStatement(sql); // SQL 문장을 사용하기 직전까지 만들어 둔다
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			pstmt.setString(3, toID);
			pstmt.setString(4, fromID);
			pstmt.setInt(5, number);
			rs = pstmt.executeQuery(); // 문장을 실행한 결과를 rs에 저장
			chatList = new ArrayList<ChatDTO>(); // chatList 초기화

			while (rs.next()) { // 어떠한 결과가 나올때마다 배열에 담아준다
				ChatDTO chat = new ChatDTO();
				chat.setChatNum(rs.getInt("chatNum"));
				chat.setFromID(rs.getString("fromID").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
						.replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				chat.setToID(rs.getString("toID").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
						.replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				chat.setChatContent(rs.getString("ChatContent").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
						.replaceAll(">", "&gt;").replaceAll("\n", "<br>"));

				// 메시지 시간 처리 (7강)
				int chatTime = Integer.parseInt(rs.getString("chatTime").substring(11, 13));
				String timeType = "오전"; // 기본값을 오전으로 설정
				if (chatTime >= 12) {
					timeType = "오후";
					chatTime -= 12;
				}
				chat.setChatTime(rs.getString("chatTime").substring(0, 11) + " " + timeType + " " + chatTime + ":"
						+ rs.getString("chatTime").substring(14, 16) + " ");
				chatList.add(chat);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return chatList; // 리스트 반환
	}

	// 채팅을 보내는 함수(전송 기능) 
	public int submit(String fromID, String toID, String chatContent) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = pool.getConnection();
			// String sql = "INSERT INTO CHAT VALUES(NULL, ?, ?, ?, NOW())"; // NULL 값을 넣어서 chatNUM이 자동으로 증가하게(?), NOW(): 현재 시각 의미  
			String sql = "INSERT INTO CHAT VALUES(SEQ_CHAT.NEXTVAL, ?, ?, ?, SYSDATE)"; // chatNum이 자동으로 증가할 수 있도록 시퀀스 사용, SYSDATE: 현재 시각 의미  

			pstmt = con.prepareStatement(sql); // SQL 문장을 사용하기 직전까지 만들어 둔다
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			pstmt.setString(3, chatContent);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return -1; // 데이터베이스 오류가 발생했음을 알림 
	}

}