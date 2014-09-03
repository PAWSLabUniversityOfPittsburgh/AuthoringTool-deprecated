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
 * Servlet implementation class AddExampleLineServlet
 */
@WebServlet("/AddExampleLineServlet")
public class AddExampleLineServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddExampleLineServlet() {
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
		String ex = request.getParameter("dis");
		try {
			Class.forName(this.getServletContext().getInitParameter("db.driver"));
			connection = DriverManager.getConnection(this.getServletContext()
					.getInitParameter("db.webexURL"), this.getServletContext()
					.getInitParameter("db.user"), this.getServletContext()
					.getInitParameter("db.passwd"));
			statement = connection.createStatement();
			int M = Integer.parseInt(request.getParameter("max"));

			for (int b = 1; b <= M; b++) {
				if (request.getParameter("lno") != null) {
					if (Integer.parseInt(request.getParameter("lno")) == b) {


						for (int a = M; a >= Integer.parseInt(request.getParameter("lno")); a--) {
							String command = "update ent_line set LineIndex = '"
									+ (a + 1)
									+ "' where DissectionID ='"
									+ ex
									+ "' and LineIndex = '" + a + "' ";
							statement.executeUpdate(command);

						}

						String command1 = "insert into ent_line (DissectionID,LineIndex,Code,Comment) values ("
								+ ex
								+ ","
								+ Integer.parseInt(request.getParameter("lno"))
								+ ",'','')";
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
	 		
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
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
