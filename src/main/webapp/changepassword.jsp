<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6 lt8"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7 lt8"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8 lt8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"> <!--<![endif]-->
    <head>
        <meta charset="UTF-8" />
        <!-- <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">  -->
        <title>Welcome to Process Designer - Change Password</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
<!--         <link rel="shortcut icon" href="../favicon.ico">  -->
        <link rel="stylesheet" type="text/css" href="css/demo.css" />
        <link rel="stylesheet" type="text/css" href="css/style2.css" />
        <link rel="stylesheet" type="text/css" href="css/animate-custom.css" />
    </head>
    <body>
        <div class="container">
            <header>
                <h1>Welcome to <span>Process-Designer</span></h1>
            </header>
            <section>               
                <div id="container_demo" >
                    <div id="wrapper">
                        <div id="changepassword" class="animate form">
                            <form  action="changepassword.action" autocomplete="on" method="post"> 
                                <h1> Change Password </h1>
                                <div class="action-message">
                                    <s:actionmessage />
                                </div>
                                <div class="action-error">
                                    <s:fielderror fieldName="changepwd.error.password" />
                                    <s:fielderror fieldName="changepwd.error.notmatch" />
                                </div>
                                <p> 
                                    <label for="password" class="youpasswd" data-icon="p">Your password </label>
                                    <input id="password" name="password" required="required" type="password" placeholder="********"/>
                                </p>
                                <p> 
                                    <label for="new_password" class="youpasswd" data-icon="p">Your new password </label>
                                    <input id="new_password" name="new_password" required="required" type="password" placeholder="********"/>
                                </p>
                                <p> 
                                    <label for="new_password_confirm" class="youpasswd" data-icon="p">Please confirm your new password </label>
                                    <input id="new_password_confirm" name="new_password_confirm" required="required" type="password" placeholder="********"/>
                                </p>
                                <p class="signin button"> 
                                    <input type="submit" value="Submit"/> 
                                </p>
                                <p class="change_link">  
                                    <a href="toworkspace.action" class="to_register"> Go workspace </a>
                                </p>
                            </form>
                        </div>
                        
                    </div>
                </div>  
            </section>
        </div>
    </body>
</html>