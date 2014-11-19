package org.authentication.action;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.opensymphony.xwork2.ActionSupport;

/**
 * @author DieuPH
 *
 */
public class RegisterAction extends ActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String emailsignup;
	private String passwordsignup;
	private String passwordsignup_confirm;

	public String execute() {
		String ret = ERROR;
		Connection conn = null;
		try {
			String URL = "jdbc:mysql://localhost/test";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(URL, "root", "root");
			
			String queryCheck = "SELECT email FROM user WHERE email = ?";
			PreparedStatement ps = conn.prepareStatement(queryCheck);
			ps.setString(1, emailsignup);
			ResultSet rs = ps.executeQuery();
			// check email exists and password match with password confirm
			if (!rs.first() && passwordsignup.equals(passwordsignup_confirm)) {
				String query = "INSERT INTO user(email, password) VALUES(?, MD5(?))";
				ps = conn.prepareStatement(query);
				ps.setString(1, emailsignup);
				ps.setString(2, passwordsignup);
				ps.executeUpdate();
				ret = SUCCESS;
				addActionMessage(getText("register.success"));
			} else {
				if (rs.first()) {
					addFieldError("register.email.already", getText("register.email.already"));
				}
				if (!passwordsignup.equals(passwordsignup_confirm)) {
					addFieldError("register.password.notmatch", getText("register.password.notmatch"));
				}
			}
		} catch (Exception e) {
			ret = ERROR;
			System.err.println("[ERROR] Can not execute register query.");
			e.printStackTrace();
		}
		return ret;
	}

	public String getEmailsignup() {
		return emailsignup;
	}
	
	public void setEmailsignup(String emailsignup) {
		this.emailsignup = emailsignup;
	}

	public String getPasswordsignup() {
		return passwordsignup;
	}

	public void setPasswordsignup(String passwordsignup) {
		this.passwordsignup = passwordsignup;
	}

	public String getPasswordsignup_confirm() {
		return passwordsignup_confirm;
	}

	public void setPasswordsignup_confirm(String passwordsignup_confirm) {
		this.passwordsignup_confirm = passwordsignup_confirm;
	}

}
