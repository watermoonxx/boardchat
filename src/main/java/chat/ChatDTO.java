package chat;

public class ChatDTO {
	int chatNum;
	String fromID;
	String toID;
	String chatContent;
	String chatTime;
	
	public int getChatNum() {
		return chatNum;
	}
	public void setChatNum(int chatNum) {
		this.chatNum = chatNum;
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