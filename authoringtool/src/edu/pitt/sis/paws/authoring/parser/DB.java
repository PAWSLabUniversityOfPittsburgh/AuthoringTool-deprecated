package edu.pitt.sis.paws.authoring.parser;

import java.sql.Blob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;




public class DB {

	private Connection connWebex21;
	private boolean isConnWebex21Valid;
	private Connection treemapConn;
	private boolean isConnTreemapValid;
	private Connection guanjieConn;
	private boolean isConnGuanjieValid;
	private Connection um2Conn;
	private boolean isConnum2Valid;


	public void connectToWebex21(ServletContext sv)
	{
		  String url = sv.getInitParameter("db.webexURL");
		  String driver = sv.getInitParameter("db.driver");
		  String userName =sv.getInitParameter("db.user");
		  String password = sv.getInitParameter("db.passwd");
		  try {
		  Class.forName(driver);
		  connWebex21 = DriverManager.getConnection(url,userName,password);
		  isConnWebex21Valid = true;
		  System.out.println("Connected to the database webex21");
		  } catch (Exception e) {
		  e.printStackTrace();
		  }	
	}
	
	public void connectToTreemap(ServletContext sv)
	{
		  String url = sv.getInitParameter("db.treemapURL");
		  String driver = sv.getInitParameter("db.driver");
		  String userName =sv.getInitParameter("db.user");
		  String password = sv.getInitParameter("db.passwd");
		  
		  try {
		  Class.forName(driver).newInstance();
		  treemapConn = DriverManager.getConnection(url,userName,password);
		  isConnTreemapValid = true;
		  System.out.println("Connected to the database treemap");
		  } catch (Exception e) {
		  e.printStackTrace();
		  }	
	}
	
	public void connectToGuangie(ServletContext sv)
	{
		  String url = sv.getInitParameter("db.guanjieURL");
		  String driver = sv.getInitParameter("db.driver");
		  String userName =sv.getInitParameter("db.user");
		  String password = sv.getInitParameter("db.passwd");
		  
		  try {
		  Class.forName(driver).newInstance();
		  guanjieConn = DriverManager.getConnection(url,userName,password);
		  isConnGuanjieValid = true;
		  System.out.println("Connected to the database guangie");
		  } catch (Exception e) {
		  e.printStackTrace();
		  }	
	}
	
	public void connectToUM2(ServletContext sv)
	{
		  String url = sv.getInitParameter("db.um2");
		  String driver = sv.getInitParameter("db.driver");
		  String userName =sv.getInitParameter("db.user");
		  String password = sv.getInitParameter("db.passwd");
		  
		  try {
		  Class.forName(driver).newInstance();
		  um2Conn = DriverManager.getConnection(url,userName,password);
		  isConnum2Valid = true;
		  System.out.println("Connected to the database um2");
		  } catch (Exception e) {
		  e.printStackTrace();
		  }	
	}
	
	
	public boolean isConnectedToWebex21()
	{
		if (connWebex21 != null) {
			try {
				if (connWebex21.isClosed() == false & isConnWebex21Valid)
					return true;
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return false;
	}
	
	public boolean isConnectedToGuanjie()
	{
		if (guanjieConn != null) {
			try {
				if (guanjieConn.isClosed() == false & isConnGuanjieValid)
					return true;
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return false;
	}
	
	public boolean isConnectedToUM2()
	{
		if (um2Conn != null) {
			try {
				if (um2Conn.isClosed() == false & isConnum2Valid)
					return true;
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return false;
	}
	
	public boolean isConnectedToTreemap()
	{
		if (treemapConn != null) {
			try {
				if (treemapConn.isClosed() == false & isConnTreemapValid)
					return true;
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return false;
	}
	
	public void disconnectFromWebex21()
	{
		if (connWebex21 != null)
			try {
				connWebex21.close();
			    System.out.println("Database webex21 Connection Closed");
			} catch (SQLException e) {
				e.printStackTrace();
			}
	}
	
	public void disconnectFromUM2()
	{
		if (um2Conn != null)
			try {
				um2Conn.close();
			    System.out.println("Database um2 Connection Closed");
			} catch (SQLException e) {
				e.printStackTrace();
			}
	}
	
	public void disconnectFromGuanjie()
	{
		if (guanjieConn != null)
			try {
				guanjieConn.close();
			    System.out.println("Database guangie Connection Closed");
			} catch (SQLException e) {
				e.printStackTrace();
			}
	}
	
	public void disconnectFromTreemap()
	{
		if (connWebex21 != null)
			try {
				treemapConn.close();
			    System.out.println("Database treemap Connection Closed");
			} catch (SQLException e) {
				e.printStackTrace();
			}
	}
	
	public Map<String,Blob> getQuizzes() {
		Map<String,Blob> quizList = new HashMap<String,Blob>();
		PreparedStatement ps = null;
		String sqlCommand = "";
		ResultSet rs = null;
		try
		{
			sqlCommand = "select Title,code from ent_jquiz";
			ps = connWebex21.prepareStatement(sqlCommand);
			rs = ps.executeQuery();
			while (rs.next())
			{
				quizList.put(rs.getString(1), rs.getBlob(2));
			}
			rs.close();
			ps.close();
		}catch (SQLException e) {
			 e.printStackTrace();
		}	
		return quizList;
	}
	
	public Blob getQuestionCode(String title) {
		Blob code = null;
		PreparedStatement ps = null;
		String sqlCommand = "";
		ResultSet rs = null;
		try
		{
			sqlCommand = "select code from ent_jquiz where rdfID = ?";
			ps = connWebex21.prepareStatement(sqlCommand);
			ps.setString(1, title);
			rs = ps.executeQuery();
			while (rs.next())
			{
				code = rs.getBlob(1);
			}
			rs.close();
			ps.close();
		}catch (SQLException e) {
			 e.printStackTrace();
		}	
		return code;
	}
	
	public int getQuestionMinVar(String title) {
		int minvar = 0;
		PreparedStatement ps = null;
		String sqlCommand = "";
		ResultSet rs = null;
		try
		{
			sqlCommand = "select MinVar from ent_jquiz where Title = ?";
			ps = connWebex21.prepareStatement(sqlCommand);
			ps.setString(1, title);
			rs = ps.executeQuery();
			while (rs.next())
			{
				minvar = rs.getInt(1);
			}
			rs.close();
			ps.close();
		}catch (SQLException e) {
			 e.printStackTrace();
		}	
		return minvar;
	}
	
		
	public int getQuestionType(String title) {
		int qtype = 0;
		PreparedStatement ps = null;
		String sqlCommand = "";
		ResultSet rs = null;
		try
		{
			sqlCommand = "select QuesType from ent_jquiz where Title = ?";
			ps = connWebex21.prepareStatement(sqlCommand);
			ps.setString(1, title);
			rs = ps.executeQuery();
			while (rs.next())
			{
				qtype = rs.getInt(1);
			}
			rs.close();
			ps.close();
		}catch (SQLException e) {
			 e.printStackTrace();
		}	
		return qtype;
	}
		
	public void insertQuizConcept(int id,String title, String concept, String className, int sline, int eline,boolean isExample,ServletContext sc) {
		PreparedStatement ps = null;
		String sqlCommand = "";
		String table = "";
		if (isExample)
			table = "ent_jexample_concept";
		else
			table = "ent_jquiz_concept";

		String topic = "";
		List<String> topicOutcomeConceptList = new ArrayList<String>();
		if (sline > eline) 
			eline = sline;
		
		
		try
		{
			//determine the topic of the content
			if (isConnectedToGuanjie() == false)
				connectToGuangie(sc);
			if (isConnectedToGuanjie())
			{
				sqlCommand = "SELECT topic_name FROM guanjie.rel_topic_content where content_name = '"+title+"'";
				ps = guanjieConn.prepareStatement(sqlCommand);
				ResultSet rs = ps.executeQuery();
				while(rs.next())
				{
					topic = rs.getString(1);
				}
				sqlCommand = " SELECT distinct concept_name" +
						     " FROM guanjie.del_rel_topic_concept_agg"+
						     " where topic_name = '"+topic+"' and direction = 'outcome'";						
				ps = guanjieConn.prepareStatement(sqlCommand);
				rs = ps.executeQuery();
				while(rs.next())
				{
					topicOutcomeConceptList.add(rs.getString(1));
				}				
			}
			
			String direction = "prerequisite";
			if (topicOutcomeConceptList.contains(concept))
				direction = "outcome";
			sqlCommand = "select * from "+table+" where title = ? and concept = ? and class = ? and sline = ? and eline =?";
			ps = connWebex21.prepareStatement(sqlCommand);
			ps.setString(1, title);
			ps.setString(2, concept);
			ps.setString(3, className);
			ps.setInt(4, sline);
			ps.setInt(5, eline);

			ResultSet rs = ps.executeQuery();
			if(rs.next()== false)
			{			
				if (isExample)
					sqlCommand = "insert into ent_jexample_concept (dissectionID,title,concept,class,sline,eline,direction) values (?,?,?,?,?,?,?)";
				else
					sqlCommand = "insert into ent_jquiz_concept (quizID,title,concept,class,sline,eline,direction) values (?,?,?,?,?,?,?)";

				ps = connWebex21.prepareStatement(sqlCommand);
				ps.setInt(1, id);
				ps.setString(2, title);
				ps.setString(3, concept);
				ps.setString(4, className);
				ps.setInt(5, sline);
				ps.setInt(6, eline);
				ps.setString(7,direction);
				ps.executeUpdate();
				ps.close();
			}
		}catch (SQLException e) {
			 e.printStackTrace();
		}			
	}

	
	public List<String> getQuizClass(String qTitle) {
		List<String> classes = new ArrayList<String>();
		PreparedStatement ps = null;
		String sqlCommand = "";
		ResultSet rs = null;
		try
		{
			sqlCommand = " select ent_class.ClassName" +
					     " from rel_quiz_class,ent_jquiz,ent_class" +
					     " where ent_jquiz.Title = ?" +
					     " and ent_jquiz.QuizID = rel_quiz_class.QuizID" +
					     " and rel_quiz_class.ClassID = ent_class.ClassID";
			ps = connWebex21.prepareStatement(sqlCommand);
			ps.setString(1, qTitle);
			rs = ps.executeQuery();	
			while (rs.next())
			{
				classes.add(rs.getString(1));
			}
			rs.close();
			ps.close();
		}catch (SQLException e) {
			 e.printStackTrace();
		}
		return classes;
	}

	public int getQuizId(String question) {
		int quizId = 0;
		PreparedStatement ps = null;
		String sqlCommand = "";
		ResultSet rs = null;
		try
		{
			sqlCommand = "select QuizID from ent_jquiz where Title = ?";
			ps = connWebex21.prepareStatement(sqlCommand);
			ps.setString(1, question);
			rs = ps.executeQuery();
			while (rs.next())
			{
				quizId = rs.getInt(1);
			}
			rs.close();
			ps.close();
		}catch (SQLException e) {
			 e.printStackTrace();
		}	
		return quizId;
	}

	public ResultSet getConcepts(String question,boolean isExample) {
		PreparedStatement ps = null;
		String sqlCommand = "";
		ResultSet rs = null;
		String table = "ent_jquiz_concept";
		if (isExample)
			table = "ent_jexample_concept";
		try
		{
			sqlCommand = "select concept,class,sline,eline from "+table+" where title = ?";
			ps = connWebex21.prepareStatement(sqlCommand);
			ps.setString(1, question);
			rs = ps.executeQuery();
		}catch (SQLException e) {
			 e.printStackTrace();
		}	
		return rs;
	}
	
	public int getDistinctConceptCount(String question,boolean isExample) {
		PreparedStatement ps = null;
		String sqlCommand = "";
		ResultSet rs = null;
		int count = 0;
		String table = "ent_jquiz_concept";
		if (isExample)
			table = "ent_jexample_concept";
		try
		{
			sqlCommand = "select count(distinct concept) from "+table+" where title = ?";
			ps = connWebex21.prepareStatement(sqlCommand);
			ps.setString(1, question);
			rs = ps.executeQuery();
			while (rs.next())
				count = rs.getInt(1);
		}catch (SQLException e) {
			 e.printStackTrace();
		}	
		return count;
	}
     public List<String> getOntologyConcepts(ServletContext sc) {
		
		List<String> ontoConcepts = new ArrayList<String>();
		connectToUM2(sc);
		if (isConnectedToUM2())
		{
			PreparedStatement ps = null;
			String sqlCommand = "";
			ResultSet rs = null;
			try
			{
				sqlCommand = " select distinct Title from ent_concept" +
			    " where Description ='java ontology v2'";
				ps = um2Conn.prepareStatement(sqlCommand);
				rs = ps.executeQuery();
				while (rs.next())
				{
					ontoConcepts.add(rs.getString(1));
				}
				rs.close();
				ps.close();
			}catch (SQLException e) {
				 e.printStackTrace();
			}	
			disconnectFromUM2();
		}
		
		return ontoConcepts;
	}
	
	public List<String> getDistinctConcepts(String question,boolean isExample) {
		PreparedStatement ps = null;
		String sqlCommand = "";
		ResultSet rs = null;
		List<String> concepts = new ArrayList<String>();
		String table = "ent_jquiz_concept";
		if (isExample)
			table = "ent_jexample_concept";
		try
		{
			sqlCommand = "select distinct concept from "+table+" where title = ?";
			ps = connWebex21.prepareStatement(sqlCommand);
			ps.setString(1, question);
			rs = ps.executeQuery();
			while (rs.next())
				concepts.add(rs.getString(1));
		}catch (SQLException e) {
			 e.printStackTrace();
		}	
		return concepts;
	}

	public boolean classExists(String question, String concept, String className,boolean isExample)
	{
		PreparedStatement ps = null;
		String sqlCommand = "";
		String table = "ent_jquiz_concept";
		if (isExample)
			table = "ent_jexample_concept";
		try
		{
			sqlCommand = "select * from "+table+" where title = ? and concept = ? and class = ?";
			ps = connWebex21.prepareStatement(sqlCommand);
			ps.setString(1, question);
			ps.setString(2, concept);
			ps.setString(3, className);
			ResultSet rs = ps.executeQuery();
			if(rs.next())
			{			
				return true;
			}
		}catch (SQLException e) {
			 e.printStackTrace();
		}	
		return false;
	}
	

	
	public void deleteQuizConcept(String question, String concept, boolean isExample) {
		PreparedStatement ps = null;
		String sqlCommand = "";
		String table = "ent_jquiz_concept";
		if (isExample)
			table = "ent_jexample_concept";
		try
		{
			sqlCommand = "delete from "+table+" where title = ? and concept = ?";
			ps = connWebex21.prepareStatement(sqlCommand);
			ps.setString(1, question);
			ps.setString(2, concept);
			ps.executeUpdate();
			ps.close();
		}catch (SQLException e) {
			 e.printStackTrace();
		}					
	}
	
	public void deleteQuizConcept(String question, String concept,String className,boolean isExample) {
		PreparedStatement ps = null;
		String sqlCommand = "";
		String table = "ent_jquiz_concept";
		if (isExample)
			table = "ent_jexample_concept";
		try
		{
			sqlCommand = "delete from "+table+" where title = ? and concept = ? and class = ?";
			ps = connWebex21.prepareStatement(sqlCommand);
			ps.setString(1, question);
			ps.setString(2, concept);
			ps.setString(3, className);
			ps.executeUpdate();
			ps.close();
		}catch (SQLException e) {
			 e.printStackTrace();
		}					
	}


	public void insertTestResult(String title, String c, String type)
	{
		PreparedStatement ps = null;
		String sqlCommand = "";
		try
		{			
				sqlCommand = "insert into javaparser_test (question,concept,type) values (?,?,?)";
				ps = connWebex21.prepareStatement(sqlCommand);
				ps.setString(1, title);
				ps.setString(2, c);
				ps.setString(3, type);
				ps.executeUpdate();
				ps.close();			
		}catch (SQLException e) {
			 e.printStackTrace();
		}	
		
	}


	public void insertConflict(String title, String c) {
		PreparedStatement ps = null;
		String sqlCommand = "";
		try
		{
				sqlCommand = "insert into conflict_jp (question,concept) values (?,?)";
				ps = connWebex21.prepareStatement(sqlCommand);
				ps.setString(1, title);
				ps.setString(2, c);
				ps.executeUpdate();
				ps.close();			
		}catch (SQLException e) {
			 e.printStackTrace();
		}			
	}

	public void deleteConcept(String question, String[] conceptsToBeRemoved,boolean isExample) {
		PreparedStatement ps = null;
		String sqlCommand = "";
		String concepts = "";
		String table = "ent_jquiz_concept";
		if (isExample)
			table = "ent_jexample_concept";
		for (int i = 0; i < conceptsToBeRemoved.length; i++)
		{
			concepts+="'"+conceptsToBeRemoved[i]+"'";
			if (i < conceptsToBeRemoved.length - 1)
				concepts+=",";
		}
		try
		{
				sqlCommand = "delete from "+table+" where concept in ("+concepts+") and title = ?" ;
				ps = connWebex21.prepareStatement(sqlCommand);
				ps.setString(1, question);
				ps.executeUpdate();
				ps.close();			
		}catch (SQLException e) {
			 e.printStackTrace();
		}					
	}

	public String getExampleCode(String question) {
		PreparedStatement ps = null;
		String sqlCommand = "";
		ResultSet rs = null;		
		String separator = System.getProperty( "line.separator" );
		StringBuilder lines = new StringBuilder("");	
		
		try
		{
			sqlCommand = "SELECT l.Code FROM ent_line l where l.DissectionID="+question+" order by l.LineIndex ";
			ps = connWebex21.prepareStatement(sqlCommand);
			rs = ps.executeQuery();
			String line;
			while (rs.next())
			{
				line = rs.getString(1);
				line = line.replaceAll("[\\r\\n]", ""); 
				lines.append( line ); 
				lines.append( separator );
			}
		}catch (SQLException e) {
			 e.printStackTrace();
		}
		return  lines.toString( );
	}

	public String getExampleRDF(String question) {
		PreparedStatement ps = null;
		String sqlCommand = "";
		ResultSet rs = null;
		String rdf = "";
		try
		{
			sqlCommand = "SELECT rdfID FROM ent_dissection where dissectionID = "+question;
			ps = connWebex21.prepareStatement(sqlCommand);
			rs = ps.executeQuery();
			while (rs.next())
				rdf = rs.getString(1);
		}catch (SQLException e) {
			 e.printStackTrace();
		}	
		return rdf;
	}

	public List<String> getExamplesID(ServletContext sc) {
        PreparedStatement ps = null;
		String sqlCommand = "";
		ResultSet rs = null;
		List<String> list = new ArrayList<String>();
		List<String> ids = new ArrayList<String>();
		String temp = "";
		try {
			connectToGuangie(sc);
			if (isConnectedToGuanjie())
			{
				sqlCommand = "SELECT content_name  FROM ent_content where content_type = 'example' and domain = 'java'";
				ps = guanjieConn.prepareStatement(sqlCommand);
				rs = ps.executeQuery();
				while (rs.next())
					ids.add(rs.getString(1));
				disconnectFromGuanjie();
				for (int i = 0; i< ids.size();i++)
				{
					temp+="'"+ids.get(i)+"'";
					if (i < ids.size() - 1)
						temp+=",";
				}				
			}
           
			sqlCommand = "SELECT e.DissectionID  FROM ent_dissection e, rel_scope_dissection r, ent_scope s where e.DissectionID=r.DissectionID and r.ScopeID = s.ScopeID and s.domain = 'JAVA' and e.rdfID in ("+temp+")";
			ps = connWebex21.prepareStatement(sqlCommand);
			rs = ps.executeQuery();
			while (rs.next())
				list.add(rs.getString(1));
		} catch (SQLException e) {
			e.printStackTrace();
		}
			
		return list;
	}

	public List<String> getExamplesRDF() {
        PreparedStatement ps = null;
		String sqlCommand = "";
		ResultSet rs = null;
		List<String> list = new ArrayList<String>();
		
		try {
			sqlCommand = "SELECT e.rdfID  FROM ent_dissection e, rel_scope_dissection r, ent_scope s where e.DissectionID=r.DissectionID and r.ScopeID = s.ScopeID and s.domain = 'JAVA'";
			ps = connWebex21.prepareStatement(sqlCommand);
			rs = ps.executeQuery();
			while (rs.next())
				list.add(rs.getString(1));
		} catch (SQLException e) {
			e.printStackTrace();
		}
			
		return list;
	}

   public int getQuestionID(String question) {
	   PreparedStatement ps = null;
		String sqlCommand = "";
		ResultSet rs = null;
		int qid = 0;
		try {
			sqlCommand = "SELECT quizID  FROM ent_jquiz where rdfID = '"+question+"'";
			ps = connWebex21.prepareStatement(sqlCommand);
			rs = ps.executeQuery();
			while (rs.next())
				qid = rs.getInt(1);
		} catch (SQLException e) {
			e.printStackTrace();
		}
			
		return qid;
	}
   
   public int getExampleID(String example) {
	   PreparedStatement ps = null;
		String sqlCommand = "";
		ResultSet rs = null;
		int dis = 0;
		try {
			sqlCommand = "SELECT dissectionID  FROM ent_Dissection where rdfID = '"+example+"'";
			ps = connWebex21.prepareStatement(sqlCommand);
			rs = ps.executeQuery();
			while (rs.next())
				dis = rs.getInt(1);
		} catch (SQLException e) {
			e.printStackTrace();
		}
			
		return dis;
	}
   
   public List<String> getParsedQuestionConcepts() {
		PreparedStatement ps = null;
		String sqlCommand = "";
		ResultSet rs = null;
		List<String> list = new ArrayList<String>();
		try {
			sqlCommand = "SELECT distinct concept  FROM ent_jquiz_concept";
			ps = connWebex21.prepareStatement(sqlCommand);
			rs = ps.executeQuery();
			while (rs.next())
				list.add(rs.getString(1));
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return list;
	}

	public List<String> getParsedExampleConcepts() {

		PreparedStatement ps = null;
		String sqlCommand = "";
		ResultSet rs = null;
		List<String> list = new ArrayList<String>();
		try {
			sqlCommand = "SELECT distinct concept  FROM ent_jexample_concept";
			ps = connWebex21.prepareStatement(sqlCommand);
			rs = ps.executeQuery();
			while (rs.next())
				list.add(rs.getString(1));
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return list;
	
	}

}
