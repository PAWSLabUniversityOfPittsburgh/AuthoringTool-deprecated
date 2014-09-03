<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.lang.*" %>

<%@ page import="java.sql.*" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.util.Date" %>

<script language="javascript">
<!--

function cOn(td){
if(document.getElementById||(document.all && !(document.getElementById))){
td.style.backgroundColor="#ffffe1";
}
}

function cOut(td){
if(document.getElementById||(document.all && !(document.getElementById))){
td.style.backgroundColor="#FFCC00";
}
}
//-->
</script>

	<script>
		function rtrim(StringToTrim){
			return StringToTrim.replace(/\s+$/,"");
		}
	</script>



        <BR>
<form ACTION="savecomment.jsp" METHOD="post" name="myForm"> 
	        <table style = "width: 100%">	        
	        <tr>
	        	<td class="formfieldbold formfielddark"><b>Line</b></td>
	        	<td class="formfieldbold formfielddark"><b>Comment</b></td>
	        	<td class="formfieldbold formfielddark" width="15%"><b>Characters left</b></td>
	        </tr>
         <%
         ResultSet resultd = null;
         
            Connection connection = null;
            Class.forName(this.getServletContext().getInitParameter("db.driver"));
            connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
            
            Statement statement = connection.createStatement();
            
		
	String text1 = request.getParameter("title");  	
	text1=text1.replace("'","\\'");	
  %>
	<script>
		var myString1 = "<%=text1%>";
		myString1.rtrim();
	</script>
	<%
	String topic = request.getParameter("topic");
	String text2 = request.getParameter("chapter");  
		
	//String text3 = request.getParameter("Scope"); 	
	String text5 = request.getParameter("rdfID"); 
  %>
	<script>
		var myString5 = "<%=text5%>";
		myString5.rtrim();
	</script>
	<%
	
	//String[] sa=text3.split("[ ]");
	//int text3_0 = Integer.parseInt(sa[0]); 
	//TODO 
	int text3_0 = 12;
		

	

  String text4="";
  int text2index = text2.lastIndexOf("text2");
  if (text2index>=255){
		 text4 = text2.substring(0,254);		
		 text4=text4.replace("'","\\'");
		  %>
			<script>
				var myString4 = "<%=text4%>";
				myString4.rtrim();
			</script>
			<%		 
	}else{
		 text4=text2;
		 text4=text4.replace("'","\\'");
		  %>
			<script>
				var myString4 = "<%=text4%>";
				myString4.rtrim();
			</script>
			<%		 
	}
	
	String command3 = "INSERT INTO ent_dissection (rdfID,Name, Description) VALUES ('"+text5+"','"+text1+"','"+text2+"')";
	statement.executeUpdate(command3); 
	
	String MaxID ="";
	resultd = statement.executeQuery("SELECT MAX(DissectionID) AS LastID FROM ent_dissection WHERE rdfID='"+text5+"';");        
	  while(resultd.next())
		{ 	
		MaxID = resultd.getString(1);		
		}	
  int Max = Integer.parseInt(MaxID);
			
	String command2 = "INSERT INTO rel_scope_dissection (ScopeID,DissectionID) VALUES ( '"+(text3_0)+"','" +(Max)+ "')";         
        statement.executeUpdate(command2);  

	 String uid="";
	 ResultSet rs = null;  
	 rs = statement.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
	 while(rs.next())
	  {
	  	uid=rs.getString(1);  	
	  }  
	String privacy = request.getParameter("privacy");	
	if (privacy.equals("Private")){
		String command4 = "insert into rel_dissection_privacy (DissectionID, Uid, Privacy) values ('"+(Max)+"','"+uid+"','0') ";			
		statement.executeUpdate(command4);                        	    	      		
	}else {
 		String command4 = "insert into rel_dissection_privacy (DissectionID, Uid, Privacy) values ('"+(Max)+"','"+uid+"','1') ";			
		statement.executeUpdate(command4);                        	    	      		
	}

	String command5 = "insert into rel_topic_dissection (topicID,DissectionID) values ('"+topic+"','"+Max+"') ";			
	statement.executeUpdate(command5);     

//ADD TO AGGREGATE
//select login
     ResultSet tmpRs = null;
     tmpRs = statement.executeQuery("SELECT login FROM ent_user where name = '"+userBeanName+"' ");
     String login = "";
     while(tmpRs.next())
     {
  	   login=tmpRs.getString(1);  	
     }

Connection connection2 = null;
connection2 = DriverManager.getConnection(this.getServletContext().getInitParameter("db.aggregateURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
Statement statement2 = connection2.createStatement();
DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
Date date = new Date();
String pri = privacy.equals("Private")?"private":"public";
String c2 ="insert into ent_content (content_name,content_type,display_name,`desc`,url,domain,provider_id,visible,creation_date,creator_id,privacy,comment) values "+
        "('"+text5+"','example','"+text1+"','"+text2+"','http://adapt2.sis.pitt.edu/webex/Dissection2?act="+text5+"&svc=progvis','java','webex','1','"+dateFormat.format(date)+"','"+login+"','"+pri+"','')";
statement2.executeUpdate(c2); 
try {
    if (statement2 != null)
     statement2.close();
    }  catch (SQLException e) {}
    try {
     if (connection2 != null)
      connection2.close();
     } catch (SQLException e) {}     
    //end agg add
		
       String text = request.getParameter("textarea1");  
       String Message = "";        
       int msgLength = text.length();
       int Position = 0;
       int count = 0;
%>

 <%      
       out.write("<h3>Please write down the comments for each line of the code and then click the save button.</h3>");
       text=text+"\n";
       while (true) { 
                int index = text.indexOf('\n', Position);
                if (index == -1) {
                break;
        	}
 
        if (index > Position) {
    	Message = text.substring(Position, index);  
    	Message = Message.replace("'","\\'");	    	    	
        }
        
        String command = "INSERT INTO ent_line (Code, LineIndex,DissectionID,Comment) VALUES ( '" +Message+ "' , '"+(count+1)+"','" +(Max)+ "','')";
        statement.executeUpdate(command);                        	    	      
        
        Position = index + 1;
        count = count + 1;
        

	 %>
	
	
	        <TR>        
	        <TD class = 'formfieldlight'><%= Message %></TD>
	        <td >
	        <textarea name=C<%=count%> wrap=physical cols=80 rows=3 onKeyDown="textCounter(this.form.C<%=count%>,this.form.remLen<%=count%>,2048);" onKeyUp="textCounter(this.form.C<%=count%>,this.form.remLen<%=count%>,2048);" style='width: 100%;'></textarea>
					</td>
					<td ><textarea readonly rows=3  name=remLen<%=count%>   style='width: 100%;'>2048</textarea>					
	        </TR>
	          
	 <%                                  
      }
 
      if (Position >= 0) {
        Message += text.substring(Position);
        Message = Message.replace("'","\\'");
      }
         %>

        </table> 
        <input type="Submit" value="Save" fn = 'save'>
        <input type = "hidden" name = "sc" value = "<%=text3_0%>">
        <input type = "hidden" name = "ex" value = "<%=Max%>">
        
        
        </form>
 <SCRIPT LANGUAGE="JavaScript">
<!-- Begin
function textCounter(field,cntfield,maxlimit) {
if (field.value.length > maxlimit) // if too long...trim it!
field.value = field.value.substring(0, maxlimit);
// otherwise, update 'characters left' counter
else
cntfield.value = maxlimit - field.value.length;
}
//  End -->
</script>          



		       
    </BODY>
</HTML>      