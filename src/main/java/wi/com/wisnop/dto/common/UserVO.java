package wi.com.wisnop.dto.common;

import java.io.Serializable;

public class UserVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private String userId;
	private String userNm;
	private String userType;
	private String pwd;
	private String delFlag;
	private String langCd;
	private String email;
	private String finalAccessFinishDttm;
	private String finalAccessStartDttm;
	private String pwCompareYn;
	private String dashboardYn;
	
	public String getDashboardYn() {
		return dashboardYn;
	}
	public void setDashboardYn(String dashboardYn) {
		this.dashboardYn = dashboardYn;
	}
	public String getPwCompareYn() {
		return pwCompareYn;
	}
	public void setPwCompareYn(String pwCompareYn) {
		this.pwCompareYn = pwCompareYn;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getUserType() {
		return userType;
	}
	public void setUserType(String userType) {
		this.userType = userType;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getDelFlag() {
		return delFlag;
	}
	public void setDelFlag(String delFlag) {
		this.delFlag = delFlag;
	}
	public String getLangCd() {
		return langCd;
	}
	public void setLangCd(String langCd) {
		this.langCd = langCd;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getFinalAccessFinishDttm() {
		return finalAccessFinishDttm;
	}
	public void setFinalAccessFinishDttm(String finalAccessFinishDttm) {
		this.finalAccessFinishDttm = finalAccessFinishDttm;
	}
	public String getFinalAccessStartDttm() {
		return finalAccessStartDttm;
	}
	public void setFinalAccessStartDttm(String finalAccessStartDttm) {
		this.finalAccessStartDttm = finalAccessStartDttm;
	}
}
