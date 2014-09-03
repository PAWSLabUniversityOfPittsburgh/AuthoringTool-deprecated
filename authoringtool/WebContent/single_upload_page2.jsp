<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@page import="java.io.*"%>
<%
	//to get the content type information from JSP Request Header
	String contentType = request.getContentType();
	//here we are checking the content type is not equal to Null and as well as the passed data from mulitpart/form-data is greater than or equal to 0
	if ((contentType != null) && (contentType.indexOf("multipart/form-data") >= 0)) {
 		DataInputStream in = new DataInputStream(request.getInputStream());
		//we are taking the length of Content type data
		int formDataLength = request.getContentLength();
		byte dataBytes[] = new byte[formDataLength];
		int byteRead = 0;
		int totalBytesRead = 0;
		//this loop converting the uploaded file into byte code
		while (totalBytesRead < formDataLength) {
			byteRead = in.read(dataBytes, totalBytesRead, formDataLength);
			totalBytesRead += byteRead;
		}

		String file = new String(dataBytes);
		//for saving the file name
		String saveFile = file.substring(file.indexOf("filename=\"") + 10);
		saveFile = saveFile.substring(0, saveFile.indexOf("\n"));
		saveFile = saveFile.substring(saveFile.lastIndexOf("\\") + 1,saveFile.indexOf("\""));
		int lastIndex = contentType.lastIndexOf("=");
		String boundary = contentType.substring(lastIndex + 1,contentType.length());
		int pos;
		//extracting the index of file 
		pos = file.indexOf("filename=\"");
		pos = file.indexOf("\n", pos) + 1;
		pos = file.indexOf("\n", pos) + 1;
		pos = file.indexOf("\n", pos) + 1;
		int boundaryLocation = file.indexOf(boundary, pos) - 4;
		int startPos = ((file.substring(0, pos)).getBytes()).length;
		int endPos = ((file.substring(0, boundaryLocation)).getBytes()).length;

		// creating a new file with the same name and writing the content in new file
		String fileDirName = "C:\\java\\Tomcat\\webapps\\quizjet\\class\\"+saveFile; 
		//;"/Users/hy/inf/Study/CS/Projects_Codes_Data/CodingProjects/Quizjet2/WebContent/class/" + saveFile;
		File f = new File(fileDirName);
		if (f.exists() && f.isFile()){
			out.println("{");
			out.println("error:'File exists! Please change the name! (Use numbers in front of your class name, like 01BankAccount.java)'"); 
			out.println("}");
			//System.out.println("your file name:" + saveFile);
		}
		else{
			
		FileOutputStream fileOut = new FileOutputStream(fileDirName);//"C:\\java\\Tomcat\\webapps\\quizjet\\class\\"+saveFile);
		fileOut.write(dataBytes, startPos, (endPos - startPos));
		fileOut.flush();
		fileOut.close();
		
		//add one entry into ent_class table
        Connection connection = null;
		Class.forName(this.getServletContext().getInitParameter("db.driver"));
		connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
        Statement statement = connection.createStatement();	            	           	            	
        String command = "insert into ent_class (ClassName) values ('"+saveFile+"');";
 		statement.executeUpdate(command);	
		//out.println("file save to ent_class table successfully!");  	
			
 		String MaxID ="";
 		ResultSet rs3 = null;
		rs3 = statement.executeQuery("SELECT MAX(LAST_INSERT_ID(ClassID)) AS LastID FROM ent_class WHERE ClassName = '"+saveFile+"';");        
	        while(rs3.next())
		{ 	
			MaxID = rs3.getString(1);		
		}
		//response.sendRedirect("classcombo.jsp?totalcount="+MaxID);
		
		out.println("{");
		out.println("error:'',filename:'"+saveFile+"'"+",fileid:'"+MaxID+"'"); 
		out.println("}");
		//System.out.println("filename:" + saveFile + ",fileid:" + MaxID);
		}
	}
		
%>