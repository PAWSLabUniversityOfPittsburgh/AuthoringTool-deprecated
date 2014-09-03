package edu.pitt.sis.paws.authoring.parser;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;

/**
 * Servlet implementation class Parser
 */
public class ParserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ParserServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String question = request.getParameter("question"); //question is rdfid for quiz and dissectionId for example
		String scope = request.getParameter("sc");
		String load = request.getParameter("load");
		DB db = new DB();
		db.connectToWebex21(this.getServletContext());
		if (db.isConnectedToWebex21())
		{
			String type = request.getParameter("type");
			if (type.equals("example"))
			{			
					Parser2 parser = new Parser2();
					String code = db.getExampleCode(question);
					String title = db.getExampleRDF(question);
					parser.parseExample(title,code,this.getServletContext(),false);
					//response.sendRedirect("concept_indexing1.jsp?sc="+scope+"&ex="+question);
					response.sendRedirect(load);
			}			
			else
			{
				db.connectToWebex21(this.getServletContext());
				
					Parser2 parser = new Parser2();
					Blob testerCode = db.getQuestionCode(question);
					int minvar = db.getQuestionMinVar(question);
					int qtype = db.getQuestionType(question);
					try {
						parser.parse(question,getSource(testerCode.getBinaryStream(),minvar,qtype),this.getServletContext(),true);
						List<String> quizClassList = db.getQuizClass(question);
						Map<String,String> externalClassSourceMap = getExternalClassSource(question,minvar,qtype,quizClassList);
						for (String className : externalClassSourceMap.keySet())			
							parser.parse(question, externalClassSourceMap.get(className),this.getServletContext(),false);
						db.disconnectFromWebex21();
						parser = null;
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					//response.sendRedirect("jquestion_concept.jsp?question="+question);
					response.sendRedirect(load);
		}
		
			db = null;

		}
	}
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
	public Map<String,String> getExternalClassSource(String question, int minvar, int qtype, List<String> quizClassList)
	{
		Map<String,String> externalClassSourceMap = new HashMap<String,String>();
		String source = "";
		for (String className : quizClassList)
		{
			try {
				source = FileUtils.readFileToString(new File(getServletContext().getRealPath(edu.pitt.sis.paws.authoring.data.Const.PATH.CLASS_RELATIVE_PATH+className)));
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			externalClassSourceMap.put(className, source);
		}
		return externalClassSourceMap;	
	}

	private String getSource(InputStream in, int minvar, int qtype) {
		
		byte[] buffer = new byte[1024];

		int P = minvar;
		int position = 0;
		String codepart = "";
		try {
			while ( in.read(buffer) != -1) {
				StringBuffer text = new StringBuffer(new String(buffer));
				int linecount = 0;
				int loc = (new String(text)).indexOf('\n', position);
				while (loc >= 0) {
					loc = (new String(text)).indexOf('\n', position);
					String line = "";
					if (loc > position) {

						line = text.substring(position, loc);
						int b = line.indexOf("_Param");
						int b2 = line.lastIndexOf("_Param");
						if (b > 0 && b == b2) {
							line = line.substring(0, b) + P
									+ line.substring(b + 6);
						} else if (b > 0 && b2 > b) {
							line = line.substring(0, b) + P
									+ line.substring(b + 6, b2) + P
									+ line.substring(b2 + 6);
						}
						linecount = linecount + 1; //just for knowing the line number

						// for Question Type 3
						if (qtype != 3) {
							codepart += line; 
						}
					}
					else
					{
						line = text.substring(position, position+1);
						codepart += line; 
					}
					position = loc + 1;
				}
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		return codepart;
	}
}
