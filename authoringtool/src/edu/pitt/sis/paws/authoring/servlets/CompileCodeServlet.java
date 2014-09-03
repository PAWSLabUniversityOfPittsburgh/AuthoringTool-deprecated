package edu.pitt.sis.paws.authoring.servlets;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONException;
import org.json.JSONObject;
import edu.pitt.sis.paws.authoring.parser.CompileSource;

/**
 * Servlet implementation class CompileCodeServlet
 */
@WebServlet("/CompileCodeServlet")
public class CompileCodeServlet extends AbstractServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CompileCodeServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	// hy{
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String code = request.getParameter("code");
		// TODO: need to get the code's real name
		ArrayList<String> importClassCode = null;
		ArrayList<String> importClassRealName = null;

		// System.out.println("To compile...");
		String importclassesnames = request.getParameter("importclasses");
		// TODO better checking code's compilation when it has _Param.
		String minvar = request.getParameter("minvar");
		if (code != null && minvar != null)
			code = code.replace("_Param", minvar);

		if (importclassesnames != null && importclassesnames.length() > 0) {
			importClassCode = new ArrayList<String>();
			importClassRealName = new ArrayList<String>();
			// 10Animal.java 11Person.java 09Mechanic.java
			// System.out.println("import classes names: " + importclassesnames);
			String[] classNames = importclassesnames.split("\\s+");
			BufferedReader reader = null;
			String line;
			for (int i = 0; i < classNames.length; i++) {
				if (classNames[i].length() < 1 || classNames[i].equals("")
						|| classNames[i].equalsIgnoreCase("null")
						|| classNames[i].equals("\"\"") || classNames[i].equals("''"))
					continue;
				String importClassCodeStr = "";
				// System.out.println("To read: " + classNames[i]);
				reader = new BufferedReader(new FileReader(
						"C:\\java\\Tomcat\\webapps\\quizjet\\class\\"
						// "/Users/hy/inf/Study/CS/Projects_Codes_Data/CodingProjects/Quizjet2/WebContent/class/"
								+ classNames[i]));
				// "C:\\java\\Tomcat\\webapps\\quizjet\\class\\" + classes[i]));
				while ((line = reader.readLine()) != null) {
					importClassCodeStr += line + "\n";
				}
				if (importClassCodeStr.startsWith("null")) {
					System.out.println("import class starts with 'null'!");
					importClassCodeStr = importClassCodeStr.substring(4);
				}
				importClassCode.add(importClassCodeStr);
				// TODO: get real names! one is for dealing with conventionally named
				// files, another is more general...
				String realName = classNames[i].replaceAll("^[0-9]+", ""); // Checked
				if (realName.endsWith(".java"))
					realName = realName.substring(0, realName.length() - 5);
				importClassRealName.add(realName);
				// System.out.println("import class code:\n" + importClassCode[i]);
			}
			reader.close();
		}
		// hy* String message = CompileSource.compileCode(code,
		// this.getServletContext()
		// hy* .getInitParameter("jdkAddr"));
		String message = CompileSource.compileCode(code, importClassCode,
				importClassRealName,
				this.getServletContext().getInitParameter("jdkAddr"));
		try {
			PrintWriter out = response.getWriter();
			JSONObject json = new JSONObject();
			json.put("message", message);
			out.print(json);
		}
		catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}

// }hy
