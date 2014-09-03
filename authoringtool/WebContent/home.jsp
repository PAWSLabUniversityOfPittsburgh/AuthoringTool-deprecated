<%@ page language="java"%>
<%@ include file = "include/htmltop.jsp" %>

	<b>Welcome, <%=userBeanName%>.</b>  <br/><br/> 
	
<%
   // GroupBean gBean = (GroupBean) session.getAttribute("groupBean");	
 	//userBean.setGroupBean(gBean);			 

//if (userBean.getGroupBean().getName().equals("teachers") | userBean.getGroupBean().getName().equals("admins") )
//{
	response.sendRedirect("TopicAuthoring.jsp");	
//}	 
%>
		
<%@ include file = "include/htmlbottom.jsp" %>