<%@ page language="java" import="edu.pitt.sis.paws.authoring.beans.UserBean" %>


<jsp:useBean id="userBean" scope="session" class="edu.pitt.sis.paws.authoring.beans.UserBean" /> 

<%
        if(userBean.getName() == null || userBean.getName().equals(""))
        {
%>	
		<!--Please  <a href="login.jsp">Login</a> first. -->
		<jsp:forward page="login.html?request=LOGINREQD" /> 
				
<%		}


        else
		{
%> 			<?xml version="1.0" encoding="iso-8859-1"?>
			<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
			<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
			<title>Change Password</title>	
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
			</head>

<script language="JavaScript" type="text/javascript">

<!--
function validateForm()
{
	if(formChangePass.newpassword.value != formChangePass.newpasswordc.value)
	{
		alert("The new password and re-entered new password doesnot match. Please re-enter passwords again.");
		formChangePass.newpassword.value="";
		formChangePass.newpasswordc.value="";
		return false;
	}
	else
		return true;
}

-->
</script>







			<body>














			













<% 			
 			
 			if(request.getParameter("referrer").equalsIgnoreCase("ChangePass"))
 			{
				if(userBean.getPassword().equals(request.getParameter("oldpassword")))
				{
					if(request.getParameter("newpassword").equals(request.getParameter("newpasswordc")))
					{
						userBean.setPassword(request.getParameter("newpassword"));
%>						<jsp:forward page="servlet/quizpack.servlets.SecurityServlet?request=CHANGEPASS" /> 	
<%					}
					else
					{
%> 						The new password confirmation doesnot match with the new password.<br/>
						Please re enter passwords.<hr/>										
	 			
<%					}
				}
				else
				{
%>					The old password you entered is incorrect. Please enter correct old password.<hr/> 				
<%				}
			}
%>
			<form name="formChangePass" id="formChangePass" method="post" action="changePass.jsp" onSubmit"return validateForm()" >
			<input type="hidden" name="referrer" value="ChangePass" />
	
			<h3><strong>Change Your Password</strong> </h3>
			<p>Old Password :  <input type="password" name="oldpassword" value=""/>  </p>
			<p>New Password : <input name="newpassword" type="password" value=""/>  </p>
		    <p>Confirm New Password :<input name="newpasswordc" type="password" value=""/>  </p>
  			<input name="submit" type="submit" value="Change Password" />
<%		}
%>
</body>
</html>