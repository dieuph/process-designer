package org.authentication.action;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.authentication.features.Emailer;
import org.authentication.features.RandomStringGenerator;

import com.opensymphony.xwork2.ActionSupport;

public class ForgotPasswordAction extends ActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String email;

	public String execute() {
		String ret = ERROR;
		Connection conn = null;
		try {
			String URL = "jdbc:mysql://localhost/test";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(URL, "root", "root");
			String query = "SELECT email FROM user WHERE email = ?";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, email);
			ResultSet rs = ps.executeQuery();
			if (rs.first()) {
				// generate new password
				String newPassword = RandomStringGenerator.generateRandomString(8, RandomStringGenerator.Mode.ALPHANUMERIC);
				
				// update new password
				String queryUpdate = "UPDATE user SET password = MD5(?) WHERE email = ?";
				ps = conn.prepareStatement(queryUpdate);
				ps.setString(1, newPassword);
				ps.setString(2, email);
				ps.executeUpdate();
				
				// initial email properties and sent it
				String from = "dieuph2211@gmail.com";
				String to = email;
				String password = "$DoubleD@1122";
				String subject = "Forgotten Process-Designer password";
				String body = "Hi,<br /><br />"
						+ "We received a request to change your password on Process-Designer.<br /><br />"
						+ "Your new password is: <span style='color: #FEAA2E; font-weight: bold;'>" + newPassword + "</span><br />"
						+ "Please keep it secret, keep it safe!<br /><br />"
						+ "After you  have logged in using new password, you may change it by going to the 'Change Password' area.<br />"
						+ "We hope you enjoy your stay at process-designer.com<br /><br />"
						+ "All the best,<br />"
						+ "The Process-Designer Team";
				
				Emailer email = new Emailer(from, to, password, subject, body);
				email.sendEmail();
				addActionMessage(getText("forgotpwd.success"));
			} else {
				addActionError(getText("forgotpwd.error"));
			}
			ret = SUCCESS;
		} catch (Exception e) {
			ret = ERROR;
			System.err.println("[ERROR] Reset password and sent email has failed.");
			e.printStackTrace();
		}
		return ret;
	}
	
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
}
