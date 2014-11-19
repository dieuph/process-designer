package org.authentication.action;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.struts2.dispatcher.SessionMap;
import org.apache.struts2.interceptor.SessionAware;

import com.opensymphony.xwork2.ActionSupport;

/**
 * @author DieuPH
 *
 */
public class LoginAction extends ActionSupport implements SessionAware {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String email;
	private String password;
	
	private SessionMap<String, Object> map;

	public String execute() {
		String ret = ERROR;
		Connection conn = null;
		try {
			String URL = "jdbc:mysql://localhost/test";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(URL, "root", "root");
			String query = "SELECT email FROM user WHERE email = ? AND password = ?";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, email);
			ps.setString(2, DigestUtils.md5Hex(password));
			ResultSet rs = ps.executeQuery();
			if (rs.first()) {
				map.put("login", "true");
				map.put("email", email);
				ret = SUCCESS;
			} else {
				addFieldError("login.field.invalid", getText("login.field.invalid"));
			}
		} catch (Exception e) {
			System.err.println("[ERROR] Can not execute login query.");
			e.printStackTrace();
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (Exception e) {
					System.err.println("[ERROR] Can not close connection.");
					e.printStackTrace();
				}
			}
		}
		return ret;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

//	@Override
	public void setSession(Map<String, Object> map) {
		this.map = (SessionMap<String, Object>) map;
	}

}
