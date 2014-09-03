<%@ page 
	contentType="text/html; charset=utf8"
	language="java"
	import="java.io.*, java.util.*, edu.pitt.sis.paws.authoring.beans.*, edu.pitt.sis.paws.authoring.data.Const"
	pageEncoding="utf8"
%>

<%
	int colspan = 3;
	boolean displaySysManage = false;
	UserBean userBean = (UserBean) session.getAttribute("userBean");
	String userBeanName = "";
	if (userBean != null)
	{
		userBeanName = userBean.getName();
		GroupBean gbean = userBean.getGroupBean();
		if (gbean != null)
		{
			if (userBean.getGroupBean().getName().equals("admins")) {    
				colspan++;
				displaySysManage = true;
			}
		}
		
	}
	else
		response.sendRedirect("index.html?action="+"EXPIRED");
%>

<?xml version="1.0" encoding="utf8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Authoring Tool</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
<link href="<%=request.getContextPath()%>/stylesheets/authoring.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/stylesheets/treetable.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/stylesheets/EditInPlace.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/stylesheets/starrating.js"></script>
<SCRIPT type="text/javascript" src="<%=request.getContextPath()%>/stylesheets/boxover.js"></SCRIPT>
<script type="text/javascript" src="<%=request.getContextPath()%>/stylesheets/getQuiz.js"></script>
<script type="text/javascript">
function toggleMe(a){
var e=document.getElementById(a);
if(!e)return true;
if(e.style.display=="none"){
e.style.display="block"
}
else{
e.style.display="none"
}
return true;
}
</script>
<style>

/* Start by setting display:none to make this hidden.
   Then we position it in relation to the viewport window
   with position:fixed. Width, height, top and left speak
   speak for themselves. Background we set to 80% white with
   our animation centered, and no-repeating */
.modal {
    display:    none;
    position:   fixed;
    z-index:    1000;
    top:        0;
    left:       0;
    height:     100%;
    width:      100%;
    background: rgba( 255, 255, 255, .8 ) 
                url('http://i.stack.imgur.com/FhHRx.gif') 
                50% 50% 
                no-repeat;
}

/* When the body has the loading class, we turn
   the scrollbar off with overflow:hidden */
body.loading {
    overflow: hidden;   
}

/* Anytime the body has the loading class, our
   modal element will be visible */
body.loading .modal {
    display: block;
}
</style>

</head>

<body onload="loadStars()">
<div class="modal"><!-- Place at bottom of page --></div>

	<center>
<table width="80%" cellspacing="0" cellpadding="0" align="center">
  <tr> 
    <td class="titlebar">Authoring Tool</td>
  </tr>
  <tr> 
    <td>
    <table width="100%" cellspacing="0" cellpadding="0">  		
<%
if (userBean != null) {

if (userBean.getGroupBean() != null) {
	%>
		<td width="1" class="menubar"><nobr><a class="menu" href="TopicAuthoring.jsp">Authoring</a></nobr></td>
<%
		if(displaySysManage) {
%>	
		<td width="1" class="menubar"><nobr><a class="menu" href="sysmanage.jsp">System Management</a></nobr></td>
<%
		}
%>
		<td width="*" class="menubar">&nbsp;</td>
		<td width="1" class="menubar"><nobr><a class="menu" href="myaccount.jsp">My Account</a></nobr></td>
<%
	}
}
%>
		<td width="1" class="rightborder menubar"><nobr><a class="menu" href="SecurityServlet?action=LOGOUT">Logout</a></nobr></td>
  	</table>
  	</td>
  </tr>
  <tr> 
    <td class="mainpage">
    	