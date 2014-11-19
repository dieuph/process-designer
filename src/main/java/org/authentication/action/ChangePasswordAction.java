package org.authentication.action;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;

public class ChangePasswordAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String password;
	private String new_password;
	private String new_password_confirm;
	
	Map<String, Object> map;
	
	public String execute() {
		String ret = ERROR;
		Connection conn = null;
		HttpSession session = ServletActionContext.getRequest().getSession(false);
		if (session != null && session.getAttribute("login") != null && session.getAttribute("email") != null) {
			if (password != null && new_password != null && new_password_confirm != null) {
				try {
					String URL = "jdbc:mysql://localhost/test";
					Class.forName("com.mysql.jdbc.Driver");
					conn = DriverManager.getConnection(URL, "root", "root");
					String query = "SELECT password FROM user WHERE email = ?";
					PreparedStatement ps = conn.prepareStatement(query);
					ps.setString(1, (String) session.getAttribute("email"));
					ResultSet rs = ps.executeQuery();
					rs.next();
					String tmpPassword = rs.getString("password");
					if (tmpPassword.equals(DigestUtils.md5Hex(password)) && new_password.equals(new_password_confirm)) {
						String queryUpdate = "UPDATE user SET password = MD5(?) WHERE email = ?";
						ps = conn.prepareStatement(queryUpdate);
						ps.setString(1, new_password);
						ps.setString(2, (String) session.getAttribute("email"));
						ps.executeUpdate();
						ret = SUCCESS;
						addActionMessage(getText("changepwd.success"));
					} else {
						if (!tmpPassword.equals(DigestUtils.md5Hex(password))) {
							addFieldError("changepwd.error.password", getText("changepwd.error.password"));
						}
						if (!new_password.equals(new_password_confirm)) {
							addFieldError("changepwd.error.notmatch", getText("changepwd.error.notmatch"));
						}
					}
				} catch (Exception e) {
					System.err.println("[ERROR] Can not execute change password query.");
					e.printStackTrace();
				}
			} else {
				addActionError(getText("changepwd.error"));
			}
		} else {
			System.out.println("something wrong.");
		}
		return ret;
	}
	
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getNew_password() {
		return new_password;
	}
	public void setNew_password(String new_password) {
		this.new_password = new_password;
	}
	public String getNew_password_confirm() {
		return new_password_confirm;
	}
	public void setNew_password_confirm(String new_password_confirm) {
		this.new_password_confirm = new_password_confirm;
	}
}
