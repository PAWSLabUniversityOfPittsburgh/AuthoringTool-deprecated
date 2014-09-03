package edu.pitt.sis.paws.authoring.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import edu.pitt.sis.paws.authoring.parser.Parser2;

import java.sql.*;
/**
 * Servlet implementation class DeleteExampleLineServlet
 */
@WebServlet("/DeleteExampleLineServlet")
public class DeleteExampleLineServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteExampleLineServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		Connection connection = null;
		Statement statement = null;
		try {
			String ex = request.getParameter("dis");
			String lno = request.getParameter("lno");
			String max = request.getParameter("max");
			Class.forName(this.getServletContext().getInitParameter("db.driver"));
			connection = DriverManager.getConnection(this.getServletContext()
					.getInitParameter("db.webexURL"), this.getServletContext()
					.getInitParameter("db.user"), this.getServletContext()
					.getInitParameter("db.passwd"));
			statement = connection.createStatement();
			int M = Integer.parseInt(max);
			for (int b = 1; b <= M; b++) {
				if (Integer.parseInt(lno) == b) {
					String command = "delete from ent_line where DissectionID ='"
							+ ex + "' and LineIndex = '" + b + "' ";
					statement.executeUpdate(command);
					for (int a = Integer.parseInt(lno); a <= M; a++) {
						String command1 = "update ent_line set LineIndex = '"
								+ (a - 1) + "' where DissectionID ='" + ex
								+ "' and LineIndex = '" + a + "' ";
						statement.executeUpdate(command1);
					}
				}
			}
			String command = "delete from ent_jexample_concept where dissectionId = '"+ex+"'";	
	 		statement.executeUpdate(command); 	
	 		Parser2 parser = new Parser2();
			String code = getExampleCode(ex,connection);
			String title = getExampleRDF(ex,connection);
			parser.parseExample(title,code,this.getServletContext(),false);
	 		
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		finally {
			try {
				if (statement != null)
					statement.close();
			} catch (SQLException e) {
			}
			try {
				if (connection != null)
					connection.close();
			} catch (SQLException e) {
			}
		}

	}
	
	public String getExampleCode(String question,Connection connWebex21) {
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

	public String getExampleRDF(String question,Connection connWebex21) {
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


}
