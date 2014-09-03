<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>

<script language="JavaScript">
<!--

function handleRequest()
{
	var query = window.location.search;
	if (query.length == 0) {
		return("No message display requested.");
	}
	else	
	{
		var action = query.substring(query.indexOf("=") + 1,query.length);
		if (action == "MODIFYUSERINFOOK") {
			return("You have successfully modified your personal data.");
		}
		else if (action =="MODIFYUSERINFOFAILED" ) {
			return("Error occured while saving user info to the database. " + 
				   "Please contact <a href=\"mailto:roh38@pitt.edu\">System Administrator</a>");
		}
		else if (action == "CREATEGROUPOK") {
			return("The group has been successfully created.");
		}
		else if (action == "CREATEGROUPFAILED") {
			return("Error occured while saving group info to the database. " + 
				   "Please contact <a href=\"mailto:roh38@pitt.edu\">System Administrator</a>");				   
		}
		else if (action == "MODIFYGROUPOK") {
			return("The group has been successfully modified.");
		}
		else if (action == "MODIFYGROUPFAILED") {
			return("Error occured while saving group info to the database. " + 
				   "Please contact <a href=\"mailto:roh38@pitt.edu\">System Administrator</a>");
		}
		else if (action == "DELETEGROUPOK") {
			return("The group has been successfully deleted.");
		}		
		else if (action == "DELETEGROUPFAILED") {
			return("Error occured while deleting a group from the database. " + 
				   "Please contact <a href=\"mailto:roh38@pitt.edu\">System Administrator</a>");
		}
		else if (action == "MODIFYUSERRIGHTSOK") {
			return("The users' rights for the current group have been successfully modified.");
		}
		else if (action == "MODIFYUSERRIGHTSFAILED") 	{
			return("Error occured while saving users' rights to the database. " + 
				   "Please contact <a href=\"mailto:roh38@pitt.edu\">System Administrator</a>");
		}
		else if (action == "ADDUSERSTOGROUPOK") {
			return("The users have been successfully added to the current group.");
		}
		else if (action == "ADDUSERSTOGROUPFAILED") {
			return("Error occured while adding users to the current group. " + 
				   "Please contact <a href=\"mailto:roh38@pitt.edu\">System Administrator</a>");
		}
		else if (action == "DELETEUSERSFROMGROUPOK") {
			return("The users have been successfully deleted from the current group.");
		}
		else if (action == "DELETEUSERSFROMGROUPFAILED") {
			return("Error occured while deleteing users from the current group. " + 
				   "Please contact <a href=\"mailto:roh38@pitt.edu\">System Administrator</a>");
		}
		else if (action == "GETGROUPUSERLISTFAILED") {
			return("Error occured while retrieving users of the current group. " + 
				   "Please contact <a href=\"mailto:roh38@pitt.edu\">System Administrator</a>");
		}
		else if (action == "GETADDUSERLISTFAILED") {
			return("Error occured while retrieving users for adding to the current group. " + 
				   "Please contact <a href=\"mailto:roh38@pitt.edu\">System Administrator</a>");
		}		
		else if (action == "CREATEUSEROK") {
			return("The user has been successfully added to the database.");
		}
		else if (action == "CREATEUSERFAILED") {
			return("Error occured while adding a user to the database. " + 
				   "Please contact <a href=\"mailto:roh38@pitt.edu\">System Administrator</a>. Though you're an admin yourself ;-)");
		}
		else if (action == "MODIFYUSEROK") {
			return("The user has been successfully modified in the database.");
		}
		else if (action == "MODIFYUSERFAILED") {
			return("Error occured while modifying a user in the database. " + 
				   "Please contact <a href=\"mailto:roh38@pitt.edu\">System Administrator</a>. Though you're an admin yourself ;-)");
		}
		else if (action == "DELETEUSEROK") {
			return("The user has been successfully deleted from the database.");
		}
		else if (action == "DELETEUSERFAILED") {
			return("Error occured while deleting a user from the database. " + 
				   "Please contact <a href=\"mailto:roh38@pitt.edu\">System Administrator</a>. Though you're an admin yourself ;-)");
		}
		else if (action == "GETMODIFYUSERLISTFAILED") {
			return("Error occured while retrieving users to modify from the database. " + 
				   "Please contact <a href=\"mailto:roh38@pitt.edu\">System Administrator</a>. Though you're an admin yourself ;-)");
		}
		else if (action == "GETDELETEUSERLISTFAILED") {
			return("Error occured while deleting users to delete from the database. " + 
				   "Please contact <a href=\"mailto:roh38@pitt.edu\">System Administrator</a>. Though you're an admin yourself ;-)");
		}		
	}
}
-->
</script>

<script type="text/javascript">document.write(handleRequest())</script>
<br/>

Return to <a href="home.jsp">Home</a>.
<%@ include file = "include/htmlbottom.jsp" %>