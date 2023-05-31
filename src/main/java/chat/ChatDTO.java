package chat;

public class ChatDTO {
	private int userNum;
	private String fromID;
	private String toID;
	private String chatContent;
	private String chatTime;
	
	public int getuserNum() {
		return userNum;
	}
	public void setuserNum(int userNum) {
		this.userNum = userNum;
	}
	public String getFromID() {
		return fromID;
	}
	public void setFromID(String fromID) {
		this.fromID = fromID;
	}
	public String getToID() {
		return toID;
	}
	public void setToID(String toID) {
		this.toID = toID;
	}
	public String getChatContent() {
		return chatContent;
	}
	public void setChatContent(String chatContent) {
		this.chatContent = chatContent;
	}
	public String getChatTime() {
		return chatTime;
	}
	public void setChatTime(String chatTime) {
		this.chatTime = chatTime;
	}
	
	

}