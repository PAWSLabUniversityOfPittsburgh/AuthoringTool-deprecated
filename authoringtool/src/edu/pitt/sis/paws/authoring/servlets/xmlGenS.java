/*
 * Date  : May, 15, 2006
 * Author(s): Michael Yudelson, Sergey Sosnovsky
 * Email : sas15@pitt.edu
 */

package edu.pitt.sis.paws.authoring.servlets;

import java.lang.*;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class xmlGenS extends HttpServlet {
	private static final int MAX_NODES = 900;
	private static final int BRANCH_FACTOR = 5;
	private static final String CONTENT_TYPE = "text/html";

	public void init(ServletConfig config) throws ServletException
	{
		super.init(config);
	}
	private void genFakeXML(HttpServletRequest req)
	{
		ArrayList id = new ArrayList(MAX_NODES);
		ArrayList style = new ArrayList(MAX_NODES);
		for(int i=0;i<MAX_NODES;i++) id.add(new Integer(i));
		for(int i=0;i<7;i++) style.add(new Integer(0));
		for(int i=7;i<(int)Math.floor(MAX_NODES/2);i++)style.add(new Integer(1));
		for(int i=(int)Math.floor(MAX_NODES/2);i<MAX_NODES;i++)style.add(new Integer(2));
		
		ArrayList edge = new ArrayList(MAX_NODES);
		for(int i=1;i<(MAX_NODES);i++)
		{
			edge.add(new Integer((int)Math.floor((i-1)/BRANCH_FACTOR)));
			edge.add(new Integer(i));
		}
		
		ArrayList name = new ArrayList(MAX_NODES);
		for(int i=0;i<MAX_NODES;i++) name.add( "node" + (String)Integer.toString(i+1) );
		
		HttpSession session = req.getSession();
		session.setAttribute("IDs",id);
		session.setAttribute("Styles",style);
		session.setAttribute("Names",name);
		session.setAttribute("Edges",edge);
		return;
	}
	public void doGet(HttpServletRequest req, HttpServletResponse res)
		throws ServletException, IOException
	{
		res.setContentType(CONTENT_TYPE);
		PrintWriter out = res.getWriter();

		
		out.println("<?xml version='1.0'?>");
		out.println("<!DOCTYPE GraphXML SYSTEM 'GraphXML.dtd'>");
		out.println("<GraphXML>");
		out.println("<graph id='My First Graph'>");

		//Styles
		out.println("<style>");
		out.println("<line tag=\"node\" class=\"c0\"  color=\"black\"/>");
		out.println("<line tag=\"node\" class=\"c1\"  color=\"#0000CC\"/>");
		out.println("<line tag=\"node\" class=\"c2\"  color=\"#000099\"/>");
		out.println("<fill tag=\"node\" class=\"c2\"  color=\"#9999FF\"/>");
		out.println("</style>");
		
//		genFakeXML(req);
		
		HttpSession session = req.getSession();
		ArrayList id =  (ArrayList)session.getAttribute("IDs");
		ArrayList style = (ArrayList)session.getAttribute("Styles");
		ArrayList name = (ArrayList)session.getAttribute("Names");
		ArrayList edge = (ArrayList)session.getAttribute("Edges");

		for(int i=0;i<id.size();i++)
		{
			out.println("<node name='" + ((Integer)id.get(i)).intValue() + "' class='c" + ((Integer)style.get(i)).intValue() + "'>");	
			out.println("<label>" + (String)name.get(i) + "</label>");	
			String oper = (((Integer)style.get(i)).intValue()==1)?"Add":
				(((Integer)style.get(i)).intValue()==2)?"Del":"";
			String par = (((Integer)style.get(i)).intValue()==1)?"add":
				(((Integer)style.get(i)).intValue()==2)?"del":"";
//System.out.println("xmlGen: style="+((Integer)style.get(i)).intValue()+" oper="+oper+" par="+par);
			if((((Integer)style.get(i)).intValue() == 1) || 
				(((Integer)style.get(i)).intValue() == 2))
			{
				out.println("<dataref>");
				out.println("	 <ref xlink:href=\"editConcepts.jsp?XML="+((Integer)id.get(i)).intValue()+"\"/>");
//				out.println("	 <ref xlink:href=\"extractConcepts.jsp?XML="+oper+"&"+par+"="+((Integer)id.get(i)).intValue()+"\"/>");
				out.println("</dataref> ");
			}
			out.println("</node>");	
		}
		for(int i=0;i<edge.size();i++)
		{
			out.println("<edge source='" + 
				((Integer)edge.get(i++)).intValue() + "' target='" +
				((Integer)edge.get(i)).intValue() + "'/>");	
		}
/*
		<node name="n1" class="root">
			<label>C programming</label>
			<dataref>
				<ref xlink:show="xFrame" xlink:href = "#"/>
			</dataref>
		</node>
		
		<edge source="n12" target="n121" class="isa"/>
		
 */

		out.println("</graph>");
		out.println("</GraphXML>");


/*		out.println("<html>");
		out.println("<head><title>xmlGetS</title></head>");
		out.println("<body>");
		out.println("<p>The servlet has received a GET. This is the reply.</p>");
		out.println("</body></html>");*/
		out.close();
	}
}