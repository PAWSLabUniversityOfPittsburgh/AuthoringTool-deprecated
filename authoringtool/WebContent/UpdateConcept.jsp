<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>	
<%@ page import="java.util.Collections" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Edit Question Concept</title>
<script src="<%=request.getContextPath()%>/js/jquery1.4.2.js"></script>
<script type="text/javascript" language="javascript">
	

    $(document).ready(function(){
    	var args = window.dialogArguments;
		var argsArray = args.split(",");
		var question = argsArray[0];
		var concept = argsArray[1];
		var type = argsArray[2];
		
		$("#applyBtn").click(function () {
    		
    		var count = document.getElementById("questionClassCount").value;
            var array = new Array();
            array.push(document.getElementById("questionClassCount"));
            for (var i = 0; i < count; i++)
            	{
            	   var selected = document.getElementById(i+"RowSelected");
            	   var lines = document.getElementById(i+"RowLines");
            	   var className = document.getElementById(i+"ConceptClass");
            	   
            	   if (selected.checked)
            		   {
            		   array.push(selected);
            		   array.push(lines);
            		   array.push(className);
            		   }
            	   else 
            		   array.push(className);
            	}
            $.post("UpdateConcept?question="+question+"&concept="+concept+"&type="+type,array,function() {
            	alert("Concept Updated successfully!"); 
                window.returnValue = true;
                window.close();
            });
      	});	
		
    	$("input").change(function () {
    		var fn =  $(this).attr("fn");
    		if (fn == 'lines')
    		{
    			var input = $(this).val();
    			input = input.replace(/\s+/g, '');
    			var regex = /^(\d+-\d+)(;\d+-\d+)*$/;
    			var match = false;
    			 if (input.match(regex)) 
    				match = true;
    			 else if (input == '')
    				match = true;
    			 else if (input.match(/^(\d+-\d+)(;\d+-\d+)*;$/))
    				match = true;
    			 if (match == false)
    				 alert("Input should be list of hyphenated digits separated by ;'");
    		}    			
    	});	
    });
    
    
    function disableEnableRowLine(line)
	{
        var select = document.getElementById(line+"RowSelected");
  	    var lineText = document.getElementById(line+"RowLines");
	    var row =  document.getElementById(line+'Row');

        if (select.checked == false)
        	{
    		  lineText.disabled = true;
    		  row.style.color = "gray";
        	}
        else
        {
  		  lineText.disabled = false;
  		  row.style.color = "black";
      	}
		
	}	 
</script>
</head>
<body>
 <% 
    String question = request.getParameter("question");
    String concept = request.getParameter("concept");
    String type = request.getParameter("type");
    boolean isExample = false;
    if (type != null)
    {
    	if (type.equals("example"))
    		isExample = true;    		
    }
    ArrayList<String> classList = new ArrayList<String>();
    
    Connection conn = null;
    String query = "";    
    int quizId = -1;
    Statement statement = null;
    try
    {    	   	
    
    	Class.forName(this.getServletContext().getInitParameter("db.driver"));
		conn = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
        statement = conn.createStatement();  

    	if(isExample)
    		classList.add(question);
    		
    	else
    	{
            //if the concept is null, it means the check box of the concept
    		//	is not selected by user and this concept should be removed since it 
    		//	has been previously stored in db by ParserServlet

        	query = "select QuizID from ent_jquiz where  Title = '"+question+"'";      
            ResultSet quizRs = statement.executeQuery(query);
              
            while (quizRs.next()) {
                quizId = quizRs.getInt(1);
            }
                    
            query = "select c.ClassName from ent_class c, rel_quiz_class r where c.ClassID = r.ClassID and r.QuizID= '"+quizId+"' ";      
            ResultSet  classRs = statement.executeQuery(query);  
            String className =  "";

            while (classRs.next())
            {  
            	className = classRs.getString(1);
            	if (className.substring(0,1).equals("0") |
            		className.substring(0,1).equals("1"))
            		className = className.substring(2,className.length()); 
            	classList.add(className);
            }      
            classList.add("Tester.java"); // this class always exists and is not in the query result
    	}
		
        Collections.sort(classList);
    
 %>
 <div style = "border-style:solid;border-width:1px; border-color:rgb(120,172,255);padding: 10px">
    <table width="100%" id ="editTable">    
    <tr><td style = "padding-bottom:10px;" colspan="3">
  <b><%=question%>: <%=concept %> </b>
    
    </td></tr>   
    <tr><td></td><td></td><td style="font-style:italic;color: gray;padding-left: 10px">start-end lines example: 1-3;5-5</td></tr>
    
      <%
      
      String lines = "";
      boolean exists = false;
      ResultSet rs;
      String className;
      String table = "ent_jquiz_concept";
      if (isExample)
    	  table = "ent_jexample_concept";
      for (int j = 0; j < classList.size(); j++)
	  {
		  className = classList.get(j);
		  lines = "";
	      exists = false;
	      if (isExample == false)
	    	  query = "select class from "+table+" where title = '"+ question + "' and class = '"+className+"' and concept = '"+concept+"'";
	      else
	    	  query = "select class from "+table+" where title = '"+ question + "' and concept = '"+concept+"'";
	      rs = statement.executeQuery(query);
	      if (rs.next())
	    	  exists = true;

	      if (exists)
	      {
	    	  if (isExample = false)
	    		  query = "select sline,eline from "+table+" where title = '"+ question + "' and class = '"+className+"' and concept = '"+concept+"' and sline != -1 and eline !=-1";
	    	  else
		    	  query = "select sline,eline from "+table+" where title = '"+ question + "' and concept = '"+concept+"' and sline != -1 and eline !=-1";
	    	  rs = statement.executeQuery(query);
	          while (rs.next())
	          {
	        	  lines += rs.getInt(1)+"-"+rs.getInt(2);
	        	  if (rs.isLast() == false)
	        		  lines += ";";
	          }
	      }	 
	  %>	  
      <tr id = '<%=j%>Row'  <%=(exists?"":"style=\"color:gray\"")%>>
      <td><input type=checkbox id='<%=j %>RowSelected' name='<%=j %>RowSelected' align="left" onchange = "disableEnableRowLine(<%=j %>);" <%=(exists?"checked":"")%>></td>
      <td > <%=className %></td>
      <td style = "padding-left:10px" >start-end lines: <input type="text" id = '<%=j%>RowLines' name = '<%=j%>RowLines' <%=(exists?"":"disabled")%> value='<%=lines%>' fn = 'lines'></td>
      </tr>
      <%} %>    
    </table>
    <div align="right"><input type="button"  name ="applyBtn" id ='applyBtn' value="Apply">
    <input type="hidden" id='questionClassCount' name='questionClassCount' value='<%=classList.size()%>'>	      
        <%
        for (int i = 0; i < classList.size(); i++)
		{
		%>
	    <input type="hidden" name='<%=i+"ConceptClass"%>' id='<%=i+"ConceptClass"%>' value='<%=classList.get(i)%>'>	      
	  <%
	   }
	   }catch(SQLException e)
       {
		   e.printStackTrace();    	
       }
    finally {
			try {   						
				if (statement != null)
					statement.close();
				try {
					if (conn != null && (conn.isClosed() == false)) {
						conn.close();
					}
				} catch (SQLException e) {
					e.printStackTrace();
				}
				
			} catch (Exception e) {
				if (conn != null && (conn.isClosed() == false)) {
					conn.close();
				}
				e.printStackTrace();
			}
     }
        %>
    </div>
    </div>
</body>
</html>


<%--!
//for local connection
public Connection getConnectionToWebex21()
 {
	Connection conn = null;
	try
	{
		Class.forName(api.Constants.DB.DRIVER).newInstance();
		conn = DriverManager.getConnection(api.Constants.DB.URL,api.Constants.DB.USER,api.Constants.DB.PASSWORD);
	}catch (Exception e) {
		e.printStackTrace();
	}
	return conn;
 }--%>
