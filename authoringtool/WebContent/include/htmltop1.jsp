<%@ page 
	contentType="text/html; charset=windows-1251"
	language="java"
	import="java.io.*, java.util.*, edu.pitt.sis.paws.authoring.beans.*, edu.pitt.sis.paws.authoring.data.Const"
%>



<?xml version="1.0" encoding="windows-1251"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Authoring Tool</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<link href="<%=request.getContextPath()%>/stylesheets/authoring.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/stylesheets/treetable.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/stylesheets/EditInPlace.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/stylesheets/starrating1.js"></script>
<SCRIPT type="text/javascript" src="<%=request.getContextPath()%>/stylesheets/boxover.js"></SCRIPT>
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

</head>

<body onload="loadStars()">

    	