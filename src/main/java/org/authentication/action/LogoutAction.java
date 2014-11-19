package org.authentication.action;

import java.util.Map;

import org.apache.struts2.dispatcher.SessionMap;
import org.apache.struts2.interceptor.SessionAware;

import com.opensymphony.xwork2.ActionSupport;

public class LogoutAction extends ActionSupport implements SessionAware {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private SessionMap<String, Object> map;
	
	public String execute() {
		String ret = ERROR;
		try {
			map.remove("login");
			map.remove("email");
			ret = SUCCESS;
		} catch (Exception e) {
			System.err.println("[ERROR] Remove session has failed.");
			e.printStackTrace();
		}
		return ret;
	}

//	@Override
	public void setSession(Map<String, Object> map) {
		this.map = (SessionMap<String, Object>) map;
	}
}
