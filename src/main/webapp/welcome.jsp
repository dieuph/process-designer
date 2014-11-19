<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<title>Successful Login</title>
</head>
<body>
	Hello World, <s:property value="email" />
	<s:property value="#session.login" />
	<s:property value="#session.email" />
	<hr />
	<a href="logout.action">logout</a>
	<a href="tochangepassword.action">Change Password</a>
</body>
</html>